Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52EC1CF5FB;
	Wed,  2 Oct 2024 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879599; cv=none; b=eHDy9FBI+82ZP1lTNjLEw9tX6tQZF37c/jS5ZR4+6h6hM06oxJGprP4rEZDr6ICoQdEPPjhXaDOXkEQNhnKZ4BzjiRzfQaEHmBcyLz36RHrRM2940ZXQepdlxJA63tPg1N9bQ93MU4vib7aJndMre5y+DdTY0HM5e8X5gSdJrIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879599; c=relaxed/simple;
	bh=zqyQFIxEQrYGHA58HVN+orQKMEyLyyixe5zGHKBToIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3t1+mSb2jdbcsS8QOGMscTvcO/eiJjB0LAkPN8siT0G2OE4Lb22P4yUs0x9fds+ouYobnwqLfCIGoDUEfnHsRw9tuE+Kq4zHqZpgFVTg6+9y5fUzApjHhJtX39yo+oQTCmZZPSOYuRCQh/daQmpoINaeW4/MQn9xZIi1cblg/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9QdUgkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9QdUgkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E72C4CEC5;
	Wed,  2 Oct 2024 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879599;
	bh=zqyQFIxEQrYGHA58HVN+orQKMEyLyyixe5zGHKBToIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9QdUgkJpLOF3UZ7yuVbAxB7PhCsW238EXADTfKveOIO8h94xYX39JpeyTXqOJZOL
	 m0WT5fGDByqiuAk9ZjfSVAQwbcr2cfWNq46bdlCEwxS4G62zPBIY4k2jYiU/Qw+3Fd
	 JrJyoiWMwQok8W82wtBNVwu/wPuKtWhIi3d0fgj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/538] xen: tolerate ACPI NVS memory overlapping with Xen allocated memory
Date: Wed,  2 Oct 2024 14:56:54 +0200
Message-ID: <20241002125759.164582327@linuxfoundation.org>
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

[ Upstream commit be35d91c8880650404f3bf813573222dfb106935 ]

In order to minimize required special handling for running as Xen PV
dom0, the memory layout is modified to match that of the host. This
requires to have only RAM at the locations where Xen allocated memory
is living. Unfortunately there seem to be some machines, where ACPI
NVS is located at 64 MB, resulting in a conflict with the loaded
kernel or the initial page tables built by Xen.

Avoid this conflict by swapping the ACPI NVS area in the memory map
with unused RAM. This is possible via modification of the dom0 P2M map.
Accesses to the ACPI NVS area are done either for saving and restoring
it across suspend operations (this will work the same way as before),
or by ACPI code when NVS memory is referenced from other ACPI tables.
The latter case is handled by a Xen specific indirection of
acpi_os_ioremap().

While the E820 map can (and should) be modified right away, the P2M
map can be updated only after memory allocation is working, as the P2M
map might need to be extended.

Fixes: 808fdb71936c ("xen: check for kernel memory conflicting with memory layout")
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/setup.c | 92 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 112b071bac9d4..989c14b1ff6c8 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -496,6 +496,8 @@ void __init xen_remap_memory(void)
 	set_pte_mfn(buf, mfn_save, PAGE_KERNEL);
 
 	pr_info("Remapped %ld page(s)\n", remapped);
+
+	xen_do_remap_nonram();
 }
 
 static unsigned long __init xen_get_pages_limit(void)
@@ -626,14 +628,102 @@ phys_addr_t __init xen_find_free_area(phys_addr_t size)
 	return 0;
 }
 
+/*
+ * Swap a non-RAM E820 map entry with RAM above ini_nr_pages.
+ * Note that the E820 map is modified accordingly, but the P2M map isn't yet.
+ * The adaption of the P2M must be deferred until page allocation is possible.
+ */
+static void __init xen_e820_swap_entry_with_ram(struct e820_entry *swap_entry)
+{
+	struct e820_entry *entry;
+	unsigned int mapcnt;
+	phys_addr_t mem_end = PFN_PHYS(ini_nr_pages);
+	phys_addr_t swap_addr, swap_size, entry_end;
+
+	swap_addr = PAGE_ALIGN_DOWN(swap_entry->addr);
+	swap_size = PAGE_ALIGN(swap_entry->addr - swap_addr + swap_entry->size);
+	entry = xen_e820_table.entries;
+
+	for (mapcnt = 0; mapcnt < xen_e820_table.nr_entries; mapcnt++) {
+		entry_end = entry->addr + entry->size;
+		if (entry->type == E820_TYPE_RAM && entry->size >= swap_size &&
+		    entry_end - swap_size >= mem_end) {
+			/* Reduce RAM entry by needed space (whole pages). */
+			entry->size -= swap_size;
+
+			/* Add new entry at the end of E820 map. */
+			entry = xen_e820_table.entries +
+				xen_e820_table.nr_entries;
+			xen_e820_table.nr_entries++;
+
+			/* Fill new entry (keep size and page offset). */
+			entry->type = swap_entry->type;
+			entry->addr = entry_end - swap_size +
+				      swap_addr - swap_entry->addr;
+			entry->size = swap_entry->size;
+
+			/* Convert old entry to RAM, align to pages. */
+			swap_entry->type = E820_TYPE_RAM;
+			swap_entry->addr = swap_addr;
+			swap_entry->size = swap_size;
+
+			/* Remember PFN<->MFN relation for P2M update. */
+			xen_add_remap_nonram(swap_addr, entry_end - swap_size,
+					     swap_size);
+
+			/* Order E820 table and merge entries. */
+			e820__update_table(&xen_e820_table);
+
+			return;
+		}
+
+		entry++;
+	}
+
+	xen_raw_console_write("No suitable area found for required E820 entry remapping action\n");
+	BUG();
+}
+
+/*
+ * Look for non-RAM memory types in a specific guest physical area and move
+ * those away if possible (ACPI NVS only for now).
+ */
+static void __init xen_e820_resolve_conflicts(phys_addr_t start,
+					      phys_addr_t size)
+{
+	struct e820_entry *entry;
+	unsigned int mapcnt;
+	phys_addr_t end;
+
+	if (!size)
+		return;
+
+	end = start + size;
+	entry = xen_e820_table.entries;
+
+	for (mapcnt = 0; mapcnt < xen_e820_table.nr_entries; mapcnt++) {
+		if (entry->addr >= end)
+			return;
+
+		if (entry->addr + entry->size > start &&
+		    entry->type == E820_TYPE_NVS)
+			xen_e820_swap_entry_with_ram(entry);
+
+		entry++;
+	}
+}
+
 /*
  * Check for an area in physical memory to be usable for non-movable purposes.
- * An area is considered to usable if the used E820 map lists it to be RAM.
+ * An area is considered to usable if the used E820 map lists it to be RAM or
+ * some other type which can be moved to higher PFNs while keeping the MFNs.
  * In case the area is not usable, crash the system with an error message.
  */
 void __init xen_chk_is_e820_usable(phys_addr_t start, phys_addr_t size,
 				   const char *component)
 {
+	xen_e820_resolve_conflicts(start, size);
+
 	if (!xen_is_e820_reserved(start, size))
 		return;
 
-- 
2.43.0



