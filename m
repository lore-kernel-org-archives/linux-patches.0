Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DBE32D43C;
	Sat, 12 Sep 2026 18:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237675; cv=none; b=iuT4fCHjliQGV7PPDS6cTBiOZLeFpJvhwLUaTY3dWR7Q3iUIqGq12qyVmeSoLxg0/GmPBvdrDitxm8+hIrXSoXjmiQK49wDkpFt/Irs+4g8vAfCiffgDWBEZ3Xfm3xlqIaDwujgkgjnv+UfWcHU45T/6bVSFMmiETxub7BKVb7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237675; c=relaxed/simple;
	bh=XODJPCsLMzDVGsyB5tW7lfwwSJS0a6gvmbeIOxr9lxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfTVkRhLgWQyzrR1wpD+53fNymdt/RXs0G+PCInDm9OWbW5oozIhNqMG3ny+DrchfrHHIBRLiHj/KK0IoC25mexGJI48uCb5I5FPFpI55SK2eBREg09ptTf+Q/5ZPOSAdh0fbOE3oMNKeoRXKkEiDQfpoDN7/Vwr/ljo9p4D738=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xKwBcaT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xKwBcaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8661F000FF;
	Sat, 12 Sep 2026 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237673;
	bh=KYyrNLHyAUWGuRdneAwk0Zm0hVK7w49iyWxvMSrPlxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xKwBcaTUwuS4xbANXJbqvgi9QY2vmH7rK4MCAIc6qoC8Fg3bvRXra01aT6nlWAaP
	 vAgo1v4Jr2W2AlK8l9E3H1oiSmkbmRwdrbz0nUqlNiQCOR0GZoXmJ++TfQFxEaZibw
	 /mh3yQ9pPABZSOjcRjrD2sufJ3ytnq9EaARbVrmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+225231fce6755d40d078@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 263/935] ALSA: pcm: Fix race between non-atomic ops and trigger-start
Date: Sat, 12 Sep 2026 08:54:53 +0200
Message-ID: <20260912065532.856738744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit acac7b5e07349a9d10d78873afb4b93cd1dc721f upstream.

We protect the races of the concurrent state transitions between
atomic PCM ops, but the checks between the non-atomic ops (hw_params,
hw_free and prepare) and the atomic ops aren't perfect; there is a
check of the conflicting PCM state at the beginning of hw_params & co,
but the atomic PCM ops can be still issued during the non-atomic PCM
operations.  An example such scenario is that a thread A re-issues the
PREPARE or HW_PARAMS for the already prepared stream, while another
thread B triggers the PCM start in the middle of the prepare
operation.  Although this usually doesn't lead to much serious issues,
it can give some inconsistency as reported by syzkaller (such as
ODEBUG warning).

There are various atomic PCM ops, and basically the only problem is
the PCM start as it operates from the PREPARED state.  Other trigger
commands (stop, etc) are for the running or the other special state,
hence they are filtered as pre-condition.

This patch is for preventing the PCM trigger-start during the non-
atomic operations in order to address the problems above.
Fortunately, the hw_params, hw_free and prepare operations call
snd_pcm_buffer_access_lock(), and this can be used for checking the
concurrent operations at the PCM trigger -- which sets the
runtime->buffer_accessing to a negative (if possible), so the PCM
trigger just needs to check the runtime->buffer_accessing value; if
it's negative, it means the concurrent non-atomic PCM ops is running.

Reported-by: syzbot+225231fce6755d40d078@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6a8f0de8.1d9ded08.62e62.00b5.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260828115542.3999-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1430,6 +1430,8 @@ static int snd_pcm_pre_start(struct snd_
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	if (runtime->state != SNDRV_PCM_STATE_PREPARED)
 		return -EBADFD;
+	if (atomic_read(&runtime->buffer_accessing) < 0)
+		return -EBADFD; /* during hw_params, hw_free or prepare */
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
 	    !snd_pcm_playback_data(substream))
 		return -EPIPE;


