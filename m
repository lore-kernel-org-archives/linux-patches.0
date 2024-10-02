Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C96129CE7;
	Wed,  2 Oct 2024 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875865; cv=none; b=Qy5GnSH/pikCXB9kIKT4+8+tQ5NWXTZdAH+LpxQT9L/0Kfs653ZbiSKhnu+Q863oKRraB3G5dHMXvQdQlhNgFfS87RG/OBLb2SwiCLnQFgR2VWVm3ZMooemfEj/d47KprF7OESZ9iz/2DEh3+8UCWM+lOHy2NR75BT2M02G2eLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875865; c=relaxed/simple;
	bh=8O2bENdDjLZYl/DEOKiAwJYnDM01qgpXsj7qqbnqWkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fRp6NeEMOxFs/hNuPJheHdYKxyi6Dn1NvzHAGYv21SI2wlWMXur0zuNCDg8azZaVJJyhs+iKz28daFfsUXuSjEGnr44FvUOnMs/d89VVi+6dfZKyyowHlOa2e1B2JduWrwss1OgCgypSqZuqJGScmnKjjgDCjjvQ+8zBx6WluVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4fPdzkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4fPdzkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBAEC4CEC5;
	Wed,  2 Oct 2024 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875864;
	bh=8O2bENdDjLZYl/DEOKiAwJYnDM01qgpXsj7qqbnqWkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4fPdzkEdo/BK7YytQrw6ADW4SCKL8H9JclQbyGJATO8t3AsGAhv0zvTp/G5g2UOi
	 PA6fl2hoIbjV91AuNRf/rjx3f6yaT2+G+hDsqdm+Yy8EEEaThEj7UNLV4wOWJQ0IlI
	 NTgOFWg3Hg5H7pLVQocyvzbJaELjIWtFRg9wyzP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 247/695] xen: move max_pfn in xen_memory_setup() out of function scope
Date: Wed,  2 Oct 2024 14:54:05 +0200
Message-ID: <20241002125832.310784221@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 43dc2a0f479b9cd30f6674986d7a40517e999d31 ]

Instead of having max_pfn as a local variable of xen_memory_setup(),
make it a static variable in setup.c instead. This avoids having to
pass it to subfunctions, which will be needed in more cases in future.

Rename it to ini_nr_pages, as the value denotes the currently usable
number of memory pages as passed from the hypervisor at boot time.

Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: be35d91c8880 ("xen: tolerate ACPI NVS memory overlapping with Xen allocated memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/setup.c | 52 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 96765180514bd..4c18d8b1cdf10 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -46,6 +46,9 @@ bool xen_pv_pci_possible;
 /* E820 map used during setting up memory. */
 static struct e820_table xen_e820_table __initdata;
 
+/* Number of initially usable memory pages. */
+static unsigned long ini_nr_pages __initdata;
+
 /*
  * Buffer used to remap identity mapped pages. We only need the virtual space.
  * The physical page behind this address is remapped as needed to different
@@ -212,7 +215,7 @@ static int __init xen_free_mfn(unsigned long mfn)
  * as a fallback if the remapping fails.
  */
 static void __init xen_set_identity_and_release_chunk(unsigned long start_pfn,
-			unsigned long end_pfn, unsigned long nr_pages)
+						      unsigned long end_pfn)
 {
 	unsigned long pfn, end;
 	int ret;
@@ -220,7 +223,7 @@ static void __init xen_set_identity_and_release_chunk(unsigned long start_pfn,
 	WARN_ON(start_pfn > end_pfn);
 
 	/* Release pages first. */
-	end = min(end_pfn, nr_pages);
+	end = min(end_pfn, ini_nr_pages);
 	for (pfn = start_pfn; pfn < end; pfn++) {
 		unsigned long mfn = pfn_to_mfn(pfn);
 
@@ -341,15 +344,14 @@ static void __init xen_do_set_identity_and_remap_chunk(
  * to Xen and not remapped.
  */
 static unsigned long __init xen_set_identity_and_remap_chunk(
-	unsigned long start_pfn, unsigned long end_pfn, unsigned long nr_pages,
-	unsigned long remap_pfn)
+	unsigned long start_pfn, unsigned long end_pfn, unsigned long remap_pfn)
 {
 	unsigned long pfn;
 	unsigned long i = 0;
 	unsigned long n = end_pfn - start_pfn;
 
 	if (remap_pfn == 0)
-		remap_pfn = nr_pages;
+		remap_pfn = ini_nr_pages;
 
 	while (i < n) {
 		unsigned long cur_pfn = start_pfn + i;
@@ -358,19 +360,19 @@ static unsigned long __init xen_set_identity_and_remap_chunk(
 		unsigned long remap_range_size;
 
 		/* Do not remap pages beyond the current allocation */
-		if (cur_pfn >= nr_pages) {
+		if (cur_pfn >= ini_nr_pages) {
 			/* Identity map remaining pages */
 			set_phys_range_identity(cur_pfn, cur_pfn + size);
 			break;
 		}
-		if (cur_pfn + size > nr_pages)
-			size = nr_pages - cur_pfn;
+		if (cur_pfn + size > ini_nr_pages)
+			size = ini_nr_pages - cur_pfn;
 
 		remap_range_size = xen_find_pfn_range(&remap_pfn);
 		if (!remap_range_size) {
 			pr_warn("Unable to find available pfn range, not remapping identity pages\n");
 			xen_set_identity_and_release_chunk(cur_pfn,
-						cur_pfn + left, nr_pages);
+							   cur_pfn + left);
 			break;
 		}
 		/* Adjust size to fit in current e820 RAM region */
@@ -397,18 +399,18 @@ static unsigned long __init xen_set_identity_and_remap_chunk(
 }
 
 static unsigned long __init xen_count_remap_pages(
-	unsigned long start_pfn, unsigned long end_pfn, unsigned long nr_pages,
+	unsigned long start_pfn, unsigned long end_pfn,
 	unsigned long remap_pages)
 {
-	if (start_pfn >= nr_pages)
+	if (start_pfn >= ini_nr_pages)
 		return remap_pages;
 
-	return remap_pages + min(end_pfn, nr_pages) - start_pfn;
+	return remap_pages + min(end_pfn, ini_nr_pages) - start_pfn;
 }
 
-static unsigned long __init xen_foreach_remap_area(unsigned long nr_pages,
+static unsigned long __init xen_foreach_remap_area(
 	unsigned long (*func)(unsigned long start_pfn, unsigned long end_pfn,
-			      unsigned long nr_pages, unsigned long last_val))
+			      unsigned long last_val))
 {
 	phys_addr_t start = 0;
 	unsigned long ret_val = 0;
@@ -436,8 +438,7 @@ static unsigned long __init xen_foreach_remap_area(unsigned long nr_pages,
 				end_pfn = PFN_UP(entry->addr);
 
 			if (start_pfn < end_pfn)
-				ret_val = func(start_pfn, end_pfn, nr_pages,
-					       ret_val);
+				ret_val = func(start_pfn, end_pfn, ret_val);
 			start = end;
 		}
 	}
@@ -700,7 +701,7 @@ static void __init xen_reserve_xen_mfnlist(void)
  **/
 char * __init xen_memory_setup(void)
 {
-	unsigned long max_pfn, pfn_s, n_pfns;
+	unsigned long pfn_s, n_pfns;
 	phys_addr_t mem_end, addr, size, chunk_size;
 	u32 type;
 	int rc;
@@ -712,9 +713,8 @@ char * __init xen_memory_setup(void)
 	int op;
 
 	xen_parse_512gb();
-	max_pfn = xen_get_pages_limit();
-	max_pfn = min(max_pfn, xen_start_info->nr_pages);
-	mem_end = PFN_PHYS(max_pfn);
+	ini_nr_pages = min(xen_get_pages_limit(), xen_start_info->nr_pages);
+	mem_end = PFN_PHYS(ini_nr_pages);
 
 	memmap.nr_entries = ARRAY_SIZE(xen_e820_table.entries);
 	set_xen_guest_handle(memmap.buffer, xen_e820_table.entries);
@@ -767,10 +767,10 @@ char * __init xen_memory_setup(void)
 	max_pages = xen_get_max_pages();
 
 	/* How many extra pages do we need due to remapping? */
-	max_pages += xen_foreach_remap_area(max_pfn, xen_count_remap_pages);
+	max_pages += xen_foreach_remap_area(xen_count_remap_pages);
 
-	if (max_pages > max_pfn)
-		extra_pages += max_pages - max_pfn;
+	if (max_pages > ini_nr_pages)
+		extra_pages += max_pages - ini_nr_pages;
 
 	/*
 	 * Clamp the amount of extra memory to a EXTRA_MEM_RATIO
@@ -779,8 +779,8 @@ char * __init xen_memory_setup(void)
 	 * Make sure we have no memory above max_pages, as this area
 	 * isn't handled by the p2m management.
 	 */
-	maxmem_pages = EXTRA_MEM_RATIO * min(max_pfn, PFN_DOWN(MAXMEM));
-	extra_pages = min3(maxmem_pages, extra_pages, max_pages - max_pfn);
+	maxmem_pages = EXTRA_MEM_RATIO * min(ini_nr_pages, PFN_DOWN(MAXMEM));
+	extra_pages = min3(maxmem_pages, extra_pages, max_pages - ini_nr_pages);
 	i = 0;
 	addr = xen_e820_table.entries[0].addr;
 	size = xen_e820_table.entries[0].size;
@@ -885,7 +885,7 @@ char * __init xen_memory_setup(void)
 	 * Set identity map on non-RAM pages and prepare remapping the
 	 * underlying RAM.
 	 */
-	xen_foreach_remap_area(max_pfn, xen_set_identity_and_remap_chunk);
+	xen_foreach_remap_area(xen_set_identity_and_remap_chunk);
 
 	pr_info("Released %ld page(s)\n", xen_released_pages);
 
-- 
2.43.0



