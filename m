Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6F83C0A0C;
	Wed, 30 Sep 2026 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795260; cv=none; b=HZOTMg0npbLgQ0XElNTpxn9IxFsdpD/CW6IYZkPYaUy8hPnPikduHgSHoZ4F8mpTl5R7TSKacR/FPaZmR4UMbkjo2jyMWkiCPaUZuLB6IptxAyki8S1Ai6mFoiNVKZ+xr3XTsjU0yuR0GOxkDdwadnSLxzX+SixsNFv5EKFbA2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795260; c=relaxed/simple;
	bh=LOA9gwnnzsVjeOJPJmi/a2oWxfa8qO+1xvM8+L0mjXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tk606vdoDyfBP3i+oiLEilFLoffGWSfIBSV2eM/CjDjbVY5+NUPqvDmBZMTuP8knCuMcS1Uf2bOY9SgF2ZA7oGdCqFxvDeOVWp9dAlLWnXsVDyxhfoIA6kpP6MPi92za8KP5uE8kEA5xukt2Joh/iX+1I2AZFxAo6ZXsg1X0LJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZlRxg7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZlRxg7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009B81F00898;
	Wed, 30 Sep 2026 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795259;
	bh=ayYU722X+LIPDa62f45zEbFQVLNJ5i60eD5OkRTRIMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZlRxg7Q/Adeea7pi05HAqPyeN/s//LT2OoZJdb14t6K9Da5cCDJi025vQ+7bKYGh
	 jCPXW75oUqHF4QuaDchLg4GpweO2vCUUaPb1UNUc8bzk9wVU3BTexe6lrY0xK7vnFm
	 sW2CZEz4Khn01jKid6+vxWjRjDbzB//IDiuINsNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0498/1193] pds_core: fix cmd_regs access racing BAR unmap on reset
Date: Wed, 30 Sep 2026 17:19:42 +0200
Message-ID: <20260930152445.217739311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 7980325b2f71e3f65c1323c39792e2455da6fab6 ]

pdsc_reset_prepare() and pdsc_reset_done()'s pdsc_map_bars() error path
clear/iounmap cmd_regs without devcmd_lock, and
pdsc_legacy_firmware_update()'s download loop derefs cmd_regs after
dropping and retaking the lock without re-checking. An FLR concurrent
with a devlink flash can unmap cmd_regs under an in-flight devcmd,
causing a NULL deref or a write to unmapped MMIO.

Take devcmd_lock across the BAR unmap/remap, and re-check cmd_regs in
the download loop. Only the PF maps cmd_regs and runs devcmd, so skip
the unmap on a VF, as pdsc_remove() and pdsc_reset_done() already do.

A reset that completes entirely within the unlocked window is not a
correctness problem for the image: the device clears its update session,
so a resumed download is rejected, and it verifies the staged image
before writing a flash slot, reporting PDS_RC_BAD_FW rather than
activating it.

pdsc_unmap_bars() also clears info_regs, intr_status and intr_ctrl. The
interrupt and start/stop readers of those are quiesced before the unmap
by pdsc_fw_down(), which frees the interrupts and tears down the queues.
The debugfs readers are not, since those files outlive a reset; that is
pre-existing and out of scope here.

Fixes: e96094c1d11c ("pds_core: Clear BARs on reset")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260708212222.296202-1-nikhil.rao%40amd.com?part=3
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260901044219.1361466-2-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/fw.c   | 10 +++++++++-
 drivers/net/ethernet/amd/pds_core/main.c |  8 +++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c
index fa626719e68d1..59d262b0d29c5 100644
--- a/drivers/net/ethernet/amd/pds_core/fw.c
+++ b/drivers/net/ethernet/amd/pds_core/fw.c
@@ -107,8 +107,10 @@ int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 
 	dev_info(pdsc->dev, "Installing firmware\n");
 
-	if (!pdsc->cmd_regs)
+	if (!pdsc->cmd_regs) {
+		NL_SET_ERR_MSG_MOD(extack, "BARs not mapped");
 		return -ENXIO;
+	}
 
 	dl = priv_to_devlink(pdsc);
 	devlink_flash_update_status_notify(dl, "Preparing to flash",
@@ -134,6 +136,12 @@ int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 
 		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
 		mutex_lock(&pdsc->devcmd_lock);
+		if (!pdsc->cmd_regs) {
+			mutex_unlock(&pdsc->devcmd_lock);
+			err = -ENXIO;
+			NL_SET_ERR_MSG_MOD(extack, "Device reset during flash");
+			goto err_out;
+		}
 		memcpy_toio(&pdsc->cmd_regs->data, fw->data + offset, copy_sz);
 		err = pdsc_devcmd_fw_download_locked(pdsc, data_addr,
 						     offset, copy_sz);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 93fa7dfd74cbc..e88230ae6349d 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -490,7 +490,11 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
 					    &pf->vfs[pdsc->vf_id].padev);
 	}
 
-	pdsc_unmap_bars(pdsc);
+	if (!pdev->is_virtfn) {
+		mutex_lock(&pdsc->devcmd_lock);
+		pdsc_unmap_bars(pdsc);
+		mutex_unlock(&pdsc->devcmd_lock);
+	}
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
@@ -518,7 +522,9 @@ static void pdsc_reset_done(struct pci_dev *pdev)
 			return;
 		}
 
+		mutex_lock(&pdsc->devcmd_lock);
 		err = pdsc_map_bars(pdsc);
+		mutex_unlock(&pdsc->devcmd_lock);
 		if (err)
 			return;
 	}
-- 
2.53.0



