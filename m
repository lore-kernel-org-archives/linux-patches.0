Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D16BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818C5C433EF;
	Tue,  7 Mar 2023 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213209;
	bh=r57Ea5GmEX0qfEv3DD/ciDbNj4bijMfTV9RcavoDFvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtFMbqlXwvXI/oXvUDGIKqYZmx+76jMv6ky9NAXi5wJrrMRK48lfMQMaqGtvLs/GS
	 djwsifYkxJSqz0r72tYKnNZ+7PRxizTdiys9Sots7pn1f6yNYXXXoFayaPVXcrtb/8
	 gG37CBS29ETmwTwXEoyKfQQzkXE8TSBcZQelrYas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/885] RDMA/hns: Fix refcount leak in hns_roce_mmap
Date: Tue,  7 Mar 2023 17:55:41 +0100
Message-Id: <20230307170020.095171797@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit cf6a05c8494a8ae7fec8e5f1229b45ca5b4bcd30 ]

rdma_user_mmap_entry_get_pgoff() takes the reference.
Add missing rdma_user_mmap_entry_put() to release the reference.

Fixes: 0045e0d3f42e ("RDMA/hns: Support direct wqe of userspace")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by Haoyue Xu <xuhaoyue1@hisilicon.com>
Link: https://lore.kernel.org/r/20221223072900.802728-1-linmq006@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 8ba68ac12388d..946ba1109e878 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -443,14 +443,15 @@ static int hns_roce_mmap(struct ib_ucontext *uctx, struct vm_area_struct *vma)
 		prot = pgprot_device(vma->vm_page_prot);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	ret = rdma_user_mmap_io(uctx, vma, pfn, rdma_entry->npages * PAGE_SIZE,
 				prot, rdma_entry);
 
+out:
 	rdma_user_mmap_entry_put(rdma_entry);
-
 	return ret;
 }
 
-- 
2.39.2



