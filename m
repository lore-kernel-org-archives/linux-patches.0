Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667E33D091A;
	Tue, 16 Jun 2026 18:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633548; cv=none; b=b+C5ZkqQM0P7Qg6OeRyaq7qcvXt+T7xvVPgpsVxzdcCulqCB/BOuuuqzl9eaX1h9juZ4v5rSa8t6jNuIE29Q0heO2kyVVIpgoSMg+o//N5VO8I3FyMQ14GALNTbHOYLZ+Ow6QvnJZl6GCSsyibmqJsCNF5DJM/4K+GB1QIuPDaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633548; c=relaxed/simple;
	bh=u4yUzLj7BI/uVtNl305jspyoVAt5tZibJmytGYEMdWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqyI28BoLHOEPbFdJYWulXBB8A4IMR2ClZM3ogmdRmfVn7YRnJqmrLN1TEXo6YNAQT48usw71Su5yHmUGDV5TR3fKmulsdwUaVNXD/vK4uR8jZoI3+ZvryYDr4HU5du6Bpv4agMYiNhd+jogiXIYL3tedKHwvJwAD4/W1+UhMj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lryeAG7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lryeAG7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A7C1F000E9;
	Tue, 16 Jun 2026 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633547;
	bh=6YqYJoSq4K2mRexNVEJdl7r0wlR/rpDOzszFRiXWeRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lryeAG7OYJehxwVMOA5y3TincI+3wxtcMN60FgQn/aTcGmjhDmwS12vUBxgjVPKfm
	 j2uJ99uh1lzDWBzeFGOdGSe2pPbjs2NUnFp9Ou5g4hVASjnnKdHWQy8H9ol4Y2h0k2
	 tHogpWpbacxM00e2bKtfa9Qq9/X+NpBT+LFNxMeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 100/411] ASoC: qcom: q6asm-dai: do not set stream state in event and trigger callbacks
Date: Tue, 16 Jun 2026 20:25:38 +0530
Message-ID: <20260616145105.547195091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


