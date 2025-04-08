Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9D6267B89;
	Tue,  8 Apr 2025 12:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114054; cv=none; b=BRFQforuduQtI3PPsARA22iijTIRlUygVdgC/5zJXXQtBMM6iTB5PKHlm1Db+mZtiZCasKhvuL6VDBh8N5SBdpcbYtSlfiSabjW+gYF50c21ZMeU5RX2HeqD42LcFdWt5BCkswSzA4tyrHenBrwXpKQ0JS4zUeRQxOUqvHz82BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114054; c=relaxed/simple;
	bh=nX6KZ9gfDGodsg2xCgO9c7DvuI2bCfZUYqeUi3BYBME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSLuEcOAgR+xLyMgLgufLyaifpV4UnHLHcKyjmWIIgwFsYV4uLrTIhZK0P9wniJeJ3T1LhoI2pH94WOG+hVlXvsJmptyZ7UMd1Lm9UuEUfvdsXZLKtcFgNrsnnApfdCQEyNK+Or6yySUhDDJ7GyGw/+prQgLZfdvyGlG9GX/JBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8Rsiv2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8Rsiv2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F3EC4CEE5;
	Tue,  8 Apr 2025 12:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114054;
	bh=nX6KZ9gfDGodsg2xCgO9c7DvuI2bCfZUYqeUi3BYBME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8Rsiv2cqtJ5aRFcLo/fZ4i8CDd5IoU8KYGEEgECB13JN6HXsI/rHq+ni+Z3+fvEw
	 accVOkFSKZpjQ98RlYiC9aNR2bFJ/kqNCATVH/Gwt7LQ1ygWZJ8PreOqe4fOMAhAMg
	 Vm1g/Hd8uhEre9KXOIh2tsu3m4gFRa9FRclykPyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/154] RDMA/mlx5: Fix mlx5_poll_one() cur_qp update flow
Date: Tue,  8 Apr 2025 12:50:53 +0200
Message-ID: <20250408104818.924855797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 5ed3b0cb3f827072e93b4c5b6e2b8106fd7cccbd ]

When cur_qp isn't NULL, in order to avoid fetching the QP from
the radix tree again we check if the next cqe QP is identical to
the one we already have.

The bug however is that we are checking if the QP is identical by
checking the QP number inside the CQE against the QP number inside the
mlx5_ib_qp, but that's wrong since the QP number from the CQE is from
FW so it should be matched against mlx5_core_qp which is our FW QP
number.

Otherwise we could use the wrong QP when handling a CQE which could
cause the kernel trace below.

This issue is mainly noticeable over QPs 0 & 1, since for now they are
the only QPs in our driver whereas the QP number inside mlx5_ib_qp
doesn't match the QP number inside mlx5_core_qp.

BUG: kernel NULL pointer dereference, address: 0000000000000012
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP
 CPU: 0 UID: 0 PID: 7927 Comm: kworker/u62:1 Not tainted 6.14.0-rc3+ #189
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
 Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
 RIP: 0010:mlx5_ib_poll_cq+0x4c7/0xd90 [mlx5_ib]
 Code: 03 00 00 8d 58 ff 21 cb 66 39 d3 74 39 48 c7 c7 3c 89 6e a0 0f b7 db e8 b7 d2 b3 e0 49 8b 86 60 03 00 00 48 c7 c7 4a 89 6e a0 <0f> b7 5c 98 02 e8 9f d2 b3 e0 41 0f b7 86 78 03 00 00 83 e8 01 21
 RSP: 0018:ffff88810511bd60 EFLAGS: 00010046
 RAX: 0000000000000010 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff88885fa1b3c0 RDI: ffffffffa06e894a
 RBP: 00000000000000b0 R08: 0000000000000000 R09: ffff88810511bc10
 R10: 0000000000000001 R11: 0000000000000001 R12: ffff88810d593000
 R13: ffff88810e579108 R14: ffff888105146000 R15: 00000000000000b0
 FS:  0000000000000000(0000) GS:ffff88885fa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000012 CR3: 00000001077e6001 CR4: 0000000000370eb0
 Call Trace:
  <TASK>
  ? __die+0x20/0x60
  ? page_fault_oops+0x150/0x3e0
  ? exc_page_fault+0x74/0x130
  ? asm_exc_page_fault+0x22/0x30
  ? mlx5_ib_poll_cq+0x4c7/0xd90 [mlx5_ib]
  __ib_process_cq+0x5a/0x150 [ib_core]
  ib_cq_poll_work+0x31/0x90 [ib_core]
  process_one_work+0x169/0x320
  worker_thread+0x288/0x3a0
  ? work_busy+0xb0/0xb0
  kthread+0xd7/0x1f0
  ? kthreads_online_cpu+0x130/0x130
  ? kthreads_online_cpu+0x130/0x130
  ret_from_fork+0x2d/0x50
  ? kthreads_online_cpu+0x130/0x130
  ret_from_fork_asm+0x11/0x20
  </TASK>

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/4ada09d41f1e36db62c44a9b25c209ea5f054316.1741875692.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 7f659c240c99c..eb20f8fa2bd31 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -483,7 +483,7 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 	}
 
 	qpn = ntohl(cqe64->sop_drop_qpn) & 0xffffff;
-	if (!*cur_qp || (qpn != (*cur_qp)->ibqp.qp_num)) {
+	if (!*cur_qp || (qpn != (*cur_qp)->trans_qp.base.mqp.qpn)) {
 		/* We do not have to take the QP table lock here,
 		 * because CQs will be locked while QPs are removed
 		 * from the table.
-- 
2.39.5



