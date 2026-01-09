Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D011C3C08;
	Fri,  9 Jan 2026 12:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960934; cv=none; b=JkRatcl0cxrBuW7KqILxXhSW6/Nm9jZg0jSlQzoERCIW3YQ9ug6CXZBDFTH12wfbkVT2707DWL4MQ70q6Pr1NvjVML/FEQOXNAi6aPEtpLHn/ySx5AwOrfsjf/BuTxgX+SwonY7Eu9PVpdNDk0cZavzh73tgEcFygSFNy9mg/14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960934; c=relaxed/simple;
	bh=dAgXcEoerScpsTTI0Lm6wveXpFmBwZZB892EGS+GsvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goUZCIB7v5E1aGxzH8v86nVWDywMHU6XJg4VAKI1b2ECnsD+lKMDKgzDblaRK5pa2YZWj8TqP+zsyfrhORjGL2b6zJmmF5fQ2/3KyqZyIm2MGVcnw26sQqA/ik+fJuZ46NvjjqdoYf4/IJp8zeNupl/yeDxQTnbJZXpWUCOaGzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEDnBEKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEDnBEKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7300C4CEF1;
	Fri,  9 Jan 2026 12:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960934;
	bh=dAgXcEoerScpsTTI0Lm6wveXpFmBwZZB892EGS+GsvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEDnBEKimGtzRf4I84z9KjTMIHw8zwW7Ns3D9XsjKjK7LrhUxexGK7652GXoWJ33r
	 oB9dXAV4jQHXuEmE58h/DAvRemSrAKDB/6KMmC3R0NGESnYURRnN7Cl/Pm/7yt2BqF
	 fGRPw4G1dLLX62B2VOTRwb5KJTGPf5zdFaTYiOS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Rao <mahesh.rao@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.6 577/737] firmware: stratix10-svc: Add mutex in stratix10 memory management
Date: Fri,  9 Jan 2026 12:41:56 +0100
Message-ID: <20260109112155.707033483@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -996,6 +1004,7 @@ int stratix10_svc_send(struct stratix10_
 			p_data->flag = ct->flags;
 		}
 	} else {
+		guard(mutex)(&svc_mem_lock);
 		list_for_each_entry(p_mem, &svc_data_mem, node)
 			if (p_mem->vaddr == p_msg->payload) {
 				p_data->paddr = p_mem->paddr;
@@ -1078,6 +1087,7 @@ void *stratix10_svc_allocate_memory(stru
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
+	guard(mutex)(&svc_mem_lock);
 	va = gen_pool_alloc(genpool, s);
 	if (!va)
 		return ERR_PTR(-ENOMEM);
@@ -1106,6 +1116,7 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
+	guard(mutex)(&svc_mem_lock);
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->vaddr == kaddr) {


