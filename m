Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D34E7E0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 01:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9613C433C1;
	Wed, 30 Nov 2022 01:09:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fGFRUR+o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669770556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S1si/cA8UcowkQYtlSOeleWUR5BllaZz4lBVZJERp9U=;
	b=fGFRUR+oKPNieDw+p0j7LTBmeYOJw1nMQPx6bc/U7+M3ZyUwAWtjpc2i/RydnEet93kPQZ
	hypbpJEFk4TJP3hFPj8vW5lmojo4doXEIsRKqvzGIxT4fiDyOFW7+3zRDM0tGFMEPD78Yj
	Sf2jFZ8DrGlgtz/yrtJXuPiatuQPiCw=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2bf40420 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 30 Nov 2022 01:09:15 +0000 (UTC)
Date: Wed, 30 Nov 2022 02:09:10 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 3/4] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y4atNgDqLL4KFubS@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-4-Jason@zx2c4.com>
 <87a649v0vr.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a649v0vr.ffs@tglx>

Hi Thomas,

On Tue, Nov 29, 2022 at 11:42:16PM +0100, Thomas Gleixner wrote:
> Jason!
> 
> On Tue, Nov 29 2022 at 22:06, Jason A. Donenfeld wrote:
> > +/**
> > + * struct vdso_rng_data - vdso RNG state information
> > + * @generation:	a counter representing the number of RNG reseeds

FYI, ever other struct in this file uses lower case and no punctuation,
so I'll follow that for this one.

> A counter
> 
> > + * @is_ready:	whether the RNG is initialized
> 
> Signals whether ...

Ack.

> > + */
> > +struct vdso_rng_data {
> > +	unsigned long	generation;
> > +	bool		is_ready;
> > +};
> > +
> > +
> > +#define MEMCPY_AND_ZERO_SRC(type, dst, src, len) do { \
> > +	while (len >= sizeof(type)) { \
> > +		__put_unaligned_t(type, __get_unaligned_t(type, src), dst); \
> > +		__put_unaligned_t(type, 0, src); \
> > +		dst += sizeof(type); \
> > +		src += sizeof(type); \
> > +		len -= sizeof(type); \
> > +	} \
> > +} while (0)
> 
> I'd appreciate it if you go back to the code I suggested to you and
> compare and contrast it in terms of readability.

Ahh, you like to align your \. Okay, I'll do that. I also added a do {
... } while (0) wrapper around it, but I think it makes sense to keep
that so that there aren't stray semicolons.

> > +/**
> > + * __cvdso_getrandom_data - generic vDSO implementation of getrandom() syscall
> > + * @rng_info:		describes state of kernel RNG, memory shared with kernel
> > + * @buffer:		destination buffer to fill with random bytes
> > + * @len:		size of @buffer in bytes
> > + * @flags:		zero or more GRND_* flags
> > + * @opaque_state:	a pointer to an opaque state area
> 
> NIT. Please start the explanations with an uppercase letter

Okay. Will do everywhere in this patchset except for in vdso/datapage.h.

 
> This one is odd:
> 
> > +	len = ret;
> 
> @ret is not modified after the initialization at the top of the
> function:
> 
> > +	ssize_t ret = min_t(size_t, INT_MAX & PAGE_MASK /* = MAX_RW_COUNT */, len);
> 
> so I really had to go up a page and figure out what the story is.

If the generation changes, and it's tried again, the whole random buffer
is filled again, so that has to be reset. I'll leave a comment.

> > +
> > +	/* Since the batch was just refilled, set the position back to 0 to indicate a full batch. */
> > +	state->pos = 0;
> > +	goto more_batch;
> 
> Aside of the nitpicks above, thank you very much for making this
> comprehensible.

Thanks for nudging me in the right direction.

> 
> The comments are well done and appreciated and I'm pretty sure that this
> part:
> 
> > +	in_use = READ_ONCE(state->in_use);
> > +	if (unlikely(in_use))
> > +		goto fallback_syscall;
> > +	WRITE_ONCE(state->in_use, true);
> 
> was very much induced by writing those comments :)

Well, not exactly, unfortunately. Adhemerval -- the glibc maintainer
working on the libc side of this -- and I have been discussing signal
handling craziness and lots of different schemes over the last week+,
and this rather simple thing is the result of those conversations.

Jason
