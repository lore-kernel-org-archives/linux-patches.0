Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987A31D2E8;
	Wed,  9 Aug 2023 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCE1C433C8;
	Wed,  9 Aug 2023 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691604737;
	bh=dQSxAwTg/Ur8+g1iyJEmUIHV6QtyBHM7QCfl22I5E88=;
	h=From:Date:Subject:To:Cc:From;
	b=QExAzpIxW8VIhUg0Dx3HmURl8L8cDXikq01/z7xjlsz992JPeLyzHZatsyZdgx8Fe
	 SD8Jaca7/bbEOVQeWY8qiEF9DyRf6lkHZya2xYqHWJQZ9AAEkKTXQ7lG2YsoiYcl8Q
	 76wMGGYPqhdnyqpsLlxdglMv9nWYzowNf3LllrA5d/HNTRUnr9UnCbQhLK5wC34dSu
	 UfPqScmBzgYm68ZLPTVQCa8BzvWtK8SWHZGwk4w2rBG3bChG2LGjWxh4A9RmibSyab
	 QwEapEYqjVHdo1kvwUIrf/LUQNK+H28VSI4xvdTjvushDEew3K+PsYEsgH3ESQJaE3
	 xko1vLC9gP0VA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 09 Aug 2023 11:12:07 -0700
Subject: [PATCH] ASoC: SOF: Intel: Initialize chip in
 hda_sdw_check_wakeen_irq()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPbW02QC/x3MQQqDMBBG4avIrB1I1Urbq4iLOJmaH9pUMiKCe
 HdDl99bvINMM9ToVR2UdYPhlwpudUUSfZqVEYqpcU3rHu7JSKt+OAbPX5ghzSwRS8lYOYjIpH3
 b331H5bBkfWP/34fxPC/UGTIgbQAAAA==
To: broonie@kernel.org, pierre-louis.bossart@linux.intel.com, 
 lgirdwood@gmail.com, peter.ujfalusi@linux.intel.com, 
 yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com, 
 daniel.baluta@nxp.com
Cc: kai.vehmanen@linux.intel.com, ndesaulniers@google.com, trix@redhat.com, 
 rander.wang@intel.com, sound-open-firmware@alsa-project.org, 
 alsa-devel@alsa-project.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1494; i=nathan@kernel.org;
 h=from:subject:message-id; bh=dQSxAwTg/Ur8+g1iyJEmUIHV6QtyBHM7QCfl22I5E88=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCmXrzPYTvdaPP30JJdUySrx88FcXYe+p3ScPHqfSdrV/
 KerY21vRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZgItxwjw6kXaxRKy0pFy15t
 nhx3bf6RacFfap7fl8itvCgl8+Rc+z2GP1w5N62F+FcE1HD3HLvlE+dx4MH1mxsbXsi8YFB5N8d
 akRUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR):

  sound/soc/sof/intel/hda.c:423:6: error: variable 'chip' is uninitialized when used here [-Werror,-Wuninitialized]
    423 |         if (chip && chip->check_sdw_wakeen_irq)
        |             ^~~~
  sound/soc/sof/intel/hda.c:418:39: note: initialize the variable 'chip' to silence this warning
    418 |         const struct sof_intel_dsp_desc *chip;
        |                                              ^
        |                                               = NULL
  1 error generated.

Add the missing initialization, following the pattern of the other irq
functions.

Fixes: 9362ab78f175 ("ASoC: SOF: Intel: add abstraction for SoundWire wake-ups")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/sof/intel/hda.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 04c748a72b13..15e6779efaa3 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -420,6 +420,7 @@ static bool hda_sdw_check_wakeen_irq(struct snd_sof_dev *sdev)
 	if (!(interface_mask & BIT(SOF_DAI_INTEL_ALH)))
 		return false;
 
+	chip = get_chip_info(sdev->pdata);
 	if (chip && chip->check_sdw_wakeen_irq)
 		return chip->check_sdw_wakeen_irq(sdev);
 

---
base-commit: 59146c3cd326a622e9041614842346aada11ca99
change-id: 20230809-intel-hda-missing-chip-init-dcccbe6365a4

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

