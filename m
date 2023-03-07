Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7197BBA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA108C433D2;
	Tue,  7 Mar 2023 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210273;
	bh=f6W7bCcTSiDUU65TmuctwK2LGw8w6jQmgWm8k5T/kqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXXiQCfeUG+aHt28ghZjiOzYVmfkkXmdYfTpt1UebqLdWTduc2kdDIrFq/TLmAeWz
	 +88Gc+9ZRZQthezXnmPwKryjTQuSHsfjULUEHU6+Xzl7OWLicLmylV3qOcYOAVn4lh
	 W9/G5tARKc39P6gg3NIIElOPKX+wij6/MqK8IxSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0487/1001] RDMA/erdma: Fix refcount leak in erdma_mmap
Date: Tue,  7 Mar 2023 17:54:19 +0100
Message-Id: <20230307170042.524346399@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ee84146c05ad2316b9a7222d0ec4413e0bf30eeb ]

rdma_user_mmap_entry_get() take reference, we should release it when not
need anymore, add the missing rdma_user_mmap_entry_put() in the error
path to fix it.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20221220121139.1540564-1-linmq006@gmail.com
Acked-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 5dab1e87975ba..9c30d78730aa1 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1110,12 +1110,14 @@ int erdma_mmap(struct ib_ucontext *ctx, struct vm_area_struct *vma)
 		prot = pgprot_device(vma->vm_page_prot);
 		break;
 	default:
-		return -EINVAL;
+		err = -EINVAL;
+		goto put_entry;
 	}
 
 	err = rdma_user_mmap_io(ctx, vma, PFN_DOWN(entry->address), PAGE_SIZE,
 				prot, rdma_entry);
 
+put_entry:
 	rdma_user_mmap_entry_put(rdma_entry);
 	return err;
 }
-- 
2.39.2



