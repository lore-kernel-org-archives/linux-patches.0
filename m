Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247DB17C202;
	Wed,  3 Jul 2024 10:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003920; cv=none; b=iE9Z2tfIaDXUJc8twheiI9gJ+ApDU3FGow1EFay+Hlpiq2ZGUwGpGPJ8GwB31l96E/1SRxh4GDlC+ZsEuNo4696IcZZJ4DKtW2AnKwQdjt8iW6JnjIyJ5iwjA6TfsSwMYUFZBYZ6Pmzt5XOUsxugIimP69E4rMcTAMX3v/xZhN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003920; c=relaxed/simple;
	bh=QDwD51XjmBPwzxRuAu1hlGgHIO3Y7lV/ROKdenk6pSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHRARqAasV6Z5MLjMLy8QX5dsXfzzhtYhtc4ITTD2i76+jUe9x2+AkWpde/197EyV+/h8FGSnDIXm0FbQyBkJxnF1ram6S321nI+wKEoTksHZrA87TSxjj1vloqrLYH3QXbpeXFFywe0UhwdTOYhfTmhhMJ+nvPOz3ZomRLxQYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhOMfbf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhOMfbf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98802C2BD10;
	Wed,  3 Jul 2024 10:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003920;
	bh=QDwD51XjmBPwzxRuAu1hlGgHIO3Y7lV/ROKdenk6pSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhOMfbf/GozXlaGNreh1ikCwjA524PSFAvz27ohZurnpQDJc1SV6UAIUZOes7E/Qc
	 an4fb6DppPkMNdHc13lgTGNxqDuLBj+f5/+IzJ/bctOLV9kf8QIDldtUUKN0Cm2BuB
	 8yM0KeTrUVcmgGfg4FjUzJ0FeuYdq1+ZXLzVwcsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/189] ionic: fix use after netif_napi_del()
Date: Wed,  3 Jul 2024 12:38:46 +0200
Message-ID: <20240703102843.962238136@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 79f18a41dd056115d685f3b0a419c7cd40055e13 ]

When queues are started, netif_napi_add() and napi_enable() are called.
If there are 4 queues and only 3 queues are used for the current
configuration, only 3 queues' napi should be registered and enabled.
The ionic_qcq_enable() checks whether the .poll pointer is not NULL for
enabling only the using queue' napi. Unused queues' napi will not be
registered by netif_napi_add(), so the .poll pointer indicates NULL.
But it couldn't distinguish whether the napi was unregistered or not
because netif_napi_del() doesn't reset the .poll pointer to NULL.
So, ionic_qcq_enable() calls napi_enable() for the queue, which was
unregistered by netif_napi_del().

Reproducer:
   ethtool -L <interface name> rx 1 tx 1 combined 0
   ethtool -L <interface name> rx 0 tx 0 combined 1
   ethtool -L <interface name> rx 0 tx 0 combined 4

Splat looks like:
kernel BUG at net/core/dev.c:6666!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 1057 Comm: kworker/3:3 Not tainted 6.10.0-rc2+ #16
Workqueue: events ionic_lif_deferred_work [ionic]
RIP: 0010:napi_enable+0x3b/0x40
Code: 48 89 c2 48 83 e2 f6 80 b9 61 09 00 00 00 74 0d 48 83 bf 60 01 00 00 00 74 03 80 ce 01 f0 4f
RSP: 0018:ffffb6ed83227d48 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff97560cda0828 RCX: 0000000000000029
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff97560cda0a28
RBP: ffffb6ed83227d50 R08: 0000000000000400 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: ffff97560ce3c1a0 R14: 0000000000000000 R15: ffff975613ba0a20
FS:  0000000000000000(0000) GS:ffff975d5f780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8f734ee200 CR3: 0000000103e50000 CR4: 00000000007506f0
PKRU: 55555554
Call Trace:
 <TASK>
 ? die+0x33/0x90
 ? do_trap+0xd9/0x100
 ? napi_enable+0x3b/0x40
 ? do_error_trap+0x83/0xb0
 ? napi_enable+0x3b/0x40
 ? napi_enable+0x3b/0x40
 ? exc_invalid_op+0x4e/0x70
 ? napi_enable+0x3b/0x40
 ? asm_exc_invalid_op+0x16/0x20
 ? napi_enable+0x3b/0x40
 ionic_qcq_enable+0xb7/0x180 [ionic 59bdfc8a035436e1c4224ff7d10789e3f14643f8]
 ionic_start_queues+0xc4/0x290 [ionic 59bdfc8a035436e1c4224ff7d10789e3f14643f8]
 ionic_link_status_check+0x11c/0x170 [ionic 59bdfc8a035436e1c4224ff7d10789e3f14643f8]
 ionic_lif_deferred_work+0x129/0x280 [ionic 59bdfc8a035436e1c4224ff7d10789e3f14643f8]
 process_one_work+0x145/0x360
 worker_thread+0x2bb/0x3d0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xcc/0x100
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2d/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20240612060446.1754392-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -205,10 +205,8 @@ static int ionic_qcq_enable(struct ionic
 	if (ret)
 		return ret;
 
-	if (qcq->napi.poll)
-		napi_enable(&qcq->napi);
-
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		napi_enable(&qcq->napi);
 		irq_set_affinity_hint(qcq->intr.vector,
 				      &qcq->intr.affinity_mask);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,


