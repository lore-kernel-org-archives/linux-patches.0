Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC3513D51C;
	Tue, 14 May 2024 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685934; cv=none; b=d6QtJ8hJjPVaIIo8fTD1lf7BPbdib22q/8hdCp7PDZ5SH0eoBJy/msssjypkDA/CB6Ta5PAB9VPfgr9FbvxP/nBJp7CPzykmUxX5c7SIDr9fT57OVJoXI2LX3XkrDf6p/xEfpUUwCnFoYqMP5wU648RkfpidVa5sjDn8nPv7O3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685934; c=relaxed/simple;
	bh=IMtdshwa/wBKusNLHDHSfBYL2BbGBvdqIahMWX1Wt0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8okpeGUtOwemH4rQUI42xI4J9ydi8rPlfSon4EqYyvqk+qgaihMdfymLklCCmhRgSxjnrqoi2OBEvBDK7zLsZXM2kUT74/fjOwH+gBKhrapTxoa/3fnpLNQUDjdm//luTBUHNq4PvQLPJvwjIl6HETxlqWEbY6OdTM3VZ+qVsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNbSG8Zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNbSG8Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E2FC2BD10;
	Tue, 14 May 2024 11:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685933;
	bh=IMtdshwa/wBKusNLHDHSfBYL2BbGBvdqIahMWX1Wt0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNbSG8ZsYD4w+2sS/Q2mh5ATnakKE1X8YXC3ZEecedC20j7hs/gS5QpcrbYvMuTgc
	 YQCjjIQTSlmE1Q3J/9DXM31TRqD6ACmjDcWYuHFoO7h+8tccSecu0XoVlbb02Q207t
	 2CTaqs9U/VlRulBsmN/DcVwAVbvD+OmTvrQyTa7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Huang <ahuang12@lenovo.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 280/301] x86/apic: Dont access the APIC when disabling x2APIC
Date: Tue, 14 May 2024 12:19:11 +0200
Message-ID: <20240514101042.836557063@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 720a22fd6c1cdadf691281909950c0cbc5cdf17e upstream.

With 'iommu=off' on the kernel command line and x2APIC enabled by the BIOS
the code which disables the x2APIC triggers an unchecked MSR access error:

  RDMSR from 0x802 at rIP: 0xffffffff94079992 (native_apic_msr_read+0x12/0x50)

This is happens because default_acpi_madt_oem_check() selects an x2APIC
driver before the x2APIC is disabled.

When the x2APIC is disabled because interrupt remapping cannot be enabled
due to 'iommu=off' on the command line, x2apic_disable() invokes
apic_set_fixmap() which in turn tries to read the APIC ID. This triggers
the MSR warning because x2APIC is disabled, but the APIC driver is still
x2APIC based.

Prevent that by adding an argument to apic_set_fixmap() which makes the
APIC ID read out conditional and set it to false from the x2APIC disable
path. That's correct as the APIC ID has already been read out during early
discovery.

Fixes: d10a904435fa ("x86/apic: Consolidate boot_cpu_physical_apicid initialization sites")
Reported-by: Adrian Huang <ahuang12@lenovo.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Adrian Huang <ahuang12@lenovo.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/875xw5t6r7.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/apic.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1808,7 +1808,7 @@ void x2apic_setup(void)
 	__x2apic_enable();
 }
 
-static __init void apic_set_fixmap(void);
+static __init void apic_set_fixmap(bool read_apic);
 
 static __init void x2apic_disable(void)
 {
@@ -1830,7 +1830,12 @@ static __init void x2apic_disable(void)
 	}
 
 	__x2apic_disable();
-	apic_set_fixmap();
+	/*
+	 * Don't reread the APIC ID as it was already done from
+	 * check_x2apic() and the APIC driver still is a x2APIC variant,
+	 * which fails to do the read after x2APIC was disabled.
+	 */
+	apic_set_fixmap(false);
 }
 
 static __init void x2apic_enable(void)
@@ -2095,13 +2100,14 @@ void __init init_apic_mappings(void)
 	}
 }
 
-static __init void apic_set_fixmap(void)
+static __init void apic_set_fixmap(bool read_apic)
 {
 	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
 	apic_mmio_base = APIC_BASE;
 	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
 		    apic_mmio_base, mp_lapic_addr);
-	apic_read_boot_cpu_id(false);
+	if (read_apic)
+		apic_read_boot_cpu_id(false);
 }
 
 void __init register_lapic_address(unsigned long address)
@@ -2111,7 +2117,7 @@ void __init register_lapic_address(unsig
 	mp_lapic_addr = address;
 
 	if (!x2apic_mode)
-		apic_set_fixmap();
+		apic_set_fixmap(true);
 }
 
 /*


