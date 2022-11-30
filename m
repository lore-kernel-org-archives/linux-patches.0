Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E47E0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 01:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8047CC433D6;
	Wed, 30 Nov 2022 00:59:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VOgfVFkE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669769997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AVZ0a4yNyl9QifKKmusGvNag1P4amfiAPAcNIjSeQF4=;
	b=VOgfVFkEdcJzAi5A5PI7M4rG6AY+LXbxSA+jKovlt5vt+7vUd/h88Od+lK+AAe5/GhSlJj
	Bf4VsRiKWQzGPFejPE6x8/K/9l/sV7asBnz6YJPYv6g8GMVbuwOYimxRFSibbBCKUz75iJ
	C5B5Awo3oba23iKWgccliY87aJMuwYA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2b53e127 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 30 Nov 2022 00:59:57 +0000 (UTC)
Date: Wed, 30 Nov 2022 01:59:51 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 1/4] random: add vgetrandom_alloc() syscall
Message-ID: <Y4arB7/zB8mRoapK@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-2-Jason@zx2c4.com>
 <87cz95v2q2.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87cz95v2q2.ffs@tglx>

Hi Thomas,

Thanks again for the big review. Comments inline below.

On Tue, Nov 29, 2022 at 11:02:29PM +0100, Thomas Gleixner wrote:
> > +/**
> > + * vgetrandom_alloc - allocate opaque states for use with vDSO getrandom().
> > + *
> > + * @num: on input, a pointer to a suggested hint of how many states to
> > + * allocate, and on output the number of states actually allocated.
> > + *
> > + * @size_per_each: the size of each state allocated, so that the caller can
> > + * split up the returned allocation into individual states.
> > + *
> > + * @flags: currently always zero.
> 
> NIT!
> 
> I personally prefer and ask for it in stuff I maintain:
> 
>  * @num:		On input, a pointer to a suggested hint of how many states to
>  *			allocate, and on output the number of states actually allocated.
>  *
>  * @size_per_each: 	The size of each state allocated, so that the caller can
>  * 			split up the returned allocation into individual states.
>  *
>  * @flags: 		Currently always zero.
> 
> But your turf :)

Hm. Caps and punctuation seem mostly missing in kernel/time/, though it
is that way in some places, so I'll do it with caps and punctuation.
Presumably that's the "newer" style you prefer, though I didn't look at
the dates in git-blame to confirm that supposition.

> 
> > + *
> > + * The getrandom() vDSO function in userspace requires an opaque state, which
> > + * this function allocates by mapping a certain number of special pages into
> > + * the calling process. It takes a hint as to the number of opaque states
> > + * desired, and provides the caller with the number of opaque states actually
> > + * allocated, the size of each one in bytes, and the address of the first
> > + * state.
> 
> make W=1 rightfully complains about:
> 
> > +
> 
> drivers/char/random.c:182: warning: bad line: 
> 
> > + * Returns a pointer to the first state in the allocation.
> 
> I have serious doubts that this statement is correct.

"Returns the address of the first state in the allocation" is better I
guess.

> and W=1 also complains rightfully here:
> 
> > +SYSCALL_DEFINE3(vgetrandom_alloc, unsigned int __user *, num,
> > +		unsigned int __user *, size_per_each, unsigned int, flags)
> 
> drivers/char/random.c:188: warning: expecting prototype for vgetrandom_alloc(). Prototype was for sys_vgetrandom_alloc() instead

Squinted at a lot of headers before realizing that's a kernel-doc
warning. Fixed, thanks.

> > +#ifndef _VDSO_GETRANDOM_H
> > +#define _VDSO_GETRANDOM_H
> > +
> > +#include <crypto/chacha.h>
> > +
> > +struct vgetrandom_state {
> > +	union {
> > +		struct {
> > +			u8 batch[CHACHA_BLOCK_SIZE * 3 / 2];
> > +			u32 key[CHACHA_KEY_SIZE / sizeof(u32)];
> > +		};
> > +		u8 batch_key[CHACHA_BLOCK_SIZE * 2];
> > +	};
> > +	unsigned long generation;
> > +	u8 pos;
> > +	bool in_use;
> > +};
> 
> Again, please make this properly tabular:
> 
> struct vgetrandom_state {
> 	union {
> 		struct {
> 			u8	batch[CHACHA_BLOCK_SIZE * 3 / 2];
> 			u32	key[CHACHA_KEY_SIZE / sizeof(u32)];
> 		};
> 		u8	batch_key[CHACHA_BLOCK_SIZE * 2];
> 	};
> 	unsigned long	generation;
> 	u8		pos;
> 	bool		in_use;
> };
> 
> Plus some kernel doc which explains what this is about.

Will do. Though, I'm going to move this to the vDSO commit, and for the
syscall commit, which needs the struct to merely exist, I'll have no
members in it. This should make review a bit easier.

Jason
