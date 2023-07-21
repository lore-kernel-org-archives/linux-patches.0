Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D51F94D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F42C433C7;
	Fri, 21 Jul 2023 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956640;
	bh=UzZrEQsv/5tBjYsvD7JpXbYSuWx74VdNZDcpsRNR5XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeS3YsCKe0RzKu7iq8Iq6Z7ajXP6M7DAbsoM0FhduT7C/ayKq1DrOUNMmDmPWlyp0
	 f6Eq3R2OUYEthmRiOOcxJ8PNSiUvp+najEtMNlnIlRNFTMgFg5OcESl9WYlWNMSI/w
	 kjg5Zr0cYCDDZJxpz+SwKrlu36aLNoGFfY4UqkyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 247/292] drm/amd/pm: conditionally disable pcie lane/speed switching for SMU13
Date: Fri, 21 Jul 2023 18:05:56 +0200
Message-ID: <20230721160539.516787758@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 31c7a3b378a136adc63296a2ff17645896fcf303 upstream.

Intel platforms such as Sapphire Rapids and Raptor Lake don't support
dynamic pcie lane or speed switching.

This limitation seems to carry over from one generation to another.
To be safer, disable dynamic pcie lane width and speed switching when
running on an Intel platform.

Link: https://edc.intel.com/content/www/us/en/design/products/platforms/details/raptor-lake-s/13th-generation-core-processors-datasheet-volume-1-of-2/005/pci-express-support/
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2663
Co-developed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |   42 +++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2454,6 +2454,25 @@ int smu_v13_0_mode1_reset(struct smu_con
 	return ret;
 }
 
+/*
+ * Intel hosts such as Raptor Lake and Sapphire Rapids don't support dynamic
+ * speed switching. Until we have confirmation from Intel that a specific host
+ * supports it, it's safer that we keep it disabled for all.
+ *
+ * https://edc.intel.com/content/www/us/en/design/products/platforms/details/raptor-lake-s/13th-generation-core-processors-datasheet-volume-1-of-2/005/pci-express-support/
+ * https://gitlab.freedesktop.org/drm/amd/-/issues/2663
+ */
+static bool smu_v13_0_is_pcie_dynamic_switching_supported(void)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (c->x86_vendor == X86_VENDOR_INTEL)
+		return false;
+#endif
+	return true;
+}
+
 int smu_v13_0_update_pcie_parameters(struct smu_context *smu,
 				     uint32_t pcie_gen_cap,
 				     uint32_t pcie_width_cap)
@@ -2461,15 +2480,32 @@ int smu_v13_0_update_pcie_parameters(str
 	struct smu_13_0_dpm_context *dpm_context = smu->smu_dpm.dpm_context;
 	struct smu_13_0_pcie_table *pcie_table =
 				&dpm_context->dpm_tables.pcie_table;
+	int num_of_levels = pcie_table->num_of_link_levels;
 	uint32_t smu_pcie_arg;
 	int ret, i;
 
-	for (i = 0; i < pcie_table->num_of_link_levels; i++) {
-		if (pcie_table->pcie_gen[i] > pcie_gen_cap)
+	if (!smu_v13_0_is_pcie_dynamic_switching_supported()) {
+		if (pcie_table->pcie_gen[num_of_levels - 1] < pcie_gen_cap)
+			pcie_gen_cap = pcie_table->pcie_gen[num_of_levels - 1];
+
+		if (pcie_table->pcie_lane[num_of_levels - 1] < pcie_width_cap)
+			pcie_width_cap = pcie_table->pcie_lane[num_of_levels - 1];
+
+		/* Force all levels to use the same settings */
+		for (i = 0; i < num_of_levels; i++) {
 			pcie_table->pcie_gen[i] = pcie_gen_cap;
-		if (pcie_table->pcie_lane[i] > pcie_width_cap)
 			pcie_table->pcie_lane[i] = pcie_width_cap;
+		}
+	} else {
+		for (i = 0; i < num_of_levels; i++) {
+			if (pcie_table->pcie_gen[i] > pcie_gen_cap)
+				pcie_table->pcie_gen[i] = pcie_gen_cap;
+			if (pcie_table->pcie_lane[i] > pcie_width_cap)
+				pcie_table->pcie_lane[i] = pcie_width_cap;
+		}
+	}
 
+	for (i = 0; i < num_of_levels; i++) {
 		smu_pcie_arg = i << 16;
 		smu_pcie_arg |= pcie_table->pcie_gen[i] << 8;
 		smu_pcie_arg |= pcie_table->pcie_lane[i];


