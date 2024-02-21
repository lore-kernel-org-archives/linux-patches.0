Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B3169953;
	Wed, 21 Feb 2024 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522246; cv=none; b=GWz/7bHeFFU9BlPfrgVIzeZFSG/LCja/+mTPAp+DPnHK7VvLK29jIXxTWNLCxRsFS9qH/tvll80zmxl3i1vS/tQ8NsUgWKKiSeOxCLN+Eff4TYbQZMDT6SZosvjejRir/nrdrvYAnH5h4O7TuPWMzfmRf0/hRMWghKXlWCBscD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522246; c=relaxed/simple;
	bh=BA5IR95nauOo3IqDhdZ+wHR/wVQusLErrJMcjZg/cEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWiCA1G5OKfNtEUapQ/wn40zFLonxtoeVp9ps60Set9+B+rY6A4CDiUkSpiUeRPYgXZge9w+W7vufYDKlWVcfgCx4YE7zg4iOxbz0U+hSE0srlERq/J3ekOHgi4J8UvaLDyvciryK3NNqN98cY1+rxZfgSZqPQ3p575nf7u8t9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zALaOkIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zALaOkIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97BBC433A6;
	Wed, 21 Feb 2024 13:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522246;
	bh=BA5IR95nauOo3IqDhdZ+wHR/wVQusLErrJMcjZg/cEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zALaOkIOgGyJVvYfUTHLMV0xRtOyKilvCL9sveaB2KMx8BaimjaTASjgRpKUzLLcT
	 Enb1oIBSGcJTrBcxQyE6bRFEgxPTOrOQjZpJVGJkO+79RZnOCE04ITpc0qZe9mi2fK
	 B23UIs2C/xHkZdZsVDZFNvaDaQD2XG/w4M7LM7vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 086/476] netfilter: nft_chain_filter: handle NETDEV_UNREGISTER for inet/ingress basechain
Date: Wed, 21 Feb 2024 14:02:17 +0100
Message-ID: <20240221130011.168071308@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

commit 01acb2e8666a6529697141a6017edbf206921913 upstream.

Remove netdevice from inet/ingress basechain in case NETDEV_UNREGISTER
event is reported, otherwise a stale reference to netdevice remains in
the hook list.

Fixes: 60a3815da702 ("netfilter: add inet ingress support")
Cc: stable@vger.kernel.org
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_chain_filter.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -355,9 +355,10 @@ static int nf_tables_netdev_event(struct
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
-	struct nft_table *table;
 	struct nft_chain *chain, *nr;
+	struct nft_table *table;
 	struct nft_ctx ctx = {
 		.net	= dev_net(dev),
 	};
@@ -369,7 +370,8 @@ static int nf_tables_netdev_event(struct
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-		if (table->family != NFPROTO_NETDEV)
+		if (table->family != NFPROTO_NETDEV &&
+		    table->family != NFPROTO_INET)
 			continue;
 
 		ctx.family = table->family;
@@ -378,6 +380,11 @@ static int nf_tables_netdev_event(struct
 			if (!nft_is_base_chain(chain))
 				continue;
 
+			basechain = nft_base_chain(chain);
+			if (table->family == NFPROTO_INET &&
+			    basechain->ops.hooknum != NF_INET_INGRESS)
+				continue;
+
 			ctx.chain = chain;
 			nft_netdev_event(event, dev, &ctx);
 		}


