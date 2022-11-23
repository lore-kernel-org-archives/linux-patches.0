Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95561C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8EDC433C1;
	Wed, 23 Nov 2022 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197395;
	bh=68AKfwnypnKLgfbG65qF4VPPNMAQjvmyo0dT43Kx61M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3D0VHysGsbjZ8QQWmWEzKkrCYS/7h5uMsU9RrNq6DU2gvX+YqG4WJ72CSUzqJiGt
	 pxDLEsRvilVOTHL2c4ZwJ/R1jj6IY5TKbpCW4Mre8mLoaev3NBpBpvoUe9cQt8tge2
	 i4komHx1IHuKOViv1rIQIw7sKdl+6obmVBzJEIbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 283/314] ASoC: SOF: topology: No need to assign core ID if token parsing failed
Date: Wed, 23 Nov 2022 09:52:08 +0100
Message-Id: <20221123084638.361619570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 3d59eaef49ca2db581156a7b77c9afc0546eefc0 ]

Move the return value check before attempting to assign the core ID to the
swidget since we are going to fail the sof_widget_ready() and free up
swidget anyways.

Fixes: 909dadf21aae ("ASoC: SOF: topology: Make DAI widget parsing IPC agnostic")

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221107090433.5146-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 9273a70fec25..e1b7f07de7fc 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1346,16 +1346,6 @@ static int sof_widget_ready(struct snd_soc_component *scomp, int index,
 		break;
 	}
 
-	if (sof_debug_check_flag(SOF_DBG_DISABLE_MULTICORE)) {
-		swidget->core = SOF_DSP_PRIMARY_CORE;
-	} else {
-		int core = sof_get_token_value(SOF_TKN_COMP_CORE_ID, swidget->tuples,
-					       swidget->num_tuples);
-
-		if (core >= 0)
-			swidget->core = core;
-	}
-
 	/* check token parsing reply */
 	if (ret < 0) {
 		dev_err(scomp->dev,
@@ -1367,6 +1357,16 @@ static int sof_widget_ready(struct snd_soc_component *scomp, int index,
 		return ret;
 	}
 
+	if (sof_debug_check_flag(SOF_DBG_DISABLE_MULTICORE)) {
+		swidget->core = SOF_DSP_PRIMARY_CORE;
+	} else {
+		int core = sof_get_token_value(SOF_TKN_COMP_CORE_ID, swidget->tuples,
+					       swidget->num_tuples);
+
+		if (core >= 0)
+			swidget->core = core;
+	}
+
 	/* bind widget to external event */
 	if (tw->event_type) {
 		if (widget_ops[w->id].bind_event) {
-- 
2.35.1



