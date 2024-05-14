Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224C313B287;
	Tue, 14 May 2024 11:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684991; cv=none; b=hFrQSlL6mgb25vld1vpS0E7XGX0L44Qr0cHDBw2z5f8BLNOJhweRZIuUCvTLVhqH0Xge//mwgQ6OhekMJEka958D3Rx7VJD0Qtz/qGZ7N6TixgElNI/Tl87kjxnFmtT3iPFVOGjIBVzmhbcj/lYlAvh0d9fk9X7Ch86pbaYB5Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684991; c=relaxed/simple;
	bh=E9N6uVbucIWdnidfGxPlPUc+HgD985D8sxHpeL2wmls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AowTBaNOm5MVWzgMXtswChwi263Juvr5xHTrfU2pgYpmoig45yrqrCnx9QU1++gSj2Z5WBD2dvQ14vQy1MVObGiRxCrGy/y+eb0kVqaW7e/ymu79B3ARUEDb633FSAjoqA8A4O1MUOpbiY9KDzlPoRBMeJ7GcINo0DQ58YCJgns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNi/SUAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNi/SUAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3FC32781;
	Tue, 14 May 2024 11:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684991;
	bh=E9N6uVbucIWdnidfGxPlPUc+HgD985D8sxHpeL2wmls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNi/SUAOlF5uFe3JBfrZzCGzgmrATldPR9spszEbwJxntwiqOUU+ZxP0QOy7Vd0yl
	 /wrl1bRHCbksm9U1qEe5ii4J+45RPLqC2vsNw9y7YhSkqGAzjSwcAcd8pHU7W5X4Zl
	 B3D9FZ6zHRh6Rk/af4Y/tnUu8TlMI7EAom+0PLSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/301] ASoC: SOF: Intel: hda-dsp: Skip IMR boot on ACE platforms in case of S3 suspend
Date: Tue, 14 May 2024 12:16:29 +0200
Message-ID: <20240514101036.706316071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit c61115b37ff964d63191dbf4a058f481daabdf57 ]

SoCs with ACE architecture are tailored to use s2idle instead deep (S3)
suspend state and the IMR content is lost when the system is forced to
enter even to S3.
When waking up from S3 state the IMR boot will fail as the content is lost.
Set the skip_imr_boot flag to make sure that we don't try IMR in this case.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://msgid.link/r/20240322112504.4192-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dsp.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dsp.c b/sound/soc/sof/intel/hda-dsp.c
index 44f39a520bb39..e80a2a5ec56a1 100644
--- a/sound/soc/sof/intel/hda-dsp.c
+++ b/sound/soc/sof/intel/hda-dsp.c
@@ -681,17 +681,27 @@ static int hda_suspend(struct snd_sof_dev *sdev, bool runtime_suspend)
 	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
 	const struct sof_intel_dsp_desc *chip = hda->desc;
 	struct hdac_bus *bus = sof_to_bus(sdev);
+	bool imr_lost = false;
 	int ret, j;
 
 	/*
-	 * The memory used for IMR boot loses its content in deeper than S3 state
-	 * We must not try IMR boot on next power up (as it will fail).
-	 *
+	 * The memory used for IMR boot loses its content in deeper than S3
+	 * state on CAVS platforms.
+	 * On ACE platforms due to the system architecture the IMR content is
+	 * lost at S3 state already, they are tailored for s2idle use.
+	 * We must not try IMR boot on next power up in these cases as it will
+	 * fail.
+	 */
+	if (sdev->system_suspend_target > SOF_SUSPEND_S3 ||
+	    (chip->hw_ip_version >= SOF_INTEL_ACE_1_0 &&
+	     sdev->system_suspend_target == SOF_SUSPEND_S3))
+		imr_lost = true;
+
+	/*
 	 * In case of firmware crash or boot failure set the skip_imr_boot to true
 	 * as well in order to try to re-load the firmware to do a 'cold' boot.
 	 */
-	if (sdev->system_suspend_target > SOF_SUSPEND_S3 ||
-	    sdev->fw_state == SOF_FW_CRASHED ||
+	if (imr_lost || sdev->fw_state == SOF_FW_CRASHED ||
 	    sdev->fw_state == SOF_FW_BOOT_FAILED)
 		hda->skip_imr_boot = true;
 
-- 
2.43.0



