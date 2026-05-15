Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9829A3FF1D8;
	Fri, 15 May 2026 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860526; cv=none; b=t+DfqcZz2L1ZV8vzlTJ7VZ3ThV74tKIMi2Bq8o/ds0PEgURfhEefNcyXPv8VrlBJm5KTI7CK5ZIFdJfeXaGDSYetHeu5LcS8Wm6kF2gzYfRAyQv7a7Sw8auKV4gU27oxmLCQ7tj/zdoLuYyEaPviVYPTjbX3RaFxhbFG46wjM+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860526; c=relaxed/simple;
	bh=n2n7+5f37GgL6+n0ARpb0PZwnEYXRs25R1lYABV5nYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ltH5sNo75AsKssABVHI4VdyirYQVIsTuhbCTzwGxIi3XrRXpGpg4AsIxnImvbSDskyoWT9KKWunjEQNoK4ZfAziNR71R52ygw3LiQ/BmSXv51hqJvV7drFqDofiOJ3CZhRDH87o1s1OeOAE26Z2+y6UWSo2Llw295mlGwuzrzd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVkZSNZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVkZSNZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E16CC2BCB0;
	Fri, 15 May 2026 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860526;
	bh=n2n7+5f37GgL6+n0ARpb0PZwnEYXRs25R1lYABV5nYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVkZSNZQI1xKPLHCz0mt1qOmFGAc8dFuJklKHxJLGqDyfislHWMS+DPMbQ6E2A5nj
	 ZqHS/Ip9svqe7vTUzAweqi8cs6BAka55F1wZHNtpkusEovSZM3eaUZ3BO6dPC3t3cM
	 rzQkt148Tup0WD/wwIfoeRIcFMG2OMpqq4StSeiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/144] ALSA: core: Serialize deferred fasync state checks
Date: Fri, 15 May 2026 17:48:52 +0200
Message-ID: <20260515154655.952307598@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 5337213381df578058e2e41da93cbd0e4639935f ]

snd_fasync_helper() updates fasync->on under snd_fasync_lock, and
snd_fasync_work_fn() now also evaluates fasync->on under the same
lock. snd_kill_fasync() still tests the flag before taking the lock,
leaving an unsynchronized read against FASYNC enable/disable updates.

Move the enabled-state check into the locked section.

Also clear fasync->on under snd_fasync_lock in snd_fasync_free()
before unlinking the pending entry. Together with the locked sender-side
check, this publishes teardown before flushing the deferred work and
prevents a racing sender from requeueing the entry after free has
started.

Fixes: ef34a0ae7a26 ("ALSA: core: Add async signal helpers")
Fixes: 8146cd333d23 ("ALSA: core: Fix potential data race at fasync handling")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260506-alsa-core-fasync-on-lock-v1-1-ea48c77d6ca4@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/misc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -148,9 +148,11 @@ EXPORT_SYMBOL_GPL(snd_fasync_helper);
 
 void snd_kill_fasync(struct snd_fasync *fasync, int signal, int poll)
 {
-	if (!fasync || !fasync->on)
+	if (!fasync)
 		return;
 	guard(spinlock_irqsave)(&snd_fasync_lock);
+	if (!fasync->on)
+		return;
 	fasync->signal = signal;
 	fasync->poll = poll;
 	list_move(&fasync->list, &snd_fasync_list);
@@ -163,8 +165,10 @@ void snd_fasync_free(struct snd_fasync *
 	if (!fasync)
 		return;
 
-	scoped_guard(spinlock_irq, &snd_fasync_lock)
+	scoped_guard(spinlock_irq, &snd_fasync_lock) {
+		fasync->on = 0;
 		list_del_init(&fasync->list);
+	}
 
 	flush_work(&snd_fasync_work);
 	kfree(fasync);


