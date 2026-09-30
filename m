Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFEA3264C2;
	Wed, 30 Sep 2026 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789761; cv=none; b=QPW5WlCv5uBG/mAIfDekTP0c214y7IJPUXq8fyBdPrFkHRmwB1sKinWLKbjg/99JsSslWvQSlZQIygKhqLGo6fU7g//2o1BthDDzPX/bn7YwbxAcAkI9UHrJZy2dt6UnAx/07uOVQWwJjkCJkOG9EGIDBGyvdnwCpBmmLZXaXkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789761; c=relaxed/simple;
	bh=SO/7g0/hcVcM2G04aX/rGU8GVTBohak0cOT3WixwPak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNaJY/5/fZZgqpL/6fPsBXdRODEQXeV3Yq4AKDmvwZtCiccwxxaC5lq3MmccwEES33l1VRqKh1D3lxvBF8saHYn80jzuAgjL56aZk8g4oZO2LaRms9ZeXUIxMwZLSstIHi8Y82s+YgGKa03lw2yQgDwOE/9QGR4HsxdmkV22hbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4Sys73s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4Sys73s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD981F000FF;
	Wed, 30 Sep 2026 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789760;
	bh=GihbTkRlLR7b3l6E5LVzM5UmUvxcDC8fwE6jMpb//xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4Sys73s5AgmZyvrBHqQUR50kw/wlMYGLOM+xbCaBvDV6PCDONx7Ncv2ItlTb1ddH
	 9HXZV10ftfMqrIdrhYlZZtIl1F0PnvHhG9GsBJuUzumY4LJKU1lOwgvYxN6gTu28LL
	 6/UdRz0PepOYvXQpeZzpPEtjjjGDPLjpMJ+8vFLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 589/877] platform/x86/amd/pmc: Move STB block into amd_pmc_s2d_init()
Date: Wed, 30 Sep 2026 17:25:00 +0200
Message-ID: <20260930152427.359883896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 83ad6974dd3bf34c080b3c08d36d02ebc3bd6da8 ]

Transfer the support for STB-related file operations to the
amd_pmc_s2d_init() function, thereby consolidating the STB and S2D
(Spill to DRAM) functionality in one location. Also, relocate the
call to amd_pmc_s2d_init() to occur after the creation of the
"amd_pmc" debugfs directory. This ensures that the driver's root debugfs
directory is established beforehand.

For older platforms that supported S2D, exit immediately after creating
debugfs. These platforms may not support the PMFW messages available on
newer platforms. This adjustment is necessary due to the relocation of
debugfs creation into amd_pmc_s2d_init().

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Co-developed-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20241108070822.3912689-2-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 9cef693bce96 ("platform/x86/amd/pmc: Restore msg_port on amd_stb_s2d_init() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -657,15 +657,6 @@ static void amd_pmc_dbgfs_register(struc
 			    &s0ix_stats_fops);
 	debugfs_create_file("amd_pmc_idlemask", 0644, dev->dbgfs_dir, dev,
 			    &amd_pmc_idlemask_fops);
-	/* Enable STB only when the module_param is set */
-	if (enable_stb) {
-		if (amd_pmc_is_stb_supported(dev))
-			debugfs_create_file("stb_read", 0644, dev->dbgfs_dir, dev,
-					    &amd_pmc_stb_debugfs_fops_v2);
-		else
-			debugfs_create_file("stb_read", 0644, dev->dbgfs_dir, dev,
-					    &amd_pmc_stb_debugfs_fops);
-	}
 }
 
 static void amd_pmc_dump_registers(struct amd_pmc_dev *dev)
@@ -1069,6 +1060,18 @@ static int amd_pmc_s2d_init(struct amd_p
 	u32 size = 0;
 	int ret;
 
+	if (!enable_stb)
+		return 0;
+
+	if (amd_pmc_is_stb_supported(dev)) {
+		debugfs_create_file("stb_read", 0644, dev->dbgfs_dir, dev,
+				    &amd_pmc_stb_debugfs_fops_v2);
+	} else {
+		debugfs_create_file("stb_read", 0644, dev->dbgfs_dir, dev,
+				    &amd_pmc_stb_debugfs_fops);
+		return 0;
+	}
+
 	/* Spill to DRAM feature uses separate SMU message port */
 	dev->msg_port = 1;
 
@@ -1187,12 +1190,6 @@ static int amd_pmc_probe(struct platform
 	/* Get num of IP blocks within the SoC */
 	amd_pmc_get_ip_info(dev);
 
-	if (enable_stb && amd_pmc_is_stb_supported(dev)) {
-		err = amd_pmc_s2d_init(dev);
-		if (err)
-			goto err_pci_dev_put;
-	}
-
 	platform_set_drvdata(pdev, dev);
 	if (IS_ENABLED(CONFIG_SUSPEND)) {
 		err = acpi_register_lps0_dev(&amd_pmc_s2idle_dev_ops);
@@ -1203,6 +1200,10 @@ static int amd_pmc_probe(struct platform
 	}
 
 	amd_pmc_dbgfs_register(dev);
+	err = amd_pmc_s2d_init(dev);
+	if (err)
+		goto err_pci_dev_put;
+
 	if (IS_ENABLED(CONFIG_AMD_MP2_STB))
 		amd_mp2_stb_init(dev);
 	pm_report_max_hw_sleep(U64_MAX);


