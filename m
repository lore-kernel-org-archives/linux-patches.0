Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A98303CBF;
	Sat, 25 Oct 2025 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408741; cv=none; b=k+tVxdOnf4N1iZtWnl59WpIvq9xEnGxbbJ9i1TyE0U0mPKEfhWjkah86IWVWBHg9ghEtkELjzWDqt9vGE8j/DGm2Cb8Cbi9bqyRZwjnuzmiQX8RYfOojenoR0IxUC546FGHw3Hh6Edjmai/J/LuVFO9ZWSpihRVdwNBsobb/9bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408741; c=relaxed/simple;
	bh=pMl37ApY9q1oEO6GNHOOwSnbQfDdDTupMqIbpjuHO4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGR4CCxzfjuJNn3oDo5+wO8nF7zpzqWgGYLN158Fs5xzN3SIr/Ra+3r39G4s51b0tfGvrnm+85/06qG7g+Cbc7MNzMPEdQZ2djEoldYP6vIq0o7mNtmPv9mrupCduM7AoTOUxzyJhWLO0jE/NAKO5RsJBTOb53RZiQrbDPKI0Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byyL3RE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byyL3RE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124C3C4CEFB;
	Sat, 25 Oct 2025 16:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408740;
	bh=pMl37ApY9q1oEO6GNHOOwSnbQfDdDTupMqIbpjuHO4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byyL3RE9L3uonpmfM2JzTZiZph8Dx0+gMnRELwXKSUqgD8Xzl13j1hX2SUE8r3gP6
	 Nt2pqA7tcBsdsC1ZWYCMBZVLhpm2y1b6Bol5lmHOly8wl3yoyqgsErmgmQz3hHVs8J
	 doPBJ92fL9sqf7ADKqwhvdwxSQ/FDvY0gPEBFvfT1mlS3Zxk/dgXMHNuJNovPihddE
	 eJaagDLRKjidJe83QikjSI5UR31UvPGWipN0ADe1rAI7Te0A2Fx+hljIFWOEoqo2/0
	 gAMO6xuQ/2nu/kE3uZ7XxsilflLWrwx3N3IsYSGf/Iky9GRGT67e6l56YsWDQJ+67L
	 3Ldqvk5SiMEjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-5.15] ALSA: seq: Fix KCSAN data-race warning at snd_seq_fifo_poll_wait()
Date: Sat, 25 Oct 2025 11:54:51 -0400
Message-ID: <20251025160905.3857885-60-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1f9fc89cbbe8a7a8648ea2f827f7d8590e62e52c ]

snd_seq_fifo_poll_wait() evaluates f->cells without locking after
poll_wait(), and KCSAN doesn't like it as it appears to be a
data-race.  Although this doesn't matter much in practice as the value
is volatile, it's still better to address it for the mind piece.

Wrap it with f->lock spinlock for avoiding the potential data race.

Reported-by: syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c3dbc239259940ededba
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The only runtime change wraps the `f->cells` check in
  `snd_seq_fifo_poll_wait()` with `guard(spinlock_irq)(&f->lock)`
  (`sound/core/seq/seq_fifo.c:213`), aligning this reader with every
  writer of `f->cells`, each of which already holds `f->lock` via
  `scoped_guard(spinlock_irqsave)` or explicit `spin_lock_irqsave`
  (`sound/core/seq/seq_fifo.c:125`, `sound/core/seq/seq_fifo.c:183`).
  That removes the unlocked load which KCSAN flagged as a real data race
  on the non-atomic `int` counter.
- This race is user-visible: if `snd_seq_fifo_poll_wait()` races with a
  concurrent producer/consumer, the poll mask built in `snd_seq_poll()`
  (`sound/core/seq/seq_clientmgr.c:1092-1106`) can sporadically omit
  `EPOLLIN`, leaving sequencer clients to sleep despite queued events.
  On weakly ordered architectures that behavior is not just theoretical;
  racing non-atomic accesses are undefined in the kernel memory model
  and trigger syzbot reports.
- The fix is minimal, self-contained, and mirrors existing guard usage
  in this file, so it has negligible regression risk: the lock is
  already part of the FIFO hot path, RAII unlock occurs immediately on
  return, and there are no new dependencies or API changes.
- Because the bug allows incorrect poll readiness and trips KCSAN, it
  meets stable criteria (user-visible correctness plus sanitizer
  warning) and applies cleanly to older trees that already contain the
  guard helpers used elsewhere in this file.

Suggested next step: run the targeted ALSA sequencer poll tests (or
reproducer from the linked syzbot report) on the backport branch to
confirm the warning disappears.

 sound/core/seq/seq_fifo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
index 3a10b081f129c..7dc2bd94cefc3 100644
--- a/sound/core/seq/seq_fifo.c
+++ b/sound/core/seq/seq_fifo.c
@@ -213,6 +213,7 @@ int snd_seq_fifo_poll_wait(struct snd_seq_fifo *f, struct file *file,
 			   poll_table *wait)
 {
 	poll_wait(file, &f->input_sleep, wait);
+	guard(spinlock_irq)(&f->lock);
 	return (f->cells > 0);
 }
 
-- 
2.51.0

