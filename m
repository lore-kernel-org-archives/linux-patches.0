Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C061E98EF;
	Sun,  7 Jun 2026 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828987; cv=none; b=BrEOFG9k8nOnf6udORJU+zbqjPxj/hps1yteBa0H2ey5JZ/7rQHCh0MtQulgD1ij/XW1P2v1VavXSt/68gthqf+dYiLk+pt84CB73IjLdTIX0bJ2S+6mbCQaRNh18uUEpJhTy3RnXcxl8AUjf9KzWaAu+8xJtpVCLCxKph47/pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828987; c=relaxed/simple;
	bh=nLwXQY+j/CTrqFj5jGopMPHrULOeISyuBePk9FfHQeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgDFk2IIzurZWqyFyg3GzTavVjx8qllPXy1LIB0Jm258GJjZfiMav53dH3OzNxC8VsEh7xC1YU5IEZvzt9djsJeTUkbLYOFvL0u2bvu5JQ48eBh1KLFliio5Vwsr/zM/yaFnn+/7ubIWIH/zSWtEiHOjgqQyfiTU2oBACatHQP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYx4a/41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYx4a/41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D1E1F00893;
	Sun,  7 Jun 2026 10:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828986;
	bh=ZeqWL/CuTARuVCY9NdHzVKb0FUAXtQ8pqa6mHyhMnk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYx4a/413kgHyVT+vhtWDGl19rkn93Ibos2Jt6DpjSg4OJQG43qjsaYMPW5CVtC3p
	 EOdkLioBIrDPeP/AnCCJ5eH4E3G4szx6pYocR1f8tpZT6DuAcGiY71STVtq/AcHgxB
	 Ggkj8rObdwPhQS7YLs9eLMto/Uarz5hNfeQ7TQhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 207/315] ASoC: qcom: q6asm-dai: do not set stream state in event and trigger callbacks
Date: Sun,  7 Jun 2026 11:59:54 +0200
Message-ID: <20260607095735.158408509@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -187,7 +187,6 @@ static void event_handler(uint32_t opcod
 				   prtd->pcm_count, 0, 0, 0);
 		break;
 	case ASM_CLIENT_EVENT_CMD_EOS_DONE:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		break;
 	case ASM_CLIENT_EVENT_DATA_WRITE_DONE: {
 		prtd->pcm_irq_pos += prtd->pcm_count;
@@ -334,7 +333,6 @@ static int q6asm_dai_trigger(struct snd_
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;
@@ -545,8 +543,6 @@ static void compress_event_handler(uint3
 			snd_compr_drain_notify(prtd->cstream);
 			prtd->notify_on_drain = false;
 
-		} else {
-			prtd->state = Q6ASM_STREAM_STOPPED;
 		}
 		spin_unlock_irqrestore(&prtd->lock, flags);
 		break;
@@ -1009,7 +1005,6 @@ static int q6asm_dai_compr_trigger(struc
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;


