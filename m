Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F4D310620;
	Thu, 28 May 2026 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001280; cv=none; b=pGzIagiFBXc9EkRasgGrqPSAor38iZlaGawqYVqnccsIjcpO5MOclpMRPWkKM9tyBTk+nYoksL4sXhRJN3rUjvHcM7sZoC+w1FYlGJueWcN/kyaJdlwdr2jiDwVA/UrZuSlwBTs60wLEF8bMvhJN9vRl8SNtE1hyAwcLqQA8YKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001280; c=relaxed/simple;
	bh=vsfNHanUhZ9MSaug28mR1OkmA5Ouf1xdubk+s/Pz1S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTpWg2R2R2Hq0Y5zBVHHuRclvAHQvj9QcUgCv9oPZlBS+g/RbiwTNkfiyuRfMt10mqdUFb29fK9y39+thDe8D220edukqMyVpGqIqBhuSc+eCytcB+ZSaGci22LlC/oKfRCxJJio1LiQNbhaAcIRnxFqLFmk1aO3z0CL3ZwFVdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u79ICRqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u79ICRqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38D31F000E9;
	Thu, 28 May 2026 20:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001279;
	bh=IGlKY1u8FqLhjWW4Mjqc3atULyoR1s6nUQR6cJrUAwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u79ICRqtHHOeol32bIhvz9sPPQ/e0lNxro95x+CYLjQXmb4F1IgoW9EqFYVjydtX2
	 H8Np8U8c9N/N4Pf4bireLDOltAP4jYMmVihs62z7iQS29Gw9UTTYKCxjs0vRTAIzGe
	 2a86z2gZawTgJuD+DvMjNvS3qdDpr+PSjSncaPGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 032/186] efi: Allocate runtime workqueue before ACPI init
Date: Thu, 28 May 2026 21:48:32 +0200
Message-ID: <20260528194929.830248445@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,21 +371,11 @@ static void __init efi_debugfs_init(void
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
@@ -397,9 +387,23 @@ static int __init efisubsys_init(void)
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


