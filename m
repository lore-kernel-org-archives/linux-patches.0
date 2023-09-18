Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4E46D39
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 07:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23874C433C7;
	Mon, 18 Sep 2023 07:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695021289;
	bh=09nsw1TusQJg4e9irDAkszwTeBuZsH3FmiN7yoKx0DE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xY7q2g3EGof6v0XnJdR4SiC6V9BMDnTjmTdVTQDiV5Vr014mXjE3bE+ENqYemO1og
	 3JE3D2AvziRvQ1WsXzGduDYKbcTHNWWpvDcW0UhMNeLYK2bEiuEvX6/GXFJWWOQZVx
	 5sQD931W+7HAPxPxnhMRFy/t8XVvn23ahy1IzDSU=
Date: Mon, 18 Sep 2023 09:14:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 096/406] crypto: blake2b - sync with blake2s
 implementation
Message-ID: <2023091832-doormat-chump-fe2b@gregkh>
References: <20230917191101.035638219@linuxfoundation.org>
 <20230917191103.663752909@linuxfoundation.org>
 <20230918025318.GA5356@sol.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918025318.GA5356@sol.localdomain>

On Sun, Sep 17, 2023 at 07:53:18PM -0700, Eric Biggers wrote:
> On Sun, Sep 17, 2023 at 09:09:10PM +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > [ Upstream commit 28dcca4cc0c01e2467549a36b1b0eacfdb01236c ]
> > 
> > Sync the BLAKE2b code with the BLAKE2s code as much as possible:
> > 
> > - Move a lot of code into new headers <crypto/blake2b.h> and
> >   <crypto/internal/blake2b.h>, and adjust it to be like the
> >   corresponding BLAKE2s code, i.e. like <crypto/blake2s.h> and
> >   <crypto/internal/blake2s.h>.
> > 
> > - Rename constants, e.g. BLAKE2B_*_DIGEST_SIZE => BLAKE2B_*_HASH_SIZE.
> > 
> > - Use a macro BLAKE2B_ALG() to define the shash_alg structs.
> > 
> > - Export blake2b_compress_generic() for use as a fallback.
> > 
> > This makes it much easier to add optimized implementations of BLAKE2b,
> > as optimized implementations can use the helper functions
> > crypto_blake2b_{setkey,init,update,final}() and
> > blake2b_compress_generic().  The ARM implementation will use these.
> > 
> > But this change is also helpful because it eliminates unnecessary
> > differences between the BLAKE2b and BLAKE2s code, so that the same
> > improvements can easily be made to both.  (The two algorithms are
> > basically identical, except for the word size and constants.)  It also
> > makes it straightforward to add a library API for BLAKE2b in the future
> > if/when it's needed.
> > 
> > This change does make the BLAKE2b code slightly more complicated than it
> > needs to be, as it doesn't actually provide a library API yet.  For
> > example, __blake2b_update() doesn't really need to exist yet; it could
> > just be inlined into crypto_blake2b_update().  But I believe this is
> > outweighed by the benefits of keeping the code in sync.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > Stable-dep-of: 9ae4577bc077 ("crypto: api - Use work queue in crypto_destroy_instance")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 1.) This isn't a Stable-dep-of 9ae4577bc077.   I don't see why this is being
> backported.

Odd, I don't know why either, Sasha's tools must have picked this up
incorrectly.  Now dropped.

> 2.) On lore.kernel.org, there is no record of this patch being queued to 5.10.
> See https://lore.kernel.org/all/?q=%22sync+with+blake2s+implementation%22.  The
> first mention of 5.10 and this patch is this thread, which is already the -rc1
> review.  I guess the only list that the initial "patch was queued" email was
> sent to is stable-commits, and stable-commits is not archived on
> lore.kernel.org.  That is surprising and makes it harder for people to give
> feedback on patches going into stable.  stable-commits should be archived on
> lore.kernel.lorg, and patches should generally be sent to more lists as well.
> (I'm probably shouting into a void here as I've given this same feedback on
> other patches before and nothing changed, but here it is again...)

I'll figure out how to sign this list up to lore.  We got complaints
when we were sending these emails to lkml, which is fair, but I thought
lore was subscribed to the list already, sorry about that.

greg k-h
