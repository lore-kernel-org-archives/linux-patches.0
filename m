Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FAC330D35;
	Thu, 28 May 2026 20:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000573; cv=none; b=M/tZ+fGS0DDqjipo43RkakyHDTZU2KxexqSHXyR9h1EQWQ8fteUvEbOGP/2eD/TvRH/RFHfjdt24fnLki3ejUjJGku8G1lfiVKQ5dPH8GHCAk5Khl1wjLE6aASa8VGGpxqlwVQ29xQzVlpErzgi1bnMUqhvudrvhuyRNR7FD9bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000573; c=relaxed/simple;
	bh=r3vF5nrMzvN75/G5jhP7Rh1OiLyaKTyOjMgt4TCO41s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttawo5k/TDhW0jv+SoPbsY6HHt0Idwjwv/bFAN/ViVAV77zrwFvzAx5qtTM41QI/VRO2xPLHB2ew+rgpbFtrpfTBja9B5o+THSaUI1EczpsghDie63EyVylQB0fajCXSQGr2iEHPjfNIeTovDhEadHCkHnms2j3NuQnslwnlt6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wh+2WnVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wh+2WnVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B561F00A3D;
	Thu, 28 May 2026 20:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000571;
	bh=lmClig8AN+REzadste5oyL0Lp9YeKsc95ognavV2sJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wh+2WnVJK0a2sfYyNfA0lvsHzXl7nA1dG6GyHv+R6Xqd5X5FkxeQBW5gGDEWUtzKd
	 e+XfJTCzNosbi+yXdFZvL55duyrTmEwN9ZgNbGYxP70SZkLTYurohAPtlFzEOVi8av
	 ln7L3dUj9rV99RE6vIGEZPAr2I61Qy04wyGgwmB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.12 055/272] efi: Allocate runtime workqueue before ACPI init
Date: Thu, 28 May 2026 21:47:09 +0200
Message-ID: <20260528194630.923351767@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -387,21 +387,11 @@ static void __init efi_debugfs_init(void
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
@@ -413,9 +403,23 @@ static int __init efisubsys_init(void)
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


