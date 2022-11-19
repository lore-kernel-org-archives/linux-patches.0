Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0D3EC0D
	for <patches@lists.linux.dev>; Sat, 19 Nov 2022 23:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B85CC433C1;
	Sat, 19 Nov 2022 23:59:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gQCJ1S+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668902350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pF5hygQOZimknkE9dVS3ToHPgi15Fs/0Dk7gv5XPx2I=;
	b=gQCJ1S+OriuBT7to95epQyIA2rapjpQ/C5zZiKyFZeQnVxr41IehVybTQz1bYZ23k99xST
	cAbM5WFiac4vkg2pXEsah7omTBW1qQjex1gv7LaKbB4tHeC9XG9+JmfOguXy2mXHQ5a2W8
	6FU171U7Q+37zlYEkJiztmMtxU3E0PU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 01fc7d27 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 19 Nov 2022 23:59:10 +0000 (UTC)
Date: Sun, 20 Nov 2022 00:59:07 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v5 1/3] random: add vgetrandom_alloc() syscall
Message-ID: <Y3ltyzxIPwniRNW5@zx2c4.com>
References: <20221119120929.2963813-1-Jason@zx2c4.com>
 <20221119120929.2963813-2-Jason@zx2c4.com>
 <Y3k+/hSL5rIIkBhK@sol.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3k+/hSL5rIIkBhK@sol.localdomain>

Hi Eric,

On Sat, Nov 19, 2022 at 12:39:26PM -0800, Eric Biggers wrote:
> On Sat, Nov 19, 2022 at 01:09:27PM +0100, Jason A. Donenfeld wrote:
> > +SYSCALL_DEFINE3(vgetrandom_alloc, unsigned long __user *, num,
> > +		unsigned long __user *, size_per_each, unsigned int, flags)
> > +{
> > +	unsigned long alloc_size;
> > +	unsigned long num_states;
> > +	unsigned long pages_addr;
> > +	int ret;
> > +
> > +	if (flags)
> > +		return -EINVAL;
> > +
> > +	if (get_user(num_states, num))
> > +		return -EFAULT;
> > +
> > +	alloc_size = size_mul(num_states, sizeof(struct vgetrandom_state));
> > +	if (alloc_size == SIZE_MAX)
> > +		return -EOVERFLOW;
> > +	alloc_size = roundup(alloc_size, PAGE_SIZE);
> 
> Small detail: the roundup to PAGE_SIZE can make alloc_size overflow to 0.
> 
> Also, 'roundup(alloc_size, PAGE_SIZE)' could be 'PAGE_ALIGN(alloc_size)'.

Good catch, thanks. So perhaps this?

        alloc_size = size_mul(num_states, sizeof(struct vgetrandom_state));
        if (alloc_size > SIZE_MAX - PAGE_SIZE + 1)
                return -EOVERFLOW;
        alloc_size = PAGE_ALIGN(alloc_size);

Does that look right?

> > +	pages_addr = vm_mmap(NULL, 0, alloc_size, PROT_READ | PROT_WRITE,
> > +			     MAP_PRIVATE | MAP_ANONYMOUS | MAP_LOCKED, 0);
> > +	if (IS_ERR_VALUE(pages_addr))
> > +		return pages_addr;
> 
> This will only succeed if the userspace process has permission to mlock pages,
> i.e. if there is space available in RLIMIT_MEMLOCK or if process has
> CAP_IPC_LOCK.  I suppose this is working as intended, as this syscall can be
> used to try to allocate and mlock arbitrary amounts of memory.
> 
> I wonder if this permission check will cause problems.  Maybe there could be a
> way to relax it for just one page per task?  I don't know how that would work,
> though, especially when the planned usage involves userspace allocating a single
> pool of these contexts per process that get handed out to threads.

Probably though, we don't want to create a mlock backdoor, right? I
suppose if a user is above RLIMIT_MEMLOCK, it'll just fallback to the
slowpath, which still works. That seems like an okay enough
circumstance.

Jason
