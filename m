Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CEB3A641C;
	Sat, 12 Sep 2026 18:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238090; cv=none; b=gPxrjdfFXj5tdamObWTfBGdrQLoFkfQHZ4/RLPS84uIMSyYaNW+N/4T8r3Z6oyWxUIEUiHhRZVG3V0ZMgn7yu21T91fAhn745PAz6K5silt84Wl57mHQRO0BSPMcX7ESx7VBr20e5/gWU6on3LFpNGVl0wMt4MlzjSpSwd2bLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238090; c=relaxed/simple;
	bh=PwTX8mgdMACqfzLfs4N9G6WGaZl2iqaZdn61uoUNM+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEeSIjI5tOtYRDJiE6jBbHbE7aF2DNnlrz7UepYqHvf5coseORw9C2gqpBwUiYl5HPajHeQnyJQJiX4cCpO8t4dRvqWUCwAorkWuv+Ypv+YEqXsoAFYp2A8G66ZQWdDh6Di7u3H9LxBYrkjbCaHVIGN3pJ2XS1DdaLUyPEAY3AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPn6gFDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPn6gFDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013741F000FF;
	Sat, 12 Sep 2026 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238089;
	bh=HtgKQ4DrMRUN07tC0r06l0hv8Cy744Rrxdua8sLrjy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPn6gFDqKjXCOc9djI0bSOptRhZuxGUnoDOMZm83oPCGo8ZiKGCZULsn+B+U36EVq
	 ZUlsqa5/DUt9DR1BsPhErO0DLeQ8vdp3/IPAa8oRCk7jF58vOOzFi/f7240hV8UTAI
	 aM2nO5cqdmSSmIicyQOAnhHYFHrC1KAUnWMFI2tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Rao <mahesh.rao@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 390/935] firmware: stratix10-svc: Add mutex in stratix10 memory management
Date: Sat, 12 Sep 2026 08:57:00 +0200
Message-ID: <20260912065535.765679650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Rao <mahesh.rao@altera.com>

[ Upstream commit 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ]

Add mutex lock to stratix10_svc_allocate_memory and
stratix10_svc_free_memory for thread safety. This prevents race
conditions and ensures proper synchronization during memory operations.
This is required for parallel communication with the Stratix10 service
channel.

[ 5.15.y lacks <linux/cleanup.h>, so the upstream guard(mutex) is
  open-coded as explicit mutex_lock()/mutex_unlock(). ]

Fixes: 7ca5ce896524f ("firmware: add Intel Stratix10 service layer driver")
Cc: <stable@vger.kernel.org> # v5.15.y
Signed-off-by: Mahesh Rao <mahesh.rao@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index c5ddd20fe4b75..c0027a6bf4718 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017-2018, Intel Corporation
+ * Copyright (C) 2025, Altera Corporation
  */
 
 #include <linux/completion.h>
@@ -167,6 +168,12 @@ struct stratix10_svc_chan {
 static LIST_HEAD(svc_ctrl);
 static LIST_HEAD(svc_data_mem);
 
+/**
+ * svc_mem_lock protects access to the svc_data_mem list for
+ * concurrent multi-client operations
+ */
+static DEFINE_MUTEX(svc_mem_lock);
+
 /**
  * svc_pa_to_va() - translate physical address to virtual address
  * @addr: to be translated physical address
@@ -179,9 +186,13 @@ static void *svc_pa_to_va(unsigned long addr)
 	struct stratix10_svc_data_mem *pmem;
 
 	pr_debug("claim back P-addr=0x%016x\n", (unsigned int)addr);
+	mutex_lock(&svc_mem_lock);
 	list_for_each_entry(pmem, &svc_data_mem, node)
-		if (pmem->paddr == addr)
+		if (pmem->paddr == addr) {
+			mutex_unlock(&svc_mem_lock);
 			return pmem->vaddr;
+		}
+	mutex_unlock(&svc_mem_lock);
 
 	/* physical address is not found */
 	return NULL;
@@ -844,11 +855,13 @@ int stratix10_svc_send(struct stratix10_svc_chan *chan, void *msg)
 			p_data->flag = ct->flags;
 		}
 	} else {
+		mutex_lock(&svc_mem_lock);
 		list_for_each_entry(p_mem, &svc_data_mem, node)
 			if (p_mem->vaddr == p_msg->payload) {
 				p_data->paddr = p_mem->paddr;
 				break;
 			}
+		mutex_unlock(&svc_mem_lock);
 	}
 
 	p_data->command = p_msg->command;
@@ -915,8 +928,10 @@ void *stratix10_svc_allocate_memory(struct stratix10_svc_chan *chan,
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_lock(&svc_mem_lock);
 	va = gen_pool_alloc(genpool, s);
 	if (!va) {
+		mutex_unlock(&svc_mem_lock);
 		kfree(pmem);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -930,6 +945,7 @@ void *stratix10_svc_allocate_memory(struct stratix10_svc_chan *chan,
 	list_add_tail(&pmem->node, &svc_data_mem);
 	pr_debug("%s: va=%p, pa=0x%016x\n", __func__,
 		 pmem->vaddr, (unsigned int)pmem->paddr);
+	mutex_unlock(&svc_mem_lock);
 
 	return (void *)va;
 }
@@ -946,6 +962,7 @@ void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
 
+	mutex_lock(&svc_mem_lock);
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->vaddr == kaddr) {
 			gen_pool_free(chan->ctrl->genpool,
@@ -953,8 +970,10 @@ void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 			pmem->vaddr = NULL;
 			list_del(&pmem->node);
 			kfree(pmem);
+			mutex_unlock(&svc_mem_lock);
 			return;
 		}
+	mutex_unlock(&svc_mem_lock);
 }
 EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
 
-- 
2.53.0



