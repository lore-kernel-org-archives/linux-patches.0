Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3F516179;
	Wed, 30 Sep 2026 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784837; cv=none; b=RNb52svJTTiKlAuuaR0wXYDHrCPZJWjIEr8bHq2dZqa480iVTKTpGD9ECMHfvj7QBpLMO4Mn8t5sH9KMQvZw/fwwx9DGy3eD6Nkt7wY9+zAaZXwv2Q8KkLCmOksCw9BTc4LcMHAuq4xSGvBXNtDWPuTetQAjrN4PmTdHHqQCdFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784837; c=relaxed/simple;
	bh=9CRiT/0E9u0l4m8ASupq25WBoZiyFLMUSuMsYEmZTyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGiPMRifhTLKDX8nciYMNarFESESdAXymjo/avp9jz97Satj0+0cWjlw4R/7dov0iFUwhRnh8M5GQKArv3pie5JZ81vdsbYhZtyfD2nN3O0UUX9lN+KvGTYdcf2wQX7FmuVN5XHjKF1abI8sWfTdnjQJzQL5dFF6WIlncmC/+6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU0qKk1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU0qKk1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AF81F00893;
	Wed, 30 Sep 2026 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784833;
	bh=0c4gz8U/JzRRIVrlbPoENWSq3rDddn5BsLChiaVVvto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uU0qKk1CjgTWfQJakIdy+N3GkA1BkDuMnSQ0mqTDNl5Hdvii+L7r4RLbvCXGRNuba
	 v5v5JJJ4mjooKpv0fkUFmsHq3qJEwRG7qOEDAIlF1NCJAH0ISMBD5Mmj5lrpY6rHbn
	 /q2RUWwXwxjNhurJGALXtgzHckLXtrkW/K6ym1ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 293/982] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
Date: Wed, 30 Sep 2026 17:17:09 +0200
Message-ID: <20260930152423.100833539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b7528fa74f3af..d3c43897250a5 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1129,21 +1129,26 @@ static int __net_init nfnl_log_net_init(struct net *net)
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



