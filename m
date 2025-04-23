Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6F027FD49;
	Wed, 23 Apr 2025 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419628; cv=none; b=EhFlNgibkWF4osFXq2b2VbkosHxxlBFSU9wz1jjcVW34hZH6EyTXUwI+ZREPeYnPM4ir5bd8wufmiY2dh2fh9v/dBkY3nvqotFgNDOf+bqu6Oh/9vBU0KxDz22WoJZvAxsP269WnDnD+dbgyh409A8HmKiv1dk0/GaG6O7NR8UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419628; c=relaxed/simple;
	bh=9UQbWn7IdktPOP/rKsM+YcuJJT/v9xfYUOfCUqLRyrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8klqxZRWaE7m7ZGOMHSTHBUMzjQ0rzgKrlwPTWwg4L70jZwDbEtqa7pCv4rYR3W/ZF2dhZzp5RKK6aJNNxwTCOJ0y4lnPIAFiulI//JsoyNWa94s8BRQyfIf+5mMOS5zTXByfbpHd+TYaGa78ZDQdzd8pxsvPM/+VwJaV4Jnu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FelxhDFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FelxhDFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE18C4CEE2;
	Wed, 23 Apr 2025 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419628;
	bh=9UQbWn7IdktPOP/rKsM+YcuJJT/v9xfYUOfCUqLRyrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FelxhDFPrKI82jZheudDjqQGJ0KoCQ+QiCgewFgAvCHx0sWbZ9+wmB5jEUdwazF6u
	 LcHwqbOQgTqzbaTIsMaeVWh27bnu4vkrvFwIbohYz6jLfn5kUpHwLgMB9iE//Dsp2r
	 7KQoQgSNCXTTFG+NjGNS3LdZgQ2tBnLzgG9Tz23k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/223] RDMA/core: Silence oversized kvmalloc() warning
Date: Wed, 23 Apr 2025 16:41:38 +0200
Message-ID: <20250423142618.180003089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 9a0e6f15029e1a8a21e40f06fd05aa52b7f063de ]

syzkaller triggered an oversized kvmalloc() warning.
Silence it by adding __GFP_NOWARN.

syzkaller log:
 WARNING: CPU: 7 PID: 518 at mm/util.c:665 __kvmalloc_node_noprof+0x175/0x180
 CPU: 7 UID: 0 PID: 518 Comm: c_repro Not tainted 6.11.0-rc6+ #6
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:__kvmalloc_node_noprof+0x175/0x180
 RSP: 0018:ffffc90001e67c10 EFLAGS: 00010246
 RAX: 0000000000000100 RBX: 0000000000000400 RCX: ffffffff8149d46b
 RDX: 0000000000000000 RSI: ffff8881030fae80 RDI: 0000000000000002
 RBP: 000000712c800000 R08: 0000000000000100 R09: 0000000000000000
 R10: ffffc90001e67c10 R11: 0030ae0601000000 R12: 0000000000000000
 R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
 FS:  00007fde79159740(0000) GS:ffff88813bdc0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000020000180 CR3: 0000000105eb4005 CR4: 00000000003706b0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  ib_umem_odp_get+0x1f6/0x390
  mlx5_ib_reg_user_mr+0x1e8/0x450
  ib_uverbs_reg_mr+0x28b/0x440
  ib_uverbs_write+0x7d3/0xa30
  vfs_write+0x1ac/0x6c0
  ksys_write+0x134/0x170
  ? __sanitizer_cov_trace_pc+0x1c/0x50
  do_syscall_64+0x50/0x110
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 37824952dc8f ("RDMA/odp: Use kvcalloc for the dma_list and page_list")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Link: https://patch.msgid.link/c6cb92379de668be94894f49c2cfa40e73f94d56.1742388096.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_odp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index e9fa22d31c233..c48ef60830205 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -76,12 +76,14 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 
 		npfns = (end - start) >> PAGE_SHIFT;
 		umem_odp->pfn_list = kvcalloc(
-			npfns, sizeof(*umem_odp->pfn_list), GFP_KERNEL);
+			npfns, sizeof(*umem_odp->pfn_list),
+			GFP_KERNEL | __GFP_NOWARN);
 		if (!umem_odp->pfn_list)
 			return -ENOMEM;
 
 		umem_odp->dma_list = kvcalloc(
-			ndmas, sizeof(*umem_odp->dma_list), GFP_KERNEL);
+			ndmas, sizeof(*umem_odp->dma_list),
+			GFP_KERNEL | __GFP_NOWARN);
 		if (!umem_odp->dma_list) {
 			ret = -ENOMEM;
 			goto out_pfn_list;
-- 
2.39.5



