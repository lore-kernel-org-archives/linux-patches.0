Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E796E1774B;
	Thu, 18 Jan 2024 10:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575330; cv=none; b=dU7RORo8gTRSO7FjktADtwRnPZZs0KAwzhqZjUGsw4JAvcAv187lxvP7lixcmoePmXZXnP7ldxFjVE5QMCiuFwfDKa3waAcZw0tbEp1fdtD9y/QxGB7XlDWTXmTQTKmaHRJKIkIhrTFZ57u/JuerKIkIZzFSu6AWxn6Cx5Ctoi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575330; c=relaxed/simple;
	bh=7VczybJS7d/aI1GZgoZ2DBQ/0Roz6sFuw5Y50euyrM8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=SrvS0d8sYvHumv0DPHWo48nQHCWoyeWoEUktYFQB6ApqzN+RFY1zjrvPfVa4so2CEvo41rlRTGQ8ElHn7fiEf3EuBOkqb7bcXcq4JHgzmUH+dsbWRY0WFIHm+qJo3QyvBjnTR0B/U9+jIjK0t+QAH+ZC6t7K7zUj7EkxsrMcJE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uC8fJ7bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uC8fJ7bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADC5C433C7;
	Thu, 18 Jan 2024 10:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575329;
	bh=7VczybJS7d/aI1GZgoZ2DBQ/0Roz6sFuw5Y50euyrM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uC8fJ7bzHR9oLzPf+f7+qbEvNAZMU2VAXRUuDpYuGCna7FnvYc9cvGJDcMv28tdlV
	 vsFq5Ko8kLCt5RGsk6rzIDJGvkqDpAooEyNFmXJtFfQp9AipWG0ZqRaQuhbOQjgFOz
	 AW0qdK6/qk+WJhMQTSi+VtDrheQuJDXPre+fBIzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/150] ALSA: pcmtest: stop timer before buffer is released
Date: Thu, 18 Jan 2024 11:48:06 +0100
Message-ID: <20240118104322.942028580@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit eb99b1b72a424a79f56c972e0fd7ad01fe93a008 ]

Stop timer in the 'trigger' and 'sync_stop' callbacks since we want
the timer to be stopped before the DMA buffer is released. Otherwise,
it could trigger a kernel panic in some circumstances, for instance
when the DMA buffer is already released but the timer callback is
still running.

Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Link: https://lore.kernel.org/r/20231206223211.12761-1-ivan.orlov0322@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index b59b78a09224..b8bff5522bce 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -397,7 +397,6 @@ static int snd_pcmtst_pcm_close(struct snd_pcm_substream *substream)
 	struct pcmtst_buf_iter *v_iter = substream->runtime->private_data;
 
 	timer_shutdown_sync(&v_iter->timer_instance);
-	v_iter->substream = NULL;
 	playback_capture_test = !v_iter->is_buf_corrupted;
 	kfree(v_iter);
 	return 0;
@@ -435,6 +434,7 @@ static int snd_pcmtst_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		// We can't call timer_shutdown_sync here, as it is forbidden to sleep here
 		v_iter->suspend = true;
+		timer_delete(&v_iter->timer_instance);
 		break;
 	}
 
@@ -512,12 +512,22 @@ static int snd_pcmtst_ioctl(struct snd_pcm_substream *substream, unsigned int cm
 	return snd_pcm_lib_ioctl(substream, cmd, arg);
 }
 
+static int snd_pcmtst_sync_stop(struct snd_pcm_substream *substream)
+{
+	struct pcmtst_buf_iter *v_iter = substream->runtime->private_data;
+
+	timer_delete_sync(&v_iter->timer_instance);
+
+	return 0;
+}
+
 static const struct snd_pcm_ops snd_pcmtst_playback_ops = {
 	.open =		snd_pcmtst_pcm_open,
 	.close =	snd_pcmtst_pcm_close,
 	.trigger =	snd_pcmtst_pcm_trigger,
 	.hw_params =	snd_pcmtst_pcm_hw_params,
 	.ioctl =	snd_pcmtst_ioctl,
+	.sync_stop =	snd_pcmtst_sync_stop,
 	.hw_free =	snd_pcmtst_pcm_hw_free,
 	.prepare =	snd_pcmtst_pcm_prepare,
 	.pointer =	snd_pcmtst_pcm_pointer,
@@ -530,6 +540,7 @@ static const struct snd_pcm_ops snd_pcmtst_capture_ops = {
 	.hw_params =	snd_pcmtst_pcm_hw_params,
 	.hw_free =	snd_pcmtst_pcm_hw_free,
 	.ioctl =	snd_pcmtst_ioctl,
+	.sync_stop =	snd_pcmtst_sync_stop,
 	.prepare =	snd_pcmtst_pcm_prepare,
 	.pointer =	snd_pcmtst_pcm_pointer,
 };
-- 
2.43.0



