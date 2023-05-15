Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A611FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA742C4339B;
	Mon, 15 May 2023 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171604;
	bh=x/p1t7HAQ7Wo3VHr0Cq7bYnbckkSRlGPYPm5aGzbmss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEE/AZPysnqeVcHEp/tQrYCykkmRiLuQU26RwaR8SzdNawmQIFvGlPe8DM4riwuhO
	 ycv89PkSY83DAzyRTSNnQF0rQG86TIJpMPxiKnGtJX3ioSy0/R7xVDtnLQOQLNZu7F
	 ICDzGe2YJiHkaOOfcEcFU88InBQ/ozCdYnWYOVrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/134] ASoC: soc-pcm: align BE atomicity with that of the FE
Date: Mon, 15 May 2023 18:28:09 +0200
Message-Id: <20230515161703.383776436@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
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

[ Upstream commit bbf7d3b1c4f40eb02dd1dffb500ba00b0bff0303 ]

Since the flow for DPCM is based on taking a lock for the FE first, we
need to make sure during the connection between a BE and an FE that
they both use the same 'atomicity', otherwise we may sleep in atomic
context.

If the FE is nonatomic, this patch forces the BE to be nonatomic as
well. That should have no negative impact since the BE 'inherits' the
FE properties.

However, if the FE is atomic and the BE is not, then the configuration
is flagged as invalid.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
[ removed FE stream lock by tiwai ]
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20211207173745.15850-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index a2b20526e7e2b..7bea8fa59f676 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1123,6 +1123,8 @@ static snd_pcm_uframes_t soc_pcm_pointer(struct snd_pcm_substream *substream)
 static int dpcm_be_connect(struct snd_soc_pcm_runtime *fe,
 		struct snd_soc_pcm_runtime *be, int stream)
 {
+	struct snd_pcm_substream *fe_substream;
+	struct snd_pcm_substream *be_substream;
 	struct snd_soc_dpcm *dpcm;
 	unsigned long flags;
 
@@ -1132,6 +1134,20 @@ static int dpcm_be_connect(struct snd_soc_pcm_runtime *fe,
 			return 0;
 	}
 
+	fe_substream = snd_soc_dpcm_get_substream(fe, stream);
+	be_substream = snd_soc_dpcm_get_substream(be, stream);
+
+	if (!fe_substream->pcm->nonatomic && be_substream->pcm->nonatomic) {
+		dev_err(be->dev, "%s: FE is atomic but BE is nonatomic, invalid configuration\n",
+			__func__);
+		return -EINVAL;
+	}
+	if (fe_substream->pcm->nonatomic && !be_substream->pcm->nonatomic) {
+		dev_warn(be->dev, "%s: FE is nonatomic but BE is not, forcing BE as nonatomic\n",
+			 __func__);
+		be_substream->pcm->nonatomic = 1;
+	}
+
 	dpcm = kzalloc(sizeof(struct snd_soc_dpcm), GFP_ATOMIC);
 	if (!dpcm)
 		return -ENOMEM;
-- 
2.39.2



