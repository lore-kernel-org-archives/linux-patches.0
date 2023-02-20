Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8999463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D5EC4339B;
	Mon, 20 Feb 2023 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901426;
	bh=Wwlb/I8iWbAt/dqNVJVL9xlCcsw0/STdjDDLmn7ZQwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inMq+888EXJIaTDS19NbG2BqAwVhKm4T3sBoW9+ljkF5uNSVtcW7PjJ3opI3BZedw
	 JPqeTfOWMZrVjW/N3jUQGtMpgjftf/m1X5VVU3pvWGcvh6qMpFBJYnAsRJy9DmO+C2
	 B5os2FIzX0S5BV46IPRL0BFvKeL8Ok+H1NvWiG+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/118] ASoC: Intel: sof_ssp_amp: always set dpcm_capture for amplifiers
Date: Mon, 20 Feb 2023 14:35:29 +0100
Message-Id: <20230220133600.936120517@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b3c00316a2f847791bae395ea6dd91aa7a221471 ]

The amplifier may provide hardware support for I/V feedback, or
alternatively the firmware may generate an echo reference attached to
the SSP and dailink used for the amplifier.

To avoid any issues with invalid/NULL substreams in the latter case,
always unconditionally set dpcm_capture.

Link: https://github.com/thesofproject/linux/issues/4083
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20230119163459.2235843-5-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_ssp_amp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/sof_ssp_amp.c b/sound/soc/intel/boards/sof_ssp_amp.c
index 94d25aeb6e7ce..7b74f122e3400 100644
--- a/sound/soc/intel/boards/sof_ssp_amp.c
+++ b/sound/soc/intel/boards/sof_ssp_amp.c
@@ -258,13 +258,12 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 		sof_rt1308_dai_link(&links[id]);
 	} else if (sof_ssp_amp_quirk & SOF_CS35L41_SPEAKER_AMP_PRESENT) {
 		cs35l41_set_dai_link(&links[id]);
-
-		/* feedback from amplifier */
-		links[id].dpcm_capture = 1;
 	}
 	links[id].platforms = platform_component;
 	links[id].num_platforms = ARRAY_SIZE(platform_component);
 	links[id].dpcm_playback = 1;
+	/* feedback from amplifier or firmware-generated echo reference */
+	links[id].dpcm_capture = 1;
 	links[id].no_pcm = 1;
 	links[id].cpus = &cpus[id];
 	links[id].num_cpus = 1;
-- 
2.39.0



