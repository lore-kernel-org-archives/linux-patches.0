Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32EF2C11F9;
	Thu, 28 May 2026 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999468; cv=none; b=nqruk9m6gSPjnO5TjFW0JT3t637FLODt5wKB78LSyb2lsFVetYi2OnMIDkEia8ngvhRn3he+4ZYF3ihD8dtIjXaON0mCljmRs+B6pLvvdjl/8I93dvkNNKaf0ulPkIYo9IxYRG1sM0+s6QGO71v56QPYx+akF2GcWXcAYnVmo9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999468; c=relaxed/simple;
	bh=VQh9KFS0+Kjc8hNV2Rd6lHrvD7sXk9vlrn1izcjdSXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L70h+t+moFJisnUtd2M+sSPL1lpQnA5AXU4yqV33FlCTcIWusslvrpo7syDs68xd0abEfOmQiH5ULKkVRey/aHo26Jdw82ImjO2PFHqDAJwmwVaYt9AT+aDCpvHO1xDKDCB3Bo56e6HSXyou904D4sg5u0C6hGLYF70qmI+I2aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTnf+NRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTnf+NRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171071F00A3A;
	Thu, 28 May 2026 20:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999466;
	bh=+bu1BSt3RStSE6CtEkdLhQhyQitz4eTbLqCi71lMbfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTnf+NRTd/4WFwXv98qLI6dblq9Qkrmz5ChbuVtRAEjFXABGxDIPNBmBqrUxfouL3
	 1vp37EE6RlDzsMP57p96OX4WcEdXO8fHvpv2jzW8DGP83BrAkW2oZK1VE26xQTwXH3
	 zpDaFxpkg3nGnL82ZScwIVStjB4ukHm5ktDTRZVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 041/377] efi: Allocate runtime workqueue before ACPI init
Date: Thu, 28 May 2026 21:44:39 +0200
Message-ID: <20260528194639.564845753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 13c6da02e767152c9ac4330962247a5e47011035 upstream.

Since commit

  5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM handlers")

ACPI PRM calls are delegated to a workqueue which runs in a kernel
thread, making it easier to detect and mitigate faulting memory accesses
performed by the firmware.

Rafael reports that such PRM accesses may occur before efisubsys_init()
executes, which is where the workqueue is allocated, leading to NULL
pointer dereferences. Since acpi_init() [which triggers the early PRM
accesses] executes as a subsys_initcall() as well, and has its own
dependencies that may be sensitive to initcall ordering, deferring
acpi_init() is not an option.

So instead, split off the workqueue allocation into its own postcore
initcall, as this is the only missing piece to allow EFI runtime calls
to be made. This ensures that EFI runtime call (including PRM calls) are
accessible to all code running at subsys_initcall() level.

Cc: <stable@vger.kernel.org>
Fixes: 5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM handlers")
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -401,21 +401,11 @@ static void __init efi_debugfs_init(void
 static inline void efi_debugfs_init(void) {}
 #endif
 
-/*
- * We register the efi subsystem with the firmware subsystem and the
- * efivars subsystem with the efi subsystem, if the system was booted with
- * EFI.
- */
-static int __init efisubsys_init(void)
+static int __init efipostcore_init(void)
 {
-	int error;
-
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		efi.runtime_supported_mask = 0;
 
-	if (!efi_enabled(EFI_BOOT))
-		return 0;
-
 	if (efi.runtime_supported_mask) {
 		/*
 		 * Since we process only one efi_runtime_service() at a time, an
@@ -427,9 +417,23 @@ static int __init efisubsys_init(void)
 			pr_err("Creating efi_rts_wq failed, EFI runtime services disabled.\n");
 			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 			efi.runtime_supported_mask = 0;
-			return 0;
 		}
 	}
+	return 0;
+}
+postcore_initcall(efipostcore_init);
+
+/*
+ * We register the efi subsystem with the firmware subsystem and the
+ * efivars subsystem with the efi subsystem, if the system was booted with
+ * EFI.
+ */
+static int __init efisubsys_init(void)
+{
+	int error;
+
+	if (!efi_enabled(EFI_BOOT))
+		return 0;
 
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_TIME_SERVICES))
 		platform_device_register_simple("rtc-efi", 0, NULL, 0);


