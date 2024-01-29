Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9BF15CD75;
	Mon, 29 Jan 2024 17:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548361; cv=none; b=aQHSF74Z8VHhco+e9CAMfqazR+OVM7y3vXYn1t9HWVaBjMlO8/vQfsepoeetL56TVWW337G05ZVse5CmCFtvedWvZaJxc35s3+W+hyDrX5w8bh1C/U9UQZlyjw/Y6udXVLrVDjeS+Ev4UTtlaPy/TAjb3qNV9ZE0Svb8hAYYWIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548361; c=relaxed/simple;
	bh=fEYWoC5uaxjtMVnpvsruXIJ/G+Hxw4qQZL9bahTbL6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlA0kCM6hAv2Y2ocjRkmcO3yhP7tBiLoMuuoLg6ici/xq9FjyHbS8NkIjfRfF7Rl0lr0WWeq7AdqZZsixz0Ff8P4mikGijJ+bqAzPWfDqKOuNhSXkmIOAWUp1YvToTlUFVbQCNxxzIfSZ6MMMjDOYTkpF+GPQv1GruxcsfwoM6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgj+2GJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgj+2GJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46933C433F1;
	Mon, 29 Jan 2024 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548361;
	bh=fEYWoC5uaxjtMVnpvsruXIJ/G+Hxw4qQZL9bahTbL6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgj+2GJ2hTSCCQHq/u3rXU5eQzFepDgxoIv7A4XXG1Q17VbnbgNyXZgOAJgpg4jUu
	 miFuXaUYj9D/Lt9UEo+nNY1yTnn2AYOsvU7433LPfPU6z9DVbx5X5dbZwgdmxAz49i
	 /TEiNokqBBftauqklDI0qiGcEpyBJpBjKCajD2kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 125/185] netfilter: nft_chain_filter: handle NETDEV_UNREGISTER for inet/ingress basechain
Date: Mon, 29 Jan 2024 09:05:25 -0800
Message-ID: <20240129170002.606213632@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
@@ -357,9 +357,10 @@ static int nf_tables_netdev_event(struct
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
@@ -371,7 +372,8 @@ static int nf_tables_netdev_event(struct
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-		if (table->family != NFPROTO_NETDEV)
+		if (table->family != NFPROTO_NETDEV &&
+		    table->family != NFPROTO_INET)
 			continue;
 
 		ctx.family = table->family;
@@ -380,6 +382,11 @@ static int nf_tables_netdev_event(struct
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


