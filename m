Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11805139CFE;
	Thu, 13 Jun 2024 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282655; cv=none; b=XwIwt1f6v5XJXI3rK9tqateNbtNBmwUe2T5OvVepv8cPnuc3wB9Dl8Rid621QGop/NDxFP05RSlX+Eq5E8a8vk4zAIkbt8bybhm2CkjQiQ460OSdr9dENpV8smtxFP0rSObOBZdyJdjYbkVrSiclqm8UX3Ja/oF7esKfga5fv48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282655; c=relaxed/simple;
	bh=G4RiEjbfjlr4b0q7R6WIBEIIQOLebt5Y8c3dzwaSKR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSpNAjF2/YvcRBi1qDV1CqH/g3PrdktNDJ9djRMDKU7dJ6UOdmAInFdQv6szJHhTBBGPVgoNWTPOBpSdtaxJN60OwneNEQs9rtYaIQoyrpA9OBA/sccU9VEg9l8+HdLRelKCSoORCvZJzmXOPMQO8NCWUJEYgtDhFBIYPovbfm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOwVxZyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOwVxZyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CC3C2BBFC;
	Thu, 13 Jun 2024 12:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282654;
	bh=G4RiEjbfjlr4b0q7R6WIBEIIQOLebt5Y8c3dzwaSKR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOwVxZySMxsM0vVo/S14IceGCUpVYpkwBBO6n98CKdO3au63trDHmXYO8WjC4Y/gN
	 01LQgtwwA3HXAOB+YJnAAVMR4gMLevQpsaQYMoMa439gP5YeNuSIyzC2oUIXmowvtZ
	 lqWNhvqXu09aU9/t34xdWX9m+mxRrgf3jJRmW80Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/402] netfilter: nft_payload: rebuild vlan header when needed
Date: Thu, 13 Jun 2024 13:34:37 +0200
Message-ID: <20240613113314.620808543@linuxfoundation.org>
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

[ Upstream commit de6843be3082d416eaf2a00b72dad95c784ca980 ]

Skip rebuilding the vlan header when accessing destination and source
mac address.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 33c563ebf8d3 ("netfilter: nft_payload: skbuff vlan metadata mangle support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e5f0d33a27e61..b1745304dbd22 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -127,7 +127,8 @@ void nft_payload_eval(const struct nft_expr *expr,
 		if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) == 0)
 			goto err;
 
-		if (skb_vlan_tag_present(skb)) {
+		if (skb_vlan_tag_present(skb) &&
+		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
-- 
2.43.0



