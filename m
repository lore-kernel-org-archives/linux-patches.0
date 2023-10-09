Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104DB17990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYz638Zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D907C433C8;
	Mon,  9 Oct 2023 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857163;
	bh=ad4tpvR4n6aXF6N8V7O9O9yb7zQAdSfJ9Doxwve2i94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYz638ZojS02eYk5oMKJbDZFKSR2UoINIPDk02LBT+k1oKOJkcQD3skDc7+wUST1n
	 lYeX4TWSmKXYn6IZLJnCsVbrkGeIIRUvJcGIsRWiBRIPno3l8WAIrc+sCslmZrU7JW
	 OVYV/Sdn6oDAhZbqC6cZcAOU8Zg4/7+Qq3bR4/d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ward <david.ward@ll.mit.edu>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 117/163] netfilter: nft_payload: rebuild vlan header on h_proto access
Date: Mon,  9 Oct 2023 15:01:21 +0200
Message-ID: <20231009130127.256521593@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 8cb8009899479..120f6d395b98b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -154,6 +154,17 @@ int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
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
@@ -172,7 +183,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 
 		if (skb_vlan_tag_present(skb) &&
-		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
+		    nft_payload_need_vlan_copy(priv)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
-- 
2.40.1



