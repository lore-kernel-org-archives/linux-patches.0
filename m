Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599C36FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84C5C433EF;
	Tue, 10 Jan 2023 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374713;
	bh=y2Ppgz8FPbpRQPLR/AGHTGFAgEiy6KDl4M0uBsPvi28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olCAcc+hvtFe64S8BAkUski2LoheQNfpnfFWhpZRqjlMd0MHM3RD0tOzBnC90zkv9
	 /Q8zoau4K2uRxmvwZ0jhJ5ZchqxEisW6RnLMsCC+cPbwCTxozwcyjj/Oa6GbzjGXPH
	 xoVC/chgmvrXPA9b+WZlpC+lAb1SucYOdAvY3uC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/159] ASoC: SOF: Revert: "core: unregister clients and machine drivers in .shutdown"
Date: Tue, 10 Jan 2023 19:04:17 +0100
Message-Id: <20230110180021.754717941@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 44fda61d2bcfb74a942df93959e083a4e8eff75f ]

The unregister machine drivers call is not safe to do when
kexec is used. Kexec-lite gets blocked with following backtrace:

[   84.943749] Freezing user space processes ... (elapsed 0.111 seconds) done.
[  246.784446] INFO: task kexec-lite:5123 blocked for more than 122 seconds.
[  246.819035] Call Trace:
[  246.821782]  <TASK>
[  246.824186]  __schedule+0x5f9/0x1263
[  246.828231]  schedule+0x87/0xc5
[  246.831779]  snd_card_disconnect_sync+0xb5/0x127
...
[  246.889249]  snd_sof_device_shutdown+0xb4/0x150
[  246.899317]  pci_device_shutdown+0x37/0x61
[  246.903990]  device_shutdown+0x14c/0x1d6
[  246.908391]  kernel_kexec+0x45/0xb9

This reverts commit 83bfc7e793b555291785136c3ae86abcdc046887.

Reported-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221209114529.3909192-3-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 3e6141d03770..625977a29d8a 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -475,19 +475,10 @@ EXPORT_SYMBOL(snd_sof_device_remove);
 int snd_sof_device_shutdown(struct device *dev)
 {
 	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
-	struct snd_sof_pdata *pdata = sdev->pdata;
 
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
 		cancel_work_sync(&sdev->probe_work);
 
-	/*
-	 * make sure clients and machine driver(s) are unregistered to force
-	 * all userspace devices to be closed prior to the DSP shutdown sequence
-	 */
-	sof_unregister_clients(sdev);
-
-	snd_sof_machine_unregister(sdev, pdata);
-
 	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE)
 		return snd_sof_shutdown(sdev);
 
-- 
2.35.1



