Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91F21482E8;
	Fri,  9 Jan 2026 12:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962744; cv=none; b=Igaz1U0T0p7I70eLO3m8SfR/SPo9nh4eN4OPhlERE9fHummXq7VWaaKfptT1Dkui++ctZW4k6BfCztVwp13ZadZCEL0Wr/Hc+cllEVBuOAFk8A18gjvm7xagMp1st3r2drEIJUdsbzgfh+rNbpyM7MW8NW5Y/OpIFO4Zx52f158=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962744; c=relaxed/simple;
	bh=+WmskWhzyfuXovCmVrm4mbVMP3ggxLfRiVaBne0yz8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUv8HeV7k3Jn5PlC12Jm9mc801naxFSao7gJAtI1zKZWpRsprrrWcYBxqb+QsnnOn469fENMviv3oWjhM7SSvjXs8ay6BNMAlJtHvBLLzFO3o+4vN4ZeV0NfqnyUQX/oef7BGl4FylVaxtt5K7SBoKy8YdtqOa3MYoJ8iRKNVBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmgAhXDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmgAhXDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F048AC16AAE;
	Fri,  9 Jan 2026 12:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962744;
	bh=+WmskWhzyfuXovCmVrm4mbVMP3ggxLfRiVaBne0yz8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmgAhXDDG4OdmdCxAIirBStWYHPh6FCFxCy6ao/p+yDEDvKGNIAfvoq8bV9yeT6AS
	 bJzSTFKu132HyOJl1VaDBK+p7GnU/2uI+wIRmGCSyUMdM6RuRdBaS+Fa04DvGouxDC
	 gLEJ/DI1PwMrQ59+WR0rgJGTL09QoGjw2HYpEKps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Rao <mahesh.rao@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.1 472/634] firmware: stratix10-svc: Add mutex in stratix10 memory management
Date: Fri,  9 Jan 2026 12:42:30 +0100
Message-ID: <20260109112135.310955923@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -175,6 +176,12 @@ static LIST_HEAD(svc_ctrl);
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
@@ -186,6 +193,7 @@ static void *svc_pa_to_va(unsigned long
 	struct stratix10_svc_data_mem *pmem;
 
 	pr_debug("claim back P-addr=0x%016x\n", (unsigned int)addr);
+	guard(mutex)(&svc_mem_lock);
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->paddr == addr)
 			return pmem->vaddr;
@@ -978,6 +986,7 @@ int stratix10_svc_send(struct stratix10_
 			p_data->flag = ct->flags;
 		}
 	} else {
+		guard(mutex)(&svc_mem_lock);
 		list_for_each_entry(p_mem, &svc_data_mem, node)
 			if (p_mem->vaddr == p_msg->payload) {
 				p_data->paddr = p_mem->paddr;
@@ -1060,6 +1069,7 @@ void *stratix10_svc_allocate_memory(stru
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
+	guard(mutex)(&svc_mem_lock);
 	va = gen_pool_alloc(genpool, s);
 	if (!va)
 		return ERR_PTR(-ENOMEM);
@@ -1088,6 +1098,7 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
+	guard(mutex)(&svc_mem_lock);
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->vaddr == kaddr) {


