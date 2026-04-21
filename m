Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB782384246;
	Tue, 21 Apr 2026 07:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776757484; cv=none; b=Pgawn1kvpHcQkRN+H1IXfSm2VV4tfAXlpKTE8B4OYNZzZkINwU11GMfD0c149c0hovK1Jvvx6BNhdQgyG0YScrii1aAUzK/0w0QuZNBuRHmB2dSOWTZg5Mv9VyJqI9qYognUmAIhxNiO15efD7CDBl/Mxz2xlq0kfM/PiUB715A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776757484; c=relaxed/simple;
	bh=0EMFpbrCJoatvTqDf+TiQUyN8UQfUhVeoIOH+JwPzHA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=ALbSUh2u1muVQIL/jI3LwM1SdP/7ktAN15D3xciSK5+vLS/gmuGkC8XuD/Ilf8kvGTfCmci/aY1CFlDhJ99babYsmmpwunpIV3s3McWXvlbje3NSRY6PtgeWtXoNN5/KlU/fEOkj9+YOrD3nDwDEMrjCjdlky1a7DN0v/q2crtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+7PczEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+7PczEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35565C2BCB0;
	Tue, 21 Apr 2026 07:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776757483;
	bh=0EMFpbrCJoatvTqDf+TiQUyN8UQfUhVeoIOH+JwPzHA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=h+7PczEvJCRkdUjBIlTu5UaGdQM4Dq7rNc3pbjUuHnAeNmOKE/AfTO5hJ45fXu7CB
	 42UTiUDA4qH0Jgu62wf7PEBFXlJkm+PqU1ra1mTpvqKTxWG6s4+YWu3oO2PIZ/wiYo
	 /TDU7K1JRsQS2GPG+Be5ActNp8RR/PJ3rVjogtVE=
Subject: Patch "clockevents: Add missing resets of the next_event_forced flag" has been added to the 7.0-stable tree
To: akpm@linux-foundation.org,bp@alien8.de,calvin@wbinvd.org,dnaim@cachyos.org,fweisbec@gmail.com,gregkh@linuxfoundation.org,i.r.e.c.c.a.k.u.n+kernel.org@gmail.com,mingo@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tglx@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 21 Apr 2026 09:44:41 +0200
In-Reply-To: <87jyu0de2c.ffs@tglx>
Message-ID: <2026042141-overflow-pamphlet-d954@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    clockevents: Add missing resets of the next_event_forced flag

to the 7.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     clockevents-add-missing-resets-of-the-next_event_forced-flag.patch
and it can be found in the queue-7.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-240041-greg=kroah.com@vger.kernel.org Tue Apr 21 08:29:11 2026
From: Thomas Gleixner <tglx@kernel.org>
Date: Tue, 21 Apr 2026 08:26:19 +0200
Subject: clockevents: Add missing resets of the next_event_forced flag
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, stable@vger.kernel.org
Cc: Calvin Owens <calvin@wbinvd.org>, Borislav Petkov <bp@alien8.de>, Sasha Levin <sashal@kernel.org>, fweisbec@gmail.com, mingo@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-ID: <87jyu0de2c.ffs@tglx>

From: Thomas Gleixner <tglx@kernel.org>

commit 4096fd0e8eaea13ebe5206700b33f49635ae18e5 upstream.

The prevention mechanism against timer interrupt starvation missed to reset
the next_event_forced flag in a couple of places:

    - When the clock event state changes. That can cause the flag to be
      stale over a shutdown/startup sequence

    - When a non-forced event is armed, which then prevents rearming before
      that event. If that event is far out in the future this will cause
      missed timer interrupts.

    - In the suspend wakeup handler.

That led to stalls which have been reported by several people.

Add the missing resets, which fixes the problems for the reporters.

Fixes: d6e152d905bd ("clockevents: Prevent timer interrupt starvation")
Reported-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Reported-by: Eric Naim <dnaim@cachyos.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Tested-by: Eric Naim <dnaim@cachyos.org>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/68d1e9ac-2780-4be3-8ee3-0788062dd3a4@gmail.com
Link: https://patch.msgid.link/87340xfeje.ffs@tglx

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/clockevents.c    |    7 ++++++-
 kernel/time/tick-broadcast.c |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -94,6 +94,9 @@ static int __clockevents_switch_state(st
 	if (dev->features & CLOCK_EVT_FEAT_DUMMY)
 		return 0;
 
+	/* On state transitions clear the forced flag unconditionally */
+	dev->next_event_forced = 0;
+
 	/* Transition with new state-specific callbacks */
 	switch (state) {
 	case CLOCK_EVT_STATE_DETACHED:
@@ -332,8 +335,10 @@ int clockevents_program_event(struct clo
 	if (delta > (int64_t)dev->min_delta_ns) {
 		delta = min(delta, (int64_t) dev->max_delta_ns);
 		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
-		if (!dev->set_next_event((unsigned long) clc, dev))
+		if (!dev->set_next_event((unsigned long) clc, dev)) {
+			dev->next_event_forced = 0;
 			return 0;
+		}
 	}
 
 	if (dev->next_event_forced)
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -108,6 +108,7 @@ static struct clock_event_device *tick_g
 
 static void tick_oneshot_wakeup_handler(struct clock_event_device *wd)
 {
+	wd->next_event_forced = 0;
 	/*
 	 * If we woke up early and the tick was reprogrammed in the
 	 * meantime then this may be spurious but harmless.


Patches currently in stable-queue which might be from tglx@kernel.org are

queue-7.0/clockevents-add-missing-resets-of-the-next_event_forced-flag.patch
