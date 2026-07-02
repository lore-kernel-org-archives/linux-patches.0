Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0480330C60F;
	Thu,  2 Jul 2026 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010497; cv=none; b=iROMltSiiEEq5TwJZ/9KqEz+lWTGi+uej3sMgQDWF3xT21bRFKIcR1Ty77HExk/4+G96OUZNRNLJy7D73rg0gTFJumEnOFnqfFgLwDgbOAMYKNnaBFzdKAsIJ83OKcvLnkKHTZahSxS0RAnQLHTpnoyghGIZ0k0xxTIhh4Wkyus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010497; c=relaxed/simple;
	bh=oIjTtdrSsiLrc/jBArpfI9dboHuJc2q2xciFUxCwZdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IggwnWv0mgRl61SdbI8ktnM7cidMtsJLirLmbZL9KQwjUU9oFXYo1Kf1Ju8T+IUd+lF+oP81GahFf6nIeUqM7yLnlVeJZJ+Lae1t/fJprb3a4zVtadGl5dna9ztXAJqhiDPjrevKSVjpF0rrNPBJn5oNtTKzshqtLRI5eZ9In/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikCN+DP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikCN+DP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70B11F0155C;
	Thu,  2 Jul 2026 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010490;
	bh=sImg1cN9ax5nEUDCye+lCL2DvbzgM7tEjBKR/2wQsOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikCN+DP8t7/Yytj++48UrkGW5rfGodK1NpdP+qjMUvPgX6BGFs6XZRR0e01aa56rr
	 AOQcwufyEpfjlPV0R6J8Kx71cFfndwqnvqUR/0Uf1UGtNutAwoLcaIaR0WNhxHIGbw
	 awnFrgmtGUeXY6ua8F57/uxgRVkBOGIDwmG+0Nfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jungwoo Lee <jwlee2217@gmail.com>,
	Wongi Lee <qw3rtyp0@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/204] ipv4: account for fraggap on the paged allocation path
Date: Thu,  2 Jul 2026 18:19:46 +0200
Message-ID: <20260702155121.361628729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0d0d6ebdd3a849..41031c5c430334 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1118,8 +1118,8 @@ static int __ip_append_data(struct sock *sk,
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
-				alloclen = fragheaderlen + transhdrlen;
-				pagedlen = datalen - transhdrlen;
+				alloclen = fragheaderlen + transhdrlen + fraggap;
+				pagedlen = datalen - transhdrlen - fraggap;
 			}
 
 			alloclen += alloc_extra;
@@ -1166,9 +1166,6 @@ static int __ip_append_data(struct sock *sk,
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



