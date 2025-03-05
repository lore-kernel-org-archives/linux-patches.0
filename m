Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBEE253326;
	Wed,  5 Mar 2025 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198793; cv=none; b=WmCJT4Cqg5BpQCry4xOG/gtq7aC3/OEbwknFbwuqNCQU9k0rIIXTOR7FotAWPLA147c0k1pYKLaIlNkOrVcLS6GULJu0vS2/TwwRsXhrSmorVYouu94l1SF1qitE9DUj8xip3AF/6tpme+EAq21o5trTsU/naL1EG9Y74hGtBWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198793; c=relaxed/simple;
	bh=DevxrhMDMAycgyZpQ+Jybjt/s6IMcZlCZlTQ8Z49/Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbJoYp4oQWfzF/WHfHiZi7VEA0WgAG2Rz2F1/4LrsfTYlaVCPTboUbdVHoOQm/8M81hIvbBi1iCXy5XOxk9SeNUcfbPaA/H5eA9+9KgxO4daNvVU7o6WEcYppCPzViBBSbxv8EyRM66bcJVMZXYQPzWNcmGmY+QRAZCh/MHjKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnWkFgir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnWkFgir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99708C4CED1;
	Wed,  5 Mar 2025 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198793;
	bh=DevxrhMDMAycgyZpQ+Jybjt/s6IMcZlCZlTQ8Z49/Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnWkFgirxaYewORyYDxFHKlt8Ce5T9HkEjwDYO6dYnzH5UgJUVVPNIPcHQlQxk8cQ
	 g0lR/cqpEWe3WLkQITYhXZNG/ouzBu6uLujQnXMJSN2XZkL+kJGTB0YFRXWgkiDEKg
	 P7l/VTnROHoBpZGzncrvrGEUCYfGrh9IRGTqfB50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Jones <pjones@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.13 149/157] efi: Dont map the entire mokvar table to determine its size
Date: Wed,  5 Mar 2025 18:49:45 +0100
Message-ID: <20250305174511.282447344@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Jones <pjones@redhat.com>

commit 2b90e7ace79774a3540ce569e000388f8d22c9e0 upstream.

Currently, when validating the mokvar table, we (re)map the entire table
on each iteration of the loop, adding space as we discover new entries.
If the table grows over a certain size, this fails due to limitations of
early_memmap(), and we get a failure and traceback:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:139 __early_ioremap+0xef/0x220
  ...
  Call Trace:
   <TASK>
   ? __early_ioremap+0xef/0x220
   ? __warn.cold+0x93/0xfa
   ? __early_ioremap+0xef/0x220
   ? report_bug+0xff/0x140
   ? early_fixup_exception+0x5d/0xb0
   ? early_idt_handler_common+0x2f/0x3a
   ? __early_ioremap+0xef/0x220
   ? efi_mokvar_table_init+0xce/0x1d0
   ? setup_arch+0x864/0xc10
   ? start_kernel+0x6b/0xa10
   ? x86_64_start_reservations+0x24/0x30
   ? x86_64_start_kernel+0xed/0xf0
   ? common_startup_64+0x13e/0x141
   </TASK>
  ---[ end trace 0000000000000000 ]---
  mokvar: Failed to map EFI MOKvar config table pa=0x7c4c3000, size=265187.

Mapping the entire structure isn't actually necessary, as we don't ever
need more than one entry header mapped at once.

Changes efi_mokvar_table_init() to only map each entry header, not the
entire table, when determining the table size.  Since we're not mapping
any data past the variable name, it also changes the code to enforce
that each variable name is NUL terminated, rather than attempting to
verify it in place.

Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/mokvar-table.c |   42 +++++++++++-------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

--- a/drivers/firmware/efi/mokvar-table.c
+++ b/drivers/firmware/efi/mokvar-table.c
@@ -103,9 +103,7 @@ void __init efi_mokvar_table_init(void)
 	void *va = NULL;
 	unsigned long cur_offset = 0;
 	unsigned long offset_limit;
-	unsigned long map_size = 0;
 	unsigned long map_size_needed = 0;
-	unsigned long size;
 	struct efi_mokvar_table_entry *mokvar_entry;
 	int err;
 
@@ -134,48 +132,34 @@ void __init efi_mokvar_table_init(void)
 	 */
 	err = -EINVAL;
 	while (cur_offset + sizeof(*mokvar_entry) <= offset_limit) {
-		mokvar_entry = va + cur_offset;
-		map_size_needed = cur_offset + sizeof(*mokvar_entry);
-		if (map_size_needed > map_size) {
-			if (va)
-				early_memunmap(va, map_size);
-			/*
-			 * Map a little more than the fixed size entry
-			 * header, anticipating some data. It's safe to
-			 * do so as long as we stay within current memory
-			 * descriptor.
-			 */
-			map_size = min(map_size_needed + 2*EFI_PAGE_SIZE,
-				       offset_limit);
-			va = early_memremap(efi.mokvar_table, map_size);
-			if (!va) {
-				pr_err("Failed to map EFI MOKvar config table pa=0x%lx, size=%lu.\n",
-				       efi.mokvar_table, map_size);
-				return;
-			}
-			mokvar_entry = va + cur_offset;
+		if (va)
+			early_memunmap(va, sizeof(*mokvar_entry));
+		va = early_memremap(efi.mokvar_table + cur_offset, sizeof(*mokvar_entry));
+		if (!va) {
+			pr_err("Failed to map EFI MOKvar config table pa=0x%lx, size=%zu.\n",
+			       efi.mokvar_table + cur_offset, sizeof(*mokvar_entry));
+			return;
 		}
+		mokvar_entry = va;
 
 		/* Check for last sentinel entry */
 		if (mokvar_entry->name[0] == '\0') {
 			if (mokvar_entry->data_size != 0)
 				break;
 			err = 0;
+			map_size_needed = cur_offset + sizeof(*mokvar_entry);
 			break;
 		}
 
-		/* Sanity check that the name is null terminated */
-		size = strnlen(mokvar_entry->name,
-			       sizeof(mokvar_entry->name));
-		if (size >= sizeof(mokvar_entry->name))
-			break;
+		/* Enforce that the name is NUL terminated */
+		mokvar_entry->name[sizeof(mokvar_entry->name) - 1] = '\0';
 
 		/* Advance to the next entry */
-		cur_offset = map_size_needed + mokvar_entry->data_size;
+		cur_offset += sizeof(*mokvar_entry) + mokvar_entry->data_size;
 	}
 
 	if (va)
-		early_memunmap(va, map_size);
+		early_memunmap(va, sizeof(*mokvar_entry));
 	if (err) {
 		pr_err("EFI MOKvar config table is not valid\n");
 		return;


