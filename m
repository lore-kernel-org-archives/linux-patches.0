Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF92BB1B;
	Fri, 15 Nov 2024 06:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653272; cv=none; b=FrzK2b7YKBukRIV44W0AIMTkRuGdDGfAvpkJx5nX7EshSq+Rn3B3Gzr2Gx3/sRK2BTyicWJfR0jL0uYspGl+29M1mrmnvxMq2hKVc4SgR0c3x0xXA7w0P67fTo5bq71k/WhdgwxasoPCN5HRJkerVUl0w+bDRKKRF1KScKEmefs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653272; c=relaxed/simple;
	bh=F3bF2kVPt+fprVAC2nu37LbyubgeWtrF0VfoD2iffiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kt3HNxC3b8fQ7rdZ4SYVUtLp8aiUnJLNFHtnpj5jI2NcVFVu3rs2YYzV1qANy52BYtrUpWcfQDwSBwUIXI9LaQ7VLZKhz8FEcIjoIkK0p0+khL3dvE/vdw+TLEsZ+tE08zj8iiO9wYhy4s+QhDmaxaPZcDyRcaLHiCXg+oQjcp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THjbGdCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THjbGdCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C10C4CECF;
	Fri, 15 Nov 2024 06:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653272;
	bh=F3bF2kVPt+fprVAC2nu37LbyubgeWtrF0VfoD2iffiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THjbGdCvoSVKfzTu4eW1Qpwq7xm0b9bke3Weu4zXE58F+wBwNEPj/vaq4LxkvdtSD
	 dEQLsnfyzNeyAlbjGSHM6p8NLGx8hRJLzE/cSays+rpNHpLDW4zmllbY7dKgrMLf6c
	 k+Dn/0gnqy4fWgpxbcoVU/JbdOR0obV9/pZiUqoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 38/63] ASoC: Intel: avs: Update stream status in a separate thread
Date: Fri, 15 Nov 2024 07:38:01 +0100
Message-ID: <20241115063727.291483234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 0dbb186c3510cad4e9f443e801bf2e6ab5770c00 ]

Function snd_pcm_period_elapsed() is part of sequence servicing HDAudio
stream IRQs. It's called under Global Interrupt Enable (GIE) disabled -
no HDAudio interrupts will be raised. At the same time, the function may
end up calling __snd_pcm_xrun() or snd_pcm_drain_done(). On the
avs-driver side, this translates to IPCs and as GIE is disabled, these
will never complete successfully.

Improve system stability by scheduling stream-IRQ handling in a separate
thread.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20241008083758.756578-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c |  3 ++-
 sound/soc/intel/avs/pcm.c  | 19 +++++++++++++++++++
 sound/soc/intel/avs/pcm.h  | 16 ++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 sound/soc/intel/avs/pcm.h

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index f2dc82a2abc71..4d1e6c84918c6 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -28,6 +28,7 @@
 #include "avs.h"
 #include "cldma.h"
 #include "messages.h"
+#include "pcm.h"
 
 static u32 pgctl_mask = AZX_PGCTL_LSRMD_MASK;
 module_param(pgctl_mask, uint, 0444);
@@ -247,7 +248,7 @@ static void hdac_stream_update_pos(struct hdac_stream *stream, u64 buffer_size)
 static void hdac_update_stream(struct hdac_bus *bus, struct hdac_stream *stream)
 {
 	if (stream->substream) {
-		snd_pcm_period_elapsed(stream->substream);
+		avs_period_elapsed(stream->substream);
 	} else if (stream->cstream) {
 		u64 buffer_size = stream->cstream->runtime->buffer_size;
 
diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index c76b86254a8b4..37b1880c81141 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -16,6 +16,7 @@
 #include <sound/soc-component.h>
 #include "avs.h"
 #include "path.h"
+#include "pcm.h"
 #include "topology.h"
 #include "../../codecs/hda.h"
 
@@ -30,6 +31,7 @@ struct avs_dma_data {
 		struct hdac_ext_stream *host_stream;
 	};
 
+	struct work_struct period_elapsed_work;
 	struct snd_pcm_substream *substream;
 };
 
@@ -56,6 +58,22 @@ avs_dai_find_path_template(struct snd_soc_dai *dai, bool is_fe, int direction)
 	return dw->priv;
 }
 
+static void avs_period_elapsed_work(struct work_struct *work)
+{
+	struct avs_dma_data *data = container_of(work, struct avs_dma_data, period_elapsed_work);
+
+	snd_pcm_period_elapsed(data->substream);
+}
+
+void avs_period_elapsed(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct snd_soc_dai *dai = snd_soc_rtd_to_cpu(rtd, 0);
+	struct avs_dma_data *data = snd_soc_dai_get_dma_data(dai, substream);
+
+	schedule_work(&data->period_elapsed_work);
+}
+
 static int avs_dai_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
@@ -77,6 +95,7 @@ static int avs_dai_startup(struct snd_pcm_substream *substream, struct snd_soc_d
 	data->substream = substream;
 	data->template = template;
 	data->adev = adev;
+	INIT_WORK(&data->period_elapsed_work, avs_period_elapsed_work);
 	snd_soc_dai_set_dma_data(dai, substream, data);
 
 	if (rtd->dai_link->ignore_suspend)
diff --git a/sound/soc/intel/avs/pcm.h b/sound/soc/intel/avs/pcm.h
new file mode 100644
index 0000000000000..0f3615c903982
--- /dev/null
+++ b/sound/soc/intel/avs/pcm.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright(c) 2024 Intel Corporation
+ *
+ * Authors: Cezary Rojewski <cezary.rojewski@intel.com>
+ *          Amadeusz Slawinski <amadeuszx.slawinski@linux.intel.com>
+ */
+
+#ifndef __SOUND_SOC_INTEL_AVS_PCM_H
+#define __SOUND_SOC_INTEL_AVS_PCM_H
+
+#include <sound/pcm.h>
+
+void avs_period_elapsed(struct snd_pcm_substream *substream);
+
+#endif
-- 
2.43.0



