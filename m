Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C09C375ACB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301645; cv=none; b=BKQgLZEQkpunREveETJnvoLMNIjaLwvD0rVmKBE4PsdRh8ka+KgrYJu+/1K2FwKv4VS+SDhRMZ5s5frKzZ7neDZLdZgSNdTLabLcBB+f8qNzP1gJI1PX+qp4dRS/DyuzCB/4iy8xZ7ke9cDUeIICRscXoc8QohBqmGf3EFVf7Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301645; c=relaxed/simple;
	bh=k1ndAiWyCLqDeeU8Tfluu/50cWKcqjoV1ps3Ck0vKV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FhHCtKTlPKcERRU211A/u1c2r3ZWApcPOJubpsrQhNdACsIEfwA0eCYEUTCe8nTNfJfTSxfNz96ap7s41jdwrR0Y9BP58+xXJLn0f5m2WfthzNIzr3t/rNslyG4lxKtJTNm2tOMj4olHX8rOxc0D940FLLrfixJoLk+Olt6kddw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqyiZ5Ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqyiZ5Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAC1C116D0;
	Sat, 28 Feb 2026 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301645;
	bh=k1ndAiWyCLqDeeU8Tfluu/50cWKcqjoV1ps3Ck0vKV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqyiZ5YaC8XaOI2ONew4yXo16jImnF6QRZOELvtiqy5T00QUJf3G+Bizj7UK9W5OV
	 aarjUpJavL9YRfe6v8K47feFNnzcDPARcXb1hPGygZXZOYucKmG5V0mrw+ne8tGpBL
	 w74kcsw9AEvb6oyRIM+rj4O0g+XgJkgZv9D7TJdCzTKXBdOI4+PWqWCiz55Joptc4N
	 fx4oRqiJHTBjid9vRyKmjGEai1QTVG3BDmz2vMNqPGL/1fkW+HmTJ6uXolgyGr+uhE
	 2ZDCVZtkEUPdcZLvAFUJ2Q1zSxeW+PkGvJWYXag7/h3wyosNVobVm7tWRQVTZGAAvZ
	 MwKU3Fg7ZNAJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Roger Pau Monne <roger.pau@citrix.com>,
	James Dingwall <james@dingwall.me.uk>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/385] Partial revert "x86/xen: fix balloon target initialization for PVH dom0"
Date: Sat, 28 Feb 2026 12:54:22 -0500
Message-ID: <20260228180011.1568201-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 0949c646d64697428ff6257d52efa5093566868d ]

This partially reverts commit 87af633689ce16ddb166c80f32b120e50b1295de so
the current memory target for PV guests is still fetched from
start_info->nr_pages, which matches exactly what the toolstack sets the
initial memory target to.

Using get_num_physpages() is possible on PV also, but needs adjusting to
take into account the ISA hole and the PFN at 0 not considered usable
memory despite being populated, and hence would need extra adjustments.
Instead of carrying those extra adjustments switch back to the previous
code.  That leaves Linux with a difference in how current memory target is
obtained for HVM vs PV, but that's better than adding extra logic just for
PV.

However if switching to start_info->nr_pages for PV domains we need to
differentiate between released pages (freed back to the hypervisor) as
opposed to pages in the physmap which are not populated to start with.
Introduce a new xen_unpopulated_pages to account for papges that have
never been populated, and hence in the PV case don't need subtracting.

Fixes: 87af633689ce ("x86/xen: fix balloon target initialization for PVH dom0")
Reported-by: James Dingwall <james@dingwall.me.uk>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260128110510.46425-2-roger.pau@citrix.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten.c        |  2 +-
 drivers/xen/balloon.c           | 19 +++++++++++++++----
 drivers/xen/unpopulated-alloc.c |  3 +++
 include/xen/xen.h               |  2 ++
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0c950bbca309f..86dd33f1aeaab 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -474,7 +474,7 @@ int __init arch_xen_unpopulated_init(struct resource **res)
 		 * driver to know how much of the physmap is unpopulated and
 		 * set an accurate initial memory target.
 		 */
-		xen_released_pages += xen_extra_mem[i].n_pfns;
+		xen_unpopulated_pages += xen_extra_mem[i].n_pfns;
 		/* Zero so region is not also added to the balloon driver. */
 		xen_extra_mem[i].n_pfns = 0;
 	}
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index e47bb157aa090..88511187458a9 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -720,6 +720,7 @@ static int __init balloon_add_regions(void)
 static int __init balloon_init(void)
 {
 	struct task_struct *task;
+	unsigned long current_pages;
 	int rc;
 
 	if (!xen_domain())
@@ -727,12 +728,18 @@ static int __init balloon_init(void)
 
 	pr_info("Initialising balloon driver\n");
 
-	if (xen_released_pages >= get_num_physpages()) {
-		WARN(1, "Released pages underflow current target");
-		return -ERANGE;
+	if (xen_pv_domain()) {
+		if (xen_released_pages >= xen_start_info->nr_pages)
+			goto underflow;
+		current_pages = min(xen_start_info->nr_pages -
+		                    xen_released_pages, max_pfn);
+	} else {
+		if (xen_unpopulated_pages >= get_num_physpages())
+			goto underflow;
+		current_pages = get_num_physpages() - xen_unpopulated_pages;
 	}
 
-	balloon_stats.current_pages = get_num_physpages() - xen_released_pages;
+	balloon_stats.current_pages = current_pages;
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
@@ -763,6 +770,10 @@ static int __init balloon_init(void)
 	xen_balloon_init();
 
 	return 0;
+
+ underflow:
+	WARN(1, "Released pages underflow current target");
+	return -ERANGE;
 }
 subsys_initcall(balloon_init);
 
diff --git a/drivers/xen/unpopulated-alloc.c b/drivers/xen/unpopulated-alloc.c
index a39f2d36dd9cf..ae46291e99a9d 100644
--- a/drivers/xen/unpopulated-alloc.c
+++ b/drivers/xen/unpopulated-alloc.c
@@ -18,6 +18,9 @@ static unsigned int list_count;
 
 static struct resource *target_resource;
 
+/* Pages to subtract from the memory count when setting balloon target. */
+unsigned long xen_unpopulated_pages __initdata;
+
 /*
  * If arch is not happy with system "iomem_resource" being used for
  * the region allocation it can provide it's own view by creating specific
diff --git a/include/xen/xen.h b/include/xen/xen.h
index a1e5b3f18d69f..86fe96fe51834 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -62,11 +62,13 @@ extern u64 xen_saved_max_mem_size;
 #endif
 
 #ifdef CONFIG_XEN_UNPOPULATED_ALLOC
+extern unsigned long xen_unpopulated_pages;
 int xen_alloc_unpopulated_pages(unsigned int nr_pages, struct page **pages);
 void xen_free_unpopulated_pages(unsigned int nr_pages, struct page **pages);
 #include <linux/ioport.h>
 int arch_xen_unpopulated_init(struct resource **res);
 #else
+#define xen_unpopulated_pages 0UL
 #include <xen/balloon.h>
 static inline int xen_alloc_unpopulated_pages(unsigned int nr_pages,
 		struct page **pages)
-- 
2.51.0

