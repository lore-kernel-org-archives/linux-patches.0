Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB60331203;
	Sat, 12 Sep 2026 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242457; cv=none; b=H20JY4stnlqPhMAs4RHrarIVLnqiVQhXyfZ2BNUFVtw//VsvclL2QuccfDUoAn6Fau98km/KWBRy4YiSA1dX31rGihLMWx3urQuUe9dsPJ9jN2TRx5Y1JeBqarNzW9nc+tHjzu+vDBGaoO03PMXYB5UjB/O4RwzdUGOevjc+xKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242457; c=relaxed/simple;
	bh=4y/uArpuucPDYVOZLDTK9uUC9okyvqy6nGn8i2V0eGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMSXmiprVRG9mency3e7p06C1O7cgGuCpQXeEfGXxpkGju35BKRx+2/eUY7uES6X+Njqg5701LYI2e1r9xFsb/QH3hoQBBALF75dISf8oEAtUE5ws7zp+EF3Tdc45wRL+vbZ3eFoxc6y+CPpK6/FXvNO49gDUwaO6ooWmc+nxFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsV1s01l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsV1s01l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF411F000FF;
	Sat, 12 Sep 2026 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242456;
	bh=TL/QI9LVhmePMW5XMBo1HtnNzTDOreSztNyusLed700=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsV1s01l3YnOhUrI1p7euvPLP6PkXTtBhhde323TCw+LoRCEnNGWZPVcDtmj8+9b2
	 TKOZbJzRh7/Bf5NoKZq6bp9lPTET0FK3+tkx8Cr0B1G05gxQ2GrbRxo75kjK+Rr8mw
	 4aX3Cc48C9AR++IJyc5Iaeu5ZL7YFVxb7/H8K+is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>,
	Yongwei Xu <xuyongwei@open-hieco.net>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/798] iommu/amd: Fix false positive in SB IOAPIC IVRS validation
Date: Sat, 12 Sep 2026 09:00:37 +0200
Message-ID: <20260912065526.523327555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <wei.w.wang@hotmail.com>

[ Upstream commit 04fee302fac762a242ff1ad6810cff90c2a350ba ]

The check_ioapic_information() function is designed to prevent boot hangs
by ensuring the Southbridge (SB) IOAPIC is properly mapped in the IVRS
table before enabling Interrupt Remapping.

Currently, this check passes if *any* enumerated IOAPIC matches the
expected SB IOAPIC device ID. If a buggy BIOS incorrectly assigns the
SB IOAPIC's device ID to a secondary IOAPIC in the IVRS, while scrambling
the true SB IOAPIC's mapping, the check hits a false positive and
succeeds.

This erroneously enables Interrupt Remapping. Consequently, the IOMMU
blocks unmapped interrupts from the actual SB IOAPIC, dropping the system
timer and leading to a silent kernel boot hang.

Tighten the validation to verify the device ID specifically against the SB
IOAPIC by matching their APIC IDs first. This prevents the validation
check from being bypassed via device ID aliasing.

Fixes: c2ff5cf5294b ("iommu/amd: Work around wrong IOAPIC device-id in IVRS table")
Signed-off-by: Wei Wang <wei.w.wang@hotmail.com>
Tested-by: Yongwei Xu <xuyongwei@open-hieco.net>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 098bec555ea52..cccbe59c2604e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2572,11 +2572,25 @@ static void __init free_iommu_resources(void)
 /* SB IOAPIC for Hygon family 18h model 4h is on the device 0xb */
 #define IOAPIC_SB_DEVID_FAM18H_M4H	((0x00 << 8) | PCI_DEVFN(0xb, 0))
 
+/*
+ * The Southbridge IOAPIC is assigned a GSI Base of 0 (handling interrupts
+ * 0 through 23).
+ */
+static int __init get_sb_ioapic_id(void)
+{
+	int idx = mp_find_ioapic(0);
+
+	if (idx < 0)
+		return -ENODEV;
+
+	return mpc_ioapic_id(idx);
+}
+
 static bool __init check_ioapic_information(void)
 {
 	const char *fw_bug = FW_BUG;
 	bool ret, has_sb_ioapic;
-	int idx;
+	int idx, sb_apicid;
 
 	has_sb_ioapic = false;
 	ret           = true;
@@ -2589,6 +2603,16 @@ static bool __init check_ioapic_information(void)
 	if (cmdline_maps)
 		fw_bug = "";
 
+	sb_apicid = get_sb_ioapic_id();
+	if (sb_apicid < 0) {
+		/*
+		 * Lack of SB IOAPIC registration is not a firmware bug,
+		 * e.g. kernel booted with noapic or noacpi.
+		 */
+		fw_bug = "";
+		goto out;
+	}
+
 	for (idx = 0; idx < nr_ioapics; idx++) {
 		int devid, id = mpc_ioapic_id(idx);
 
@@ -2597,16 +2621,16 @@ static bool __init check_ioapic_information(void)
 			pr_err("%s: IOAPIC[%d] not in IVRS table\n",
 				fw_bug, id);
 			ret = false;
-		} else if (devid == IOAPIC_SB_DEVID ||
+		} else if (id == sb_apicid && (devid == IOAPIC_SB_DEVID ||
 			   (boot_cpu_data.x86_vendor == X86_VENDOR_HYGON &&
 			    boot_cpu_data.x86 == 0x18 &&
 			    boot_cpu_data.x86_model >= 0x4 &&
 			    boot_cpu_data.x86_model <= 0xf &&
-			    devid == IOAPIC_SB_DEVID_FAM18H_M4H)) {
+			    devid == IOAPIC_SB_DEVID_FAM18H_M4H))) {
 			has_sb_ioapic = true;
 		}
 	}
-
+out:
 	if (!has_sb_ioapic) {
 		/*
 		 * We expect the SB IOAPIC to be listed in the IVRS
-- 
2.53.0



