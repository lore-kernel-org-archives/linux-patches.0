Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E3E210E4
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CO6vUvrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B93C433C8;
	Wed,  4 Oct 2023 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444352;
	bh=pyzqGPDu5SuEgWdy1QLEDdGJHR/p+EpUaBGCqBv+sQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CO6vUvrUN9Jp0R+SEBd8/VbhPpNUtK1uFZWhT1goqLTcfeCCvTJTCU7gFssSv4tfL
	 4gmDnYejxPPc0l+NXXncYoipU4pN2nknSWD/TzoPAbm86/3sn1Ywh3NniR8HKEucgX
	 iDY0msWzzlJAjZQdjOktiEzdLOPKaDtk1cMb+8iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 220/321] ASoC: SOF: sof-audio: Fix DSP core put imbalance on widget setup failure
Date: Wed,  4 Oct 2023 19:56:05 +0200
Message-ID: <20231004175239.417778889@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit bb0216d4db9ecaa51af45d8504757becbe5c050d ]

In case the widget setup fails we should only decrement the core usage
count if the sof_widget_free_unlocked() has not been called as part of
the error handling.
sof_widget_free_unlocked() calls snd_sof_dsp_core_put() and the additional
core_put will cause imbalance in core usage count.
Use the existing use_count_decremented to handle this issue.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230914124725.17397-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-audio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index e7ef77012c358..e5405f854a910 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -212,7 +212,8 @@ static int sof_widget_setup_unlocked(struct snd_sof_dev *sdev,
 	sof_widget_free_unlocked(sdev, swidget);
 	use_count_decremented = true;
 core_put:
-	snd_sof_dsp_core_put(sdev, swidget->core);
+	if (!use_count_decremented)
+		snd_sof_dsp_core_put(sdev, swidget->core);
 pipe_widget_free:
 	if (swidget->id != snd_soc_dapm_scheduler)
 		sof_widget_free_unlocked(sdev, swidget->spipe->pipe_widget);
-- 
2.40.1



