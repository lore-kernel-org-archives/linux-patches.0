Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577BB47CA71;
	Sat, 12 Sep 2026 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229863; cv=none; b=FyB5yJQ4KEdBJ/nXSz3QiEqBlXMq8fGcjyzb3i4b3TR9FqyAKm+6PF34bTD9vL+yG2NvtrX2P1xP3wN2gGR6Voo5fwISidK/rsbG25xLVPX5nmSialLSoVA9g4wPewkRT2KU/WiYgwfzizgvoD4swzm7YOCK5UHFctqH6Uy0OhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229863; c=relaxed/simple;
	bh=I08tYGV7CEtElKfU4aEP2KjwvIszrKtfXjE8scfy6/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQGgoMZB20YonUecn/Y6XXKbLcYcnxd4VNKQrvm64jpBbThka6YbREgTV1of98evydLyXZVSCwnAWK01cT4AFLSvf76kMgdto8/oXN0aJnjTa5735oXuFl/Kqdc/1O5T3y9qXkiF6EU1sLiPDbtyIcDA+4Vi/aPw1PUgKazNqFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCQSPpy0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCQSPpy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F291F00898;
	Sat, 12 Sep 2026 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229860;
	bh=55CSKbSX6I9EWYhmZfoPXqIIJONnYELhX+w+qvhim2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCQSPpy0Sj79x/edZApzPTig6VSBW0qLdX+K48GBH7O/+d6Otz/mS2p55DH6miK83
	 ZXqKSxMu0OyF+QHmcYoOesh0rAM8NY/s8Xn+8lRH73SeeTdD+4ztA/rPcA7n4E3KTl
	 ejXJAFTC+aV2sqG0A81vtkhgcmz8XqpvzwvYLkkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0675/1191] ACPI: processor: validate MADT IOAPIC entry bounds
Date: Sat, 12 Sep 2026 08:56:43 +0200
Message-ID: <20260912065603.419388103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 2c50ffdc73f3a70d745d249f509fc290754121e6 ]

The IOAPIC hotplug lookup parses both MADT and _MAT records directly.
The MADT walk previously used a subtable's declared length to advance
the cursor after only locating a generic header.  The _MAT path likewise
passed a generic header to the IOAPIC helper.

Validate that a current record has a complete generic header, that its
declared length is contained in the available record range, and that a
typed IOAPIC record contains the full fixed IOAPIC body before reading
its fields.  Use the same relation for both MADT and _MAT provider
paths.

Fixes: ecf5636dcd59 ("ACPI: Add interfaces to parse IOAPIC ID for IOAPIC hotplug")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260715083253.22831-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_core.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index eae7efae3b5cf..63c787f142ef0 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -262,11 +262,26 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
 
 #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
-static int get_ioapic_id(struct acpi_subtable_header *entry, u32 gsi_base,
+static bool madt_entry_is_valid(struct acpi_subtable_header *entry,
+				unsigned long end)
+{
+	unsigned long start = (unsigned long)entry;
+
+	if (start >= end || end - start < sizeof(*entry))
+		return false;
+
+	return entry->length >= sizeof(*entry) && entry->length <= end - start;
+}
+
+static int get_ioapic_id(struct acpi_subtable_header *entry,
+			 const unsigned long end, u32 gsi_base,
 			 u64 *phys_addr, int *ioapic_id)
 {
 	struct acpi_madt_io_apic *ioapic = (struct acpi_madt_io_apic *)entry;
 
+	if (!madt_entry_is_valid(entry, end) || BAD_MADT_ENTRY(ioapic, end))
+		return 0;
+
 	if (ioapic->global_irq_base != gsi_base)
 		return 0;
 
@@ -287,17 +302,19 @@ static int parse_madt_ioapic_entry(u32 gsi_base, u64 *phys_addr)
 		return apic_id;
 
 	entry = (unsigned long)madt;
+	if (madt->header.length < sizeof(*madt))
+		return apic_id;
 	madt_end = entry + madt->header.length;
 
 	/* Parse all entries looking for a match. */
 	entry += sizeof(struct acpi_table_madt);
-	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
+	while (madt_entry_is_valid((struct acpi_subtable_header *)entry,
+				   madt_end)) {
 		hdr = (struct acpi_subtable_header *)entry;
 		if (hdr->type == ACPI_MADT_TYPE_IO_APIC &&
-		    get_ioapic_id(hdr, gsi_base, phys_addr, &apic_id))
+		    get_ioapic_id(hdr, madt_end, gsi_base, phys_addr, &apic_id))
 			break;
-		else
-			entry += hdr->length;
+		entry += hdr->length;
 	}
 
 	return apic_id;
@@ -324,7 +341,9 @@ static int parse_mat_ioapic_entry(acpi_handle handle, u32 gsi_base,
 
 	header = (struct acpi_subtable_header *)obj->buffer.pointer;
 	if (header->type == ACPI_MADT_TYPE_IO_APIC)
-		get_ioapic_id(header, gsi_base, phys_addr, &apic_id);
+		get_ioapic_id(header,
+			      (unsigned long)header + obj->buffer.length,
+			      gsi_base, phys_addr, &apic_id);
 
 exit:
 	kfree(buffer.pointer);
-- 
2.53.0



