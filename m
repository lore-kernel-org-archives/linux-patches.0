Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641834D4E4;
	Tue,  6 Jan 2026 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722221; cv=none; b=V5jTy+5K6lekuXFQG/0DbKI3ECHFjUk7PtLdZ2wokgiGPWfRy2OdNM+22CG7X2O7KjoiAjQnVTUR4KoK34XyHoEHsEY1iuDEEtQ29BHb9tFx90FMx05uU3SF0/CNIdtTV4ZLuw1tKjEDJeWC/em1G58JdVdxUF8GmBqsN++KbHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722221; c=relaxed/simple;
	bh=tMiWbtS2/Z4bJgrpBMNB8LLIm+wM4GZSESv1oA598ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tv46gF3lrqKmmwipjB7mqlbfWcuqBuHoCIsGfhq2PC8cSuPsMyd+zI4ADaSASnTGd75W2/H6+rnRwljjpa3F/tLjvl4vzj/rHSKtSIY8wcb5qyczfq3m8UCiTcN/a7Al/6mehLdUWWUKTtEpJke286XnIejTqAozmYB2rXBL1SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2OlAzqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2OlAzqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D68C116C6;
	Tue,  6 Jan 2026 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722221;
	bh=tMiWbtS2/Z4bJgrpBMNB8LLIm+wM4GZSESv1oA598ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2OlAzqz86BgaOEOZZK8X+tprPZR5nmAyhzcxElRJTbl2ZYh++AQ9PVgtVJWxNQdO
	 WLdW9J72v3gz/tYsxA+Cd0iwGKhC6CJ9f91U1fCNQVZrpgguGg0Eo8EIq65HJ2KvHS
	 VcOmV991YJe8t/69tZ/3/az5U8QnDnWdzPKj4Fw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Rao <mahesh.rao@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.18 166/312] firmware: stratix10-svc: Add mutex in stratix10 memory management
Date: Tue,  6 Jan 2026 18:04:00 +0100
Message-ID: <20260106170553.839762719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Rao <mahesh.rao@altera.com>

commit 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b upstream.

Add mutex lock to stratix10_svc_allocate_memory and
stratix10_svc_free_memory for thread safety. This prevents race
conditions and ensures proper synchronization during memory operations.
This is required for parallel communication with the Stratix10 service
channel.

Fixes: 7ca5ce896524f ("firmware: add Intel Stratix10 service layer driver")
Cc: stable@vger.kernel.org
Signed-off-by: Mahesh Rao <mahesh.rao@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017-2018, Intel Corporation
+ * Copyright (C) 2025, Altera Corporation
  */
 
 #include <linux/completion.h>
@@ -176,6 +177,12 @@ static LIST_HEAD(svc_ctrl);
 static LIST_HEAD(svc_data_mem);
 
 /**
+ * svc_mem_lock protects access to the svc_data_mem list for
+ * concurrent multi-client operations
+ */
+static DEFINE_MUTEX(svc_mem_lock);
+
+/**
  * svc_pa_to_va() - translate physical address to virtual address
  * @addr: to be translated physical address
  *
@@ -187,6 +194,7 @@ static void *svc_pa_to_va(unsigned long
 	struct stratix10_svc_data_mem *pmem;
 
 	pr_debug("claim back P-addr=0x%016x\n", (unsigned int)addr);
+	guard(mutex)(&svc_mem_lock);
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->paddr == addr)
 			return pmem->vaddr;
@@ -993,6 +1001,7 @@ int stratix10_svc_send(struct stratix10_
 			p_data->flag = ct->flags;
 		}
 	} else {
+		guard(mutex)(&svc_mem_lock);
 		list_for_each_entry(p_mem, &svc_data_mem, node)
 			if (p_mem->vaddr == p_msg->payload) {
 				p_data->paddr = p_mem->paddr;
@@ -1075,6 +1084,7 @@ void *stratix10_svc_allocate_memory(stru
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
+	guard(mutex)(&svc_mem_lock);
 	va = gen_pool_alloc(genpool, s);
 	if (!va)
 		return ERR_PTR(-ENOMEM);
@@ -1103,6 +1113,7 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
+	guard(mutex)(&svc_mem_lock);
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->vaddr == kaddr) {


