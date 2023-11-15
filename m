Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDBB2FC35
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeVzmh9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D73C433C8;
	Wed, 15 Nov 2023 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076625;
	bh=VhF6u9UMG7d8VF845IX4gtGu8KjgcfVPxbW2K+vEU/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeVzmh9u2eXtzAk/Z5g60YlRBqSqamelDbI5YXzMM1y8EhxaDAVDTcxqqRMa6mLtX
	 hnmtFj7rAMICgSV4Kt8MF2hmYXTbjg4cqpWKJcKFGiU6bIt+/DoHQe2pxZLkrT2zln
	 RGYsupRXWCwmwBEZkqyr+G87PrUfK9PZQ9A2msWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 346/550] ASoC: SOF: core: Ensure sof_ops_free() is still called when probe never ran.
Date: Wed, 15 Nov 2023 14:15:30 -0500
Message-ID: <20231115191624.740838574@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

[ Upstream commit f549a82aff57865c47b5abd17336b23cd9bb2d2c ]

In an effort to not call sof_ops_free twice, we stopped running it when
probe was aborted.

Check the result of cancel_work_sync to see if this was the case.

Fixes: 31bb7bd9ffee ("ASoC: SOF: core: Only call sof_ops_free() on remove if the probe was successful")
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://lore.kernel.org/r/20231009115437.99976-2-maarten.lankhorst@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 2d1616b81485c..0938b259f7034 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -459,9 +459,10 @@ int snd_sof_device_remove(struct device *dev)
 	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
 	struct snd_sof_pdata *pdata = sdev->pdata;
 	int ret;
+	bool aborted = false;
 
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
-		cancel_work_sync(&sdev->probe_work);
+		aborted = cancel_work_sync(&sdev->probe_work);
 
 	/*
 	 * Unregister any registered client device first before IPC and debugfs
@@ -487,6 +488,9 @@ int snd_sof_device_remove(struct device *dev)
 		snd_sof_free_debug(sdev);
 		snd_sof_remove(sdev);
 		sof_ops_free(sdev);
+	} else if (aborted) {
+		/* probe_work never ran */
+		sof_ops_free(sdev);
 	}
 
 	/* release firmware */
-- 
2.42.0



