Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BE751D50F;
	Wed, 30 Sep 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791356; cv=none; b=Tm7TO+PmI3QAAEsyCQx4PuVkWbja1+vZdJTKg2BVqNb5uUEp0rtmddF9mnX1+Szgwh66WGdaF7gE3bibPa7Bgik2N8mHL8uJAiIwx8rsSWZe8ig9QmZkOEi7C40x2P3WFugc8lqdLJGeMwJNGhYSBfj5wusY67X5R+HGFSg/+vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791356; c=relaxed/simple;
	bh=XUqEe+MlBVJ9PZvlo37vsNAzuN6ds7IaaP/kVU5V7TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcCbzkhxSfrXxZRjEmklk5518otJsO8hD1jNPegJQN2IBrnioNs5gvaANTLKkOM1b0nlBdl2FvNm/5oUFHd80nAzV9J6rVqKqw6Waxk2U7nxZlnF9KrHzQ5rA7p6eqrrksJTznl69cAJOi4VS9IlWy/z3dgarg7duP7h7tv6nKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWYj+1Eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWYj+1Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618EF1F000FF;
	Wed, 30 Sep 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791354;
	bh=ErEhYoBrj8Vty1cAqxQxVD9hKUiuUs6SHVr9J8q/hBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWYj+1Eg8JUDSS4WFCtcddRVN05xeHUgoMMbZSMsT/SCUXt+0C6kfYy4pYR3Fj5fZ
	 HJxEeu7VT9a82Efwey6jk7eQhmJGtW+7Z48ANdD/3qHEuRjEvf39kKQpTMYR6NBJLw
	 zoVaSc8GwFTFEdU/5rUSxDjx7WepoIJKAPsuPuBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/752] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
Date: Wed, 30 Sep 2026 17:21:38 +0200
Message-ID: <20260930152403.193693951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index cae95c7963d73..b741d75dc329f 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1011,7 +1011,7 @@ static int __net_init nf_log_syslog_net_init(struct net *net)
 	return ret;
 }
 
-static void __net_exit nf_log_syslog_net_exit(struct net *net)
+static void __net_exit nf_log_syslog_net_pre_exit(struct net *net)
 {
 	nf_log_unset(net, &nf_ip_logger);
 	nf_log_unset(net, &nf_arp_logger);
@@ -1022,7 +1022,7 @@ static void __net_exit nf_log_syslog_net_exit(struct net *net)
 
 static struct pernet_operations nf_log_syslog_net_ops = {
 	.init = nf_log_syslog_net_init,
-	.exit = nf_log_syslog_net_exit,
+	.pre_exit = nf_log_syslog_net_pre_exit,
 };
 
 static int __init nf_log_syslog_init(void)
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index db309c4167427..7ad0cf0cb6935 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1126,21 +1126,26 @@ static int __net_init nfnl_log_net_init(struct net *net)
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



