Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40514385D85;
	Tue, 12 May 2026 17:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607831; cv=none; b=mr8jbWSSfo7PkLAtQvxHp0YXqgw+aeyZeV9DV0bwMGCCXlERD4VOg5TD3OpY3h2R72Q9UT7mwQG4Vl2ERcFTVASoDf2xO/yzXF0RMBZ36ciVEMhmDK2cV9gh6IPwARv+9KpmKEV8QQXWVFDYyJiA/KSQJphMorK+2TlNAYfBMcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607831; c=relaxed/simple;
	bh=8KypxVgL7vEVaHNdawDxnzxB4KrVOx2IgBt0iCzlM7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQ5KKgEHbiBC9mYe4X/tbHaPwilz+k6YAysAx1F0Q4iHd7SvmIG43X9ZCi2CNlfi5CMSCIzjq8Gi4Wa4p4L01E5o0OlfVcMxxcFcNMFpZdjV3/wYdeo7bAuLg/DLheFoYJ3JLRdokIi3vbA3QnbzT+C7FRIsYKbYWEFAZp75arI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZ1fgxeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZ1fgxeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2849C2BCC7;
	Tue, 12 May 2026 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607831;
	bh=8KypxVgL7vEVaHNdawDxnzxB4KrVOx2IgBt0iCzlM7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZ1fgxeGWSeklchOLTcVYpp0D7XEPoS33TIl8UrA8D1DTU/UctBhUIXqprwtZ8WjJ
	 Z79KNMG9l9W7lYO5esiNa/i8n9HzZlBYJO5YelHPjj20dqw/3JDMDLwDE84Jn4HpCy
	 2pht4tYiFn8LErgq7q6N1UWktSSDfJ3nN9d1WSpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>
Subject: [PATCH 6.12 050/206] ALSA: pcm: oss: Fix data race at accessing runtime.oss.trigger
Date: Tue, 12 May 2026 19:38:22 +0200
Message-ID: <20260512173933.896661367@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 901ac0ff15edf9503162e2cf6579bd11a30f1ed4 upstream.

Currently the runtime.oss.trigger field may be accessed concurrently
without protection, which may lead to the data race.  And, in this
case, it may lead to more severe problem because it's a bit field; as
writing the data, it may overwrite other bit fields as well, which
confuses the operation completely, as spotted by fuzzing.

Fix it by covering runtime.oss.trigger bit fled also with the existing
params_lock mutex in both snd_pcm_oss_get_trigger() and
snd_pcm_oss_poll().

Reported-and-tested-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Closes: https://lore.kernel.org/20260423145330.210035-1-jjy600901@snu.ac.kr
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260424112205.123703-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/pcm_oss.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2147,10 +2147,16 @@ static int snd_pcm_oss_get_trigger(struc
 
 	psubstream = pcm_oss_file->streams[SNDRV_PCM_STREAM_PLAYBACK];
 	csubstream = pcm_oss_file->streams[SNDRV_PCM_STREAM_CAPTURE];
-	if (psubstream && psubstream->runtime && psubstream->runtime->oss.trigger)
-		result |= PCM_ENABLE_OUTPUT;
-	if (csubstream && csubstream->runtime && csubstream->runtime->oss.trigger)
-		result |= PCM_ENABLE_INPUT;
+	if (psubstream && psubstream->runtime) {
+		guard(mutex)(&psubstream->runtime->oss.params_lock);
+		if (psubstream->runtime->oss.trigger)
+			result |= PCM_ENABLE_OUTPUT;
+	}
+	if (csubstream && csubstream->runtime) {
+		guard(mutex)(&csubstream->runtime->oss.params_lock);
+		if (csubstream->runtime->oss.trigger)
+			result |= PCM_ENABLE_INPUT;
+	}
 	return result;
 }
 
@@ -2824,6 +2830,17 @@ static int snd_pcm_oss_capture_ready(str
 						runtime->oss.period_frames;
 }
 
+static bool need_input_retrigger(struct snd_pcm_runtime *runtime)
+{
+	bool ret;
+
+	guard(mutex)(&runtime->oss.params_lock);
+	ret = runtime->oss.trigger;
+	if (ret)
+		runtime->oss.trigger = 0;
+	return ret;
+}
+
 static __poll_t snd_pcm_oss_poll(struct file *file, poll_table * wait)
 {
 	struct snd_pcm_oss_file *pcm_oss_file;
@@ -2856,11 +2873,11 @@ static __poll_t snd_pcm_oss_poll(struct
 			    snd_pcm_oss_capture_ready(csubstream))
 				mask |= EPOLLIN | EPOLLRDNORM;
 		}
-		if (ostate != SNDRV_PCM_STATE_RUNNING && runtime->oss.trigger) {
+		if (ostate != SNDRV_PCM_STATE_RUNNING &&
+		    need_input_retrigger(runtime)) {
 			struct snd_pcm_oss_file ofile;
 			memset(&ofile, 0, sizeof(ofile));
 			ofile.streams[SNDRV_PCM_STREAM_CAPTURE] = pcm_oss_file->streams[SNDRV_PCM_STREAM_CAPTURE];
-			runtime->oss.trigger = 0;
 			snd_pcm_oss_set_trigger(&ofile, PCM_ENABLE_INPUT);
 		}
 	}


