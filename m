Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82A3261588;
	Fri,  7 Nov 2025 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762526324; cv=none; b=ASh0fewbmjq0OdZqqqNvEb1H30Ib/keMR+apvbvL12YDlWKdcoa3AQ+ad0aWnAVJ3pMrOrcrqwdvbDRbO5/UmRMTU7w0Dy3qGqn5EBOYqAGlUIOXl54UK8pc5csiacSLCpoAiHelknz7bfLoNg1Ov5MCThleiSzCKnCcaws2rNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762526324; c=relaxed/simple;
	bh=so4gfNSYqIzhDfeimFIQKyBgFhD4Jyl0pWhIEM8LbvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvTBeio26UJiWOL/GOzti5eiQcqWCDgv5zNMwf0y0aIp+HMKPFniirFCHkZVkfsWTTT2qOq2QCpqUTa/Ce3VzY/KPPfpBYRVvhlGEVQtTMvCeDWaOwX7yzSb93J1CAILD1CCzDNhVB/M0wtC4rqRncfFrmKaAJEhgeMgI4GzBJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Drs7e/FB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Drs7e/FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCA9C4CEF5;
	Fri,  7 Nov 2025 14:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762526324;
	bh=so4gfNSYqIzhDfeimFIQKyBgFhD4Jyl0pWhIEM8LbvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Drs7e/FBrjH2ENxd86AVQdspdQcVTxSWQ1R7B+l8hKNnekm7X/WBFkPkGI/UxQJNg
	 IY4iVCnHMaPwTmdeFIRMJIbPQFOTRJjfNQsYrSpnHrCdmOnJ9W5s1BPf12NETk5Bnk
	 cII53rGzGm1MDS/5i/J+XBQpHXn0buUlYiBwY99CVwe4Vg+i4LHAneaAi0jLUlYz6g
	 yKbjHbpN7MWY3xY5TLeFXONYXKdhrCKuNYcdQiP88YlC5Y8wgeVZYmkpAp/XKW6WZM
	 cSZboINLIXdLkxSF2rF7Z+DW36xP4DPCayRP+QlKuuub2BNSr23oEFaRqeu9nCpNGA
	 GMESL9VaVzFzQ==
Date: Fri, 7 Nov 2025 09:38:43 -0500
From: Sasha Levin <sashal@kernel.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>,
	syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com,
	alexandre.f.demers@gmail.com, alexander.deucher@amd.com
Subject: Re: [PATCH AUTOSEL 6.17-5.15] ALSA: seq: Fix KCSAN data-race warning
 at snd_seq_fifo_poll_wait()
Message-ID: <aQ4Ec03iLOg23_hd@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-60-sashal@kernel.org>
 <4f94b13f-e1f8-49bc-b0c7-bcc3eed5cca9@pobox.com>
 <aQyxGrttI4OERR96@laps>
 <36f043b1-c27a-4b93-b9ed-c5a3691ba639@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36f043b1-c27a-4b93-b9ed-c5a3691ba639@pobox.com>

On Thu, Nov 06, 2025 at 03:57:33PM -0800, Barry K. Nathan wrote:
>On 11/6/25 06:30, Sasha Levin wrote:
>>On Thu, Nov 06, 2025 at 12:49:37AM -0800, Barry K. Nathan wrote:
>>>On 10/25/25 08:54, Sasha Levin wrote:
>>>>From: Takashi Iwai <tiwai@suse.de>
>>>>
>>>>[ Upstream commit 1f9fc89cbbe8a7a8648ea2f827f7d8590e62e52c ]
>>>>
>>>>snd_seq_fifo_poll_wait() evaluates f->cells without locking after
>>>>poll_wait(), and KCSAN doesn't like it as it appears to be a
>>>>data-race.  Although this doesn't matter much in practice as the value
>>>>is volatile, it's still better to address it for the mind piece.
>>>>
>>>>Wrap it with f->lock spinlock for avoiding the potential data race.
>>>>
>>>>Reported-by: syzbot+c3dbc239259940ededba@syzkaller.appspotmail.com
>>>>Link: https://syzkaller.appspot.com/bug?extid=c3dbc239259940ededba
>>>>Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>---
>>>>
>>>>LLM Generated explanations, may be completely bogus:
>>>>
>>>>YES
>>>>- The only runtime change wraps the `f->cells` check in
>>>>  `snd_seq_fifo_poll_wait()` with `guard(spinlock_irq)(&f->lock)`
>>>>  (`sound/core/seq/seq_fifo.c:213`), aligning this reader with every
>>>>  writer of `f->cells`, each of which already holds `f->lock` via
>>>>  `scoped_guard(spinlock_irqsave)` or explicit `spin_lock_irqsave`
>>>>  (`sound/core/seq/seq_fifo.c:125`, `sound/core/seq/seq_fifo.c:183`).
>>>>  That removes the unlocked load which KCSAN flagged as a real data race
>>>>  on the non-atomic `int` counter.
>>>>- This race is user-visible: if `snd_seq_fifo_poll_wait()` races with a
>>>>  concurrent producer/consumer, the poll mask built in `snd_seq_poll()`
>>>>  (`sound/core/seq/seq_clientmgr.c:1092-1106`) can sporadically omit
>>>>  `EPOLLIN`, leaving sequencer clients to sleep despite queued events.
>>>>  On weakly ordered architectures that behavior is not just theoretical;
>>>>  racing non-atomic accesses are undefined in the kernel memory model
>>>>  and trigger syzbot reports.
>>>>- The fix is minimal, self-contained, and mirrors existing guard usage
>>>>  in this file, so it has negligible regression risk: the lock is
>>>>  already part of the FIFO hot path, RAII unlock occurs immediately on
>>>>  return, and there are no new dependencies or API changes.
>>>>- Because the bug allows incorrect poll readiness and trips KCSAN, it
>>>>  meets stable criteria (user-visible correctness plus sanitizer
>>>>  warning) and applies cleanly to older trees that already contain the
>>>>  guard helpers used elsewhere in this file.
>>>>
>>>>Suggested next step: run the targeted ALSA sequencer poll tests (or
>>>>reproducer from the linked syzbot report) on the backport branch to
>>>>confirm the warning disappears.
>>>>
>>>> sound/core/seq/seq_fifo.c | 1 +
>>>> 1 file changed, 1 insertion(+)
>>>>
>>>>diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
>>>>index 3a10b081f129c..7dc2bd94cefc3 100644
>>>>--- a/sound/core/seq/seq_fifo.c
>>>>+++ b/sound/core/seq/seq_fifo.c
>>>>@@ -213,6 +213,7 @@ int snd_seq_fifo_poll_wait(struct 
>>>>snd_seq_fifo *f, struct file *file,
>>>>                poll_table *wait)
>>>> {
>>>>     poll_wait(file, &f->input_sleep, wait);
>>>>+    guard(spinlock_irq)(&f->lock);
>>>>     return (f->cells > 0);
>>>> }
>>>
>>>With CONFIG_WERROR enabled, 5.15.y fails to build for me now, and 
>>>it seems to be due to this patch introducing a new warning. This 
>>>is with Debian bookworm and its default gcc (12.2), building for 
>>>amd64. I didn't try building 6.12.y or 6.17.y yet, but this 
>>>warning does not happen on 6.1.y, 6.6.y, or 6.18-rc4.
>>
>>Have you manually applied this patch on top of 5.15? This patch 
>>isn't in any
>>released LTS kernel.
>>
>
>Yes, I cloned the stable-queue git repo then applied the queue-5.15 
>patches on top of 5.15.196. I figured I'd do some testing and try to 
>find and report problems prior to release. Once I ran into this 
>problem, I looked into it further and narrowed it down to this patch, 
>then I searched the stable mailing list archive to see if anyone else 
>reported it already or if the patch had been posted to the list. The 
>only relevant email I found was the patch itself, so that's what I 
>replied to.
>
>If I made any mistakes in how I reported this, or if I jumped the gun 
>and should've waited until 5.15.197-rc1 before reporting anything, 
>please let me know. (Maybe I should have explicitly mentioned that the 
>patch is present in the queue as 
>"alsa-seq-fix-kcsan-data-race-warning-at-snd_seq_fifo.patch"?)

No, you did all the right things, it just so very rare to see that :)

I've dropped that patch from all branches.

Thanks for your review!

-- 
Thanks,
Sasha
