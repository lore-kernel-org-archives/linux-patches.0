Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DDA30C141;
	Thu,  2 Jul 2026 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011513; cv=none; b=FxJruXxO9IqVHHED/nOJRd+pGIyr4R398lY/WTS17YIsAfYGj2xI99b3UCvixX88a2wymf4o5etVTaFE2FKdTx4nRra1Ro9HwXAJ1gSPVNPGqXGq3z3UElv1Evzoc2U+FMH6sEaUpYcwhKu37lMngIr4rW6vAmXdPeVMaS5O8iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011513; c=relaxed/simple;
	bh=9sQjgqVgaMwyli+9fAKwUE1v+nwY/+MI4kzwQGTiMlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV7pPng4DeVQv/eUMocWt7uwc4tTJXfLLc7v/v1NEz9QEaodSO9H6cmtagVOEuXdX+ufs4xD/D99yqqBsytY48Bt9aHU6M2ySJK2fgvbB8sZHaBjOegk9UdzU1JcPoMV4P/Wtd36VHhC/xUKX8xx3Xc6iYn8Ph6BxAl7dUA63U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eQuqvNA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eQuqvNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11371F00A3A;
	Thu,  2 Jul 2026 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011512;
	bh=QC8JKleU/pUa7LK73IxfRMc9F2TLwWqrWcOq9a4CBBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eQuqvNAmwXizwvq2ZI3ekR+GJNgE0iY39Th4SBDMW1M28ezqgBwwUZkDD1JCHd8m
	 dfZ2ZFU+gFAgwTX9uHI1pNUcqqp+muZuVb9jOl52iJgVk4GPMksvTGNLIvQFEw3yN0
	 u9PXhf8ijAsg6mqh3SjI2DkH+o4ZJD2MEjBxf2/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jungwoo Lee <jwlee2217@gmail.com>,
	Wongi Lee <qw3rtyp0@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 028/120] ipv6: account for fraggap on the paged allocation path
Date: Thu,  2 Jul 2026 18:20:24 +0200
Message-ID: <20260702155113.544743381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wongi Lee <qw3rtyp0@gmail.com>

commit 736b380e28d0480c7bc3e022f1950f31fe53a7c5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1668,8 +1668,8 @@ alloc_new_skb:
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
-				alloclen = fragheaderlen + transhdrlen;
-				pagedlen = datalen - transhdrlen;
+				alloclen = fragheaderlen + transhdrlen + fraggap;
+				pagedlen = datalen - transhdrlen - fraggap;
 			}
 			alloclen += alloc_extra;
 
@@ -1684,10 +1684,7 @@ alloc_new_skb:
 			fraglen = datalen + fragheaderlen;
 
 			copy = datalen - transhdrlen - fraggap - pagedlen;
-			/* [!] NOTE: copy may be negative if pagedlen>0
-			 * because then the equation may reduces to -fraggap.
-			 */
-			if (copy < 0 && !(flags & MSG_SPLICE_PAGES)) {
+			if (copy < 0) {
 				err = -EINVAL;
 				goto error;
 			}


