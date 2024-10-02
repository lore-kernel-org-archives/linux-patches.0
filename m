Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C293B1D0964;
	Wed,  2 Oct 2024 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879590; cv=none; b=IIwJGbmDWwads2wbQLZR79B6j4BGBkWJcNzYE3oEePhIW13MW6oblMDRmx6CsrZ7o20HFS9n8Avikm6SKhO5V1ghN4K9mo1MwX+0TnSnktDZBEkcJV5B61DmceBdlMPizTZlulZ9hGKoz1V2hfsRT+pO9tR3nZ90gelHB8KDGYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879590; c=relaxed/simple;
	bh=rYdX/xVQMxMgTPbjB5m9waffjLYPD00PRUb8uYWgGW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m3QFtqP27CKzCIwYPRUgrFraDwJ6epY/HAzIllHBeUBpzPiRkgAc/Lyy9mIySdvxjvRkzhEmnuE2OzrTKtOMYUdGpHaXwlc5DbVpbF4EVRsd1Ljw1Xd4DHwSgS3EOefyFgH6B5xHpPGJF61Gqm2jc8Uh2PC1g/F27YjQ3AlbTpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNPjRrXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNPjRrXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B672C4CEC2;
	Wed,  2 Oct 2024 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879590;
	bh=rYdX/xVQMxMgTPbjB5m9waffjLYPD00PRUb8uYWgGW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNPjRrXNK/tSy3054bS7B7ngrPBE6XkiKa7ZcmlQsH6unj9vfcaNPbT5TmchvHC43
	 kUMBtF8iq+wQbx6VF0rA+EL6F4Xka6Ix+jyNgcNCYF7yRh/cTsPtdOSM5JeKWvE2cx
	 03Kv+yf6ly2nUyWSQxqz84HsDlZkY5RMPQCkuMBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/538] xen: introduce generic helper checking for memory map conflicts
Date: Wed,  2 Oct 2024 14:56:51 +0200
Message-ID: <20241002125759.045154751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit ba88829706e2c5b7238638fc2b0713edf596495e ]

When booting as a Xen PV dom0 the memory layout of the dom0 is
modified to match that of the host, as this requires less changes in
the kernel for supporting Xen.

There are some cases, though, which are problematic, as it is the Xen
hypervisor selecting the kernel's load address plus some other data,
which might conflict with the host's memory map.

These conflicts are detected at boot time and result in a boot error.
In order to support handling at least some of these conflicts in
future, introduce a generic helper function which will later gain the
ability to adapt the memory layout when possible.

Add the missing check for the xen_start_info area.

Note that possible p2m map and initrd memory conflicts are handled
already by copying the data to memory areas not conflicting with the
memory map. The initial stack allocated by Xen doesn't need to be
checked, as early boot code is switching to the statically allocated
initial kernel stack. Initial page tables and the kernel itself will
be handled later.

Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: be35d91c8880 ("xen: tolerate ACPI NVS memory overlapping with Xen allocated memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/mmu_pv.c  |  5 +----
 arch/x86/xen/setup.c   | 34 ++++++++++++++++++++++++++++------
 arch/x86/xen/xen-ops.h |  3 ++-
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 9d4a9311e819b..6b201e64d8abc 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2019,10 +2019,7 @@ void __init xen_reserve_special_pages(void)
 
 void __init xen_pt_check_e820(void)
 {
-	if (xen_is_e820_reserved(xen_pt_base, xen_pt_size)) {
-		xen_raw_console_write("Xen hypervisor allocated page table memory conflicts with E820 map\n");
-		BUG();
-	}
+	xen_chk_is_e820_usable(xen_pt_base, xen_pt_size, "page table");
 }
 
 static unsigned char dummy_mapping[PAGE_SIZE] __page_aligned_bss;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index d2073df5c5624..84cbc7ec55811 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -568,7 +568,7 @@ static void __init xen_ignore_unusable(void)
 	}
 }
 
-bool __init xen_is_e820_reserved(phys_addr_t start, phys_addr_t size)
+static bool __init xen_is_e820_reserved(phys_addr_t start, phys_addr_t size)
 {
 	struct e820_entry *entry;
 	unsigned mapcnt;
@@ -625,6 +625,23 @@ phys_addr_t __init xen_find_free_area(phys_addr_t size)
 	return 0;
 }
 
+/*
+ * Check for an area in physical memory to be usable for non-movable purposes.
+ * An area is considered to usable if the used E820 map lists it to be RAM.
+ * In case the area is not usable, crash the system with an error message.
+ */
+void __init xen_chk_is_e820_usable(phys_addr_t start, phys_addr_t size,
+				   const char *component)
+{
+	if (!xen_is_e820_reserved(start, size))
+		return;
+
+	xen_raw_console_write("Xen hypervisor allocated ");
+	xen_raw_console_write(component);
+	xen_raw_console_write(" memory conflicts with E820 map\n");
+	BUG();
+}
+
 /*
  * Like memcpy, but with physical addresses for dest and src.
  */
@@ -825,11 +842,16 @@ char * __init xen_memory_setup(void)
 	 * Failing now is better than running into weird problems later due
 	 * to relocating (and even reusing) pages with kernel text or data.
 	 */
-	if (xen_is_e820_reserved(__pa_symbol(_text),
-				 __pa_symbol(_end) - __pa_symbol(_text))) {
-		xen_raw_console_write("Xen hypervisor allocated kernel memory conflicts with E820 map\n");
-		BUG();
-	}
+	xen_chk_is_e820_usable(__pa_symbol(_text),
+			       __pa_symbol(_end) - __pa_symbol(_text),
+			       "kernel");
+
+	/*
+	 * Check for a conflict of the xen_start_info memory with the target
+	 * E820 map.
+	 */
+	xen_chk_is_e820_usable(__pa(xen_start_info), sizeof(*xen_start_info),
+			       "xen_start_info");
 
 	/*
 	 * Check for a conflict of the hypervisor supplied page tables with
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 79cf93f2c92f1..f46a1dd3624da 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -44,7 +44,8 @@ void xen_mm_unpin_all(void);
 void __init xen_relocate_p2m(void);
 #endif
 
-bool __init xen_is_e820_reserved(phys_addr_t start, phys_addr_t size);
+void __init xen_chk_is_e820_usable(phys_addr_t start, phys_addr_t size,
+				   const char *component);
 unsigned long __ref xen_chk_extra_mem(unsigned long pfn);
 void __init xen_inv_extra_mem(void);
 void __init xen_remap_memory(void);
-- 
2.43.0



