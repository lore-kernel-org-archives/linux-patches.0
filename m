Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590207;
	b=FkFLuByFSnTGIVwP5MAiOVQKK6wydITSxtLoa6l6Nev5qTRkX+TmdiujeIm+nx1qI19j
	 7RZL2SYhR1k798tmpHp0iNNQy+UM8oFpdaEZ1ipJxcRJYEzEWithR2SNdfSmbIzy9y2Xx
	 uFeJGIxHDlSBg9V3W82VEolTMzrYO+YSo0BpLcCKMcB1oQIVebYuQ/bUoK12gonbOk0Ta
	 J+ZNeMS64S6c/StTaPy+dCOy3+QcGFkNEEFuO2/4kzzthyuLUT1fcWOsY5KVD7H+JH8Sw
	 tU4THNpuGQ7QP4i+FtU+VmFSCLxg0ubaAF4Bxq9WD9xLjdffl+oX8z47KYDop9jrmuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hrIwRvwluX/eG1EIjHkXhdKysomzOjUGu+1FZmZn7A=;
	b=duL8eXvrVn1ofxW7ehHa+PBrvlka3OxySjZHJfur26zRRAKINwwPgD9rHdL1NDxXGFlT
	 3ZWzTTfGZaw8a9fgcEvtb4NDGy8Tsrkbl0izIgZyoC71sJebzS1QKe9zwIJnqIi722ycz
	 c/g9bO/agMG94ncAEGUJ4ZSY2op4DzVD3JW6FEAsZke8q90GpeFHczpNs4IVDZa4a/kgw
	 A36d4lYMG1CCRBsE09gGiXJ1rLy8xkgD/bUDka1T9QQ0UTmzcsyXP8xPVck8uKEHhwd6X
	 EeHbrKxFcyrfHlMpPntgOXT5qmTFHE2W7CtAgPZMzABR8I9BumOisW06XtJIyxjzcSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiHmsYVe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE5A606A8B7;
	Fri, 13 Nov 2026 17:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiHmsYVe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03C31F000C9;
	Fri, 13 Nov 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590207;
	bh=+hrIwRvwluX/eG1EIjHkXhdKysomzOjUGu+1FZmZn7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiHmsYVexanp29tI6hEwx5dhZ7FmrGQfrsvWOCpgO5UbwC1RPP1rmKdEK4WNe/aFN
	 z67FcMGVrdAZzUP0bCmbHf2O6Bnm3+of8lNde7821Vz2egCDsiYBJzgpscDmYWsHMo
	 NdxqjQpcaHORReZfY/SCmAoXlhhwGakWxJdktVeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/686] batman-adv: mcast: validate tracker padding before forwarding
Date: Fri, 13 Nov 2026 10:45:44 -0500
Message-ID: <20261113153828.187005313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit ea01fff30f631e67ee5f0a2b97855d772b3a35fc ]

A multicast tracker with an even number of destinations needs two
padding bytes after its destination list. batadv_mcast_forw_packet()
currently only checks that the count field and the addresses fit in
the tracker TVLV.

If an unpadded even tracker is compacted to an odd number of
destinations, batadv_mcast_forw_shrink_update_headers() includes those
missing padding bytes in the amount to remove. The subsequent memmove
can then write two bytes past the old packet tail. With no tailroom,
this corrupts skb_shared_info.

Include the required padding in the existing tracker length check.
This rejects the malformed tracker before either received or locally
generated packets can reach the compactor.

Fixes: 2dfe644a1ce0 ("batman-adv: mcast: shrink tracker packet after scrubbing")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/multicast_forw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/multicast_forw.c b/net/batman-adv/multicast_forw.c
index c99579dc1ca98..1638278178d98 100644
--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -950,8 +950,11 @@ static int batadv_mcast_forw_packet(struct batadv_priv *bat_priv,
 
 	dest = (u8 *)mcast_tracker + sizeof(*mcast_tracker);
 
-	/* check if full tracker tvlv is within skb length */
+	/* check if full tracker tvlv, including padding, is within skb length */
 	tvlv_len = sizeof(*mcast_tracker) + ETH_ALEN * num_dests;
+	if (!(num_dests % 2))
+		tvlv_len += 2;
+
 	if (tvlv_len > skb_network_header_len(skb))
 		return -EINVAL;
 
-- 
2.53.0



