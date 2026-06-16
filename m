Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B721C16A;
	Tue, 16 Jun 2026 17:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631834; cv=none; b=DbVrAYRe+Bej+ZX0F9H0oF+Y48DIyNBTMa2Itrxvnby65gu1qCl7dRbigA+nTYrKtex37IQy6Z+RNdCt1m4vDynisiX/lquW2FI9dT4so0XkqUhtIPZKU+S5LmoBLuf6inTHPBMup4KGiXCaI6z+1T5/0G4xwDaTTEWoTSGPwy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631834; c=relaxed/simple;
	bh=9kUoKrBR/yOIH66fAAzfkBp64jgmPVlwxsqL3uuhacE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch5ZT3Vp1+RHyGQHJzmuQXzps895CmviV9ih5GvEhtfxMAcz0eoKowA7R2yxD41gNoB+cRwCTMsJi/4dVh+UEooEJpe5KW52xG/AOjDujtXBGwOX65KNoRW7ayzs1kNPgcUJFZ8tx1lLCHFejBBIYBI3IP6WkXftuGtBTYu0mbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSPtfCIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSPtfCIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B681F000E9;
	Tue, 16 Jun 2026 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631832;
	bh=vVc26K62YwMzrwrBQZTvvBUwlTZfVJrMunY8XpbGDbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSPtfCIR2JwfBHjCILeRhzjjULjPaOtNpzMbdFtox5akmsAjPcXOZKDMBoWFeuZru
	 ScFr9XieviPJOAL2gsFBamJz/QURKUAF5Ts2ONFUDhnd2d73nwX1bxvOJLyr4ER3S7
	 unyuGd1QjEMrFZJfRr5NFOqHqagc7/n4PB1fSbW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 278/522] ALSA: timer: Fix UAF at snd_timer_user_params()
Date: Tue, 16 Jun 2026 20:27:05 +0530
Message-ID: <20260616145138.955648117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


