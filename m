Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0653A1A01DA;
	Thu,  6 Jun 2024 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683637; cv=none; b=lESvln3GEkpn2PIf/HvQjMMiKU9bEkJHWugfCHwfOa5fG9FVqxj9ktAkIMZ7MD1C6k2ycaIwpAkMoh+ARWC+0qQb2sBWPQmKv9dzDlNEFRhE3bPY23ijsOj/iEVF6OpV4VJLFY8e9NNDPZTiA32TvnPBfuDPZI3pQQjmDYK+VBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683637; c=relaxed/simple;
	bh=pqKwQf21argRRcGMUY6IOBjbzaPlpJUIRTZTB21M5CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq9teiGmqetDP7W7GvrwKVRX0USKcIbZHDqxn4kARniouNEPSQjhE6VQ4HqXE13IiS4M89sLpyYr2Gz6ZzYsYC+yN+tqIx0vJidV2tcaygHoDh/jokr/r74pO1S4mDByOteDM8OTDBfzXs0LUHrIX31U+kLDndcOdeKD9lahtcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xl3R0UGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xl3R0UGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98515C32786;
	Thu,  6 Jun 2024 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683636;
	bh=pqKwQf21argRRcGMUY6IOBjbzaPlpJUIRTZTB21M5CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl3R0UGgzogL+1AXspwGOuhWp3xYPskD/sqhhnGziI/9XMSv9oVLPsprvTRbfgfM4
	 nUtWA2e3lDeSuMl9eCuj+u/vZ+JuAPSYUnGwLpG6WHGWMiQfg88EHfkPwiBh6NqmRO
	 Sb+U0mZvCHnk/D64q9Mv9ezs5KFFvYguecnqWM+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ward <david.ward@ll.mit.edu>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 457/473] netfilter: nft_payload: rebuild vlan header on h_proto access
Date: Thu,  6 Jun 2024 16:06:26 +0200
Message-ID: <20240606131714.795694595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74777a687eb5f..eaa629c6d7da6 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -109,6 +109,17 @@ static int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
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
@@ -127,7 +138,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 
 		if (skb_vlan_tag_present(skb) &&
-		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
+		    nft_payload_need_vlan_copy(priv)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
-- 
2.43.0



