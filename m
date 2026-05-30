Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B87932D42B;
	Sat, 30 May 2026 17:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160574; cv=none; b=eBvIOZassGjWidch2YhEoyIFcYlg2LGbpIDv2AqZxyRMnzYmtJBstJbT/D0E0J1cIJ0ztV2wACfsvaDLCvo5c6Yb0/ROKXfHvpxOt5ql9k/l2M4TBCOeyPae/4+yl0xrKwyIyxNl2DhYY1zfFpX3iOyIBqzaJizoYoCVe72pSSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160574; c=relaxed/simple;
	bh=rCb9iSNS5RPPxqr+DxJJ5dz+vM8G4lO6XdxbL9Jp3VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5KMTFQYR2CodKb2kKbcCmvPt16mEaGP0KC9rA4S89dG+l3wmhSErWzOUHH60y73MfQCkSt1lpfGc3Bcnfg4qdqfdKIxYFTlvFb8O56s7LZBJ0xBBGfkajAmpkohCajYQT+QklONZ4gyYDXNVo8alpf1uOAvDRwgJ7Hqd34dl+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urZmNNtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urZmNNtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831811F00893;
	Sat, 30 May 2026 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160573;
	bh=KFpM8H8u15s6CL6GPY2wYbVU0g7kB7W4GDrTNagh8pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urZmNNtfGSJShVWoLZJbMsmz5L0dm6Ph2U0OhrPGkltwF7WedcToECDHehhh7qpuO
	 THmtxUTHrJyIrhtyBMhTnxnoGyM+ZWFoHPiNUV8xv3BR4pIeXmplDeum/uLJtfQe5N
	 b9il22/IGICAt9zBHKSz1u8UAQkh2Y48X5qVGB9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 345/969] ASoC: qcom: q6apm-dai: reset queue ptr on trigger stop
Date: Sat, 30 May 2026 17:57:49 +0200
Message-ID: <20260530160309.893123709@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit cab45ab95ce7600fc0ff84585c77fd45b7b0d67c upstream.

Reset queue pointer on SNDRV_PCM_TRIGGER_STOP event to be inline
with resetting appl_ptr. Without this we will end up with a queue_ptr
out of sync and driver could try to send data that is not ready yet.

Fix this by resetting the queue_ptr.

Fixes: 3d4a4411aa8bb ("ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |    1 +
 sound/soc/qcom/qdsp6/q6apm.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -246,6 +246,7 @@ static int q6apm_dai_trigger(struct snd_
 	case SNDRV_PCM_TRIGGER_STOP:
 		/* TODO support be handled via SoftPause Module */
 		prtd->state = Q6APM_STREAM_STOPPED;
+		prtd->queue_ptr = 0;
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -294,6 +294,8 @@ int q6apm_map_memory_regions(struct q6ap
 
 	mutex_lock(&graph->lock);
 
+	data->dsp_buf = 0;
+
 	if (data->buf) {
 		mutex_unlock(&graph->lock);
 		return 0;


