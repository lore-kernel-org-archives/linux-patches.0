Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA786FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FADEC4339B;
	Mon,  3 Apr 2023 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533041;
	bh=FKBZKY8qQ6HXoFsT/mRrgOqXCpdTA4uhACvftMNXzMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heWBOuQPBlHz0lSxp8caGFf9UH0R7uOsmiH3RFW1Yn9uo1ZkoVILBmIYgc/Em0w3p
	 g+bdW3svFBzUpYE6NzuQkkwhpEdhiKxnRLJS2X4rOUgrqe2XnyW2zo98UqnPPDJO0c
	 zG6aPipY93edk8wlU8Iy9R/oh+s9EF64+Lv97sTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 032/187] ASoC: SOF: Intel: hda-ctrl: re-add sleep after entering and exiting reset
Date: Mon,  3 Apr 2023 16:07:57 +0200
Message-Id: <20230403140417.054401798@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

[ Upstream commit 8bac40b8ed17ab1be9133e9620f65fae80262b7e ]

This reverts commit a09d82ce0a867 ("ASoC: SOF: Intel: hda-ctrl: remove
useless sleep")

It was a mistake to remove those delays, in light of comments in the
HDaudio spec captured in snd_hdac_bus_reset_link() that the codec
needs time for its initialization and PLL lock.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307095412.3416-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/intel/hda-ctrl.c b/sound/soc/sof/intel/hda-ctrl.c
index 3aea36c077c9d..f3bdeba284122 100644
--- a/sound/soc/sof/intel/hda-ctrl.c
+++ b/sound/soc/sof/intel/hda-ctrl.c
@@ -196,12 +196,15 @@ int hda_dsp_ctrl_init_chip(struct snd_sof_dev *sdev)
 		goto err;
 	}
 
+	usleep_range(500, 1000);
+
 	/* exit HDA controller reset */
 	ret = hda_dsp_ctrl_link_reset(sdev, false);
 	if (ret < 0) {
 		dev_err(sdev->dev, "error: failed to exit HDA controller reset\n");
 		goto err;
 	}
+	usleep_range(1000, 1200);
 
 	hda_codec_detect_mask(sdev);
 
-- 
2.39.2



