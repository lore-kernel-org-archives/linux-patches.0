Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA7F19AD8B;
	Thu,  6 Jun 2024 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683048; cv=none; b=cFtgVz3Aj5l2+e32YsAH+hUhB9/Ow/0bTWmIo3GpYej4T9yCI5uhkLBER4tzpGxNDTPvt32RLV2GCsC7BMW+Tfm0Gf0kQ2Q+a3bhjH8MvYTGEYvtm8P3rY403d8Za7SFIdIm0WvOJAKL04ppwhMIdwjhe7Uq2ykexb/bs2eyHoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683048; c=relaxed/simple;
	bh=0r7eoznFkJBxweJaiy9Nmv+sLlkraF4jBOrWrUEB4xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2u3K9AukbEtWzhTzTNepqVp6iBtZMSJ7lr7YPVpcKcRS9RKNUnqV77zqo1E+2o1r8EdaeCraZFUl366KJwNYF+tBsNtPf4lngOFIV0egkhoWqq5ACtv3QAMTm/1yB0FYlW5kr8Jbc74+fiqoCzD79KNtjamu+ZmdUwylQYRzRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxHL2kbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxHL2kbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E50CC32782;
	Thu,  6 Jun 2024 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683047;
	bh=0r7eoznFkJBxweJaiy9Nmv+sLlkraF4jBOrWrUEB4xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxHL2kbDMChGnH2o3Nu5eAi2HZrBpujAAi6KweuatWLYWz29yaIL3Ouio1YZV0/QT
	 L4z9q8XUrAwE+zSATeRNUWJ7N4Dh/V2tnrtBIA/eZSY/5lvOAPrKlWCPkRWV0egjS8
	 /fTv009STQhXev9BxDLcApjklfwl7bTCINiYqUQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 285/374] netfilter: nft_payload: restore vlan q-in-q match support
Date: Thu,  6 Jun 2024 16:04:24 +0200
Message-ID: <20240606131701.438245487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



