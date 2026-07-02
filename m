Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B1022D7B9;
	Thu,  2 Jul 2026 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011516; cv=none; b=B7fGizK2tdxS0HlW8hYs8+XPXWfqfzUV42i8JCdnSqJVkYac8CsFnTxA6ceHL88LXTA4PxpO8UpmyumD81AE+UQNLxk6usnTKvDda+wDs+3qmGeQPSqNPv3bjUL8CGLBKOttgIXW/GJtYRhug3GoLeBSD+Q/tnm74igfrNxOK/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011516; c=relaxed/simple;
	bh=95rGgU6j8Q0rKb8/bZNulRmQN0TQi2wXNp8DM5TLJiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa0o0EPl9VECyE03oDRosdiWKpl2tudTlGoBI5NjDdPXRSGBqo70DHrsULouw8cuaV1S3r93ti+B54WzWeLU6LwpYslQh8alXsB1DiD7UBvtLp2qrEJx0YBTTedp7LoW1NErmY5RUaL3e/POXqblvSx861Qf+3FHSNfk/DAbPK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6WP6Ncv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6WP6Ncv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE021F00A3A;
	Thu,  2 Jul 2026 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011514;
	bh=07gc/V5HsZj7l6HWdqoj7EIRl4KxpBYvsmMV/vIl1DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6WP6Ncvt2ocDcB+ZPOonHU4pjbvDOe2ZL97qT4FBaAaByoxpMhAuLoMPmrNWBry8
	 4wxZkE347Xf0a2UKhqKk/f5UhaV0TaoTu22WmbTXHIVVevJ9mX+SJqoq/CIWG08sa9
	 F9jJCAWreLkrc6+tlTPBOy4BzLjN5ROTkrScsHIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jungwoo Lee <jwlee2217@gmail.com>,
	Wongi Lee <qw3rtyp0@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 029/120] ipv4: account for fraggap on the paged allocation path
Date: Thu,  2 Jul 2026 18:20:25 +0200
Message-ID: <20260702155113.566052707@linuxfoundation.org>
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

[ Upstream commit eca856950f7cb1a221e02b99d758409f2c5cec42 ]

In __ip_append_data(), when the paged-allocation branch is taken,
alloclen and pagedlen are computed as

	alloclen = fragheaderlen + transhdrlen;
	pagedlen = datalen - transhdrlen;

datalen already includes fraggap, but the fraggap bytes carried over
from the previous skb are copied into the new skb's linear area at
offset transhdrlen by the subsequent skb_copy_and_csum_bits(). The
linear area is therefore undersized by fraggap bytes while pagedlen is
overstated by the same amount.

The non-paged branch sets alloclen to fraglen, which already accounts
for fraggap because datalen does. Bring the paged branch in line by
adding fraggap to alloclen and subtracting it from pagedlen.

After this adjustment, copy no longer collapses to -fraggap on the
paged path, so remove the stale comment describing that old arithmetic.

Fixes: 8eb77cc73977 ("ipv4: avoid partial copy for zc")
Signed-off-by: Jungwoo Lee <jwlee2217@gmail.com>
Signed-off-by: Wongi Lee <qw3rtyp0@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/ajFR1eLAIs42TN3g@DESKTOP-19IMU7U.localdomain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 5bcd73cbdb41c0..ec790bad1679a6 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1117,8 +1117,8 @@ static int __ip_append_data(struct sock *sk,
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
-				alloclen = fragheaderlen + transhdrlen;
-				pagedlen = datalen - transhdrlen;
+				alloclen = fragheaderlen + transhdrlen + fraggap;
+				pagedlen = datalen - transhdrlen - fraggap;
 			}
 
 			alloclen += alloc_extra;
@@ -1165,9 +1165,6 @@ static int __ip_append_data(struct sock *sk,
 			}
 
 			copy = datalen - transhdrlen - fraggap - pagedlen;
-			/* [!] NOTE: copy will be negative if pagedlen>0
-			 * because then the equation reduces to -fraggap.
-			 */
 			if (copy > 0 &&
 			    INDIRECT_CALL_1(getfrag, ip_generic_getfrag,
 					    from, data + transhdrlen, offset,
-- 
2.53.0



