Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9CD3D810C;
	Tue, 16 Jun 2026 18:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636253; cv=none; b=pT7YQYeyeXqGU7/AX4TbV4OLJqb5LzNbxrQS8vELBR1VnSQInR07sFxEsQcvauELJJ4nw49arNbiX2BDbTN6cf0zQ6FkM2P829fBRUHxDa5ZiPXzwms8G7M1ifIoJDuNPcYxQOVJi5SnU519SWcs2JaCNWVMAg2R+CSec7655GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636253; c=relaxed/simple;
	bh=VWOJVLvt/3xD1CwIMiKdO3RUtoiU6km89cVmShzA+ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYhD2pTEUWC+cuZFXqj/0q134Fhvpv5xKy0x8hvHAMl0fsYga10M+omD7lsktOJ27scR3jM8M6pLXX5cQSjDIh/iGsmormTyeF2IDwaXbIUwiBvplgRTkqSmtwOPEb6dhwy1d7cy64v0LMsVgvmMhZd4wnqJLZoLOal+IIFmccE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5pF87xd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5pF87xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F281F000E9;
	Tue, 16 Jun 2026 18:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636252;
	bh=G0aNp/txeBm9vgzuI1d0fDWM9S1lnunkdh6wpAGmFjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5pF87xdEtvve+K5rKFcHr/DpMERUIHTRqi/l4nOmwFdUw1YstIwF0Kv95AGxJloN
	 yxJmDarCfrPf+/sieG/ojJ297M5jDYzubJywhL7xoW7YrqIMoUz0+FWFhCvNh7MAFV
	 Fy10nH4njOtCvi0GiR8IboYBC0N/DDiZ8qHkBPpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 186/342] ALSA: timer: Fix UAF at snd_timer_user_params()
Date: Tue, 16 Jun 2026 20:28:02 +0530
Message-ID: <20260616145056.846164724@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 053a401b592be424fea9d57c789f66cd5d8cec11 upstream.

At releasing a timer object, e.g. when a userspace timer
(CONFIG_SND_UTIMER) gets closed and snd_timer_free() is called, it
tries to detach the timer instances and release the resources.
However, it's still possible that other in-flight tasks are holding
the timer instance where the to-be-deleted timer object is associated,
and this may lead to racy accesses.

Fortunately, most of ioctls dealing with the timer instance list
already have the protection with register_mutex, and this also avoids
such races.  But, SNDRV_TIMER_IOCTL_PARAMS isn't protected, hence the
concurrent ioctl may lead to use-after-free.

This patch just adds the guard with register_mutex to protect
snd_timer_user_params() for covering the code path as a quick
workaround.  It's no hot-path but rather a rarely issued ioctl, so the
performance penalty doesn't matter.

Reported-by: Kyle Zeng <kylebot@openai.com>
Tested-by: Kyle Zeng <kylebot@openai.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260606161145.1933447-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1842,6 +1842,7 @@ static int snd_timer_user_params(struct
 	struct snd_timer *t;
 	int err;
 
+	guard(mutex)(&register_mutex);
 	tu = file->private_data;
 	if (!tu->timeri)
 		return -EBADFD;


