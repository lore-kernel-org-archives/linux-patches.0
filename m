Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4A01741D8;
	Wed,  3 Jul 2024 11:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004910; cv=none; b=UD2SP9TVSMDQc35uvRBzv9gcNTRGaOb3r/W5BkXKkpGz9VihJhGzQYzfc34bUaQqKbUvcWUdj9Hpi969a1yrKi5l9n0TMsrD0rSCbl2UtIynuJCZGdHdyR8/bSnfvuI5/Pov/4yNsXH0PjbNqOPkBfrYDM2uGPB4n3wIuwWuSfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004910; c=relaxed/simple;
	bh=wvQmGPYeTvamABULpIMyV12LdH6FgQUzPRp7Ytqc+ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZ9RRkBpiii2a4apLM7tvpstAjEOd989gTTs8LP0eknA3btAiKesOriOT71bMJVynGOxphLj2WmwcoelfcbsqE49YD4OB6m1Kd6PxbrTdeuj+7rF2cjg5SeU0whWaMgrI4MIGpx1VWW41HgyB2noRa6LuSrjwBi2u0urCdc687s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSSvoyPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSSvoyPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C5FC4AF0B;
	Wed,  3 Jul 2024 11:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004910;
	bh=wvQmGPYeTvamABULpIMyV12LdH6FgQUzPRp7Ytqc+ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSSvoyPEHGM8+E6lPxrpTCFxZDxqy+h39IUwniqbzOO4ELGGwYGbS4r3mbF5rV1Mp
	 TFjU2IDWOu17Qh6wJohoW3NlCD8LvI+ur6iZ9N+wxWAR2zR6ETTjJAYabg/A6Z8VdG
	 5/gG8+H/fHwG2i3z9x5GMILXvUqU5BZ010t/yKcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>,
	Alexander Deucher <Alexander.Deucher@amd.com>,
	Prike Liang <prike.liang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Julian Sikorski <belegdol@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/290] ACPI: Add quirks for AMD Renoir/Lucienne CPUs to force the D3 hint
Date: Wed,  3 Jul 2024 12:39:39 +0200
Message-ID: <20240703102911.643064967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 6485fc18faa01e8845b1e5bb55118e633f84d1f2 ]

AMD systems from Renoir and Lucienne require that the NVME controller
is put into D3 over a Modern Standby / suspend-to-idle
cycle.  This is "typically" accomplished using the `StorageD3Enable`
property in the _DSD, but this property was introduced after many
of these systems launched and most OEM systems don't have it in
their BIOS.

On AMD Renoir without these drives going into D3 over suspend-to-idle
the resume will fail with the NVME controller being reset and a trace
like this in the kernel logs:
```
[   83.556118] nvme nvme0: I/O 161 QID 2 timeout, aborting
[   83.556178] nvme nvme0: I/O 162 QID 2 timeout, aborting
[   83.556187] nvme nvme0: I/O 163 QID 2 timeout, aborting
[   83.556196] nvme nvme0: I/O 164 QID 2 timeout, aborting
[   95.332114] nvme nvme0: I/O 25 QID 0 timeout, reset controller
[   95.332843] nvme nvme0: Abort status: 0x371
[   95.332852] nvme nvme0: Abort status: 0x371
[   95.332856] nvme nvme0: Abort status: 0x371
[   95.332859] nvme nvme0: Abort status: 0x371
[   95.332909] PM: dpm_run_callback(): pci_pm_resume+0x0/0xe0 returns -16
[   95.332936] nvme 0000:03:00.0: PM: failed to resume async: error -16
```

The Microsoft documentation for StorageD3Enable mentioned that Windows has
a hardcoded allowlist for D3 support, which was used for these platforms.
Introduce quirks to hardcode them for Linux as well.

As this property is now "standardized", OEM systems using AMD Cezanne and
newer APU's have adopted this property, and quirks like this should not be
necessary.

CC: Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>
CC: Alexander Deucher <Alexander.Deucher@amd.com>
CC: Prike Liang <prike.liang@amd.com>
Link: https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/power-management-for-storage-hardware-devices-intro
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Julian Sikorski <belegdol@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: e79a10652bbd ("ACPI: x86: Force StorageD3Enable on more products")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c |  3 +++
 drivers/acpi/internal.h  |  9 +++++++++
 drivers/acpi/x86/utils.c | 25 +++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 66e53df758655..4c38846fea966 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1346,6 +1346,9 @@ bool acpi_storage_d3(struct device *dev)
 	struct acpi_device *adev = ACPI_COMPANION(dev);
 	u8 val;
 
+	if (force_storage_d3())
+		return true;
+
 	if (!adev)
 		return false;
 	if (fwnode_property_read_u8(acpi_fwnode_handle(adev), "StorageD3Enable",
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 125e4901c9b47..f6c929787c9e6 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -237,6 +237,15 @@ static inline int suspend_nvs_save(void) { return 0; }
 static inline void suspend_nvs_restore(void) {}
 #endif
 
+#ifdef CONFIG_X86
+bool force_storage_d3(void);
+#else
+static inline bool force_storage_d3(void)
+{
+	return false;
+}
+#endif
+
 /*--------------------------------------------------------------------------
 				Device properties
   -------------------------------------------------------------------------- */
diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 3f9a162be84e3..b3fb428461c6f 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -177,3 +177,28 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
 
 	return ret;
 }
+
+/*
+ * AMD systems from Renoir and Lucienne *require* that the NVME controller
+ * is put into D3 over a Modern Standby / suspend-to-idle cycle.
+ *
+ * This is "typically" accomplished using the `StorageD3Enable`
+ * property in the _DSD that is checked via the `acpi_storage_d3` function
+ * but this property was introduced after many of these systems launched
+ * and most OEM systems don't have it in their BIOS.
+ *
+ * The Microsoft documentation for StorageD3Enable mentioned that Windows has
+ * a hardcoded allowlist for D3 support, which was used for these platforms.
+ *
+ * This allows quirking on Linux in a similar fashion.
+ */
+static const struct x86_cpu_id storage_d3_cpu_ids[] = {
+	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 96, NULL),	/* Renoir */
+	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 104, NULL),	/* Lucienne */
+	{}
+};
+
+bool force_storage_d3(void)
+{
+	return x86_match_cpu(storage_d3_cpu_ids);
+}
-- 
2.43.0



