Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C45715CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF7BC433D6;
	Tue,  8 Nov 2022 13:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915596;
	bh=dbhYEAJgVWuBPgDdMxla7ufAI9puyLdXwGEbC3Roo2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQAlXxDlv1QkF2lB1gXnb3hyytVKLP/Kan8ZludUa9SJYmSwMc4MPcPrCcH+FJWK6
	 zPsgspF+zZtD//fwTGG/4idP3TjHRJU7ZvGWHLq44P9WD2ecH1IDAwWJreLf3UHA6V
	 5j117q1kXAZG7rHKf87kMtx/r+jWNl3GAZEvwahA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/118] ipvs: fix WARNING in ip_vs_app_net_cleanup()
Date: Tue,  8 Nov 2022 14:38:33 +0100
Message-Id: <20221108133342.182360802@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 5663ed63adb9619c98ab7479aa4606fa9b7a548c ]

During the initialization of ip_vs_app_net_init(), if file ip_vs_app
fails to be created, the initialization is successful by default.
Therefore, the ip_vs_app file doesn't be found during the remove in
ip_vs_app_net_cleanup(). It will cause WRNING.

The following is the stack information:
name 'ip_vs_app'
WARNING: CPU: 1 PID: 9 at fs/proc/generic.c:712 remove_proc_entry+0x389/0x460
Modules linked in:
Workqueue: netns cleanup_net
RIP: 0010:remove_proc_entry+0x389/0x460
Call Trace:
<TASK>
ops_exit_list+0x125/0x170
cleanup_net+0x4ea/0xb00
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: 457c4cbc5a3d ("[NET]: Make /proc/net per network namespace")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_app.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index f9b16f2b2219..fdacbc3c15be 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -599,13 +599,19 @@ static const struct seq_operations ip_vs_app_seq_ops = {
 int __net_init ip_vs_app_net_init(struct netns_ipvs *ipvs)
 {
 	INIT_LIST_HEAD(&ipvs->app_list);
-	proc_create_net("ip_vs_app", 0, ipvs->net->proc_net, &ip_vs_app_seq_ops,
-			sizeof(struct seq_net_private));
+#ifdef CONFIG_PROC_FS
+	if (!proc_create_net("ip_vs_app", 0, ipvs->net->proc_net,
+			     &ip_vs_app_seq_ops,
+			     sizeof(struct seq_net_private)))
+		return -ENOMEM;
+#endif
 	return 0;
 }
 
 void __net_exit ip_vs_app_net_cleanup(struct netns_ipvs *ipvs)
 {
 	unregister_ip_vs_app(ipvs, NULL /* all */);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_vs_app", ipvs->net->proc_net);
+#endif
 }
-- 
2.35.1



