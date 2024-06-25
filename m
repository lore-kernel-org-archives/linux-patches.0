Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BCD12EBEA;
	Tue, 25 Jun 2024 09:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308486; cv=none; b=N9/oTY8ZeyCodIF2luZRXY58yVAfIbmOuCAmUNVZSPVW6tX9yzK3vcrx5ATu1Tlze25wecoxiwj7R8u5+eRNKzx5Cp/qIyldFWk1JIT4nkKpa6UUWc9z+oU4EShCL6HCeb/QMLJTlUvcdGq6jpbIYpTnoH6aVbLqOKKtlvIetVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308486; c=relaxed/simple;
	bh=2VQZKXlfxvgF1I1Qua1zB3vjdbmf2lfVltlAVd8c5y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZkgvwRSNoJBt2sYDNa+3afyUUP2JJNuOUVxG53SHR4sMWWpvYupzN9aeQhF51xnqj9UA3XSF5dU7zRtJuLHqVrIaccBaB2iXpsn0ZmWRb0WPM6vLVlCv0F5ixwtheILPcjjML9iKXQG4EZXqQAzfzUtoTsalvBkqJmk1cE+Wtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/3hC83C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/3hC83C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3283C32781;
	Tue, 25 Jun 2024 09:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308486;
	bh=2VQZKXlfxvgF1I1Qua1zB3vjdbmf2lfVltlAVd8c5y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/3hC83CxO98RtpAJRSgwVBLbpoAEtzIJYlMTq6majSWwPNxnncuLg0BUPqJlPx/C
	 P5eniG6RP/JEPjXy+wkEDUfT1ht9VZf6rI2OYLgT1Zcxl/mYMlmjbGYj74HzQhO+sq
	 V+kPdVOE7pL50kxkEOteud97CrtuExF9xElG2PSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jianguo Wu <wujianguo@chinatelecom.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 138/250] netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core
Date: Tue, 25 Jun 2024 11:31:36 +0200
Message-ID: <20240625085553.357145646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit a2225e0250c5fa397dcebf6ce65a9f05a114e0cf ]

Currently, the sysctl net.netfilter.nf_hooks_lwtunnel depends on the
nf_conntrack module, but the nf_conntrack module is not always loaded.
Therefore, accessing net.netfilter.nf_hooks_lwtunnel may have an error.

Move sysctl nf_hooks_lwtunnel into the netfilter core.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/netfilter.h           |    3 +
 net/netfilter/core.c                    |   13 +++++-
 net/netfilter/nf_conntrack_standalone.c |   15 -------
 net/netfilter/nf_hooks_lwtunnel.c       |   67 ++++++++++++++++++++++++++++++++
 net/netfilter/nf_internals.h            |    6 ++
 5 files changed, 87 insertions(+), 17 deletions(-)

--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -15,6 +15,9 @@ struct netns_nf {
 	const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO];
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *nf_log_dir_header;
+#ifdef CONFIG_LWTUNNEL
+	struct ctl_table_header *nf_lwtnl_dir_header;
+#endif
 #endif
 	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
 	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -815,12 +815,21 @@ int __init netfilter_init(void)
 	if (ret < 0)
 		goto err;
 
+#ifdef CONFIG_LWTUNNEL
+	ret = netfilter_lwtunnel_init();
+	if (ret < 0)
+		goto err_lwtunnel_pernet;
+#endif
 	ret = netfilter_log_init();
 	if (ret < 0)
-		goto err_pernet;
+		goto err_log_pernet;
 
 	return 0;
-err_pernet:
+err_log_pernet:
+#ifdef CONFIG_LWTUNNEL
+	netfilter_lwtunnel_fini();
+err_lwtunnel_pernet:
+#endif
 	unregister_pernet_subsys(&netfilter_net_ops);
 err:
 	return ret;
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -22,9 +22,6 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
-#ifdef CONFIG_LWTUNNEL
-#include <net/netfilter/nf_hooks_lwtunnel.h>
-#endif
 #include <linux/rculist_nulls.h>
 
 static bool enable_hooks __read_mostly;
@@ -612,9 +609,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
 #endif
-#ifdef CONFIG_LWTUNNEL
-	NF_SYSCTL_CT_LWTUNNEL,
-#endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -948,15 +942,6 @@ static struct ctl_table nf_ct_sysctl_tab
 		.proc_handler   = proc_dointvec_jiffies,
 	},
 #endif
-#ifdef CONFIG_LWTUNNEL
-	[NF_SYSCTL_CT_LWTUNNEL] = {
-		.procname	= "nf_hooks_lwtunnel",
-		.data		= NULL,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
-	},
-#endif
 	{}
 };
 
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -3,6 +3,9 @@
 #include <linux/sysctl.h>
 #include <net/lwtunnel.h>
 #include <net/netfilter/nf_hooks_lwtunnel.h>
+#include <linux/netfilter.h>
+
+#include "nf_internals.h"
 
 static inline int nf_hooks_lwtunnel_get(void)
 {
@@ -50,4 +53,68 @@ int nf_hooks_lwtunnel_sysctl_handler(str
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_sysctl_handler);
+
+static struct ctl_table nf_lwtunnel_sysctl_table[] = {
+	{
+		.procname	= "nf_hooks_lwtunnel",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
+	},
+};
+
+static int __net_init nf_lwtunnel_net_init(struct net *net)
+{
+	struct ctl_table_header *hdr;
+	struct ctl_table *table;
+
+	table = nf_lwtunnel_sysctl_table;
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(nf_lwtunnel_sysctl_table,
+				sizeof(nf_lwtunnel_sysctl_table),
+				GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+	}
+
+	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
+				     ARRAY_SIZE(nf_lwtunnel_sysctl_table));
+	if (!hdr)
+		goto err_reg;
+
+	net->nf.nf_lwtnl_dir_header = hdr;
+
+	return 0;
+err_reg:
+	if (!net_eq(net, &init_net))
+		kfree(table);
+err_alloc:
+	return -ENOMEM;
+}
+
+static void __net_exit nf_lwtunnel_net_exit(struct net *net)
+{
+	const struct ctl_table *table;
+
+	table = net->nf.nf_lwtnl_dir_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->nf.nf_lwtnl_dir_header);
+	if (!net_eq(net, &init_net))
+		kfree(table);
+}
+
+static struct pernet_operations nf_lwtunnel_net_ops = {
+	.init = nf_lwtunnel_net_init,
+	.exit = nf_lwtunnel_net_exit,
+};
+
+int __init netfilter_lwtunnel_init(void)
+{
+	return register_pernet_subsys(&nf_lwtunnel_net_ops);
+}
+
+void netfilter_lwtunnel_fini(void)
+{
+	unregister_pernet_subsys(&nf_lwtunnel_net_ops);
+}
 #endif /* CONFIG_SYSCTL */
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -29,6 +29,12 @@ void nf_queue_nf_hook_drop(struct net *n
 /* nf_log.c */
 int __init netfilter_log_init(void);
 
+#ifdef CONFIG_LWTUNNEL
+/* nf_hooks_lwtunnel.c */
+int __init netfilter_lwtunnel_init(void);
+void netfilter_lwtunnel_fini(void);
+#endif
+
 /* core.c */
 void nf_hook_entries_delete_raw(struct nf_hook_entries __rcu **pp,
 				const struct nf_hook_ops *reg);


