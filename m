Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4951D6A7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DA2C433CC;
	Wed, 20 Sep 2023 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211025;
	bh=tc35an1yL6bdqHVeKrwODlFTyysbOo07uho2dXSYu0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5040v+h11bmrTfUh0WXzy6MkeWFC9XAetNLe9MU2eYGXG4utFKYqu4Pbx9AvrQGb
	 /GhMClqRT1OIBbB6i3jIPdAfdsDKhveIq3dBYB9lw6LW85v1wgB+Dgd0ikPmTr+Bmu
	 GIFnfwyD2cq/UioWTG+jsKP7kxyUthlR79nNWroc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Yaochun Hung <yc.hung@mediatek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/139] ASoC: SOF: topology: simplify code to prevent static analysis warnings
Date: Wed, 20 Sep 2023 13:29:41 +0200
Message-ID: <20230920112837.387018223@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 55cb3dc271d81f1982c949a2ac483a6daf613b92 ]

make KCFLAGS='-fanalyzer' sound/soc/sof/intel/ reports a possible NULL
pointer dereference.

sound/soc/sof/topology.c:1136:21: error: dereference of NULL ‘w’
[CWE-476] [-Werror=analyzer-null-dereference]

 1136 |     strcmp(w->sname, rtd->dai_link->stream_name))

The code is rather confusing and can be simplified to make static
analysis happy. No functionality change.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Yaochun Hung <yc.hung@mediatek.com>
Link: https://lore.kernel.org/r/20230731213748.440285-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 872e44408298f..e7305ce57ea1f 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1086,16 +1086,17 @@ static void sof_disconnect_dai_widget(struct snd_soc_component *scomp,
 {
 	struct snd_soc_card *card = scomp->card;
 	struct snd_soc_pcm_runtime *rtd;
+	const char *sname = w->sname;
 	struct snd_soc_dai *cpu_dai;
 	int i;
 
-	if (!w->sname)
+	if (!sname)
 		return;
 
 	list_for_each_entry(rtd, &card->rtd_list, list) {
 		/* does stream match DAI link ? */
 		if (!rtd->dai_link->stream_name ||
-		    strcmp(w->sname, rtd->dai_link->stream_name))
+		    strcmp(sname, rtd->dai_link->stream_name))
 			continue;
 
 		switch (w->id) {
-- 
2.40.1



