Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7513A266196;
	Thu, 13 Feb 2025 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458110; cv=none; b=N0MXB0a3vkXCm1WQhvmw/twzgHimlUNHwfSmHplYIrjE2nWhaVz8kkICR34vv9/8+XfhQSjgu7ju/s0MIcsnvOuizGv3vG3SzjmIu3g83/07pnHap7chD8sJPaS79EDm4c92j/T1hvQL6OpMikcc+60o9BOCADDszkxvLDyJwnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458110; c=relaxed/simple;
	bh=5XUJCw6mjZ/j8uQ/pBvpgsGF01ATZb5cmzWM21/3XgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2qZIHbO2ont/vvAonp6L8lZbXkhV5P7Q3nbllqwCwE2roOVl7/RmR85qW5sWms6Y+jrFc5jWgWV/YD0/52mzzACkG/+qlr9uF70EDcSX+wq6CM4b507M2KRqxjmpMbow/AoqNTuByAtMC7aP16A78NJKRjvxi3Ko2mDr72jfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAx+g6EX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAx+g6EX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8167C4CED1;
	Thu, 13 Feb 2025 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458110;
	bh=5XUJCw6mjZ/j8uQ/pBvpgsGF01ATZb5cmzWM21/3XgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAx+g6EXS6Tqht8UdC2bOJDVy4/nNu9nyxyI1wTDuqgkWAC12Xux5hMA6GDfWR7Yk
	 BFZWCe8QRzJBE+KIkSTlBYGvHPAbMB3yMKsi3ng5kZVibw5pyaPI4fiy0tC2qjDkAr
	 JCX+OXhQrr1yGwCKdgw/5Odxbvn/OwwnGaAqPpSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 263/422] x86/acpi: Fix LAPIC/x2APIC parsing order
Date: Thu, 13 Feb 2025 15:26:52 +0100
Message-ID: <20250213142446.691701026@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 0141978ae75bd48bac13fca6de131a5071c32011 upstream.

On some systems, the same CPU (with the same APIC ID) is assigned a
different logical CPU id after commit ec9aedb2aa1a ("x86/acpi: Ignore
invalid x2APIC entries").

This means that Linux enumerates the CPUs in a different order, which
violates ACPI specification[1] that states:

  "OSPM should initialize processors in the order that they appear in
   the MADT"

The problematic commit parses all LAPIC entries before any x2APIC
entries, aiming to ignore x2APIC entries with APIC ID < 255 when valid
LAPIC entries exist. However, it disrupts the CPU enumeration order on
systems where x2APIC entries precede LAPIC entries in the MADT.

Fix this problem by:

 1) Parsing LAPIC entries first without registering them in the
    topology to evaluate whether valid LAPIC entries exist.

 2) Restoring the MADT in order parser which invokes either the LAPIC
    or the X2APIC parser function depending on the entry type.

The X2APIC parser still ignores entries < 0xff in case that #1 found
valid LAPIC entries independent of their position in the MADT table.

Link: https://uefi.org/specs/ACPI/6.5/05_ACPI_Software_Programming_Model.html#madt-processor-local-apic-sapic-structure-entry-order
Cc: All applicable <stable@vger.kernel.org>
Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/all/20241010213136.668672-1-jmattson@google.com/
Fixes: ec9aedb2aa1a ("x86/acpi: Ignore invalid x2APIC entries")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Tested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20250117081420.4046737-1-rui.zhang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/boot.c |   50 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -227,6 +227,28 @@ acpi_parse_x2apic(union acpi_subtable_he
 }
 
 static int __init
+acpi_check_lapic(union acpi_subtable_headers *header, const unsigned long end)
+{
+	struct acpi_madt_local_apic *processor = NULL;
+
+	processor = (struct acpi_madt_local_apic *)header;
+
+	if (BAD_MADT_ENTRY(processor, end))
+		return -EINVAL;
+
+	/* Ignore invalid ID */
+	if (processor->id == 0xff)
+		return 0;
+
+	/* Ignore processors that can not be onlined */
+	if (!acpi_is_processor_usable(processor->lapic_flags))
+		return 0;
+
+	has_lapic_cpus = true;
+	return 0;
+}
+
+static int __init
 acpi_parse_lapic(union acpi_subtable_headers * header, const unsigned long end)
 {
 	struct acpi_madt_local_apic *processor = NULL;
@@ -257,7 +279,6 @@ acpi_parse_lapic(union acpi_subtable_hea
 			       processor->processor_id, /* ACPI ID */
 			       processor->lapic_flags & ACPI_MADT_ENABLED);
 
-	has_lapic_cpus = true;
 	return 0;
 }
 
@@ -1029,6 +1050,8 @@ static int __init early_acpi_parse_madt_
 static int __init acpi_parse_madt_lapic_entries(void)
 {
 	int count, x2count = 0;
+	struct acpi_subtable_proc madt_proc[2];
+	int ret;
 
 	if (!boot_cpu_has(X86_FEATURE_APIC))
 		return -ENODEV;
@@ -1037,10 +1060,27 @@ static int __init acpi_parse_madt_lapic_
 				      acpi_parse_sapic, MAX_LOCAL_APIC);
 
 	if (!count) {
-		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
-					acpi_parse_lapic, MAX_LOCAL_APIC);
-		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
-					acpi_parse_x2apic, MAX_LOCAL_APIC);
+		/* Check if there are valid LAPIC entries */
+		acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC, acpi_check_lapic, MAX_LOCAL_APIC);
+
+		/*
+		 * Enumerate the APIC IDs in the order that they appear in the
+		 * MADT, no matter LAPIC entry or x2APIC entry is used.
+		 */
+		memset(madt_proc, 0, sizeof(madt_proc));
+		madt_proc[0].id = ACPI_MADT_TYPE_LOCAL_APIC;
+		madt_proc[0].handler = acpi_parse_lapic;
+		madt_proc[1].id = ACPI_MADT_TYPE_LOCAL_X2APIC;
+		madt_proc[1].handler = acpi_parse_x2apic;
+		ret = acpi_table_parse_entries_array(ACPI_SIG_MADT,
+				sizeof(struct acpi_table_madt),
+				madt_proc, ARRAY_SIZE(madt_proc), MAX_LOCAL_APIC);
+		if (ret < 0) {
+			pr_err("Error parsing LAPIC/X2APIC entries\n");
+			return ret;
+		}
+		count = madt_proc[0].count;
+		x2count = madt_proc[1].count;
 	}
 	if (!count && !x2count) {
 		pr_err("No LAPIC entries present\n");


