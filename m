Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DCD21D596;
	Wed, 25 Feb 2026 01:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982872; cv=none; b=H3YHYIIO2KoVe6zTjkyY0SmFOFi1zct52vDx38YQRCuZljR1NSEhOKkm9x8LAqEn2xkytJoUK4aS7o6/mGa21LnUgDK9wv08Ez8N9GgrD17IhX22h/chhisw6IeWelbFQrr5oGg7SyU6CBGrmw7PE6dwteVxDOMY6fiAHj3E4XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982872; c=relaxed/simple;
	bh=KXO4O7bySRgk10iMghDNrw6R8Ku1FItNWQRD2Vmqq3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mh/KphuFxlNV3+5rk061THRpQt3QWbVQeh+Isq3R70MvxNwRIjDv9nafhadRM8Q0I3yyVulJs1FsffYQJmt24uabfPAIFoTcLAEsZ2CUkKgKMUCbhHQSnDeKyb9b9nOuQQ1yrl6d0m56Vd9PAfFoq+a5N/7MIuCIXvpLQw112cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3vDiN7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3vDiN7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FAAC116D0;
	Wed, 25 Feb 2026 01:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982872;
	bh=KXO4O7bySRgk10iMghDNrw6R8Ku1FItNWQRD2Vmqq3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3vDiN7tXJS8dErL7tTZjxv/huX0v22judQDqZEA9GEtfXnyxT+N8e58QYqB/FNtl
	 LFBpwyd9F3w2iNOJy9ndjLM1aJJ5VsFXhf0mLvjcOATLYujKNBhx2p/U7nOulTeAFH
	 qqJTD0UMojBI+999l0qp82QFhwYDcapOF4Zed9xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Dingwall <james@dingwall.me.uk>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 057/781] Partial revert "x86/xen: fix balloon target initialization for PVH dom0"
Date: Tue, 24 Feb 2026 17:12:46 -0800
Message-ID: <20260225012401.104244910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 53282dc7d5ac5..23b91bf9b6630 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -470,7 +470,7 @@ int __init arch_xen_unpopulated_init(struct resource **res)
 		 * driver to know how much of the physmap is unpopulated and
 		 * set an accurate initial memory target.
 		 */
-		xen_released_pages += xen_extra_mem[i].n_pfns;
+		xen_unpopulated_pages += xen_extra_mem[i].n_pfns;
 		/* Zero so region is not also added to the balloon driver. */
 		xen_extra_mem[i].n_pfns = 0;
 	}
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 49c3f99263943..8c44a25a7d2b9 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -724,6 +724,7 @@ static int __init balloon_add_regions(void)
 static int __init balloon_init(void)
 {
 	struct task_struct *task;
+	unsigned long current_pages;
 	int rc;
 
 	if (!xen_domain())
@@ -731,12 +732,18 @@ static int __init balloon_init(void)
 
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
@@ -767,6 +774,10 @@ static int __init balloon_init(void)
 	xen_balloon_init();
 
 	return 0;
+
+ underflow:
+	WARN(1, "Released pages underflow current target");
+	return -ERANGE;
 }
 subsys_initcall(balloon_init);
 
diff --git a/drivers/xen/unpopulated-alloc.c b/drivers/xen/unpopulated-alloc.c
index d6fc2aefe2646..1dc0b495c8e59 100644
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
index 61854e3f28377..f280c5dcf9236 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -69,11 +69,13 @@ extern u64 xen_saved_max_mem_size;
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



