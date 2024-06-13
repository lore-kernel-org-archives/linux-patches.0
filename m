Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC641EEF8;
	Thu, 13 Jun 2024 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282522; cv=none; b=GjTSI/NerZ2OsEjc39ayFtpLOJQlXYGMkuQVZCCqzzwaFbaYfAqq527qf/wRnVuN8vSRcfdug3li0egDKFgh9F309dqfrR9Np9tQ5J+G9fvEZdPRMLBy0wpecBLA3bM1HYcZFxHVaEn0Iz6RowuUpOpDj49hX6nf/9jonisG4DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282522; c=relaxed/simple;
	bh=/X+86ZmPaI4ixN1TF26W4cdhbvA8ObXwJ4MQpMQ3spc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAV8TbWalee9yd31NvxP9YMtSz05k7PA5f6mWF4da3vm8GVkVEhAXbB/Q5F+LE5TDNU2Wd3nXmeDvnXgE1nj8gTXe0TGlUE7LLYnuhDpKJub0NO4w2K+CVEDqZk/jhyZW7PcRNkwt0Ceez/4NWbeCq6Ipl/FlIeSc4H5rhrsKiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdQUvEHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdQUvEHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6596CC2BBFC;
	Thu, 13 Jun 2024 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282521;
	bh=/X+86ZmPaI4ixN1TF26W4cdhbvA8ObXwJ4MQpMQ3spc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdQUvEHJey5v0eLKRkZGvcPe8Rk4FdJO7/6Gm9nhhKalvGDteFKflXcKYUcARN13q
	 AwIm0Qf9yuD4G91OU3Mwv5baSs8Zk556GjBulcl6+5oiLZTOQLTMqW3QlD6m6aX385
	 83tsxauiAnhrTdTwvzxg+4VIwJ0/0vnfTHFAD5bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/402] netfilter: nft_payload: restore vlan q-in-q match support
Date: Thu, 13 Jun 2024 13:34:22 +0200
Message-ID: <20240613113314.038725982@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 02327ffebc495..4192f0e366554 100644
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



