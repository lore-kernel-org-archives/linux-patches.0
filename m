Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AE963B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B701C433EF;
	Mon, 20 Feb 2023 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901486;
	bh=5OmrxJurgCNLgg7cJ9DcGN6qBUiedU3NnSxSYAEzYBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yiig/ObyUN4TpqbbTd7beS3WBtl3LgEi22P+ywbiRBLfd7M40IUdxG6l+hl4Kr6kq
	 aEqJcw0cM2xnIPoNz2C1hMvAWWZ2jkgqeaxsxGor+Y/NBT7rbPnby2PNt0wmn3Dcxf
	 ydCSvc6WtkVOMFVPBkXXrXouA+Yj+SELNCE6ESJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/118] ASoC: SOF: sof-audio: start with the right widget type
Date: Mon, 20 Feb 2023 14:35:24 +0100
Message-Id: <20230220133600.736275249@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit fcc4348adafe53928fda46d104c1798e5a4de4ff ]

If there is a connection between a playback stream and a capture stream,
all widgets that are connected to the playback stream and the capture
stream will be in the list.
So, we have to start with the exactly right widget type.
snd_soc_dapm_aif_out is for capture stream and a playback stream should
start with a snd_soc_dapm_aif_in widget.
Contrarily, snd_soc_dapm_dai_in is for playback stream, and a capture
stream should start with a snd_soc_dapm_dai_out widget.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230117123534.2075-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-audio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 2df433c6ef55f..cf2c0db57d899 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -431,11 +431,11 @@ sof_walk_widgets_in_order(struct snd_sof_dev *sdev, struct snd_soc_dapm_widget_l
 
 	for_each_dapm_widgets(list, i, widget) {
 		/* starting widget for playback is AIF type */
-		if (dir == SNDRV_PCM_STREAM_PLAYBACK && !WIDGET_IS_AIF(widget->id))
+		if (dir == SNDRV_PCM_STREAM_PLAYBACK && widget->id != snd_soc_dapm_aif_in)
 			continue;
 
 		/* starting widget for capture is DAI type */
-		if (dir == SNDRV_PCM_STREAM_CAPTURE && !WIDGET_IS_DAI(widget->id))
+		if (dir == SNDRV_PCM_STREAM_CAPTURE && widget->id != snd_soc_dapm_dai_out)
 			continue;
 
 		switch (op) {
-- 
2.39.0



