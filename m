Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0BF623
	for <patches@lists.linux.dev>; Sun, 20 Nov 2022 01:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05BEC433D6;
	Sun, 20 Nov 2022 01:45:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="F76kpxsD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668908739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AO3FumHniHDYxypWhfcaQ48Un3bhenW0ecmpQ/0bPjI=;
	b=F76kpxsDPEDB62/aj2fUMTpZEYLD0x3o2jlPxMiQuLsVPn2PrDcc191NSzYK8HNgcknCoo
	tMl5eYvJHuDQ1doO8v2Nmm5bWgqldkgRNkNkdQ8MNnL03yNq7pwCCZ0nkcAqkq2KBXDdgG
	CRMJqsqeH0ZmXNYYeg4JYCPeUpKdojU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 28f55c2f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 20 Nov 2022 01:45:39 +0000 (UTC)
Date: Sun, 20 Nov 2022 02:45:37 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v5 1/3] random: add vgetrandom_alloc() syscall
Message-ID: <Y3mGwfGHBQ2r3/3O@zx2c4.com>
References: <20221119120929.2963813-1-Jason@zx2c4.com>
 <20221119120929.2963813-2-Jason@zx2c4.com>
 <Y3k+/hSL5rIIkBhK@sol.localdomain>
 <Y3ltyzxIPwniRNW5@zx2c4.com>
 <Y3mFdMVowWj+VaXx@sol.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3mFdMVowWj+VaXx@sol.localdomain>

On Sat, Nov 19, 2022 at 05:40:04PM -0800, Eric Biggers wrote:
> On Sun, Nov 20, 2022 at 12:59:07AM +0100, Jason A. Donenfeld wrote:
> > Hi Eric,
> > 
> > On Sat, Nov 19, 2022 at 12:39:26PM -0800, Eric Biggers wrote:
> > > On Sat, Nov 19, 2022 at 01:09:27PM +0100, Jason A. Donenfeld wrote:
> > > > +SYSCALL_DEFINE3(vgetrandom_alloc, unsigned long __user *, num,
> > > > +		unsigned long __user *, size_per_each, unsigned int, flags)
> > > > +{
> > > > +	unsigned long alloc_size;
> > > > +	unsigned long num_states;
> > > > +	unsigned long pages_addr;
> > > > +	int ret;
> > > > +
> > > > +	if (flags)
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (get_user(num_states, num))
> > > > +		return -EFAULT;
> > > > +
> > > > +	alloc_size = size_mul(num_states, sizeof(struct vgetrandom_state));
> > > > +	if (alloc_size == SIZE_MAX)
> > > > +		return -EOVERFLOW;
> > > > +	alloc_size = roundup(alloc_size, PAGE_SIZE);
> > > 
> > > Small detail: the roundup to PAGE_SIZE can make alloc_size overflow to 0.
> > > 
> > > Also, 'roundup(alloc_size, PAGE_SIZE)' could be 'PAGE_ALIGN(alloc_size)'.
> > 
> > Good catch, thanks. So perhaps this?
> > 
> >         alloc_size = size_mul(num_states, sizeof(struct vgetrandom_state));
> >         if (alloc_size > SIZE_MAX - PAGE_SIZE + 1)
> >                 return -EOVERFLOW;
> >         alloc_size = PAGE_ALIGN(alloc_size);
> > 
> > Does that look right?
> 
> Yes.  Maybe use 'SIZE_MAX & PAGE_MASK'?
> 
> Another alternative is the following:
> 
> 	if (num_states >
> 	    (SIZE_MAX & PAGE_MASK) / sizeof(struct vgetrandom_state))
> 		return -EOVERFLOW;
> 	alloc_size = PAGE_ALIGN(num_states * sizeof(struct vgetrandom_state));

Thanks, that's much nicer.

Jason
