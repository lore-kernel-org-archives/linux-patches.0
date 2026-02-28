Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8846379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302056; cv=none; b=XfMYJdZxKPCDsWOa6TpLndQBH1jBz8xdpi3tX7hZ5oJUuU4c+/c1Ykz+kcahOcOqxHzVz9XsoYrlASnse9av0PJTL+92H37qafjXpbtDBM6CKiLaXpQnnOmTI1D8Oz6URkSlaHth1yB8lNK6F2QSTrhJ6oRGjhnbLeM3fMOxF8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302056; c=relaxed/simple;
	bh=+2FVZzTrvFFVhZODQ90VOt9Bzue+sK3G7EbcZLtvLnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUtLT/KG3exdbyq3h4Tlu69rPKyHcx+2LffgyVXrdbeISRbjvB5IvPHOB+M02oNqFfFw8BA6lrw0YXN39a2DjeBQxCKrs6Fau+aF6sHNdDL3f8shSOW/6VyDfHOxnIbcHHlq1izlQcob+AjLkxEbkHSsqnjva/py0dn6A2xyY4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNFuuuB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNFuuuB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF7C116D0;
	Sat, 28 Feb 2026 18:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302056;
	bh=+2FVZzTrvFFVhZODQ90VOt9Bzue+sK3G7EbcZLtvLnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNFuuuB7JcbkE9eHcTTC3UDJe3/DVh7YzNhSLI8x7vz5+JcmqQwokzQFKyU33Q2+2
	 p3vj798LXyH7e1nNuheN8iIOCJC7GR7IMtxezx8frNzbF/tmNK8zn9dd6VCldhoQbE
	 dAN4KSGH5K9AMvDjhs+QbvffbCGOn+onMEs5FQptKclDzsHetHyyHzMhP9RQWgsPid
	 vvjhe17seRjopCUX3hugLVnKqvCK6QIxYn+fuX0y1m3BM3Ey6MPPyXhHBjrqP4rQNa
	 o56aOWw8LJxuqwFyNXNU/w7rh8M9wJm3iKKNvRxBjYDjzHtJYSRGD2HefbRDRph3d4
	 Cduf9JOiV3KGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Roger Pau Monne <roger.pau@citrix.com>,
	James Dingwall <james@dingwall.me.uk>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/283] Partial revert "x86/xen: fix balloon target initialization for PVH dom0"
Date: Sat, 28 Feb 2026 13:02:54 -0500
Message-ID: <20260228180709.1583486-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 638de313fc4ed..03fb16dc0b926 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -480,7 +480,7 @@ int __init arch_xen_unpopulated_init(struct resource **res)
 		 * driver to know how much of the physmap is unpopulated and
 		 * set an accurate initial memory target.
 		 */
-		xen_released_pages += xen_extra_mem[i].n_pfns;
+		xen_unpopulated_pages += xen_extra_mem[i].n_pfns;
 		/* Zero so region is not also added to the balloon driver. */
 		xen_extra_mem[i].n_pfns = 0;
 	}
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 204ec1bcbd526..a76d5530533ff 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -716,6 +716,7 @@ static int __init balloon_add_regions(void)
 static int __init balloon_init(void)
 {
 	struct task_struct *task;
+	unsigned long current_pages;
 	int rc;
 
 	if (!xen_domain())
@@ -723,12 +724,18 @@ static int __init balloon_init(void)
 
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
@@ -759,6 +766,10 @@ static int __init balloon_init(void)
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

