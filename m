Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD76FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF8FC433D6;
	Wed, 30 Nov 2022 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832972;
	bh=aVEhu81fYiUkOZZElSTvCrp3+PHlarNZ2JC0hV8EM/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irm1sgaeUlLU7lik6mW1opmcqSeXVDe7/C/zEvmYbgZ91QgGnOh1+y7YAbiaR0mQv
	 VYQXCWyKYdiyIr5X4IZhsRJNTJcj6HtIZ+OxO+9DdnhbSilJ1/bUSTxdLqnJVtsqpv
	 P4tndKzSDBlodPlULEw3/PXB/DbLePORihd46pKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <set_pte_at@outlook.com>,
	Andrew Davis <afd@ti.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/162] dma-buf: fix racing conflict of dma_heap_add()
Date: Wed, 30 Nov 2022 19:22:39 +0100
Message-Id: <20221130180530.619510450@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dawei Li <set_pte_at@outlook.com>

[ Upstream commit 432e25902b9651622578c6248e549297d03caf66 ]

Racing conflict could be:
task A                 task B
list_for_each_entry
strcmp(h->name))
                       list_for_each_entry
                       strcmp(h->name)
kzalloc                kzalloc
......                 .....
device_create          device_create
list_add
                       list_add

The root cause is that task B has no idea about the fact someone
else(A) has inserted heap with same name when it calls list_add,
so a potential collision occurs.

Fixes: c02a81fba74f ("dma-buf: Add dma-buf heaps framework")
Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Acked-by: Andrew Davis <afd@ti.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/TYCP286MB2323873BBDF88020781FB986CA3B9@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-heap.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index 798f86fcd50f..dcbb023acc45 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -209,18 +209,6 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 		return ERR_PTR(-EINVAL);
 	}
 
-	/* check the name is unique */
-	mutex_lock(&heap_list_lock);
-	list_for_each_entry(h, &heap_list, list) {
-		if (!strcmp(h->name, exp_info->name)) {
-			mutex_unlock(&heap_list_lock);
-			pr_err("dma_heap: Already registered heap named %s\n",
-			       exp_info->name);
-			return ERR_PTR(-EINVAL);
-		}
-	}
-	mutex_unlock(&heap_list_lock);
-
 	heap = kzalloc(sizeof(*heap), GFP_KERNEL);
 	if (!heap)
 		return ERR_PTR(-ENOMEM);
@@ -259,13 +247,27 @@ struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_info)
 		err_ret = ERR_CAST(dev_ret);
 		goto err2;
 	}
-	/* Add heap to the list */
+
 	mutex_lock(&heap_list_lock);
+	/* check the name is unique */
+	list_for_each_entry(h, &heap_list, list) {
+		if (!strcmp(h->name, exp_info->name)) {
+			mutex_unlock(&heap_list_lock);
+			pr_err("dma_heap: Already registered heap named %s\n",
+			       exp_info->name);
+			err_ret = ERR_PTR(-EINVAL);
+			goto err3;
+		}
+	}
+
+	/* Add heap to the list */
 	list_add(&heap->list, &heap_list);
 	mutex_unlock(&heap_list_lock);
 
 	return heap;
 
+err3:
+	device_destroy(dma_heap_class, heap->heap_devt);
 err2:
 	cdev_del(&heap->heap_cdev);
 err1:
-- 
2.35.1



