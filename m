Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4175152532;
	Thu, 17 Apr 2025 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913523; cv=none; b=bSW7+eBRv8bkC3AUJEbHvVx72kWs/pX2Z6BP8gveGgVsXx3NFnFNn+FOB2CgTlD3Dhft5F9QZoOz7xPbbrDcXA7p5KWBkAzbFI/BTEGm/0GZL9ebTfrEFr7bIpuoDPjXs7ZWATLYThH6MKzjJdbRi3mVIs6TekLlDyAWyryGEmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913523; c=relaxed/simple;
	bh=r0GMHs2aA35tBTyKR+s3mMfuemWH2QJzD//8+HsI+/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=II9gOQtfSLrW/JP7uuh+tnl+iUZLGEK0+Q7cjaKzRKUFVBEwq0/Eso+G3/bu131654n27PfuBNbvLgemwTyWQ/14id9gZQ1objpZXR2FyN7e1r+SMLyh5ZDMLhR05uJ27Caq2qFe4pbba/p3e+nnZMN/AE7wAenNi6ZZdqN/kzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjyiDJFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjyiDJFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23663C4CEE4;
	Thu, 17 Apr 2025 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913523;
	bh=r0GMHs2aA35tBTyKR+s3mMfuemWH2QJzD//8+HsI+/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjyiDJFsrhD0FntyW/CrnpmMdjrsNFa8xUmTH8bVHpJ+7XSSXFAxxYtEDzpkRIwzy
	 A3tXSUOijhWYJneMtWUR78Aq55yA71Ir/DUZgsFSEe6aNG13GC8H+VgzkNqUZ0XtxA
	 5uj0kTS51ACXv41irvDups2tquvowL5TnP05LKnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.14 368/449] x86/xen: fix balloon target initialization for PVH dom0
Date: Thu, 17 Apr 2025 19:50:56 +0200
Message-ID: <20250417175133.053119761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit 87af633689ce16ddb166c80f32b120e50b1295de upstream.

PVH dom0 re-uses logic from PV dom0, in which RAM ranges not assigned to
dom0 are re-used as scratch memory to map foreign and grant pages.  Such
logic relies on reporting those unpopulated ranges as RAM to Linux, and
mark them as reserved.  This way Linux creates the underlying page
structures required for metadata management.

Such approach works fine on PV because the initial balloon target is
calculated using specific Xen data, that doesn't take into account the
memory type changes described above.  However on HVM and PVH the initial
balloon target is calculated using get_num_physpages(), and that function
does take into account the unpopulated RAM regions used as scratch space
for remote domain mappings.

This leads to PVH dom0 having an incorrect initial balloon target, which
causes malfunction (excessive memory freeing) of the balloon driver if the
dom0 memory target is later adjusted from the toolstack.

Fix this by using xen_released_pages to account for any pages that are part
of the memory map, but are already unpopulated when the balloon driver is
initialized.  This accounts for any regions used for scratch remote
mappings.  Note on x86 xen_released_pages definition is moved to
enlighten.c so it's uniformly available for all Xen-enabled builds.

Take the opportunity to unify PV with PVH/HVM guests regarding the usage of
get_num_physpages(), as that avoids having to add different logic for PV vs
PVH in both balloon_add_regions() and arch_xen_unpopulated_init().

Much like a6aa4eb994ee, the code in this changeset should have been part of
38620fc4e893.

Fixes: a6aa4eb994ee ('xen/x86: add extra pages to unpopulated-alloc if available')
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250407082838.65495-1-roger.pau@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/enlighten.c |   10 ++++++++++
 arch/x86/xen/setup.c     |    3 ---
 drivers/xen/balloon.c    |   34 ++++++++++++++++++++++++----------
 3 files changed, 34 insertions(+), 13 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -70,6 +70,9 @@ EXPORT_SYMBOL(xen_start_flags);
  */
 struct shared_info *HYPERVISOR_shared_info = &xen_dummy_shared_info;
 
+/* Number of pages released from the initial allocation. */
+unsigned long xen_released_pages;
+
 static __ref void xen_get_vendor(void)
 {
 	init_cpu_devs();
@@ -466,6 +469,13 @@ int __init arch_xen_unpopulated_init(str
 			xen_free_unpopulated_pages(1, &pg);
 		}
 
+		/*
+		 * Account for the region being in the physmap but unpopulated.
+		 * The value in xen_released_pages is used by the balloon
+		 * driver to know how much of the physmap is unpopulated and
+		 * set an accurate initial memory target.
+		 */
+		xen_released_pages += xen_extra_mem[i].n_pfns;
 		/* Zero so region is not also added to the balloon driver. */
 		xen_extra_mem[i].n_pfns = 0;
 	}
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -37,9 +37,6 @@
 
 #define GB(x) ((uint64_t)(x) * 1024 * 1024 * 1024)
 
-/* Number of pages released from the initial allocation. */
-unsigned long xen_released_pages;
-
 /* Memory map would allow PCI passthrough. */
 bool xen_pv_pci_possible;
 
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -675,7 +675,7 @@ void xen_free_ballooned_pages(unsigned i
 }
 EXPORT_SYMBOL(xen_free_ballooned_pages);
 
-static void __init balloon_add_regions(void)
+static int __init balloon_add_regions(void)
 {
 	unsigned long start_pfn, pages;
 	unsigned long pfn, extra_pfn_end;
@@ -698,26 +698,38 @@ static void __init balloon_add_regions(v
 		for (pfn = start_pfn; pfn < extra_pfn_end; pfn++)
 			balloon_append(pfn_to_page(pfn));
 
-		balloon_stats.total_pages += extra_pfn_end - start_pfn;
+		/*
+		 * Extra regions are accounted for in the physmap, but need
+		 * decreasing from current_pages to balloon down the initial
+		 * allocation, because they are already accounted for in
+		 * total_pages.
+		 */
+		if (extra_pfn_end - start_pfn >= balloon_stats.current_pages) {
+			WARN(1, "Extra pages underflow current target");
+			return -ERANGE;
+		}
+		balloon_stats.current_pages -= extra_pfn_end - start_pfn;
 	}
+
+	return 0;
 }
 
 static int __init balloon_init(void)
 {
 	struct task_struct *task;
+	int rc;
 
 	if (!xen_domain())
 		return -ENODEV;
 
 	pr_info("Initialising balloon driver\n");
 
-#ifdef CONFIG_XEN_PV
-	balloon_stats.current_pages = xen_pv_domain()
-		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
-		: get_num_physpages();
-#else
-	balloon_stats.current_pages = get_num_physpages();
-#endif
+	if (xen_released_pages >= get_num_physpages()) {
+		WARN(1, "Released pages underflow current target");
+		return -ERANGE;
+	}
+
+	balloon_stats.current_pages = get_num_physpages() - xen_released_pages;
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
@@ -734,7 +746,9 @@ static int __init balloon_init(void)
 	register_sysctl_init("xen/balloon", balloon_table);
 #endif
 
-	balloon_add_regions();
+	rc = balloon_add_regions();
+	if (rc)
+		return rc;
 
 	task = kthread_run(balloon_thread, NULL, "xen-balloon");
 	if (IS_ERR(task)) {


