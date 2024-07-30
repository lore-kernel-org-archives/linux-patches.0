Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681EE1A76A5;
	Tue, 30 Jul 2024 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360716; cv=none; b=sFS5fcxnBIcF9726XwN2yObLmGKl7v5SuKf2P75aTKtBlCS1an4rSc5r8e3P1sUsinx6O0itN59MWEGbCANh+309aKWrQwL7IkQOpH99W7nLq77kKY+hJsOmH9rnRbsILjlioFi+0jhMTpaeDllxlm077x5x8oANR7+w2vhUXcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360716; c=relaxed/simple;
	bh=oIoU2i5tqDjoJ0zXyGxW55nwsoumyyFOGdMojPWqVeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTxMLGwJdPlQUk0eoVb1xitLVpkqyaPVxBwoMerpHhblh7d3sB1g/ydAfuxOwLdWsPk9UQs7a6TY8SzAs1kbT4W7PZwmPIF/3HyTv5S2FLwhwZz2E/nQ4GuQKE5dw1BVvLmHX1+thw1zqB2AFEOG31noQuPhuLNXbf9E5afKcTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBrhECPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBrhECPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6897C32782;
	Tue, 30 Jul 2024 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360716;
	bh=oIoU2i5tqDjoJ0zXyGxW55nwsoumyyFOGdMojPWqVeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBrhECPNK3BYcQHpblmMnmtvh/m0nt2PsaPSEh0q7ZMHR6KwtMdUw6dGxXz6jkBvu
	 SyHmesM5AtP35yTd3RtvM8S1RdXMsmLAPPQwJAUFjC9u4WxpC/i+O2WOAx1IK5x2UU
	 tjXNgvVUY/yggfc77TvarpJONmt34t1mzSqMXt+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Todd Brandt <todd.e.brandt@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 785/809] ASOC: SOF: Intel: hda-loader: only wait for HDaudio IOC for IPC4 devices
Date: Tue, 30 Jul 2024 17:51:01 +0200
Message-ID: <20240730151755.971585316@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 9ee3f0d8c9999eb1ef2866e86f8d57d996fc0348 ]

Multiple users report a regression bisected to commit d5263dbbd8af
("ASoC: SOF: Intel: don't ignore IOC interrupts for non-audio
transfers"). The firmware version is the likely suspect, as these
users relied on SOF 2.0 while Intel only tested with the 2.2 release.

Rather than completely disable the wait_for_completion(), which can
help us gather timing information on the different stages of the boot
process, the simplest course of action is to just disable it for older
IPC versions which are no longer under active development.

Closes: https://github.com/thesofproject/linux/issues/5072
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218961
Fixes: d5263dbbd8af ("ASoC: SOF: Intel: don't ignore IOC interrupts for non-audio transfers")
Tested-by: Mike Krinkin <krinkin.m.u@gmail.com>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20240716084530.300829-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-loader.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index b8b914eaf7e05..75f6240cf3e1d 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -310,15 +310,19 @@ int hda_cl_copy_fw(struct snd_sof_dev *sdev, struct hdac_ext_stream *hext_stream
 		return ret;
 	}
 
-	/* Wait for completion of transfer */
-	time_left = wait_for_completion_timeout(&hda_stream->ioc,
-						msecs_to_jiffies(HDA_CL_DMA_IOC_TIMEOUT_MS));
-
-	if (!time_left) {
-		dev_err(sdev->dev, "Code loader DMA did not complete\n");
-		return -ETIMEDOUT;
+	if (sdev->pdata->ipc_type == SOF_IPC_TYPE_4) {
+		/* Wait for completion of transfer */
+		time_left = wait_for_completion_timeout(&hda_stream->ioc,
+							msecs_to_jiffies(HDA_CL_DMA_IOC_TIMEOUT_MS));
+
+		if (!time_left) {
+			dev_err(sdev->dev, "Code loader DMA did not complete\n");
+			return -ETIMEDOUT;
+		}
+		dev_dbg(sdev->dev, "Code loader DMA done\n");
 	}
-	dev_dbg(sdev->dev, "Code loader DMA done, waiting for FW_ENTERED status\n");
+
+	dev_dbg(sdev->dev, "waiting for FW_ENTERED status\n");
 
 	status = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,
 					chip->rom_status_reg, reg,
-- 
2.43.0



