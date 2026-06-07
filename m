Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14201E98EF;
	Sun,  7 Jun 2026 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828990; cv=none; b=N4Bh7xxv+cqqu9rNYn/WegTwRkRvtt0ArF2jQXZsMaRMQ36zdMkIOob7yFIhB6cp7Zx8q9icLi8Xi7k6qqibw/HK1oFlRYLax1xildPLrmJurAw33jEQmDLAlVq8TQmh5mwf98+MMBlA72SAASbE1YZe5sU02Io0iE8WPoraGo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828990; c=relaxed/simple;
	bh=BWS15MH46rl47Tx14Fx2r5O1X3YIlYgmNOzbPS5y5y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qj52RdBR8Bo0ggRpFdb7ufLw49/7NGo0+QiQjAXTEdewudtvDSalvmobtzrgQSkmtk0OiW0X65Rryj5/MDCqJDGMV6fmuPmMmi7V4IyUfEOf4JvDaNR4DwY9f4tNMDomOjo9Tw/T9rLYgO1+V+74kz/07dj+bL/PSmq8k7jgK4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/6lYh0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/6lYh0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32971F00893;
	Sun,  7 Jun 2026 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828989;
	bh=n+/3iZyy1+sQvwXs4vO+/W5l9BU14CexKYXFY3WwQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/6lYh0QcVlxJwjHB+rASPok2YUHt4lkzNUDuloJmYeQifWr5sqVutY5uoflJuVXY
	 l5g4VyKL6A7vTEVUZwRHZCiY1ZVR2/I4453H9MhXUgQfISFdVyrkccZ19nuhC1X4wv
	 yAbfKgEJXX/q3KesmFdpM+ekFs3zl8BhMx36rf34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 232/332] ASoC: qcom: q6asm-dai: do not set stream state in event and trigger callbacks
Date: Sun,  7 Jun 2026 12:00:01 +0200
Message-ID: <20260607095736.572628542@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 	case ASM_CLIENT_EVENT_CMD_RUN_DONE:
 		break;
 	case ASM_CLIENT_EVENT_CMD_EOS_DONE:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		break;
 	case ASM_CLIENT_EVENT_DATA_WRITE_DONE: {
 		snd_pcm_period_elapsed(substream);
@@ -349,7 +348,6 @@ static int q6asm_dai_trigger(struct snd_
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;
@@ -563,8 +561,6 @@ static void compress_event_handler(uint3
 			snd_compr_drain_notify(prtd->cstream);
 			prtd->notify_on_drain = false;
 
-		} else {
-			prtd->state = Q6ASM_STREAM_STOPPED;
 		}
 		break;
 
@@ -1022,7 +1018,6 @@ static int q6asm_dai_compr_trigger(struc
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;


