Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4D31AAAF;
	Thu,  2 Jul 2026 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011243; cv=none; b=f2ofT6II8GZQBL/vHiF2wjiKlT7kug2PlHEWqe9VFgBC22CsJNXRBj9fpytf92ic2D7LMslNqCR1tNn6OQjC26whX/AIU0vflLAZAjgc4XlJihw6TGcfbkyaNk6w6WIv8ycVIRLNIz2IrtFLnGnnJ37vBo0CM/O74ZYDtw9qJ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011243; c=relaxed/simple;
	bh=lwJv91lsN9Zs77JIboCmgU+MrWPePz+sZau1cvNm1XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvPWcyIUfyT0VQnZ9b9ED17claD3yKU+mDFRprRq98D/8PTGcr5bWLZCzQpxEbMXiz7ywt4IRztC20iEkXYgMhX/AaL9HXbyfClM6Gm/moG+PBsY9cJa7D5LRcJSy/JHOJknu1gWbCrSb+mPoPtlafpwRbAzuBhcKHlsJ+eyeDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7whs/0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7whs/0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0BF1F000E9;
	Thu,  2 Jul 2026 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011241;
	bh=VJJdm0QSj3KUkhJhP208RUpVEeVe5OCD6j2mj7J2lwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7whs/0pCs8sUoWOwPtmTUjZlbyWhspwRw6NEURT4t4C3uoaPsldSclKLNMCyNZNt
	 Lrd+7319SO4bvUE7NuM8Mz8J3zma9smu9+49SCTsFhLyrfRRWzrPVF3k7zZrh64vS2
	 d4mfM1RAP0SqLAT2w5MBr1ALyB4T9X4v+bgGs2oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jungwoo Lee <jwlee2217@gmail.com>,
	Wongi Lee <qw3rtyp0@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/108] ipv4: account for fraggap on the paged allocation path
Date: Thu,  2 Jul 2026 18:20:30 +0200
Message-ID: <20260702155112.794136422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7c005263262ff3..7eaf35a6e24ba6 100644
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



