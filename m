Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D827404E;
	Sat, 17 Oct 2026 16:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254674; cv=none; b=eP+tStxECwLZJvj4tnTyf+qZQnoMmd8FvAPW6Cxqt1RFNaVnMKSnaD5+Qi82HZk86zpPOq7Ccq2rNcMwlS+z8zBt0FpqIUSsh8m7Mkw+StATcwXDWRYxjXlPiM8Ebcri+VkfZszE0dQYAIVuEgJGwwKewYaw43c4wJm4x9/ToY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254674; c=relaxed/simple;
	bh=xy+psAa1nqMFzJ8wpC1ZozjYEbqAQkoc3IyxQH1O6Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEE7jtysZC4sgqhjq1uU95V1jdJBwg8hGZO6E8ldloo8rxuU+U+vNMh/8WWs5YGXEfOrXJ+2ZN+P4aAPGLVDORJLkb3fVzoKbEjFEIbtS9fxcvrAeYGBuR6Ebj1AKkgnYOJhu+vSet/2y+XhgXm3sk3wAZHH9cMp9UIoXYEvMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyIXYQFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyIXYQFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48D91F000C4;
	Sat, 17 Oct 2026 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254673;
	bh=dqC1ikHJ0CcGttud8ha87Zdczq/HmWMXr9GvvDadzxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NyIXYQFmdaqJxoPfK/FE9rl6lV3yc7iPVrG/74/HPo4XYbOB+K0cBIv3kB70r9jkg
	 3XMrNAiRFuxhUhGtcKmdjTG1/urVn6wdMTJeSf+vrpB6+pI0qicq4NTKh7K6IlddwZ
	 uTr7xngGz8uGKaWgDKlYlB5vidWmD5urS/051ORs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 525/869] ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout
Date: Sat, 17 Oct 2026 17:56:06 +0200
Message-ID: <20261017160050.573252837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 17661c67b206612cb3ba65d5ae726cd2015d0a53 ]

Ignore IPC errors for pipeline state change if the firmware state is
crashed or the IPC has timed out.

If the firmware has crashed the kernel still needs to go through the state
changes to reset its internal to be able to correctly work the next time
the DSP is booted up.

The case with IPC timeout is a bit more problematic, but it has been
rootcaused to be the result of system scheduling blockage and the firmware
did actually received and handled the message, but the reply handling got
blocked by issues outside of the SOF stack.
So far the best way to handle this is to continue with setting the state.

Fixes: c40aad7c81e5 ("ASoC: SOF: ipc4-pcm: Workaround for crashed firmware on system suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20260730112343.26687-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index dd521ea0b16a4..79b4aed4d26cd 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -501,7 +501,19 @@ static int sof_ipc4_trigger_pipelines(struct snd_soc_component *component,
 	ret = sof_ipc4_set_multi_pipeline_state(sdev, SOF_IPC4_PIPE_PAUSED, trigger_list);
 	if (ret < 0) {
 		spcm_err(spcm, substream->stream, "failed to pause all pipelines\n");
-		goto free;
+		/*
+		 * workaround: if the firmware is crashed or the IPC timed out
+		 * while setting the pipeline state we must ignore the error
+		 * code and proceed to set adjust the local pipeline states.
+		 *
+		 * If the firmware is crashed we will not send IPC messages
+		 * and we are going to see errors printed, but the state of the
+		 * widgets will be correct for the next boot.
+		 */
+		if (sdev->fw_state != SOF_FW_CRASHED && ret != -ETIMEDOUT)
+			goto free;
+
+		ret = 0;
 	}
 
 	/* update PAUSED state for all pipelines just triggered */
@@ -533,14 +545,15 @@ static int sof_ipc4_trigger_pipelines(struct snd_soc_component *component,
 			 "failed to set final state %d for all pipelines\n",
 			 state);
 		/*
-		 * workaround: if the firmware is crashed while setting the
-		 * pipelines to reset state we must ignore the error code and
-		 * reset it to 0.
-		 * Since the firmware is crashed we will not send IPC messages
+		 * workaround: if the firmware is crashed or the IPC timed out
+		 * while setting the pipeline state we must ignore the error
+		 * code and proceed to set adjust the local pipeline states.
+		 *
+		 * If the firmware is crashed we will not send IPC messages
 		 * and we are going to see errors printed, but the state of the
 		 * widgets will be correct for the next boot.
 		 */
-		if (sdev->fw_state != SOF_FW_CRASHED || state != SOF_IPC4_PIPE_RESET)
+		if (sdev->fw_state != SOF_FW_CRASHED && ret != -ETIMEDOUT)
 			goto free;
 
 		ret = 0;
-- 
2.53.0



