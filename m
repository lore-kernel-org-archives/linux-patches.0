Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100183254A8;
	Thu, 28 May 2026 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998031; cv=none; b=POZ7pGR+ZGBMBZQf3WWSHVFKOh5rt7iXhG0N2Ug8tE6Y8AU5jJA2F792L59urYzbqqeONPMgTIzQuzOno12gpoCSpkw8OJUIITykEVnl6+0+STn0Gh/Zsb4Xi4SeITKrxD1iP9FqJ+apcKYNcGKkUxkF9xMi0CS9O0qYeCFcZTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998031; c=relaxed/simple;
	bh=0fep2+l7P2mA/Vu9LcI8a2YV1IL1RHbV5NHLcuMxHAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBSMuFBKsWZyrI1Vcge/s3FmxcvpCgp3eebO3IaX2Jtnd/iNmS2h2TpmyJ7Y2i2OPZNBkv7lzkQ4XI9v8oXO3HhdjTmgzNlh5gUC/ouq8VL8bdsfWLduTCFvt4Hued/goLH1iM+YwRu7fpi5H6U1iZB7fdXu7013nbjZNhuQPJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uc7gWUP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uc7gWUP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4761F000E9;
	Thu, 28 May 2026 19:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998029;
	bh=O122pj1O22hgBrJ6QMA5fm0Ngnu1hdn+qJU1EAlNvMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uc7gWUP4qDrp9kc7GJju4GjBEdFsSezhzGjSRo8LVJaAKC7au+XWUAOkRUlQujhXe
	 dLOW3iM9zTIxJ45ennRBtb8cKA4Ktv5zDir1fXp+ereU/uSvksTS5/Z/oN22GkO/KM
	 h6I4wbAC5y4srtIWc46Gi9bAjqqBB7yi2ZFuiT8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 7.0 028/461] efi: Allocate runtime workqueue before ACPI init
Date: Thu, 28 May 2026 21:42:37 +0200
Message-ID: <20260528194647.713171354@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -402,21 +402,11 @@ static void __init efi_debugfs_init(void
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
@@ -428,9 +418,23 @@ static int __init efisubsys_init(void)
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


