Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A31346E75;
	Sat, 12 Sep 2026 20:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243213; cv=none; b=JrX3FiThim3awQlm5IA8GDXHrI5iEkITg4oiJOQOESTgtqGi67Iz0+/EaD/zZkCuqL7u7lhKaD2PRxhSAGKrG0D12amDEMvwU73tVfqclL8kTX/lmqkyypZtNJXH63L/ltE2QUjn7pIBUSMcD9D7khXENgabvdFkFVPI4XvpnWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243213; c=relaxed/simple;
	bh=dEFJTkTdkW8QGV2YvtS1RJHLFZytnUSHW2P6iGmXl10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIEam2aLVCcfJ73WEJWm64qF60Wvk4vSZuPHZ8jLIhKAZt3v7zrXi+WU8+2Xv0Jwxl7fYNlISb3IYvlpRb8ejB8D3QUF9/4Aob5nncmxtiEWUIG63rA815UQ7TK4MtUvoHbxdB/Hpogl7/XFgmCFkylNBxKf1Xhy6yE8N1Qp1m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrYbTIsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrYbTIsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ECC1F000FF;
	Sat, 12 Sep 2026 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243211;
	bh=RCwGAYFs6PTJ9vtLmx3ieaVTlLnTDnFUveViHKYIbRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrYbTIsfuFT6do7eLnP1T40xw+U43YuOrVNAb5xxKY3TVFC5viFFS9AjL/yYnnvKA
	 nisNanZK7atqI5lDs+1AaWbnR1x60mwE7Lqq+/fiJsa6LYU7OlLrCbgkra69qxKG8y
	 xcMY8uNGLmihXdQUdQi6i7vmHiZdGds2/PrLbOns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 676/798] RDMA/cma: Fix WARNING in res_to_rt
Date: Sat, 12 Sep 2026 09:05:04 +0200
Message-ID: <20260912065532.595749237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit c6d1ec4fbe56492bb88987d577f04a5fb6955f26 ]

syzbot reported a WARN_ON(!res->dev) in res_to_rt() triggered via
addr_handler() during asynchronous address resolution:

"
WARNING: drivers/infiniband/core/restrack.c:138 at res_to_rt+0x1c4/0x230
CPU#1: kworker/u8:4/59
Modules linked in:
CPU: 1 UID: 0 PID: 59 Comm: kworker/u8:4 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Compute Engine, BIOS Google 07/24/2026
Workqueue: ib_addr process_one_req
RIP: 0010:res_to_rt+0x1c4/0x230 drivers/infiniband/core/restrack.c:138
RSP: 0018:ffffc9000201f850 EFLAGS: 00010293
RAX: ffffffff88d00ce5 RBX: ffff88807f0fd4f8 RCX: ffff88801e6e0000
RDX: 0000000000000000 RSI: ffffffff8fd996f0 RDI: 0000000000000003
RBP: 0000000000000000 R08: ffff88801e6e0000 R09: 000000000000000a
R10: 0000000000000009 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff1100fe1fa9f R14: 0000000000000000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff888125012000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00001d559c3d2000 CR3: 0000000077c4c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rdma_restrack_add+0x5a/0x8a0 drivers/infiniband/core/restrack.c:236
 addr_handler+0x41a/0x5a0 drivers/infiniband/core/cma.c:3534
 process_one_req+0x2eb/0x540 drivers/infiniband/core/addr.c:624
 process_one_work kernel/workqueue.c:3375 [inline]
 process_scheduled_works+0xc4e/0x1630 kernel/workqueue.c:3458
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3539
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
"

In addr_handler(), cma_acquire_dev_by_src_ip() is called to populate
id_priv->cma_dev and bind the associated ib_device to id_priv->id.device.
If cma_acquire_dev_by_src_ip() returns an error (non-zero status), the ID
remains unassociated with any RDMA device.

Previously, rdma_restrack_add(&id_priv->res) was invoked unconditionally
even when cma_acquire_dev_by_src_ip() failed, passing a resource with a
NULL dev pointer and triggering the WARN_ON assertion in res_to_rt().

Fix this by only adding the resource to restrack when acquiring the device
succeeds.

Reported-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72eddfbadda3e3928e72
Tested-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Fixes: cb5cd0ea4eb3 ("RDMA/core: Add CM to restrack after successful attachment to a device")

Link: https://patch.msgid.link/r/20260810220123.191696-1-yanjun.zhu@linux.dev
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 61edd923114e2..4c9866ce6564a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3250,10 +3250,12 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 	memcpy(addr, src_addr, rdma_addr_size(src_addr));
 	if (!status && !id_priv->cma_dev) {
 		status = cma_acquire_dev_by_src_ip(id_priv);
-		if (status)
+		if (status) {
 			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
 					     status);
-		rdma_restrack_add(&id_priv->res);
+		} else {
+			rdma_restrack_add(&id_priv->res);
+		}
 	} else if (status) {
 		pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to resolve IP. status %d\n", status);
 	}
-- 
2.53.0



