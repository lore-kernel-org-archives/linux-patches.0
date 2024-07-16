Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B917527733;
	Tue, 16 Jul 2024 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144974; cv=none; b=rvORW8PzKx7YZkMO/BewmcEtPVoaIFtuju8lMU2uJ/mJqJno1beK0V8+hUCWDSgYVm2aZYUzV0g3sRPdHlZccI0A0HwL8a9KBSJpy/Qb4McXlIgT186jK7UHUSSpZ19UHaEN06ZfUpv1lsj7jw12ToGhBD8jvwZb8o+A42P0x5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144974; c=relaxed/simple;
	bh=+k4kWY2TBsshUL3qsiZR7WbBd8HZzwin0yLWqU3qdeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqqFy9JsjIj/Q50PiQfVvNqPZwkH4RFHJa7ZrwaeMnc+PeHdjsOxx85niHCqkQTS2XQdua6vfX/nVFoQGClqHNKLSvwXegUaeqI+GsHws23L5kqBozRkZZ2ZpbMyU8ywFOZR6ElRxKx/rPEEtqmWDvrAekdIqXopxGg25jtKnmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFGjcmK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFGjcmK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DEC116B1;
	Tue, 16 Jul 2024 15:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144974;
	bh=+k4kWY2TBsshUL3qsiZR7WbBd8HZzwin0yLWqU3qdeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFGjcmK6X1uA6iFJUHKI1GYRCAJ99ox90fqBzcGqz7/4qpnWnXLRynOuF0W260jAS
	 3EwhOdr3chMMAfTP3iuwCfwJifSdfBAiGP8uou9NViV0FzioWn/0rp/IZt5l4l17Mk
	 lelRNe6mcmVxovamDagnoPPvxDlFDf/sI3Z09ev4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 055/143] ASoC: SOF: Intel: hda: fix null deref on system suspend entry
Date: Tue, 16 Jul 2024 17:30:51 +0200
Message-ID: <20240716152758.098751197@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 9065693dcc13f287b9e4991f43aee70cf5538fdd ]

When system enters suspend with an active stream, SOF core
calls hw_params_upon_resume(). On Intel platforms with HDA DMA used
to manage the link DMA, this leads to call chain of

   hda_dsp_set_hw_params_upon_resume()
 -> hda_dsp_dais_suspend()
 -> hda_dai_suspend()
 -> hda_ipc4_post_trigger()

A bug is hit in hda_dai_suspend() as hda_link_dma_cleanup() is run first,
which clears hext_stream->link_substream, and then hda_ipc4_post_trigger()
is called with a NULL snd_pcm_substream pointer.

Fixes: 2b009fa0823c ("ASoC: SOF: Intel: hda: Unify DAI drv ops for IPC3 and IPC4")
Link: https://github.com/thesofproject/linux/issues/5080
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240704085708.371414-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 6a39ca632f55e..4a6beddb0f6c7 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -566,12 +566,6 @@ static int hda_dai_suspend(struct hdac_bus *bus)
 			sdai = swidget->private;
 			ops = sdai->platform_private;
 
-			ret = hda_link_dma_cleanup(hext_stream->link_substream,
-						   hext_stream,
-						   cpu_dai);
-			if (ret < 0)
-				return ret;
-
 			/* for consistency with TRIGGER_SUSPEND  */
 			if (ops->post_trigger) {
 				ret = ops->post_trigger(sdev, cpu_dai,
@@ -580,6 +574,12 @@ static int hda_dai_suspend(struct hdac_bus *bus)
 				if (ret < 0)
 					return ret;
 			}
+
+			ret = hda_link_dma_cleanup(hext_stream->link_substream,
+						   hext_stream,
+						   cpu_dai);
+			if (ret < 0)
+				return ret;
 		}
 	}
 
-- 
2.43.0



