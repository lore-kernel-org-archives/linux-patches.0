Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805F81CA8F;
	Mon,  1 Apr 2024 16:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987522; cv=none; b=dLxZGasvxAjZlmpRImE1Er9N/+jUAjm0YI2QYjOp5GckeBYV/Hu1xKxWeNmKdZnoTwtWtsbOPa/EwssijfclZMSt+7zn3coVLAyBrIxHbSuIiTBsQaiETFNWaEDuJLku9CRX+Ge17sixDhyGgXmgoTd2+gpCODNXOIVUqhyHIVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987522; c=relaxed/simple;
	bh=ff20X6VOBtJeOFKDS32TW7wfeFmtI6dDmnLP4k8JS+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDDXmNOSldownot2gi6iyPib95ZHLMc1V+u9fiaoJcZsTasiCC3+xqI8TpR5itysBlk5xs7nOAzGLT4aBqtvTFr3NuYYNWxx8KI48k5Xj4gqAeXIurSJVl4nnOXfSthdQzMdV3StlRQSapc3hbGXer4h9o0TNBrmvifNSX69Kw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ckz/LQ38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ckz/LQ38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7801C433C7;
	Mon,  1 Apr 2024 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987522;
	bh=ff20X6VOBtJeOFKDS32TW7wfeFmtI6dDmnLP4k8JS+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ckz/LQ3847LSKvtkw9xM/eZEExJXx1HjLsNAfsFzB/BkTt3wjvf+aLypZDa3I7aFO
	 kEOaj3mpr2G511WxyrTOv7vErUGEDI40QQ2PP7oZSEagjPA9t6VA9/upwgL2HNo2J5
	 9PvdNh1gbbiffelLCCUoLH9W3EvW8rhQ5aXhsbzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Naour <romain.naour@skf.com>,
	Tony Lindgren <tony@atomide.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.8 312/399] mmc: sdhci-omap: re-tuning is needed after a pm transition to support emmc HS200 mode
Date: Mon,  1 Apr 2024 17:44:38 +0200
Message-ID: <20240401152558.500314837@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Naour <romain.naour@skf.com>

commit f9e2a5b00a35f2c064dc679808bc8db5cc779ed6 upstream.

"PM runtime functions" was been added in sdhci-omap driver in commit
f433e8aac6b9 ("mmc: sdhci-omap: Implement PM runtime functions") along
with "card power off and enable aggressive PM" in commit 3edf588e7fe0
("mmc: sdhci-omap: Allow SDIO card power off and enable aggressive PM").

Since then, the sdhci-omap driver doesn't work using mmc-hs200 mode
due to the tuning values being lost during a pm transition.

As for the sdhci_am654 driver, request a new tuning sequence before
suspend (sdhci_omap_runtime_suspend()), otherwise the device will
trigger cache flush error:

  mmc1: cache flush error -110 (ETIMEDOUT)
  mmc1: error -110 doing aggressive suspend

followed by I/O errors produced by fdisk -l /dev/mmcblk1boot1:

  I/O error, dev mmcblk1boot0, sector 64384 op 0x0:(READ) flags 0x80700 phys_seg 1
  prio class 2
  I/O error, dev mmcblk1boot1, sector 64384 op 0x0:(READ) flags 0x80700 phys_seg 1
  prio class 2
  I/O error, dev mmcblk1boot1, sector 64384 op 0x0:(READ) flags 0x0 phys_seg 1
  prio class 2
  Buffer I/O error on dev mmcblk1boot1, logical block 8048, async page read
  I/O error, dev mmcblk1boot0, sector 64384 op 0x0:(READ) flags 0x0 phys_seg 1
  prio class 2
  Buffer I/O error on dev mmcblk1boot0, logical block 8048, async page read

Don't re-tune if auto retuning is supported in HW (when SDHCI_TUNING_MODE_3
is available).

Link: https://lore.kernel.org/all/2e5f1997-564c-44e4-b357-6343e0dae7ab@smile.fr
Fixes: f433e8aac6b9 ("mmc: sdhci-omap: Implement PM runtime functions")
Signed-off-by: Romain Naour <romain.naour@skf.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240315234444.816978-1-romain.naour@smile.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-omap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1439,6 +1439,9 @@ static int __maybe_unused sdhci_omap_run
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_omap_host *omap_host = sdhci_pltfm_priv(pltfm_host);
 
+	if (host->tuning_mode != SDHCI_TUNING_MODE_3)
+		mmc_retune_needed(host->mmc);
+
 	if (omap_host->con != -EINVAL)
 		sdhci_runtime_suspend_host(host);
 


