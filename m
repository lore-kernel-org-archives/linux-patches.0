Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5643E79DBF;
	Wed, 21 Feb 2024 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523827; cv=none; b=g8iNCSkjMH3rj3D4hI3lfKBIGn4aqWiYkqHcy6AwrpdHSgeZkd2SQrkGF97+3uwxZSn+f6if6Te+9ZDwKF7CvyGP7t9bBXvBCQB4SZfyIs6QaPXWvqf0lO2t045fBop9KHBaRxuruHHrqgymX91i2qgqGDjgX/V/QH1EEQLVFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523827; c=relaxed/simple;
	bh=SMnTCiQmYslWJfI2aHtiy9vT4w/f7h52u1wUgIzMIJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijF8tRRxdnKBIolm+L8oKAgyCEjXAzgBEjBQUwk1SQKDHJ45uvXkDJHrmyggHagrL+nGS+yTjJ6UNVzsl+nT2AmFP07ehjnIZSkAZ9ugeYcGlX/uxkQ32SUW3cjQnvvUylea2a6JqReal9gql+RmFj4X/Y3leZtHL1mEyWYSyKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRdpiNhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRdpiNhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60444C433F1;
	Wed, 21 Feb 2024 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523827;
	bh=SMnTCiQmYslWJfI2aHtiy9vT4w/f7h52u1wUgIzMIJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRdpiNhFrPmOPv/7wO+LyCN8gjfxbUiC5YkSaem/j9ZVkAJsUsRko1GhnCXfRM3OO
	 NB+4E4yUO0GBtFOPJWHKSUMJnSqudJkrCnNy89Gb5I+A9Q4Zo1klyc/93TYwyI+vYZ
	 USUwYXCGYvon1hWg+Q765Qp40c96/Vcq2Ht8hWA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 070/379] netfilter: nft_chain_filter: handle NETDEV_UNREGISTER for inet/ingress basechain
Date: Wed, 21 Feb 2024 14:04:09 +0100
Message-ID: <20240221125956.987426829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -358,9 +358,10 @@ static int nf_tables_netdev_event(struct
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
@@ -372,7 +373,8 @@ static int nf_tables_netdev_event(struct
 	nft_net = net_generic(ctx.net, nf_tables_net_id);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-		if (table->family != NFPROTO_NETDEV)
+		if (table->family != NFPROTO_NETDEV &&
+		    table->family != NFPROTO_INET)
 			continue;
 
 		ctx.family = table->family;
@@ -381,6 +383,11 @@ static int nf_tables_netdev_event(struct
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


