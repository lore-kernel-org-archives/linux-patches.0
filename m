Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D2625332E;
	Tue, 29 Apr 2025 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946909; cv=none; b=nXc0GGrk6/Nng+Nee7ZqIa9z/Etp4gOcAYLDql1ccaShJy1Dh5SNOTMg4XnWDIMi0jqGCwYbGbjAM7iZh6a3EOebzyn7vwVOMYc+ZL8HxwRU2lRQumjlomzhetz33jEpjWo8Iz9mhBLwtsINNMhVshZMgrfqko5bmOSXIru5Geo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946909; c=relaxed/simple;
	bh=w1z04mstFzrLYqwMu/oxxvUiVejEq0VP633TliA3Bik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYj/+4NXcpZPaolswESlngwCn/c09Bq1BtlDaF0m/VfvvNrI/IFPiQkDXFoKNgWDqYFbRHYfzSk+sELq6XR51ghnjweBzb6R65uc6iKNrvTG6LEB+pV76gA1Yu+/8U6i1YdAONJn/oTitG8+KemtUYnizfU8T+dnae6U/QwH+98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKTFa1jI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKTFa1jI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78744C4CEEF;
	Tue, 29 Apr 2025 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946908;
	bh=w1z04mstFzrLYqwMu/oxxvUiVejEq0VP633TliA3Bik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKTFa1jIgfsEkvAVceULVkdKRR4XgdX17dEQqtS9gGfwGDYm5rbbjDDwNmQDUYJ+W
	 to8MyDgiAc90dg8OZFPfAipuXhxmYTEk5ldo85MI4eWXcOhOIru5LpmmId9b6/SInd
	 EPWIRn5DBrMy2WMU2ZjFV+ybmh+FokyZvEZigduE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/286] RDMA/core: Silence oversized kvmalloc() warning
Date: Tue, 29 Apr 2025 18:40:13 +0200
Message-ID: <20250429161112.342860676@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index af4af4789ef27..dd69b20ed286d 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -78,12 +78,14 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 
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



