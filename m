Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB76A15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5BBC433C1;
	Tue,  8 Nov 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916010;
	bh=IDo9K3Ck+nIXqVTX/31ASlqnngdWONOIR6TXztXHqFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZLnJzcEuxNQDWlhjtV6IHvG535nANloJ35ogNqAfGsNmOg0dMbLuCZ1XJDo8+KcW
	 gUhAYNMbYhK7DwNrU1brQevBLzsYMxd0VSXU2b2+/UCFcuUL7fgO21X4pgjeqQi0Kk
	 6mpzhZxem6m/JqnjKIDV6jjkKNHnBc9mlLBINzV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/144] netfilter: nf_tables: netlink notifier might race to release objects
Date: Tue,  8 Nov 2022 14:38:33 +0100
Message-Id: <20221108133346.809953765@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d4bc8271db21ea9f1c86a1ca4d64999f184d4aae ]

commit release path is invoked via call_rcu and it runs lockless to
release the objects after rcu grace period. The netlink notifier handler
might win race to remove objects that the transaction context is still
referencing from the commit release path.

Call rcu_barrier() to ensure pending rcu callbacks run to completion
if the list of transactions to be destroyed is not empty.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Reported-by: syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f7a5b8414423..8cd11a7e5a3e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9824,6 +9824,8 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	nft_net = nft_pernet(net);
 	deleted = 0;
 	mutex_lock(&nft_net->commit_mutex);
+	if (!list_empty(&nf_tables_destroy_list))
+		rcu_barrier();
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
-- 
2.35.1



