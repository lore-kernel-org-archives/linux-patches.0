Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1076188006;
	Mon, 23 Dec 2024 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970285; cv=none; b=pwMjqLBuMRNuZq9inGPNvrNfq6mKx62u33Vj7E6/pFZCXGkfA71+3GLbSddzcXOHkb2eZxJoVhZ0Rzybs5MaTDOSJIt9EMYmzgSshzEcNI997YdG/i6d+9JKxfDPtbMuyIU1fJmrind9zN+DlCMCgyFtTpMvlcEqCR+VqorlGQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970285; c=relaxed/simple;
	bh=4ehA1i3Soo7dLU4x7Ic2TH0cQnbXdIewaPVYsSFNCD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb7T6Sw2Hhc5HZP39solgoxJrOt+g85oe9NcxEN9wbUJd8zXaNgaipEe8tepYOTrbZLPJsCjl5c/VKXdxKhMpzz3HA6nP19+c45IQnjjhakymV/WZrP9pdDRktXewuXaoki+JV3jKRK2DbUFjfS7YhWvZOad88u1FYdxp0B1w6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I34Tr4GL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I34Tr4GL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40673C4CED3;
	Mon, 23 Dec 2024 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970285;
	bh=4ehA1i3Soo7dLU4x7Ic2TH0cQnbXdIewaPVYsSFNCD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I34Tr4GL89/zUitGBTxLP2OVEDZa/fbmvYQAn0ELtb/MxBOUMsVJ89mPeCuJJsI4V
	 YXAONKE0K4ac0ryTMc3INY2+tUwluidOUVdbXoCFQH4CiNXqbCCZejjACgH6UltLYx
	 q6KKNRLMx/4xza/ZsldDP24LLymPQGd5glpF6/5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/116] net/smc: protect link down work from execute after lgr freed
Date: Mon, 23 Dec 2024 16:58:29 +0100
Message-ID: <20241223155401.087559599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit 2b33eb8f1b3e8c2f87cfdbc8cc117f6bdfabc6ec ]

link down work may be scheduled before lgr freed but execute
after lgr freed, which may result in crash. So it is need to
hold a reference before shedule link down work, and put the
reference after work executed or canceled.

The relevant crash call stack as follows:
 list_del corruption. prev->next should be ffffb638c9c0fe20,
    but was 0000000000000000
 ------------[ cut here ]------------
 kernel BUG at lib/list_debug.c:51!
 invalid opcode: 0000 [#1] SMP NOPTI
 CPU: 6 PID: 978112 Comm: kworker/6:119 Kdump: loaded Tainted: G #1
 Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 2221b89 04/01/2014
 Workqueue: events smc_link_down_work [smc]
 RIP: 0010:__list_del_entry_valid.cold+0x31/0x47
 RSP: 0018:ffffb638c9c0fdd8 EFLAGS: 00010086
 RAX: 0000000000000054 RBX: ffff942fb75e5128 RCX: 0000000000000000
 RDX: ffff943520930aa0 RSI: ffff94352091fc80 RDI: ffff94352091fc80
 RBP: 0000000000000000 R08: 0000000000000000 R09: ffffb638c9c0fc38
 R10: ffffb638c9c0fc30 R11: ffffffffa015eb28 R12: 0000000000000002
 R13: ffffb638c9c0fe20 R14: 0000000000000001 R15: ffff942f9cd051c0
 FS:  0000000000000000(0000) GS:ffff943520900000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f4f25214000 CR3: 000000025fbae004 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  rwsem_down_write_slowpath+0x17e/0x470
  smc_link_down_work+0x3c/0x60 [smc]
  process_one_work+0x1ac/0x350
  worker_thread+0x49/0x2f0
  ? rescuer_thread+0x360/0x360
  kthread+0x118/0x140
  ? __kthread_bind_mask+0x60/0x60
  ret_from_fork+0x1f/0x30

Fixes: 541afa10c126 ("net/smc: add smcr_port_err() and smcr_link_down() processing")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 3d5c542cd231..3c626c014d1d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1767,7 +1767,9 @@ void smcr_link_down_cond_sched(struct smc_link *lnk)
 {
 	if (smc_link_downing(&lnk->state)) {
 		trace_smcr_link_down(lnk, __builtin_return_address(0));
-		schedule_work(&lnk->link_down_wrk);
+		smcr_link_hold(lnk); /* smcr_link_put in link_down_wrk */
+		if (!schedule_work(&lnk->link_down_wrk))
+			smcr_link_put(lnk);
 	}
 }
 
@@ -1799,11 +1801,14 @@ static void smc_link_down_work(struct work_struct *work)
 	struct smc_link_group *lgr = link->lgr;
 
 	if (list_empty(&lgr->list))
-		return;
+		goto out;
 	wake_up_all(&lgr->llc_msg_waiter);
 	down_write(&lgr->llc_conf_mutex);
 	smcr_link_down(link);
 	up_write(&lgr->llc_conf_mutex);
+
+out:
+	smcr_link_put(link); /* smcr_link_hold by schedulers of link_down_work */
 }
 
 static int smc_vlan_by_tcpsk_walk(struct net_device *lower_dev,
-- 
2.39.5



