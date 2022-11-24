Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB771C05
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 01:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19061C433D6;
	Thu, 24 Nov 2022 01:08:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ESyQDzKV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669252126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jq/kgX6oeVA21zqtsBwkDHPYqUeMNJkafuAfZk9Ja+0=;
	b=ESyQDzKVrdgu1ir4VmP9swMJwjpGnDP1epO+1N1XeGcoWfi5vQOi9OcK8NkHse9NG+bmCq
	R6xSIqa6x0zcmDPZY0LaKjrtMQeJRruINLfghzLwEgR0gUMixuZKFFKcBMqTAezXrm2Gcg
	MyynCkI8vCgepZJdgCs6UI0v8hyAMjs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 83d3477e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 24 Nov 2022 01:08:46 +0000 (UTC)
Date: Thu, 24 Nov 2022 02:08:44 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v6 2/3] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y37EHHq41KBvgr8z@zx2c4.com>
References: <20221121152909.3414096-1-Jason@zx2c4.com>
 <20221121152909.3414096-3-Jason@zx2c4.com>
 <87r0xulzfd.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87r0xulzfd.fsf@oldenburg.str.redhat.com>

Hi Florian,

On Wed, Nov 23, 2022 at 11:48:06AM +0100, Florian Weimer wrote:
> * Jason A. Donenfeld:
> 
> >   static void *vgetrandom_alloc(size_t *num, size_t *size_per_each, unsigned int flags)
> >   {
> >     unsigned long ret = syscall(__NR_vgetrandom_alloc, num, size_per_each, flags);
> >     return ret > -4096UL ? NULL : (void *)ret;
> >   }
> 
> The traditional syscall function returns -1 on error and set errors, so
> using unsing long and the 4096 is quite misleading.

Not sure I have any idea at all whatsoever about what you're talking
about. Firstly, the function you quoted is from the "sample userspace
code" in the commit message, so it might not be code for the context you
have in mind.

Secondly, it's just doing the thing to figure out if the return value is
an error value or a pointer. Were we in glibc, we'd write this as:

    return INTERNAL_SYSCALL_ERROR_P(r) ? NULL : (void *) r;

Right? And if you look at the expansion of that glibc macro, it's just:

  #define INTERNAL_SYSCALL_ERROR_P(val) \
    ((unsigned long int) (val) > -4096UL)

So it looks like the same exact thing?

The only difference I could see is that I assign it to a `unsigned long
ret`, while glibc code tends to assign it to a `long r`? Is that the
difference you're pointing out? Except that clearly doesn't matter
because it just gets casted to unsigned by that macro anyway?

Confused.

Jason
