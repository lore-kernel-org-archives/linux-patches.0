Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E01945348A;
	Tue, 16 Jun 2026 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628678; cv=none; b=jjmlVfJTdsUiQcsH7uStfct5k3zQ1V+yiafsx58jVLbqn5k4UJXzc8OFxmZRz4B9Ys4NKH4yAoMD4zxwZR+5Dh9CimLJ+zBhrVUAieGLrS7DNFSoWFabf7djdOVeb/8NQzl2EzNLxf+NNg87rhWUJ9dFHfEgAhld78lAXKQWlpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628678; c=relaxed/simple;
	bh=9wqC5REJF4EIsVUPOT0VEZGD9k8MC/Rix0lb8Hrngmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNgFhEdxleaCvfKOXrrx/Qi9rgBedxsN1LPngcuQ4f967Ug5qY2nERsdqxy3yECdbBxHi17Pi7EWhefyJdza7+Ub4Tv2DVOobYHOwI5JOi6bLP4uzT7jfo9BRe8kLhqpl7cR4tyKBWpy3AfKZJ/bWCk3iwgZZ+LScnjBxINiCGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUu7hK+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUu7hK+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437521F000E9;
	Tue, 16 Jun 2026 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628677;
	bh=Sy64DeKnawFuMh2EFTH2hooo964bDYO2fkDEhz+z2mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUu7hK+I/J9bOzUjD2GdXqUeM7U14GLlxWKEGjOmyLATIVENO++3PvNFUlLdUn+/7
	 J2WDne4izfUvw7P+VBMQgaun5rM5yxskoFVotvoSCRPkQhlqgQZ4XZs1zfdje8wgiD
	 r3aoeB6si0WK6nCKIECo1Qpeq70i/uSj5CJNRaCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 140/452] ASoC: qcom: q6asm-dai: do not set stream state in event and trigger callbacks
Date: Tue, 16 Jun 2026 20:26:07 +0530
Message-ID: <20260616145125.073424121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -191,7 +191,6 @@ static void event_handler(uint32_t opcod
 				   prtd->pcm_count, 0, 0, 0);
 		break;
 	case ASM_CLIENT_EVENT_CMD_EOS_DONE:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		break;
 	case ASM_CLIENT_EVENT_DATA_WRITE_DONE: {
 		prtd->pcm_irq_pos += prtd->pcm_count;
@@ -338,7 +337,6 @@ static int q6asm_dai_trigger(struct snd_
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;
@@ -554,8 +552,6 @@ static void compress_event_handler(uint3
 			snd_compr_drain_notify(prtd->cstream);
 			prtd->notify_on_drain = false;
 
-		} else {
-			prtd->state = Q6ASM_STREAM_STOPPED;
 		}
 		spin_unlock_irqrestore(&prtd->lock, flags);
 		break;
@@ -1018,7 +1014,6 @@ static int q6asm_dai_compr_trigger(struc
 				       0, 0, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		prtd->state = Q6ASM_STREAM_STOPPED;
 		ret = q6asm_cmd_nowait(prtd->audio_client, prtd->stream_id,
 				       CMD_EOS);
 		break;


