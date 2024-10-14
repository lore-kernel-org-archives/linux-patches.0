Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F8E1C0DD6;
	Mon, 14 Oct 2024 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920001; cv=none; b=fAjrfMozYlNX704P55g73rvgx5yolOLE0aHaDXhHxAB02P6u8FYbBZS4I62Ms9neCKE1ioC2SxwYsLlLs0n5odgmFZE8+b6r1X/O+rX6J9NOoIGYeiesZrRK83pMy+wJ8gEjFjXT3AlH1C90yZC778TY2umbjS5l8AcPB2l+jas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920001; c=relaxed/simple;
	bh=kEZJAUZq/ZkD9YoDFhNir6fjdNPasT7NurL5owoGQ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeWCI8zW/wWiS368pChdr6Rna1DPBNpeZ5l6dUOzZqO5vn+VMABauZm73JIgnrYSEqtk00dpTSbeAMn+CtgYEy2Q+5pgCs5Qii+n0T5y0ki/fALhPgllvLWPo3Im33MziPaP9b6YmShNoAxD6YHL0uByo5I++arTsosG5F7DE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqpGIuyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqpGIuyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DB8C4CEC7;
	Mon, 14 Oct 2024 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920001;
	bh=kEZJAUZq/ZkD9YoDFhNir6fjdNPasT7NurL5owoGQ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqpGIuyJzB+4J6bj7e0vGy3RrBk6ecj5CdA5AdRTGZjndD5+erwiBlap/XwnQ/jH+
	 oPWAD9j7EqUmEODm/3RCtgPej9Qwa5dqmmd/ACqhWqx6ofwX4XTl5FxebY03Q/veGS
	 I2ATe1ItpKRV+nh2/K4WgIHfoxBM/DxWfaJq9ugQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 738/798] thermal: int340x: processor_thermal: Set feature mask before proc_thermal_add
Date: Mon, 14 Oct 2024 16:21:32 +0200
Message-ID: <20241014141247.064551588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 6ebc25d8b053a208786295bab58abbb66b39c318 ]

The function proc_thermal_add() adds sysfs entries for power limits.

The feature mask of available features is not present at that time, so
it cannot be used by proc_thermal_add() to selectively create sysfs
attributes.

The feature mask is set by proc_thermal_mmio_add(), so modify the code
to call it before proc_thermal_add() so as to allow the latter to use
the feature mask.

There is no functional impact with this change.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 99ca0b57e49f ("thermal: intel: int340x: processor: Fix warning during module unload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../processor_thermal_device_pci.c            | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index bf1b1cdfade4a..a04e565fdcf19 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -237,26 +237,26 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 
 	INIT_DELAYED_WORK(&pci_info->work, proc_thermal_threshold_work_fn);
 
-	ret = proc_thermal_add(&pdev->dev, proc_priv);
-	if (ret) {
-		dev_err(&pdev->dev, "error: proc_thermal_add, will continue\n");
-		pci_info->no_legacy = 1;
-	}
-
 	proc_priv->priv_data = pci_info;
 	pci_info->proc_priv = proc_priv;
 	pci_set_drvdata(pdev, proc_priv);
 
 	ret = proc_thermal_mmio_add(pdev, proc_priv, id->driver_data);
 	if (ret)
-		goto err_ret_thermal;
+		return ret;
+
+	ret = proc_thermal_add(&pdev->dev, proc_priv);
+	if (ret) {
+		dev_err(&pdev->dev, "error: proc_thermal_add, will continue\n");
+		pci_info->no_legacy = 1;
+	}
 
 	pci_info->tzone = thermal_zone_device_register("TCPU_PCI", 1, 1, pci_info,
 							&tzone_ops,
 							&tzone_params, 0, 0);
 	if (IS_ERR(pci_info->tzone)) {
 		ret = PTR_ERR(pci_info->tzone);
-		goto err_ret_mmio;
+		goto err_del_legacy;
 	}
 
 	/* request and enable interrupt */
@@ -283,11 +283,10 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 	pci_free_irq_vectors(pdev);
 err_ret_tzone:
 	thermal_zone_device_unregister(pci_info->tzone);
-err_ret_mmio:
-	proc_thermal_mmio_remove(pdev, proc_priv);
-err_ret_thermal:
+err_del_legacy:
 	if (!pci_info->no_legacy)
 		proc_thermal_remove(proc_priv);
+	proc_thermal_mmio_remove(pdev, proc_priv);
 	pci_disable_device(pdev);
 
 	return ret;
-- 
2.43.0



