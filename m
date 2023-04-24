Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39622108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DB3C433D2;
	Mon, 24 Apr 2023 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343177;
	bh=E5MLtgRyfqBoZdloFp77SgptROvj0OSsfz/NoVgW8Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HViSdYdJTdvmgmirAqpqyUcQ3yV/TNXXMEics06Px/aVs1IE03o8+eNolhYGXYZ+P
	 x3EjD6hNsLeXM8mbAN1iKovEX8hkLAhamhWKsACtacqe+2MJFbWA3wzSUZoZwe2jZb
	 LDu1HuHUr+tDhp3amwH4ZarC73QDLSMVajvfx3Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 107/110] ASoC: SOF: pm: Tear down pipelines only if DSP was active
Date: Mon, 24 Apr 2023 15:18:09 +0200
Message-Id: <20230424131140.620199301@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Baluta <daniel.baluta@nxp.com>

commit 0b186bb06198653d74a141902a7739e0bde20cf4 upstream.

With PCI if the device was suspended it is brought back to full
power and then suspended again.

This doesn't happen when device is described via DT.

We need to make sure that we tear down pipelines only if the device
was previously active (thus the pipelines were setup).

Otherwise, we can break the use_count:

[  219.009743] sof-audio-of-imx8m 3b6e8000.dsp:
sof_ipc3_tear_down_all_pipelines: widget PIPELINE.2.SAI3.IN is still in use: count -1

and after this everything stops working.

Fixes: d185e0689abc ("ASoC: SOF: pm: Always tear down pipelines before DSP suspend")
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20230405092655.19587-1-daniel.baluta@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -183,6 +183,7 @@ static int sof_suspend(struct device *de
 	const struct sof_ipc_tplg_ops *tplg_ops = sdev->ipc->ops->tplg;
 	pm_message_t pm_state;
 	u32 target_state = snd_sof_dsp_power_target(sdev);
+	u32 old_state = sdev->dsp_power_state.state;
 	int ret;
 
 	/* do nothing if dsp suspend callback is not set */
@@ -192,7 +193,12 @@ static int sof_suspend(struct device *de
 	if (runtime_suspend && !sof_ops(sdev)->runtime_suspend)
 		return 0;
 
-	if (tplg_ops && tplg_ops->tear_down_all_pipelines)
+	/* we need to tear down pipelines only if the DSP hardware is
+	 * active, which happens for PCI devices. if the device is
+	 * suspended, it is brought back to full power and then
+	 * suspended again
+	 */
+	if (tplg_ops && tplg_ops->tear_down_all_pipelines && (old_state == SOF_DSP_PM_D0))
 		tplg_ops->tear_down_all_pipelines(sdev, false);
 
 	if (sdev->fw_state != SOF_FW_BOOT_COMPLETE)


