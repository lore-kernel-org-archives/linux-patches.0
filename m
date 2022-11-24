Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38F21C05
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 01:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F17C433C1;
	Thu, 24 Nov 2022 01:18:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Rkjvbp4O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669252702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gHcu1Df+WYlCMCGuI6BqIh8yeKwpZ9M+Wp3aq3lKwHE=;
	b=Rkjvbp4OfknxrLRcWSuU2xsVtBe8MKafVdnOuXwJmh2md+Mi08LlKnSIRnn9aeJwmERQH4
	AFPVmUQvhTwlfyAPSrUi9xLksdXy5cS26M7wvTCOe2gkVMOGIIRigfYqR8OHqea1Ppq7th
	BtppJZ7TwGD8BnGV6IwUuDZOeE0J5YM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 99f0ec89 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 24 Nov 2022 01:18:22 +0000 (UTC)
Date: Thu, 24 Nov 2022 02:18:20 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y37GXIQVvUvRac6D@zx2c4.com>
References: <20221121152909.3414096-1-Jason@zx2c4.com>
 <20221121152909.3414096-3-Jason@zx2c4.com>
 <842fd97b-c958-7b0d-2c77-6927c7ab4d72@rasmusvillemoes.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <842fd97b-c958-7b0d-2c77-6927c7ab4d72@rasmusvillemoes.dk>

Hi Rasmus,

On Wed, Nov 23, 2022 at 09:51:04AM +0100, Rasmus Villemoes wrote:
> On 21/11/2022 16.29, Jason A. Donenfeld wrote:
> 
> Cc += linux-api
> 
> > 
> >       if (!new_block)
> >         goto out;
> >       new_cap = grnd_allocator.cap + num;
> >       new_states = reallocarray(grnd_allocator.states, new_cap, sizeof(*grnd_allocator.states));
> >       if (!new_states) {
> >         munmap(new_block, num * size_per_each);
> 
> Hm. This does leak an implementation detail of vgetrandom_alloc(),
> namely that it is based on mmap() of that size rounded up to page size.
> Do we want to commit to this being the proper way of disposing of a
> succesful vgetrandom_alloc(), or should there also be a
> vgetrandom_free(void *states, long num, long size_per_each)?

Yes, this is intentional, and this is exactly what I wanted to do. There
are various wrappers of vm_mmap() throughout, mmap being one of them,
and they typically then resort to munmap to unmap it. This is how
userspace handles memory - maps, always maps. So I think doing that is
fine and consistent.

However, your point about it relying on it being a rounded up size isn't
correct. `munmap` will unmap the whole page if the size you pass lies
within a page. So `num * size_of_each` will always do the right thing,
without needing to have userspace code round anything up. (From the man
page: "The  address addr must be a multiple of the page size (but length
need not be). All pages containing a part of the indicated range are
unmapped.") And as you can see in my example code, nothing is rounded
up. So I don't know why you made that comment.

> And if so, what color should the bikeshed really have. I.e.,

No color, thanks.

> Also, should vgetrandom_alloc() take a void *hint argument that
> would/could be passed through to mmap() to give userspace some control
> over where the memory is located - possibly only in the future, i.e.
> insist on it being NULL for now, but it could open the possibility for
> adding e.g. VGRND_MAP_FIXED[_NOREPLACE] that would translate to the
> corresponding MAP_ flags.

I think adding more control is exactly what this is trying to avoid.
It's very intentionally *not* a general allocator function, but
something specific for vDSO getrandom(). However, it does already, in
this very patchset here, take a (currently unused) flags argument, in
case we have the need for later extension.

In the meantime, however, I'm not very interested in complicating this
interface into oblivion. Firstly, it ensures nothing will get done. But
moreover, this interface needs to be somewhat future-proof, yes, but it
does not need to be a general syscall; rather, it's a specific syscall
for a specific task.

Jason
