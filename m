Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4386715F309;
	Mon, 29 Jan 2024 17:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548587; cv=none; b=b9WtWE5NQ36xxIJ4eQS3AeWe/qdmPCkBKAQgCMbWiigt9Tp6hFouLszBf4sfDXyAPP2eLPqUFYi8f3oca/CfYXHt6qwLnE3LJgQZPmaJFBCln75yySmPPt3az/ESG3TX79Vjhy0GZTSuRFktxyg/9EaiNKm1QqOrY2eJEeyrWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548587; c=relaxed/simple;
	bh=DYqpSKV9/UAiuEpg5VPsG7UXSGpG04dgF64SbvfSrqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4SW3WEjmyvGYHe70jX1y35aG+ywyL+5ThrTadn9W4QZVUSL/e4SR2Pl53mLUlAlJeUXgV9oq0DEBZheAFgLZP/VYHTXDHrrGdrnvoSF3/41YaDeN0UR/2lbLX9L1FOrLDriPZ+sOaOUeeYqklMXWwutQSMBgo3iu1zwFVFZrxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+3D1O6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+3D1O6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAC1C433C7;
	Mon, 29 Jan 2024 17:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548587;
	bh=DYqpSKV9/UAiuEpg5VPsG7UXSGpG04dgF64SbvfSrqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+3D1O6SsrWzHBKFMvYWpYoMii1/evXw6mb1OSLgMct/3WfqMmeM0kEc0UU2QhzPK
	 jm4ZGXfFYMSR9ppVWejmAeNleaThtnvobubh+osriRXNF9DtGJLEuTHs08wdQYIi7e
	 r0PyEELHmEEHtWVk49AiqybJ/2XeAfESswX63ZaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 243/331] netfilter: nft_chain_filter: handle NETDEV_UNREGISTER for inet/ingress basechain
Date: Mon, 29 Jan 2024 09:05:07 -0800
Message-ID: <20240129170021.992261767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


