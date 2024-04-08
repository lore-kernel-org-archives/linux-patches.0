Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1440412A171;
	Mon,  8 Apr 2024 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583856; cv=none; b=rADV1k/riOvjjoiJH24qCzSuEkwC2qrBXNcJ5P3rjuBdslDH3o/qhbc5wtIJlcXuf2EL5CLxunFJ8Q2ry38BN+OVoxVwFzSk92OHFOFhAKTxDxx0mWlAYfmM8Czsps+3N5n5d4EsAMIBZDthMUSU+mC/H6vCck+6JP0qNKlS3Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583856; c=relaxed/simple;
	bh=6ucf0hpvKgO3/nQ/olBLZkHsAPP+miKtm+A27QEW6R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HN4z/qELAr/aJNpWJQ/l/eiuLLhAy9XkWC0Oz5PxGDrzteZnGf6iEq0CSNO2E1zbOQHNBIXvgyFIt4Jol78jVwaZ0wLFO0RYdIkhA8nCqTUHtHuacPR58+cHcRqcMtc9yeAAkIY1dzudW9okIUy0LQJ4OX84dif1pmfdtCDbIBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMMPqUob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMMPqUob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCD0C433F1;
	Mon,  8 Apr 2024 13:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583855;
	bh=6ucf0hpvKgO3/nQ/olBLZkHsAPP+miKtm+A27QEW6R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMMPqUobXi1RnJJqliACWeoAspOoj7Y6/EOCevF2MRBwI8DCRTaiYcARRTU5XqXzn
	 FmLAP0EbArPChSwTVCdPdUWF+Ok23UIpP+2s/0YrF2hRjGGbCsUZsTKz+98t5gFlSh
	 6R5THbvw9jtyOnb0ol7MtFLcXRSEL7CtlBtLobKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 227/273] ASoC: SOF: Intel: hda: Compensate LLP in case it is not reset
Date: Mon,  8 Apr 2024 14:58:22 +0200
Message-ID: <20240408125316.459922752@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 1abc2642588e06f6180b3fbb21968cf5d0ba9e5f upstream.

During pause/reset or stop/start the LLP counter is not reset, which will
result broken delay reporting.

Read the LLP value on STOP/PAUSE trigger and use it in LLP reading to
normalize the LLP from the register.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-18-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-dai-ops.c |   11 +++++++++++
 sound/soc/sof/intel/hda-pcm.c     |    8 ++++++++
 sound/soc/sof/intel/hda-stream.c  |    9 ++++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/intel/hda-dai-ops.c
+++ b/sound/soc/sof/intel/hda-dai-ops.c
@@ -7,6 +7,7 @@
 
 #include <sound/pcm_params.h>
 #include <sound/hdaudio_ext.h>
+#include <sound/hda_register.h>
 #include <sound/hda-mlink.h>
 #include <sound/sof/ipc4/header.h>
 #include <uapi/sound/sof/header.h>
@@ -362,6 +363,16 @@ static int hda_trigger(struct snd_sof_de
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		snd_hdac_ext_stream_clear(hext_stream);
+
+		/*
+		 * Save the LLP registers in case the stream is
+		 * restarting due PAUSE_RELEASE, or START without a pcm
+		 * close/open since in this case the LLP register is not reset
+		 * to 0 and the delay calculation will return with invalid
+		 * results.
+		 */
+		hext_stream->pplcllpl = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPL);
+		hext_stream->pplcllpu = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPU);
 		break;
 	default:
 		dev_err(sdev->dev, "unknown trigger command %d\n", cmd);
--- a/sound/soc/sof/intel/hda-pcm.c
+++ b/sound/soc/sof/intel/hda-pcm.c
@@ -282,6 +282,14 @@ int hda_dsp_pcm_open(struct snd_sof_dev
 
 	/* binding pcm substream to hda stream */
 	substream->runtime->private_data = &dsp_stream->hstream;
+
+	/*
+	 * Reset the llp cache values (they are used for LLP compensation in
+	 * case the counter is not reset)
+	 */
+	dsp_stream->pplcllpl = 0;
+	dsp_stream->pplcllpu = 0;
+
 	return 0;
 }
 
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -1055,6 +1055,8 @@ snd_pcm_uframes_t hda_dsp_stream_get_pos
 	return pos;
 }
 
+#define merge_u64(u32_u, u32_l) (((u64)(u32_u) << 32) | (u32_l))
+
 /**
  * hda_dsp_get_stream_llp - Retrieve the LLP (Linear Link Position) of the stream
  * @sdev: SOF device
@@ -1084,7 +1086,12 @@ u64 hda_dsp_get_stream_llp(struct snd_so
 	llp_l = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPL);
 	llp_u = readl(hext_stream->pplc_addr + AZX_REG_PPLCLLPU);
 
-	return ((u64)llp_u << 32) | llp_l;
+	/* Compensate the LLP counter with the saved offset */
+	if (hext_stream->pplcllpl || hext_stream->pplcllpu)
+		return merge_u64(llp_u, llp_l) -
+		       merge_u64(hext_stream->pplcllpu, hext_stream->pplcllpl);
+
+	return merge_u64(llp_u, llp_l);
 }
 
 /**


