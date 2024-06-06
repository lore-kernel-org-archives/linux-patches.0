Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9491C95D3;
	Thu,  6 Jun 2024 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683727; cv=none; b=s5lsExw5jmQWUuK/dt5VEiwL827ZhX+qtCQiM8yuUuo3NWfwV7pUOVnMeOm0kYS0020JCBimqtk4SLk6+6EuLoj+hc5Yg9cnEme82IWnTjHb2Gukp2ovQIcamR+ylQUjxOmfbT8EwYgVK9LXwiRChgx8h4nB3QOXHfbFKypOyi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683727; c=relaxed/simple;
	bh=IkAyV3/tjtotLEOMEXqla8jPj1UFQkX52vXqRZbba5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs5XiL1gwetKqywHC4u0d1EdZ17Uk8HyfF0uqsccQwt+g4y2a8cydE922fBUmB7Us9TJ59rEsSFfGqBajwJ6dhafHyvz9+bycujqoLF6DjC6KTDz2sWPM1XVVUGp3GJNrwJDPs0fmzJ2SWKGnGpgL2wkTI5Jmo9+8Yc3orruaQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejrdg08b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejrdg08b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBF2C2BD10;
	Thu,  6 Jun 2024 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683726;
	bh=IkAyV3/tjtotLEOMEXqla8jPj1UFQkX52vXqRZbba5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejrdg08bkdA9Qas7aL20yv3GOdjBRlux9C/l6mx5ovtfgM4oM09hYtMfepD3xhfXp
	 VsUPjFSaKvc4aJJhdxvPZ1H3MFTuUYF9De4Y8PavD//DSFDCiVeFXkKaU/qoJkAH6I
	 P8EIHHfPqbgylavJ291tGIETt2QpJvL9B5mdy7Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 674/744] netfilter: nft_payload: restore vlan q-in-q match support
Date: Thu,  6 Jun 2024 16:05:46 +0200
Message-ID: <20240606131754.107149848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit aff5c01fa1284d606f8e7cbdaafeef2511bb46c1 ]

Revert f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support").

f41f72d09ee1 ("netfilter: nft_payload: simplify vlan header handling")
already allows to match on inner vlan tags by subtract the vlan header
size to the payload offset which has been popped and stored in skbuff
metadata fields.

Fixes: f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0a689c8e0295d..a3cb5dbcb362c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -45,36 +45,27 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	int mac_off = skb_mac_header(skb) - skb->data;
 	u8 *vlanh, *dst_u8 = (u8 *) d;
 	struct vlan_ethhdr veth;
-	u8 vlan_hlen = 0;
-
-	if ((skb->protocol == htons(ETH_P_8021AD) ||
-	     skb->protocol == htons(ETH_P_8021Q)) &&
-	    offset >= VLAN_ETH_HLEN && offset < VLAN_ETH_HLEN + VLAN_HLEN)
-		vlan_hlen += VLAN_HLEN;
 
 	vlanh = (u8 *) &veth;
-	if (offset < VLAN_ETH_HLEN + vlan_hlen) {
+	if (offset < VLAN_ETH_HLEN) {
 		u8 ethlen = len;
 
-		if (vlan_hlen &&
-		    skb_copy_bits(skb, mac_off, &veth, VLAN_ETH_HLEN) < 0)
-			return false;
-		else if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
+		if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
 			return false;
 
-		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
-			ethlen -= offset + len - VLAN_ETH_HLEN - vlan_hlen;
+		if (offset + len > VLAN_ETH_HLEN)
+			ethlen -= offset + len - VLAN_ETH_HLEN;
 
-		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
+		memcpy(dst_u8, vlanh + offset, ethlen);
 
 		len -= ethlen;
 		if (len == 0)
 			return true;
 
 		dst_u8 += ethlen;
-		offset = ETH_HLEN + vlan_hlen;
+		offset = ETH_HLEN;
 	} else {
-		offset -= VLAN_HLEN + vlan_hlen;
+		offset -= VLAN_HLEN;
 	}
 
 	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
-- 
2.43.0



