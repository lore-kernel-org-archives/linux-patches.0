Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA451E766D;
	Tue, 15 Oct 2024 11:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992555; cv=none; b=ckbIzoR1OIw2xoVJxI3999zF+ONyhIcKUZ9NLlCTFl6b2ZcRwmSZ5O13MmTjP5IpX38+M3uiSNtN7q7hrBHtCp7EfnZaEKjxmfT97/94b8OArLCVBmpY2UI8TuqixWHKkG7uaCEPIFMJvNLhE7NGw1mNAAFzqkmBJZgE6Og/I9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992555; c=relaxed/simple;
	bh=ESt85j6CeavX5VPG/cTfnDntwPTE1typyHxTUsXPgXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DL7HIucRoKTPSbyZeQPHAqD9i1At/DzvVE8OfvsAjaCZ2dp/xNV9PazjTHrCzfnYZ0dn0GDPt4euYWAISqpGz6QZnvZ0Ls2C8qE0UUqClYAVHX/EqxjPbmY2K8cjGa7v8DoW4xR008ivErOR0acgT376uWVYPoMfEuNz5i4r0X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfmN6UE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfmN6UE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BAAC4CEC6;
	Tue, 15 Oct 2024 11:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992555;
	bh=ESt85j6CeavX5VPG/cTfnDntwPTE1typyHxTUsXPgXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfmN6UE0k73w+cTrjDfOe5+L78I3PoBtOqlINpxxoThaSdNH7Vq2aKHw8646GHXh5
	 OP7yrO3ykUs3zQ3Oc7CSIpUk07jZBMLRCQ9mLI4YkFE3SSMOOMHuF8FRe0JmrWWVxL
	 BquX9n2GpWtsUpNadrThO8GrPTl+lc9UVY0/9j0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/691] ACPI: bus: Avoid using CPPC if not supported by firmware
Date: Tue, 15 Oct 2024 13:20:57 +0200
Message-ID: <20241015112444.687764415@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c42fa24b44751c62c86e98430ef915c0609a2ab8 ]

If the platform firmware indicates that it does not support CPPC by
clearing the OSC_SB_CPC_SUPPORT and OSC_SB_CPCV2_SUPPORT bits in the
platform _OSC capabilities mask, avoid attempting to evaluate _CPC
which may fail in that case.

Because the OSC_SB_CPC_SUPPORT and OSC_SB_CPCV2_SUPPORT bits are only
added to the supported platform capabilities mask on x86, when
X86_FEATURE_HWP is supported, allow _CPC to be evaluated regardless
in the other cases.

Link: https://lore.kernel.org/linux-acpi/CAJZ5v0i=ecAksq0TV+iLVObm-=fUfdqPABzzkgm9K6KxO1ZCcg@mail.gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 60949b7b8054 ("ACPI: CPPC: Fix MASK_VAL() usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c       | 8 ++++++++
 drivers/acpi/cppc_acpi.c | 3 +++
 include/linux/acpi.h     | 1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 7774b603a7962..9bc5bc5bc359b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -283,6 +283,8 @@ EXPORT_SYMBOL_GPL(osc_pc_lpi_support_confirmed);
 bool osc_sb_native_usb4_support_confirmed;
 EXPORT_SYMBOL_GPL(osc_sb_native_usb4_support_confirmed);
 
+bool osc_sb_cppc_not_supported;
+
 static u8 sb_uuid_str[] = "0811B06E-4A27-44F9-8D60-3CBBC22E7B48";
 static void acpi_bus_osc_negotiate_platform_control(void)
 {
@@ -338,6 +340,12 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 		return;
 	}
 
+#ifdef CONFIG_X86
+	if (boot_cpu_has(X86_FEATURE_HWP))
+		osc_sb_cppc_not_supported = !(capbuf_ret[OSC_SUPPORT_DWORD] &
+				(OSC_SB_CPC_SUPPORT | OSC_SB_CPCV2_SUPPORT));
+#endif
+
 	/*
 	 * Now run _OSC again with query flag clear and with the caps
 	 * supported by both the OS and the platform.
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 6dcce036adb9c..02cec9eba937f 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -673,6 +673,9 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	acpi_status status;
 	int ret = -EFAULT;
 
+	if (osc_sb_cppc_not_supported)
+		return -ENODEV;
+
 	/* Parse the ACPI _CPC table for this CPU. */
 	status = acpi_evaluate_object_typed(handle, "_CPC", NULL, &output,
 			ACPI_TYPE_PACKAGE);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index a23a5aea9c817..42f58a54dff09 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -561,6 +561,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 extern bool osc_sb_apei_support_acked;
 extern bool osc_pc_lpi_support_confirmed;
 extern bool osc_sb_native_usb4_support_confirmed;
+extern bool osc_sb_cppc_not_supported;
 
 /* USB4 Capabilities */
 #define OSC_USB_USB3_TUNNELING			0x00000001
-- 
2.43.0



