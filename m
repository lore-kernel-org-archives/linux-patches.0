Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AB72AF1D;
	Sun,  7 Jun 2026 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829199; cv=none; b=ifneE1zHEiJEm5laZvkWh6DpXUbj8JEzM20ibygxP6CQS/8q7DGPzrxPj8OgpJ+P6cB+McVuNldzgBCFj6sr4MLnXi2B5fp/bfXS7Zx3vsRoY0SQVsIVLFz1v4Nkz3iqM7ReOOYVuuLf+Ml5ZlrTbAzbrTI+vz/Hxynz4TYdQ5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829199; c=relaxed/simple;
	bh=ZwO5y7n2o6Lw+8s/diWsvz4xnlDxbxmM1BhFbaH6dUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N490++HgEvlc6T4LB0FDzDiS+VnP1bPLlY0MlvWDxUxPz6Pk5l0JUF2qcoXe2cDF8E8NS8b/5LWg+jSc9RMAVCaiBwlcFFWJV9vPAHun9SGxKCqnWaZ+PbrQQ8Lr9GLOQ6SJ7KFHmmn8ujuHpK6vypDVI1Ob7dRx1TBHEDutcIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYMCmsku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYMCmsku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576471F00893;
	Sun,  7 Jun 2026 10:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829198;
	bh=vreP0gK67MHZ/WkHCwX9mD71L1Y/kc2uT+nXYNzW1jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYMCmskuThJZEm1+X3wkziV4oFBdOXtwFmKW0SsrEf5PUyTf66MTEOAVwcx5Xqj3+
	 b/vRim35Cyy24lCzZEacUVzua5XHkvAO/KVABDQkbg/EAv1Mh1PsgBkhRQRbGWa/et
	 AJk397T8RMGe7Xr5qsXP1HeKddawb/EkOPmcyDcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 203/307] ASoC: qcom: q6asm-dai: do not set stream state in event and trigger callbacks
Date: Sun,  7 Jun 2026 12:00:00 +0200
Message-ID: <20260607095735.177718785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit cee3e63e7106c3c81b2053371fdf14240bfba2fc upstream.

The q6asm-dai stream state is used by prepare() to decide whether an
existing stream setup needs to be closed before opening/configuring a new
one. Updating the state from trigger or asynchronous DSP callbacks can make
that state stale or incorrect relative to the actual setup lifetime.

In particular, setting Q6ASM_STREAM_STOPPED on STOP or EOS completion can
make prepare() believe there is no active setup to close, which can result
in opening/configuring the same stream more than once.

Keep stream state updates tied to prepare(), where the stream is actually
closed and reopened, and stop changing it from trigger and EOS callbacks.

Fixes: bfbb12dfa144 ("ASoC: qcom: q6asm-dai: perform correct state check before closing")
Cc: Stable@vger.kernel.org
Closes: https://lore.kernel.org/all/afS7rTHdc9TyIeLx@rdacayan/
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260518092347.3446946-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -186,7 +186,6 @@ static void event_handler(uint32_t opcod
 				   prtd->pcm_count, 0, 0, 0);
 		break;
 	case ASM_CLIENT_EVENT_CMD_EOS_DONE:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		break;
 	case ASM_CLIENT_EVENT_DATA_WRITE_DONE: {
 		prtd->pcm_irq_pos += prtd->pcm_count;
@@ -333,7 +332,6 @@ static int q6asm_dai_trigger(struct snd_
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;
@@ -544,8 +542,6 @@ static void compress_event_handler(uint3
 			snd_compr_drain_notify(prtd->cstream);
 			prtd->notify_on_drain = false;
 
-		} else {
-			prtd->state = Q6ASM_STREAM_STOPPED;
 		}
 		spin_unlock_irqrestore(&prtd->lock, flags);
 		break;
@@ -1008,7 +1004,6 @@ static int q6asm_dai_compr_trigger(struc
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;


