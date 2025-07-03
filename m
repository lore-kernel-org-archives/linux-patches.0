Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270791DA23;
	Thu,  3 Jul 2025 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556039; cv=none; b=WMjE87aCwa7NuvzG/55MVv51VHbP9SuOLNDFvIWApV12pFf5TVJp/CL0Oh2GfbJdGQ1PShjndiYbwnWO+arv0eqDVGtcYPYyHyOCcutJsPQTsav83Xu/nnpbKkKu/PbGqNvdeqGDjkK+dm/knmaBx02sozId2nBHEILg7QWtGbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556039; c=relaxed/simple;
	bh=BlJKlORyZdqbPJ1UC1wF2BobK2QKWLChb2Xf4lV8HrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz3FtIUQbnxD/SOfCgMko3I3p0Z04oolGfwgXyivzSfSe5pD/tFPBtCJUO+egAQjFW7icMx+h2hmVWfFZGDVMROvRPT/e2FOj5eh/Uh26WPL53M+lUnjyXe9Wut/PhZWzaEL+VPJyFvhsEe5YZRU0z4RS9cvZyngGctPTpXade0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kjyroke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kjyroke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A323DC4CEE3;
	Thu,  3 Jul 2025 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556039;
	bh=BlJKlORyZdqbPJ1UC1wF2BobK2QKWLChb2Xf4lV8HrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kjyrokebkR7RGVy3idWAsRPzbcT57HTNPaCBfPa/FHDuPftIdRz+NkDXr7VxX59k
	 qAF4dD9pzWtQfThFAq2HZ23/mzx0poiRr3B8n4jo98CyivfF00bejyLQVUFsweDhOc
	 rotZFuKHGzHv5vVXUQxjOv7HpRwjUkm1jPyFrjyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kameron Carr <kameroncarr@linux.microsoft.com>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/132] Drivers: hv: Change hv_free_hyperv_page() to take void * argument
Date: Thu,  3 Jul 2025 16:42:24 +0200
Message-ID: <20250703143941.584078964@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kameron Carr <kameroncarr@linux.microsoft.com>

[ Upstream commit a6fe043880820981f6e4918240f967ea79bb063e ]

Currently hv_free_hyperv_page() takes an unsigned long argument, which
is inconsistent with the void * return value from the corresponding
hv_alloc_hyperv_page() function and variants. This creates unnecessary
extra casting.

Change the hv_free_hyperv_page() argument type to void *.
Also remove redundant casts from invocations of
hv_alloc_hyperv_page() and variants.

Signed-off-by: Kameron Carr <kameroncarr@linux.microsoft.com>
Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1687558189-19734-1-git-send-email-kameroncarr@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 09eea7ad0b8e ("Drivers: hv: Allocate interrupt and monitor pages aligned to system page boundary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c        | 13 ++++++-------
 drivers/hv/hv_common.c         | 10 +++++-----
 include/asm-generic/mshyperv.h |  2 +-
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 5978e9dbc286f..ebf15f31d97e3 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -209,8 +209,7 @@ int vmbus_connect(void)
 	 * Setup the vmbus event connection for channel interrupt
 	 * abstraction stuff
 	 */
-	vmbus_connection.int_page =
-	(void *)hv_alloc_hyperv_zeroed_page();
+	vmbus_connection.int_page = hv_alloc_hyperv_zeroed_page();
 	if (vmbus_connection.int_page == NULL) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -225,8 +224,8 @@ int vmbus_connect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.monitor_pages[0] = (void *)hv_alloc_hyperv_page();
-	vmbus_connection.monitor_pages[1] = (void *)hv_alloc_hyperv_page();
+	vmbus_connection.monitor_pages[0] = hv_alloc_hyperv_page();
+	vmbus_connection.monitor_pages[1] = hv_alloc_hyperv_page();
 	if ((vmbus_connection.monitor_pages[0] == NULL) ||
 	    (vmbus_connection.monitor_pages[1] == NULL)) {
 		ret = -ENOMEM;
@@ -333,15 +332,15 @@ void vmbus_disconnect(void)
 		destroy_workqueue(vmbus_connection.work_queue);
 
 	if (vmbus_connection.int_page) {
-		hv_free_hyperv_page((unsigned long)vmbus_connection.int_page);
+		hv_free_hyperv_page(vmbus_connection.int_page);
 		vmbus_connection.int_page = NULL;
 	}
 
 	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[0], 1);
 	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[1], 1);
 
-	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
-	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
+	hv_free_hyperv_page(vmbus_connection.monitor_pages[0]);
+	hv_free_hyperv_page(vmbus_connection.monitor_pages[1]);
 	vmbus_connection.monitor_pages[0] = NULL;
 	vmbus_connection.monitor_pages[1] = NULL;
 }
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 07338f6ec1e2c..2bc1aea070468 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -112,12 +112,12 @@ void *hv_alloc_hyperv_zeroed_page(void)
 }
 EXPORT_SYMBOL_GPL(hv_alloc_hyperv_zeroed_page);
 
-void hv_free_hyperv_page(unsigned long addr)
+void hv_free_hyperv_page(void *addr)
 {
 	if (PAGE_SIZE == HV_HYP_PAGE_SIZE)
-		free_page(addr);
+		free_page((unsigned long)addr);
 	else
-		kfree((void *)addr);
+		kfree(addr);
 }
 EXPORT_SYMBOL_GPL(hv_free_hyperv_page);
 
@@ -250,7 +250,7 @@ static void hv_kmsg_dump_unregister(void)
 	atomic_notifier_chain_unregister(&panic_notifier_list,
 					 &hyperv_panic_report_block);
 
-	hv_free_hyperv_page((unsigned long)hv_panic_page);
+	hv_free_hyperv_page(hv_panic_page);
 	hv_panic_page = NULL;
 }
 
@@ -267,7 +267,7 @@ static void hv_kmsg_dump_register(void)
 	ret = kmsg_dump_register(&hv_kmsg_dumper);
 	if (ret) {
 		pr_err("Hyper-V: kmsg dump register error 0x%x\n", ret);
-		hv_free_hyperv_page((unsigned long)hv_panic_page);
+		hv_free_hyperv_page(hv_panic_page);
 		hv_panic_page = NULL;
 	}
 }
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index bfb9eb9d7215b..a9b52845335c0 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -187,7 +187,7 @@ int hv_common_cpu_die(unsigned int cpu);
 
 void *hv_alloc_hyperv_page(void);
 void *hv_alloc_hyperv_zeroed_page(void);
-void hv_free_hyperv_page(unsigned long addr);
+void hv_free_hyperv_page(void *addr);
 
 /**
  * hv_cpu_number_to_vp_number() - Map CPU to VP.
-- 
2.39.5



