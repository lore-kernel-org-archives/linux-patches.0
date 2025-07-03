Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA4886348;
	Thu,  3 Jul 2025 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556032; cv=none; b=XE1O7JobsfguR+P2wV4i42rFSyD/Cz2WCYMrh+hYk5ltBsAR01A+jcUzUvT0my3KVKTuHmccaBDfotYMX95two19DR2inx17d+lECtUpULPzhKREi1TXxEZkuTkm9EkHfCoCVKXdfho0Hh4PRDW5ulrvuT1sy51QrYLs+HkTg70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556032; c=relaxed/simple;
	bh=2IRdIIaxngvHBwanPLGWaDC4zkRE9GjRzfiAf7zD1w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To8Zn8bTbEhMlKSLKTDloJHp33aO/NUHMyqoCERKXJb+ED7l1c+GKDIhTKonPIFbHuPFVd29841GC3+oszS/4l8NcuEO10qbBHwhypaIo27Vgq5te6zKQqF5J3e+oG2jfLQdjkz28JOT7wE5PVA04WVVY8zMFpgBD9WysyndGR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz6pAQFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz6pAQFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF7EC4CEE3;
	Thu,  3 Jul 2025 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556032;
	bh=2IRdIIaxngvHBwanPLGWaDC4zkRE9GjRzfiAf7zD1w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz6pAQFQkB1TtlHZEt5GMDBTnU/siW5QnPnjlKMyPc/V/xeCOfoE3vuGH4Pl1ZO53
	 7HI3/X20ZXd7LNgiilUrF0i+4GEn+NIkbW3Imft+ZxTvHsTYaM+QshBuz5Rp4GuuEt
	 r0+QzCYasCDEDSZjJ7mamRfJ0qspKNm+UP7CoWyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Tianyu Lan <Tianyu.Lan@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/132] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date: Thu,  3 Jul 2025 16:42:22 +0200
Message-ID: <20250703143941.499698293@linuxfoundation.org>
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

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit a5ddb74588213c31ce993a8e9a09d1ffdc11a142 ]

With changes to how Hyper-V guest VMs flip memory between private
(encrypted) and shared (decrypted), creating a second kernel virtual
mapping for shared memory is no longer necessary.  Everything needed
for the transition to shared is handled by set_memory_decrypted().

As such, remove the code to create and manage the second
mapping for VMBus monitor pages. Because set_memory_decrypted()
and set_memory_encrypted() are no-ops in normal VMs, it's
not even necessary to test for being in a Confidential VM
(a.k.a., "Isolation VM").

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/1679838727-87310-9-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 09eea7ad0b8e ("Drivers: hv: Allocate interrupt and monitor pages aligned to system page boundary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c   | 113 ++++++++++----------------------------
 drivers/hv/hyperv_vmbus.h |   2 -
 2 files changed, 28 insertions(+), 87 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index da51b50787dff..5978e9dbc286f 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -104,8 +104,14 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID;
 	}
 
-	msg->monitor_page1 = vmbus_connection.monitor_pages_pa[0];
-	msg->monitor_page2 = vmbus_connection.monitor_pages_pa[1];
+	/*
+	 * shared_gpa_boundary is zero in non-SNP VMs, so it's safe to always
+	 * bitwise OR it
+	 */
+	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]) |
+				ms_hyperv.shared_gpa_boundary;
+	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]) |
+				ms_hyperv.shared_gpa_boundary;
 
 	msg->target_vcpu = hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
 
@@ -219,72 +225,27 @@ int vmbus_connect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.monitor_pages[0] = (void *)hv_alloc_hyperv_zeroed_page();
-	vmbus_connection.monitor_pages[1] = (void *)hv_alloc_hyperv_zeroed_page();
+	vmbus_connection.monitor_pages[0] = (void *)hv_alloc_hyperv_page();
+	vmbus_connection.monitor_pages[1] = (void *)hv_alloc_hyperv_page();
 	if ((vmbus_connection.monitor_pages[0] == NULL) ||
 	    (vmbus_connection.monitor_pages[1] == NULL)) {
 		ret = -ENOMEM;
 		goto cleanup;
 	}
 
-	vmbus_connection.monitor_pages_original[0]
-		= vmbus_connection.monitor_pages[0];
-	vmbus_connection.monitor_pages_original[1]
-		= vmbus_connection.monitor_pages[1];
-	vmbus_connection.monitor_pages_pa[0]
-		= virt_to_phys(vmbus_connection.monitor_pages[0]);
-	vmbus_connection.monitor_pages_pa[1]
-		= virt_to_phys(vmbus_connection.monitor_pages[1]);
-
-	if (hv_is_isolation_supported()) {
-		ret = set_memory_decrypted((unsigned long)
-					   vmbus_connection.monitor_pages[0],
-					   1);
-		ret |= set_memory_decrypted((unsigned long)
-					    vmbus_connection.monitor_pages[1],
-					    1);
-		if (ret)
-			goto cleanup;
-
-		/*
-		 * Isolation VM with AMD SNP needs to access monitor page via
-		 * address space above shared gpa boundary.
-		 */
-		if (hv_isolation_type_snp()) {
-			vmbus_connection.monitor_pages_pa[0] +=
-				ms_hyperv.shared_gpa_boundary;
-			vmbus_connection.monitor_pages_pa[1] +=
-				ms_hyperv.shared_gpa_boundary;
-
-			vmbus_connection.monitor_pages[0]
-				= memremap(vmbus_connection.monitor_pages_pa[0],
-					   HV_HYP_PAGE_SIZE,
-					   MEMREMAP_WB);
-			if (!vmbus_connection.monitor_pages[0]) {
-				ret = -ENOMEM;
-				goto cleanup;
-			}
-
-			vmbus_connection.monitor_pages[1]
-				= memremap(vmbus_connection.monitor_pages_pa[1],
-					   HV_HYP_PAGE_SIZE,
-					   MEMREMAP_WB);
-			if (!vmbus_connection.monitor_pages[1]) {
-				ret = -ENOMEM;
-				goto cleanup;
-			}
-		}
-
-		/*
-		 * Set memory host visibility hvcall smears memory
-		 * and so zero monitor pages here.
-		 */
-		memset(vmbus_connection.monitor_pages[0], 0x00,
-		       HV_HYP_PAGE_SIZE);
-		memset(vmbus_connection.monitor_pages[1], 0x00,
-		       HV_HYP_PAGE_SIZE);
+	ret = set_memory_decrypted((unsigned long)
+				vmbus_connection.monitor_pages[0], 1);
+	ret |= set_memory_decrypted((unsigned long)
+				vmbus_connection.monitor_pages[1], 1);
+	if (ret)
+		goto cleanup;
 
-	}
+	/*
+	 * Set_memory_decrypted() will change the memory contents if
+	 * decryption occurs, so zero monitor pages here.
+	 */
+	memset(vmbus_connection.monitor_pages[0], 0x00, HV_HYP_PAGE_SIZE);
+	memset(vmbus_connection.monitor_pages[1], 0x00, HV_HYP_PAGE_SIZE);
 
 	msginfo = kzalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_initiate_contact),
@@ -376,31 +337,13 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
-	if (hv_is_isolation_supported()) {
-		/*
-		 * memunmap() checks input address is ioremap address or not
-		 * inside. It doesn't unmap any thing in the non-SNP CVM and
-		 * so not check CVM type here.
-		 */
-		memunmap(vmbus_connection.monitor_pages[0]);
-		memunmap(vmbus_connection.monitor_pages[1]);
-
-		set_memory_encrypted((unsigned long)
-			vmbus_connection.monitor_pages_original[0],
-			1);
-		set_memory_encrypted((unsigned long)
-			vmbus_connection.monitor_pages_original[1],
-			1);
-	}
+	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[0], 1);
+	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[1], 1);
 
-	hv_free_hyperv_page((unsigned long)
-		vmbus_connection.monitor_pages_original[0]);
-	hv_free_hyperv_page((unsigned long)
-		vmbus_connection.monitor_pages_original[1]);
-	vmbus_connection.monitor_pages_original[0] =
-		vmbus_connection.monitor_pages[0] = NULL;
-	vmbus_connection.monitor_pages_original[1] =
-		vmbus_connection.monitor_pages[1] = NULL;
+	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
+	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
+	vmbus_connection.monitor_pages[0] = NULL;
+	vmbus_connection.monitor_pages[1] = NULL;
 }
 
 /*
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index ab12e21bf5fc7..4cff3997c3ccd 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -241,8 +241,6 @@ struct vmbus_connection {
 	 * is child->parent notification
 	 */
 	struct hv_monitor_page *monitor_pages[2];
-	void *monitor_pages_original[2];
-	phys_addr_t monitor_pages_pa[2];
 	struct list_head chn_msg_list;
 	spinlock_t channelmsg_lock;
 
-- 
2.39.5



