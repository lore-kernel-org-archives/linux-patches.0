Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5779E502D67;
	Thu, 17 Sep 2026 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665019; cv=none; b=ba+l5p3IbaQXfQomhCBDzXNKprnS7zHCf4/aQoVEbO5aUP6+oo/Ks2io9XUgoxCIrZNiTwLlFcsYIbgJMlqWpcRqFxRqt1SZ/tGgg11e6YsfpOFBU+EuVuZf2JjrG4sFpgLRs0bxZKNPalUMeLd/H0bv9lasR0NFvzpBDGZjimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665019; c=relaxed/simple;
	bh=PGGnPhFxeUQD+W82LfJQPP2fFO91Dc6lhW5Ytld2OaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBk2aErkkgpXJdQ8c+qlyNQy0EUkLXTMUAvHlt1+g/M6O2JzHM7Q11YuO1CGuA5RGwk5s5+GDl2BfAD/xYIxnDxCSpx/rFZ2+QWzYH33YrA68lPdkltAvoT8Bqizbq4lkmcpn6kLGrZ9OkHk8dpI+uMprJGlha3eSrvX+V3hdtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfHQd3FG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfHQd3FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D2A1F00893;
	Thu, 17 Sep 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665017;
	bh=HGbsznYV9G24N0EQWBpGM4SzpxG+enaDcC2y5DlA1UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfHQd3FG5ZHRjpTuSBTkiFa6cOyiuKgFA48tVbwfKHUADaJp5NA9TwNQKZil3hFfZ
	 3NxK19kGcQiIbzoWwD7uscVsMMYBNmHsiXQOKy1x3mDvNiM9Wawb6Dkn57vEG9t9go
	 Zcf0L+QVYSX5GwP85CanMhVQjnbJMvo1cojDbUlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0566/1250] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
Date: Thu, 17 Sep 2026 16:06:01 +0100
Message-ID: <20260917151607.261069581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6fa0812cd79ca..07a4f4725fcb2 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1006,7 +1006,7 @@ static int __net_init nf_log_syslog_net_init(struct net *net)
 	return ret;
 }
 
-static void __net_exit nf_log_syslog_net_exit(struct net *net)
+static void __net_exit nf_log_syslog_net_pre_exit(struct net *net)
 {
 	nf_log_unset(net, &nf_ip_logger);
 	nf_log_unset(net, &nf_arp_logger);
@@ -1017,7 +1017,7 @@ static void __net_exit nf_log_syslog_net_exit(struct net *net)
 
 static struct pernet_operations nf_log_syslog_net_ops = {
 	.init = nf_log_syslog_net_init,
-	.exit = nf_log_syslog_net_exit,
+	.pre_exit = nf_log_syslog_net_pre_exit,
 };
 
 static int __init nf_log_syslog_init(void)
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index a6989966d80d5..68e5429338330 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1160,21 +1160,26 @@ static int __net_init nfnl_log_net_init(struct net *net)
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



