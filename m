Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28234A8F
	for <patches@lists.linux.dev>; Tue,  8 Mar 2022 14:59:41 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1646751579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QcGRkjg8+BFqZodBvhvBSx+26nPdc2c0IldY/TkN6SM=;
	b=wDij4aHwno+BB7bJO6Z+9KlCNGg3hEjy/IwGx1BlBmbVC5XtkOBoNoCsHkljnNUMzCi+OA
	OJl7tsOzHKVHaRhxcJmBIwP4Zy2QnJuscsxONpG0djTCDAfPKLdzwG8QKW/5iQE2YE1Rel
	G/G/zd/7Sd8JO6EJryS3aVzjskQ/QlyJPwLNt7fP5R2cASaY80s4aEtOYrXA7uYvCjbqVe
	M8vDp3WJuLPj0InPwiVgZHo++DBdqePzyNuJyUCVzYpXQ4ilo9vMoSLw5owAy5aelRQJY1
	KLIdGtSSHT7PW1erRLJCISGI6ghtVhD0s53vzK7JHcwdRRVXDo0dBcLTTTKAOg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1646751579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QcGRkjg8+BFqZodBvhvBSx+26nPdc2c0IldY/TkN6SM=;
	b=ozt5VIY7GOPKsAE3mzc9JaCfFkXME6y1rf+sc65y7D/iLpUiytIRtg+awVzBqiOwi2gdht
	6jnkA5ByIXdU6zCQ==
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/split_lock: Make life miserable for split lockers
In-Reply-To: <YialXwpbED5kAUaZ@agluck-desk3.sc.intel.com>
References: <20220217012721.9694-1-tony.luck@intel.com>
 <877d95l7jo.ffs@tglx> <YialXwpbED5kAUaZ@agluck-desk3.sc.intel.com>
Date: Tue, 08 Mar 2022 15:59:39 +0100
Message-ID: <87mti0jxr8.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Tony,

On Mon, Mar 07 2022 at 16:37, Tony Luck wrote:
> On Mon, Mar 07, 2022 at 11:30:35PM +0100, Thomas Gleixner wrote:
>> On Wed, Feb 16 2022 at 17:27, Tony Luck wrote:
>> > Questions for this RFC:
>> >
>> > 1) Does this need to be a new option? Maybe just update the
>> >    existing "warn" mode to add this level of extra pain.
>> 
>> That's fine. Warn is the default today, right?
>
> Yes. Warn is the current default.
> Does "That's fine" mean ok to change exiting warn code to add
> this level of pain? Or OK to add a new option?

Add pain to the existing warn code.

>> The question is whether this is something to worry about. If so, then we
>> need to go back to the drawing board.
>
> I don't think it is worth worrying about. The case you describe is
> a process that is about to be preempted when the #AC trap happens.
> In that case this CPU (in fact both HT threads on this core) get
> two jiffies of free split locks.  Cases from here:
>
> 1) The original process gets to run on either of these threads
> before the timeout. They get to execute their split lock and carry
> on running.
>
> 2) The process is scheduled on a different core during the two jiffie
> window. They take an #AC trap and block on the semaphore until the
> original core releases. Then they get their chance to run on this new
> core.
>
> 3) The original process doesn't get rescheduled for two jiffies, then
> runs somewhere. The original core has released the sempahore and re-enabled
> split lock checking. So the process takes #AC, gets the semaphore, kernel
> disables split lock checking ... and we try again.
>
> Now it is possible that the process may repeatedly be preempted in between
> getting the semaphore and actually getting all the way to user space
> to split a lock ... but can only happen if there are multiple processes
> splitting locks. The goal of this patch is to be mean to all of them. If
> we happen to be extra mean to some of them, well so be it.

Fair enough.

I still do not like the inconsistent state between the TIF flag and the
SLD MSR.

Thanks,

        tglx
