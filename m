Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7223EDE67;
	Tue, 12 May 2026 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609059; cv=none; b=ofAzpLPrd06kORcmRERUxVu+eq8T6qAIDJv3BhLNocrsZ9OD/FGmurd5nawVhiXcXe7jf6ZhL23RwaNLb1CfWCv9gsgLjoL7+Ukcf1c8i70I9wR4L3q8unRgQFpCLuW7fs5CHx1CQ4jGrmgZZN9UOjKLekoy1BXb8wP3ScOFucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609059; c=relaxed/simple;
	bh=a9PEQTegKRhOL17JPoKgReR0qyvAiaPo6NpEBhcD0LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gk+uZE5VKYHTfjgwWFKqZjn8iM01GM47abAhFKkQY/Fb923P3xFeH2NxezeioSoPzNIqa5kJ1Q4sCBCcYgnmmmB/61lXnTDbFG/Qp5XVBsU1LptPAsvVbqUm/U7qMHfZhYHa0Ax9yOTokZyUJmS3MSfNW9PDllJTXb06NpuOXmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Of+k08T4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Of+k08T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9667C2BCB0;
	Tue, 12 May 2026 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609059;
	bh=a9PEQTegKRhOL17JPoKgReR0qyvAiaPo6NpEBhcD0LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Of+k08T4bc2yAeaEZbV+S8dc6drHmMJOHoy0WFI0RTeAgzEdcP4A3jpjFoOLiZWYG
	 F3a8+iRhk1Ctr9ORT0Sdhd1xgOuBsOFjfz3Lj56kbBkVvCrAQJqm+tMm0q1hUDWRrP
	 Upir9TWer1Vum48lo2nlfF49wwOkh79bnQ6+9b3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 049/307] ALSA: core: Serialize deferred fasync state checks
Date: Tue, 12 May 2026 19:37:24 +0200
Message-ID: <20260512173941.158794253@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 5337213381df578058e2e41da93cbd0e4639935f upstream.

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


