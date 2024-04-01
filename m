Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7368D47A5D;
	Mon,  1 Apr 2024 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991344; cv=none; b=PIh/h8g8TFFv/IxpMDeVHvv0bsKZfDkGnqsym1SSM5v/Qaea5C0AiNH3EA5fMvJpHPtpn2/Uh7ZZFW/N3E04uS3W5/7vLg4A6CeI9I0YxIyXsM0CjGhXBY8pI2bKFwsytk/JAYPShNLoXK0+1q9i7qeZapCNXA7LAHFBIXZfT98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991344; c=relaxed/simple;
	bh=6AMjOB5BwPyeXc3q0yTIdA0kNjf7PBNs9ZqYnDqML2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USqEW+vELaxcpdW9x1WwKBHltBmF6DW159R94LADPJVE7HKuD4707JIfS4sKdv69cH6jeva1DxeJgQsvvkM0W7+3+nVg9p+Ij2o8NRNWktCbZMD4i8mE7LH6c5wVo8QmniMLAXy2GBXX9p/pFMN34xuttrBbheBfifYsuTDaZpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEurqE/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEurqE/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FA2C433C7;
	Mon,  1 Apr 2024 17:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991344;
	bh=6AMjOB5BwPyeXc3q0yTIdA0kNjf7PBNs9ZqYnDqML2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEurqE/EXXpWGdAgreqf0JOojbGwBiqPF7Gs0Lgd47TmqEn+UxAAx7Uy6T+v75+Xp
	 b64eDgcuU4Ybcjtv39v2cyYw6Gp5JhcX5GW9X68FlSUJfJ36k6zheyJLwQdj0c6dkO
	 XqC3TbYlA9NBWuKdyhbAmtLJS5Idp5eAiVF101qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.1 236/272] ALSA: sh: aica: reorder cleanup operations to avoid UAF bugs
Date: Mon,  1 Apr 2024 17:47:06 +0200
Message-ID: <20240401152538.342706487@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit 051e0840ffa8ab25554d6b14b62c9ab9e4901457 upstream.

The dreamcastcard->timer could schedule the spu_dma_work and the
spu_dma_work could also arm the dreamcastcard->timer.

When the snd_pcm_substream is closing, the aica_channel will be
deallocated. But it could still be dereferenced in the worker
thread. The reason is that del_timer() will return directly
regardless of whether the timer handler is running or not and
the worker could be rescheduled in the timer handler. As a result,
the UAF bug will happen. The racy situation is shown below:

      (Thread 1)                 |      (Thread 2)
snd_aicapcm_pcm_close()          |
 ...                             |  run_spu_dma() //worker
                                 |    mod_timer()
  flush_work()                   |
  del_timer()                    |  aica_period_elapsed() //timer
  kfree(dreamcastcard->channel)  |    schedule_work()
                                 |  run_spu_dma() //worker
  ...                            |    dreamcastcard->channel-> //USE

In order to mitigate this bug and other possible corner cases,
call mod_timer() conditionally in run_spu_dma(), then implement
PCM sync_stop op to cancel both the timer and worker. The sync_stop
op will be called from PCM core appropriately when needed.

Fixes: 198de43d758c ("[ALSA] Add ALSA support for the SEGA Dreamcast PCM device")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Message-ID: <20240326094238.95442-1-duoming@zju.edu.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/sh/aica.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -278,7 +278,8 @@ static void run_spu_dma(struct work_stru
 		dreamcastcard->clicks++;
 		if (unlikely(dreamcastcard->clicks >= AICA_PERIOD_NUMBER))
 			dreamcastcard->clicks %= AICA_PERIOD_NUMBER;
-		mod_timer(&dreamcastcard->timer, jiffies + 1);
+		if (snd_pcm_running(dreamcastcard->substream))
+			mod_timer(&dreamcastcard->timer, jiffies + 1);
 	}
 }
 
@@ -290,6 +291,8 @@ static void aica_period_elapsed(struct t
 	/*timer function - so cannot sleep */
 	int play_period;
 	struct snd_pcm_runtime *runtime;
+	if (!snd_pcm_running(substream))
+		return;
 	runtime = substream->runtime;
 	dreamcastcard = substream->pcm->private_data;
 	/* Have we played out an additional period? */
@@ -350,12 +353,19 @@ static int snd_aicapcm_pcm_open(struct s
 	return 0;
 }
 
+static int snd_aicapcm_pcm_sync_stop(struct snd_pcm_substream *substream)
+{
+	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
+
+	del_timer_sync(&dreamcastcard->timer);
+	cancel_work_sync(&dreamcastcard->spu_dma_work);
+	return 0;
+}
+
 static int snd_aicapcm_pcm_close(struct snd_pcm_substream
 				 *substream)
 {
 	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
-	flush_work(&(dreamcastcard->spu_dma_work));
-	del_timer(&dreamcastcard->timer);
 	dreamcastcard->substream = NULL;
 	kfree(dreamcastcard->channel);
 	spu_disable();
@@ -401,6 +411,7 @@ static const struct snd_pcm_ops snd_aica
 	.prepare = snd_aicapcm_pcm_prepare,
 	.trigger = snd_aicapcm_pcm_trigger,
 	.pointer = snd_aicapcm_pcm_pointer,
+	.sync_stop = snd_aicapcm_pcm_sync_stop,
 };
 
 /* TO DO: set up to handle more than one pcm instance */


