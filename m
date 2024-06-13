Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0245D2566;
	Thu, 13 Jun 2024 12:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282658; cv=none; b=TY7/6lRoo9Huix8iGMKaU5keQi7AAeY7tPVd+BqLZJHMZgj3ZO/Ss3V7OxCwlGKitlxfZnJrD7c/MsKc91uwXpoLzgsp5bR01zXKKau36nixVO7YSH2fqi4d4Jhumyqevy3LlX7JniTjaFhivr7cUCnCJgxfTNjRyuczn17wevM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282658; c=relaxed/simple;
	bh=wIN2EvmSoBnH/S0iHrtnsyIOpFW9ldybMBCLwEPPa3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWBJAV+cDx5taeB3+cSm51hz++uW2U5fsm2AjeMAOGOdFPtDpN+yYSXufv7xbYr4xdkyincbh2b5GWbJRsf1M/mMSPSNIfiuqNJzQsfFtc01ebeVHQCzSk2etBhcy1j7t/8g/mQHluqQ1438yDreu7VLa3Kfcx5KU22R9Bbh3JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeZZdJ38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeZZdJ38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCF9C2BBFC;
	Thu, 13 Jun 2024 12:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282657;
	bh=wIN2EvmSoBnH/S0iHrtnsyIOpFW9ldybMBCLwEPPa3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeZZdJ38hXu/l0fLbjsgJJU0DfSW4Np4pPKyGeJqR3E+0r1MkQtMBYgSiy3idn7F3
	 dmpQuSQhM+URzCmycPp+MuDREZAH8EPaAXs3P+g+WTBfoh/+NJLHEDcj7be4um2B5D
	 PDvL0cDGfE2YDVOfvRICMX3gFakLyOupqX7ISH1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ward <david.ward@ll.mit.edu>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/402] netfilter: nft_payload: rebuild vlan header on h_proto access
Date: Thu, 13 Jun 2024 13:34:38 +0200
Message-ID: <20240613113314.659604280@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit af84f9e447a65b4b9f79e7e5d69e19039b431c56 ]

nft can perform merging of adjacent payload requests.
This means that:

ether saddr 00:11 ... ether type 8021ad ...

is a single payload expression, for 8 bytes, starting at the
ethernet source offset.

Check that offset+length is fully within the source/destination mac
addersses.

This bug prevents 'ether type' from matching the correct h_proto in case
vlan tag got stripped.

Fixes: de6843be3082 ("netfilter: nft_payload: rebuild vlan header when needed")
Reported-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 33c563ebf8d3 ("netfilter: nft_payload: skbuff vlan metadata mangle support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b1745304dbd22..697566e4ae759 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -110,6 +110,17 @@ static int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
 	return pkt->inneroff;
 }
 
+static bool nft_payload_need_vlan_copy(const struct nft_payload *priv)
+{
+	unsigned int len = priv->offset + priv->len;
+
+	/* data past ether src/dst requested, copy needed */
+	if (len > offsetof(struct ethhdr, h_proto))
+		return true;
+
+	return false;
+}
+
 void nft_payload_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs,
 		      const struct nft_pktinfo *pkt)
@@ -128,7 +139,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 
 		if (skb_vlan_tag_present(skb) &&
-		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
+		    nft_payload_need_vlan_copy(priv)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
-- 
2.43.0



