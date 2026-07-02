Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2436330B01;
	Thu,  2 Jul 2026 16:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010149; cv=none; b=qMrlKHS89huKge9eIcGeD3B7PUA8JTCTyoMzZBFj5rpIEThKQCFrRea0Ur9hy0UPGPzV2ETvYDLqTSpXwXsPa7yr9YXwcFQ7sh0UZdmBi2IJ9MNgxhV5QC45caDp2SmAbSM9LARbo0TWLnyxjVPcqwbpmjIsxb0EbgDUnQrqrYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010149; c=relaxed/simple;
	bh=YyVtniCszM9w+SarP8GeYIaiS7NZEYEjR63aGThq34g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qD0rg8mWlqNz6vKrNB/Ve9KjccecsjQFsFm35yxFJ+EgAJgHfMZy8e7IG+3Sl4xPBuCLmteiW545rYZkSL+uGfOICKfxbTlEE3HSOSKQFc3EDHPD/chB7CQNu/65ZOfScJTUwdBXOkdDm7c72YqNNgPy2oJdQAdQIdpy7A/uGNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIr2dRub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIr2dRub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339B21F000E9;
	Thu,  2 Jul 2026 16:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010148;
	bh=3v1sjRYKnHnnoxyVf08ThOdFNcURsLgZ94+6Y7jAWnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIr2dRubWvYU7fVt7ikKz5y/aen7ILCRbMp65EzKjPdoK+zzHMQ5XmQKEC0EaE8LV
	 ewTMeVn42i1lxei6sdmUfYJ8zVfLUoOq9aCO9LJvGKI+zGzbB9idB/Fh1ZodFh1FFZ
	 UZz5Wc5040fXTREyvG/FR/KrpJEkooT04BulgfIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jungwoo Lee <jwlee2217@gmail.com>,
	Wongi Lee <qw3rtyp0@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/129] ipv6: account for fraggap on the paged allocation path
Date: Thu,  2 Jul 2026 18:20:48 +0200
Message-ID: <20260702155114.822872371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wongi Lee <qw3rtyp0@gmail.com>

[ Upstream commit 736b380e28d0480c7bc3e022f1950f31fe53a7c5 ]

In __ip6_append_data(), when the paged-allocation branch is taken
(MSG_MORE / NETIF_F_SG / large fraglen), alloclen and pagedlen are
computed as

	alloclen = fragheaderlen + transhdrlen;
	pagedlen = datalen - transhdrlen;

datalen already includes fraggap (datalen = length + fraggap). When
fraggap is non-zero, this is not the first skb and transhdrlen is zero.
The fraggap bytes carried over from the previous skb are copied just past
the fragment headers in the new skb's linear area. The linear area is
therefore undersized by fraggap bytes while pagedlen is overstated by the
same amount, and the copy writes past skb->end into the trailing
skb_shared_info.

An unprivileged user can trigger this via a UDPv6 socket using
MSG_MORE together with MSG_SPLICE_PAGES.

The bad accounting was introduced by commit 773ba4fe9104 ("ipv6:
avoid partial copy for zc"). Before commit ce650a166335 ("udp6: Fix
__ip6_append_data()'s handling of MSG_SPLICE_PAGES"), the negative
copy value caused -EINVAL to be returned. That later commit allowed
MSG_SPLICE_PAGES to proceed in this case, making the corruption
triggerable.

The non-paged branch sets alloclen to fraglen, which already accounts
for fraggap because datalen does. Bring the paged branch in line by
adding fraggap to alloclen and subtracting it from pagedlen.

After this adjustment, copy no longer collapses to -fraggap on the
paged path, so remove the stale comment describing that old arithmetic.
Since a negative copy is no longer expected for a valid MSG_SPLICE_PAGES
case, remove the MSG_SPLICE_PAGES exception from the negative copy check.

Fixes: 773ba4fe9104 ("ipv6: avoid partial copy for zc")
Signed-off-by: Jungwoo Lee <jwlee2217@gmail.com>
Signed-off-by: Wongi Lee <qw3rtyp0@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/ajFTqRljatR17fFy@DESKTOP-19IMU7U.localdomain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1622,8 +1622,8 @@ alloc_new_skb:
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
-				alloclen = fragheaderlen + transhdrlen;
-				pagedlen = datalen - transhdrlen;
+				alloclen = fragheaderlen + transhdrlen + fraggap;
+				pagedlen = datalen - transhdrlen - fraggap;
 			}
 			alloclen += alloc_extra;
 


