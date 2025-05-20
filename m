Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBEA22D7A8;
	Tue, 20 May 2025 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749214; cv=none; b=KASvziucpU/C07J2DcjpoGyiuSSG7EpqcDWR/CTDJs96URApwDFVSMEymtOvG2xTtjF29Z7GhqJ/xuOIpzzA7UKYmTNPfoo7b2OGe8/+o9JSpLctJ9V56bv7WggUDta6vqIe/8t9ogf/YuMCgIxaheLArArKS5MtpQ6hngN3xPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749214; c=relaxed/simple;
	bh=4bR1gmzwuN7qoos+9RfozyTSuoXFsG1/qafzL3ZWtGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERadNSCrM5Gy9Iy33cD7r4iXCEKWxJFlm8Ch8dXKt1r+E07lgml2aLnFfu2axZBNtee6FlDux+VMnTFxWSrkWchZ19UN+iLIvLTeDcjU6B0gm/CBxko/qbc+6f1dHGG3EdMVIExAzM4uCgeoyhVL5olayzZOQLf2g3j3FLkSFm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8vOiTf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8vOiTf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFC7C4CEE9;
	Tue, 20 May 2025 13:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749214;
	bh=4bR1gmzwuN7qoos+9RfozyTSuoXFsG1/qafzL3ZWtGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8vOiTf/6xk1qmsOgvjFQSwuvjFV6Jx6BH0/ONbGCXrqL8KhDB0WPEco4pVx7O71z
	 e68dnkmx313OCT+xBlByUAOtKBOWyLZZD93r083pBjdYrSeOuj0ZCYWh/4lIlNZDUQ
	 pyHP99uAws71Dq/NROR2vi74vjdFJd+PcUrOEpiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liuyi <liuy22@mails.tsinghua.edu.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/59] RDMA/rxe: Fix slab-use-after-free Read in rxe_queue_cleanup bug
Date: Tue, 20 May 2025 15:49:56 +0200
Message-ID: <20250520125754.051293258@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit f81b33582f9339d2dc17c69b92040d3650bb4bae ]

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x7d/0xa0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcf/0x610 mm/kasan/report.c:489
 kasan_report+0xb5/0xe0 mm/kasan/report.c:602
 rxe_queue_cleanup+0xd0/0xe0 drivers/infiniband/sw/rxe/rxe_queue.c:195
 rxe_cq_cleanup+0x3f/0x50 drivers/infiniband/sw/rxe/rxe_cq.c:132
 __rxe_cleanup+0x168/0x300 drivers/infiniband/sw/rxe/rxe_pool.c:232
 rxe_create_cq+0x22e/0x3a0 drivers/infiniband/sw/rxe/rxe_verbs.c:1109
 create_cq+0x658/0xb90 drivers/infiniband/core/uverbs_cmd.c:1052
 ib_uverbs_create_cq+0xc7/0x120 drivers/infiniband/core/uverbs_cmd.c:1095
 ib_uverbs_write+0x969/0xc90 drivers/infiniband/core/uverbs_main.c:679
 vfs_write fs/read_write.c:677 [inline]
 vfs_write+0x26a/0xcc0 fs/read_write.c:659
 ksys_write+0x1b8/0x200 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xaa/0x1b0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

In the function rxe_create_cq, when rxe_cq_from_init fails, the function
rxe_cleanup will be called to handle the allocated resources. In fact,
some memory resources have already been freed in the function
rxe_cq_from_init. Thus, this problem will occur.

The solution is to let rxe_cleanup do all the work.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://paste.ubuntu.com/p/tJgC42wDf6/
Tested-by: liuyi <liuy22@mails.tsinghua.edu.cn>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20250412075714.3257358-1-yanjun.zhu@linux.dev
Reviewed-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_cq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_cq.c b/drivers/infiniband/sw/rxe/rxe_cq.c
index 4eedaa0244b39..f22f8e950baef 100644
--- a/drivers/infiniband/sw/rxe/rxe_cq.c
+++ b/drivers/infiniband/sw/rxe/rxe_cq.c
@@ -71,11 +71,8 @@ int rxe_cq_from_init(struct rxe_dev *rxe, struct rxe_cq *cq, int cqe,
 
 	err = do_mmap_info(rxe, uresp ? &uresp->mi : NULL, udata,
 			   cq->queue->buf, cq->queue->buf_size, &cq->queue->ip);
-	if (err) {
-		vfree(cq->queue->buf);
-		kfree(cq->queue);
+	if (err)
 		return err;
-	}
 
 	if (uresp)
 		cq->is_user = 1;
-- 
2.39.5



