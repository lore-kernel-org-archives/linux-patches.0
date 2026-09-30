Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C042436F8F2;
	Wed, 30 Sep 2026 19:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794822; cv=none; b=HCD4xA2EaPlqL9wf/N+DhNkM+OeaDslIe5ejSTp7gHQw4kX+dGCYHKcqQA2IJdC/fRMrWAB6wBvvAqhkE1E67tcQ4pMJPCXxhzkxMOha/QjnSvnkeeHsvVe2kQ/Ax62bUh7sXSWkQ/kko2BUuE9U2yN3Pg9wz8DxvbCCeLV38vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794822; c=relaxed/simple;
	bh=1tQYmqWpGI3hR6JJnmbvgPtimZLoJeTUWnDbSTIDGVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2HlAQK9Vvmb1r8Q7qMkrXdq/owciXCu3dkMjEnF+Hw+npTnxf2Rn9BSWaMduETpttjOlf9c+KzAW7lwKOALhA3p/oyhjUYtSkWrbwHnEMC0wfUn1/qLjkc0xzIZzCG9IWHi9TIKwIVfcRFc4iAr8B3vjcV8F4fabskoHwyLcuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DR8aeony; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DR8aeony"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274F61F00898;
	Wed, 30 Sep 2026 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794821;
	bh=jxm0oENhTEANnKMQEGpiu7RoZBigJoZRUiUahpmFqGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DR8aeonyApqbK+0Hp9bbsDazH3UOe8wwI6sTXNhNHA4uzI99uyHPVFM0mnFdtzNmW
	 JrSWq1AQK8ARke89T/ZIExcxuI/AJE/G76M8qwg+5PPI3oaTxhzBA2ClrG+SHMOn9z
	 XeT+gqvZLOxZTEN7wVYFv/kCFMan3F3psrY5vSJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0345/1193] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
Date: Wed, 30 Sep 2026 17:17:09 +0200
Message-ID: <20260930152441.827508187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 33d1469b0124cc0baaea7a2032123b77a81e0940 ]

sashiko reports: "nfnl_log_net_exit() calls nf_log_unset(), which
clears the logger pointer without an RCU grace period.  Immediately after,
ops_free_list() frees the per-net state while concurrent packets might
still be executing nf_log_packet() under rcu_read_lock()."

Clear the pointer via .pre_exit to make sure rcu readers have completed
before pernet storage is free'd.  The change in nf_log_syslog.c is only
done for consistency: it doesn't use pernet data.

Link: https://sashiko.dev/#/patchset/20260731151806.849724-1-pablo%40netfilter.org
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_log_syslog.c |  4 ++--
 net/netfilter/nfnetlink_log.c | 13 +++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 11325bad19b36..70bac3f45a015 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1004,7 +1004,7 @@ static int __net_init nf_log_syslog_net_init(struct net *net)
 	return ret;
 }
 
-static void __net_exit nf_log_syslog_net_exit(struct net *net)
+static void __net_exit nf_log_syslog_net_pre_exit(struct net *net)
 {
 	nf_log_unset(net, &nf_ip_logger);
 	nf_log_unset(net, &nf_arp_logger);
@@ -1015,7 +1015,7 @@ static void __net_exit nf_log_syslog_net_exit(struct net *net)
 
 static struct pernet_operations nf_log_syslog_net_ops = {
 	.init = nf_log_syslog_net_init,
-	.exit = nf_log_syslog_net_exit,
+	.pre_exit = nf_log_syslog_net_pre_exit,
 };
 
 static int __init nf_log_syslog_init(void)
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 3da32d2f68e09..5df1d197f07d2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1137,21 +1137,26 @@ static int __net_init nfnl_log_net_init(struct net *net)
 	return 0;
 }
 
-static void __net_exit nfnl_log_net_exit(struct net *net)
+static void __net_exit nfnl_log_net_pre_exit(struct net *net)
 {
-	struct nfnl_log_net *log = nfnl_log_pernet(net);
-	unsigned int i;
-
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
 #endif
 	nf_log_unset(net, &nfulnl_logger);
+}
+
+static void __net_exit nfnl_log_net_exit(struct net *net)
+{
+	struct nfnl_log_net *log = nfnl_log_pernet(net);
+	unsigned int i;
+
 	for (i = 0; i < INSTANCE_BUCKETS; i++)
 		WARN_ON_ONCE(!hlist_empty(&log->instance_table[i]));
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
 	.init	= nfnl_log_net_init,
+	.pre_exit = nfnl_log_net_pre_exit,
 	.exit	= nfnl_log_net_exit,
 	.id	= &nfnl_log_net_id,
 	.size	= sizeof(struct nfnl_log_net),
-- 
2.53.0



