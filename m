Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE14C81;
	Thu, 15 Jan 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498709; cv=none; b=qHSffhgUdUadkvIeOO6rwCrUqCh/VDTDEU6VDJlqh7YsMeVSXyT+F5q2PC4CaWy/Y6vIaE3cNjuVVhnST6ybH3LRUTzi2PAxfftFA7DgrVgkM+7lcu0dP7q17ihUC715P3qpNkrczJ29ikWZl8BtEXlU/GD7zHqsoLDBtTBWfx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498709; c=relaxed/simple;
	bh=56rqIMFw9ptKj6OcyE1pYb9snlSGnAkpGVzySWEq284=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhkjNVikUFeADyY9Z/t3+yf+7WHyFaQzS2vCjESwRvvs5WMxUdJSGet4r0J2s3XafTsIperV5bYWe0cQhhfMr3UyaP5okKZBv/fAl+ADj6GhXw5//pi+uT7cAkomF2dDNYEVFFFC96TBZaSlJfB9af54AQ6R17Uplwyj7S1pIsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiDYbRW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiDYbRW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD504C116D0;
	Thu, 15 Jan 2026 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498709;
	bh=56rqIMFw9ptKj6OcyE1pYb9snlSGnAkpGVzySWEq284=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiDYbRW/JmIEpj3S7ODYrx9L/CyTXHqRCrD02LtjDxT1K0WqUBpVsgUjzr9WfLa9S
	 R2HnPWYuHnGMBLPcgiX0OdJobegmfSL6yxbDwC3GKLKzb2r4I5v99RwatWKJ105IgC
	 eu7bVBAOmCs/eJjE79kN1m9HEmY3WHXTjaiRUWIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 525/554] netfilter: nft_synproxy: avoid possible data-race on update operation
Date: Thu, 15 Jan 2026 17:49:51 +0100
Message-ID: <20260115164305.330630371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 36a3200575642846a96436d503d46544533bb943 ]

During nft_synproxy eval we are reading nf_synproxy_info struct which
can be modified on update operation concurrently. As nf_synproxy_info
struct fits in 32 bits, use READ_ONCE/WRITE_ONCE annotations.

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_synproxy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 0806813d3a767..46d2eefb0b218 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -48,7 +48,7 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -79,7 +79,7 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -339,7 +339,7 @@ static void nft_synproxy_obj_update(struct nft_object *obj,
 	struct nft_synproxy *newpriv = nft_obj_data(newobj);
 	struct nft_synproxy *priv = nft_obj_data(obj);
 
-	priv->info = newpriv->info;
+	WRITE_ONCE(priv->info, newpriv->info);
 }
 
 static struct nft_object_type nft_synproxy_obj_type;
-- 
2.51.0



