Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67597E
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 00:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508F6C385A1
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 00:19:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ri22dO4w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649204344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xxzjqX5zjzLBo9lliEEikr0oRvt6ogdQu6U4p96NT6I=;
	b=Ri22dO4w80q8gSd9GyoI+1EKHd22vyeABKfgsrL1DvAL8zKKYjWVmsg/MS/VbDkbraJ14y
	q2c516yzLY9nlmbwpoguO7yP4hbI0lvH5RgXUZRKL2wpi7hwWRPvcUDhhEE/+0BJZXewtV
	cMEKgIrbfgGHgM8MK+KDfjwhQTkubs8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ec922944 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Wed, 6 Apr 2022 00:19:04 +0000 (UTC)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 5 Apr 2022 20:07:27 +0200
References: <20220405163931.1108442-1-jannh@google.com>
In-Reply-To: <20220405163931.1108442-1-jannh@google.com>
Message-ID: <CAHmME9pW6heXtPrfCP7J6ODgSc8sotsv6E3dnJoVBaPi+Ph=HA@mail.gmail.com>
Subject: Re: [PATCH] random: Fix signal_pending() usage
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Jann Horn <jannh@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Sebastian Siewior <bigeasy@linutronix.de>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

Hi Jann,

On Tue, Apr 5, 2022 at 6:39 PM Jann Horn <jannh@google.com> wrote:
> signal_pending() checks TIF_NOTIFY_SIGNAL and TIF_SIGPENDING, which signal
> that the task should bail out of the syscall when possible.
> This is a separate concept from need_resched(), which checks
> TIF_NEED_RESCHED, signalling that the task should preempt.
>
> In particular, with the current code, the signal_pending() bailout probably
> won't work reliably.
>
> Change this to look like other functions that read lots of data, such as
> read_zero().
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Applied, thanks.

One funny aspect of the fact that signal_pending() hasn't worked right
since the genesis commit is that this has probably led to a lot of
userspace code that doesn't check the result from read() or
getrandom(), and that code has worked mostly fine.

I wonder if we should do something about that. Worth noting is that
we're no longer contending with /dev/random periodically blocking as
the "entropy runs out" nonsense. I can think of two possible changes,
which maybe aren't mutually exclusive:

1) Turn signal_pending() into fatal_signal_pending() throughout the file.
2) Rather than not checking signal_pending() for reads of length <=
256, we could not check for signal_pending() for the first 256 bytes
of any length read.

Both of these would be changing userspace behavior, so it should
probably be considered carefully. Any thoughts?

Jason
