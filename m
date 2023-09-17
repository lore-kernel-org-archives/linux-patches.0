Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3686FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD69C433C7;
	Sun, 17 Sep 2023 19:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980649;
	bh=FUFNArSybQxnqddbYf1LD/u79YnQHc1Eck/M4pdREUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScG0WfO/gNdREZxpDB6WAJpqX1su0lVKxJxy98FqdTCvCj32kMTanMgphX3TBPWRg
	 J8FKp9xtztWPV902GF1u2ER3mtD4dfnm5YyaGCvTK1Xqa3tLoIKo0lTHB1v9RVXCvm
	 3+7uVwsPVL2A4YrCI0DmEMgoAV2SZ2jhy8pHjEkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 253/285] net/smc: use smc_lgr_list.lock to protect smc_lgr_list.list iterate in smcr_port_add
Date: Sun, 17 Sep 2023 21:14:13 +0200
Message-ID: <20230917191100.051049200@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit f5146e3ef0a9eea405874b36178c19a4863b8989 ]

While doing smcr_port_add, there maybe linkgroup add into or delete
from smc_lgr_list.list at the same time, which may result kernel crash.
So, use smc_lgr_list.lock to protect smc_lgr_list.list iterate in
smcr_port_add.

The crash calltrace show below:
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 0 PID: 559726 Comm: kworker/0:92 Kdump: loaded Tainted: G
Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 449e491 04/01/2014
Workqueue: events smc_ib_port_event_work [smc]
RIP: 0010:smcr_port_add+0xa6/0xf0 [smc]
RSP: 0000:ffffa5a2c8f67de0 EFLAGS: 00010297
RAX: 0000000000000001 RBX: ffff9935e0650000 RCX: 0000000000000000
RDX: 0000000000000010 RSI: ffff9935e0654290 RDI: ffff9935c8560000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff9934c0401918
R10: 0000000000000000 R11: ffffffffb4a5c278 R12: ffff99364029aae4
R13: ffff99364029aa00 R14: 00000000ffffffed R15: ffff99364029ab08
FS:  0000000000000000(0000) GS:ffff994380600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000f06a10003 CR4: 0000000002770ef0
PKRU: 55555554
Call Trace:
 smc_ib_port_event_work+0x18f/0x380 [smc]
 process_one_work+0x19b/0x340
 worker_thread+0x30/0x370
 ? process_one_work+0x340/0x340
 kthread+0x114/0x130
 ? __kthread_cancel_work+0x50/0x50
 ret_from_fork+0x1f/0x30

Fixes: 1f90a05d9ff9 ("net/smc: add smcr_port_add() and smcr_link_up() processing")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6b78075404d7d..3e89bb9b7c56c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1654,6 +1654,7 @@ void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport)
 {
 	struct smc_link_group *lgr, *n;
 
+	spin_lock_bh(&smc_lgr_list.lock);
 	list_for_each_entry_safe(lgr, n, &smc_lgr_list.list, list) {
 		struct smc_link *link;
 
@@ -1669,6 +1670,7 @@ void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport)
 		if (link)
 			smc_llc_add_link_local(link);
 	}
+	spin_unlock_bh(&smc_lgr_list.lock);
 }
 
 /* link is down - switch connections to alternate link,
-- 
2.40.1



