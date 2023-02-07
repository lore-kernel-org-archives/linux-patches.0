Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997D43212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06820C433EF;
	Tue,  7 Feb 2023 13:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775073;
	bh=Jo+OmfsLt6OPHwjwTw3T4mdj9UgVT9DJAmEGCZR+fEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoA5QbdYSZK9QHwiIiNFnv9OXuu0UawgUIGvwGFPIhdUOi1uErpXvwso9iu3Q0bv7
	 EKRPuaYeqN6f1rC5cR1CirMDhRznYkpGA2CA0c+pIO2NSnDrJ2OuIrf5swygIOyc27
	 P4dzS73vHqwWTGhEqERPGiWs6Il4m+w+vVpf1HXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 129/208] ASoC: SOF: keep prepare/unprepare widgets in sink path
Date: Tue,  7 Feb 2023 13:56:23 +0100
Message-Id: <20230207125640.266676599@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit cc755b4377b0520d594ae573497cf0824baea648 upstream.

The existing code return when a widget doesn't need to
prepare/unprepare. This will prevent widgets in the sink path from being
prepared/unprepared.

Cc: <stable@vger.kernel.org> # 6.1
Link: https://github.com/thesofproject/linux/issues/4021
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230118101255.29139-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 8c114e6a23c6..ff716bfbcb67 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -271,9 +271,9 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 	struct snd_sof_widget *swidget = widget->dobj.private;
 	struct snd_soc_dapm_path *p;
 
-	/* return if the widget is in use or if it is already unprepared */
+	/* skip if the widget is in use or if it is already unprepared */
 	if (!swidget || !swidget->prepared || swidget->use_count > 0)
-		return;
+		goto sink_unprepare;
 
 	if (widget_ops[widget->id].ipc_unprepare)
 		/* unprepare the source widget */
@@ -281,6 +281,7 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 
 	swidget->prepared = false;
 
+sink_unprepare:
 	/* unprepare all widgets in the sink paths */
 	snd_soc_dapm_widget_for_each_sink_path(widget, p) {
 		if (!p->walking && p->sink->dobj.private) {
-- 
2.39.1



