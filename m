Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3B4210E4
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhWfzLvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D343C433C7;
	Wed,  4 Oct 2023 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444360;
	bh=qeQrZ/arc7zaxa8io9qyQnbiPXGIWaDsE7E0iUh4K1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhWfzLvJ7i9xoARdzMscXh4izwsoBn5goqQJIV54+lF0fypPskIKRaZTiKfW0Dg4b
	 IJ4dL2lnNhqgEUGqRj+zyqOaehSMXSWSqFLg/i/xZg0V92EJoyf+EUO9O1zgZEGBN0
	 5+HvE93J7RB2Y6hxUyBcfyma9EyWm+LzdJ4v++wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 223/321] ASoC: SOF: Intel: MTL: Reduce the DSP init timeout
Date: Wed,  4 Oct 2023 19:56:08 +0200
Message-ID: <20231004175239.549151942@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit e0f96246c4402514acda040be19ee24c1619e01a ]

20s seems unnecessarily large for the DSP init timeout. This coupled with
multiple FW boot attempts causes an excessive delay in the error path when
booting in recovery mode. Reduce it to 0.5s and use the existing
HDA_DSP_INIT_TIMEOUT_US.

Link: https://github.com/thesofproject/linux/issues/4565
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230915134153.9688-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/mtl.c | 2 +-
 sound/soc/sof/intel/mtl.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index 30fe77fd87bf8..79e9a7ed8feaa 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -460,7 +460,7 @@ int mtl_dsp_cl_init(struct snd_sof_dev *sdev, int stream_tag, bool imr_boot)
 	/* step 3: wait for IPC DONE bit from ROM */
 	ret = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR, chip->ipc_ack, status,
 					    ((status & chip->ipc_ack_mask) == chip->ipc_ack_mask),
-					    HDA_DSP_REG_POLL_INTERVAL_US, MTL_DSP_PURGE_TIMEOUT_US);
+					    HDA_DSP_REG_POLL_INTERVAL_US, HDA_DSP_INIT_TIMEOUT_US);
 	if (ret < 0) {
 		if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 			dev_err(sdev->dev, "timeout waiting for purge IPC done\n");
diff --git a/sound/soc/sof/intel/mtl.h b/sound/soc/sof/intel/mtl.h
index 2794fe6e81396..9a0b8b9d8a0c9 100644
--- a/sound/soc/sof/intel/mtl.h
+++ b/sound/soc/sof/intel/mtl.h
@@ -62,7 +62,6 @@
 #define MTL_DSP_IRQSTS_IPC		BIT(0)
 #define MTL_DSP_IRQSTS_SDW		BIT(6)
 
-#define MTL_DSP_PURGE_TIMEOUT_US	20000000 /* 20s */
 #define MTL_DSP_REG_POLL_INTERVAL_US	10	/* 10 us */
 
 /* Memory windows */
-- 
2.40.1



