Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688C94FC34E;
	Thu, 17 Sep 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665745; cv=none; b=MDWTdQqZNh+5vLioCLbiyakWgT1ZExemTMMHJshSMOQyxaJCLUJfqgGtmERxa3F/euHZWBGPhE5HkcnANYcUX0cIF9CqAHQHhyUU1iZFff+XQMkEsThyHsjZCwt+khAOtxLWTunPGNooUI3IpfBzZODwtes171P8hw7LDBSNhms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665745; c=relaxed/simple;
	bh=sQG7a9WmE2uiZMJgwJY/ZlT/uZWKmfYFXPOMwKtaXGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZiOqpTWaEsYhHYdQVqgsLKm1qo9ESEE91zUOT0IffqsDdLp3BaJBRuwUgbW4+dcatOfWAa6NrLJKjeBfWegt83ClrFTNkVaH+icH8b62q5BkRC/Rtcrx9nCySw+D4i/4I2HhlCiwD92zSs40gPTW7k6lx1N+6zz3qrZM1scW9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkjO6Wzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkjO6Wzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7081F000FF;
	Thu, 17 Sep 2026 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665744;
	bh=Ufeeu/Ic154Zv4o8gNUO/QsIHAs35vLiMy/jYo/y5rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkjO6WzwR1UQGpEwbcO7fFMQdbnRaU3pqibio3aaM3NcEND6bJeENqudS1jQQjQVt
	 Xd0QqJZpWvDt7hPdwd+IpivzS0GBPp0H++nxLcCmzgp0ahIapTbm2cBii3ZuKEv7TL
	 FLjbMwEysApr2/RosstpuD6ogpgHF4C1R4y1Tb9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0805/1250] pds_core: fix cmd_regs access racing BAR unmap on reset
Date: Thu, 17 Sep 2026 16:10:00 +0100
Message-ID: <20260917151613.732412046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 61be6def50b1c..ac3fbc5e3dccc 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -508,7 +508,11 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
 		pdsc_auxbus_dev_del(pdsc, pdsc, &pdsc->padev);
 	}
 
-	pdsc_unmap_bars(pdsc);
+	if (!pdev->is_virtfn) {
+		mutex_lock(&pdsc->devcmd_lock);
+		pdsc_unmap_bars(pdsc);
+		mutex_unlock(&pdsc->devcmd_lock);
+	}
 	pci_release_regions(pdev);
 	if (pci_is_enabled(pdev))
 		pci_disable_device(pdev);
@@ -537,7 +541,9 @@ static void pdsc_reset_done(struct pci_dev *pdev)
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



