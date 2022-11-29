Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416A23214
	for <patches@lists.linux.dev>; Tue, 29 Nov 2022 22:42:19 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1669761737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H1PNFgeCv+3THwA99wA+ngYPO8a+5/+rZUXoQDY+pEw=;
	b=RkdudI4Cpky8LM3YtCLk/7hoUvJh6M3IU2yqG8sG1+mFXtS47DZJ6v2/uhYJk7V0N5+z9V
	04hZ9THq0ktwXdxzwdq3dy8UI0ULnChekm5m8Ku8jNnolAbN4+GH40mBVfgnaMCVS77ciz
	SNzyvjjZ8Hfa3lcKpE+wyufIzOplkkweoUHyQIMZmqC2ySUmTjOhbMGTVfAzen/yBsop8f
	LMvNMbmaTlmBSxGXt+p+Me80bUFahUFh5y1mE/kuQIi3OMwTViuzgHf2Nje2AUacQFiPQW
	Pbm1xJ+pLJfr4BRpyepjFyLv9TOMTo54w5aOTkcbJ7i6OkU7mieWnb8r4sHEqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1669761737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H1PNFgeCv+3THwA99wA+ngYPO8a+5/+rZUXoQDY+pEw=;
	b=mdOWG2mts/uWPTselCeRbdTgdwjEFZFUp93KpqJle6nB+NyZk97JZQKV9RBLU1S//8i9di
	KbtM62r02pOrBxAQ==
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-crypto@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Adhemerval Zanella Netto
 <adhemerval.zanella@linaro.org>, Carlos O'Donell <carlos@redhat.com>,
 Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 3/4] random: introduce generic vDSO getrandom()
 implementation
In-Reply-To: <20221129210639.42233-4-Jason@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-4-Jason@zx2c4.com>
Date: Tue, 29 Nov 2022 23:42:16 +0100
Message-ID: <87a649v0vr.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason!

On Tue, Nov 29 2022 at 22:06, Jason A. Donenfeld wrote:
> +/**
> + * struct vdso_rng_data - vdso RNG state information
> + * @generation:	a counter representing the number of RNG reseeds

A counter

> + * @is_ready:	whether the RNG is initialized

Signals whether ...

> + */
> +struct vdso_rng_data {
> +	unsigned long	generation;
> +	bool		is_ready;
> +};
> +
> +
> +#define MEMCPY_AND_ZERO_SRC(type, dst, src, len) do { \
> +	while (len >= sizeof(type)) { \
> +		__put_unaligned_t(type, __get_unaligned_t(type, src), dst); \
> +		__put_unaligned_t(type, 0, src); \
> +		dst += sizeof(type); \
> +		src += sizeof(type); \
> +		len -= sizeof(type); \
> +	} \
> +} while (0)

I'd appreciate it if you go back to the code I suggested to you and
compare and contrast it in terms of readability.

> +
> +static void memcpy_and_zero_src(void *dst, void *src, size_t len)
> +{
> +	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
> +		if (IS_ENABLED(CONFIG_64BIT))
> +			MEMCPY_AND_ZERO_SRC(u64, dst, src, len);
> +		MEMCPY_AND_ZERO_SRC(u32, dst, src, len);
> +		MEMCPY_AND_ZERO_SRC(u16, dst, src, len);
> +	}
> +	MEMCPY_AND_ZERO_SRC(u8, dst, src, len);
> +}
> +
> +/**
> + * __cvdso_getrandom_data - generic vDSO implementation of getrandom() syscall
> + * @rng_info:		describes state of kernel RNG, memory shared with kernel
> + * @buffer:		destination buffer to fill with random bytes
> + * @len:		size of @buffer in bytes
> + * @flags:		zero or more GRND_* flags
> + * @opaque_state:	a pointer to an opaque state area

NIT. Please start the explanations with an uppercase letter

> +		/*
> +		 * Set @state->pos to beyond the end of the batch, so that the batch is refilled
> +		 * using the new key.
> +		 */
> +		state->pos = sizeof(state->batch);
> +	}
> +

This one is odd:

> +	len = ret;

@ret is not modified after the initialization at the top of the
function:

> +	ssize_t ret = min_t(size_t, INT_MAX & PAGE_MASK /* = MAX_RW_COUNT */, len);

so I really had to go up a page and figure out what the story is.

> +
> +	/* Since the batch was just refilled, set the position back to 0 to indicate a full batch. */
> +	state->pos = 0;
> +	goto more_batch;

Aside of the nitpicks above, thank you very much for making this
comprehensible.

The comments are well done and appreciated and I'm pretty sure that this
part:

> +	in_use = READ_ONCE(state->in_use);
> +	if (unlikely(in_use))
> +		goto fallback_syscall;
> +	WRITE_ONCE(state->in_use, true);

was very much induced by writing those comments :)

Thanks,

        tglx
