Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE20523D
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 19:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719948662; cv=none; b=dNqplfhKChJYm+/ocCqLIAZO6hWm3chcTBtI7phyHeyqqDQOz3piHVPG/iQs3k9bkxJfHZZmM2XD0xo4ofy7CBqHc135yd9N0bWwOISlnCglqRng2WxE3vAfst0FdJfo/H+bjbG0XrfBCc5YUAal3qQFzBlZnrDv+JeVn4X3x9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719948662; c=relaxed/simple;
	bh=6sueG7B9yBrOLCYUbqIkyCVc2yh5hOTU+u5di5hUTDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q2cDgVslKfhlLW+7ElU5ob+xKjgb7+wW2mkz6Ycoblj/CJFdOpcBZ0e5LVnw46FdBjKVB4L/ngbh6s0jfxD4YkUlUQJmSyvIp006sXRTgD5wcb5mKk9TxGWtQqbXM4e7j9ibcoY2oGcqf9zFm5YT/WJB4IfOtKoP0bMhN5pD20M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q1FEnjiQ; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q1FEnjiQ"
X-Envelope-To: vbabka@suse.cz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719948658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J0SU+FVYux8dBxFA9n9nO3CUHybdv+MQ9BO4fGoXttc=;
	b=Q1FEnjiQv7ICJdNXiNOvRIFyl5PIS1nWD0FR4+Ix0eD4pchJvlXx0E7f6w/9SzdkcZolPL
	wzwFQDwqxDoLZsuqWPJqMRt0iRYG7+5QuHv2rh3KcXJ3NPnYkPj+E4veQzUr4sLl3+ZDLn
	IESUTdLYgogZjOcMNea13n4RYil/wt8=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: rientjes@google.com
X-Envelope-To: cl@linux.com
X-Envelope-To: 42.hyeyoo@gmail.com
X-Envelope-To: keescook@chromium.org
X-Envelope-To: aliceryhl@google.com
X-Envelope-To: boqun.feng@gmail.com
X-Envelope-To: rust-for-linux@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: patches@lists.linux.dev
Date: Tue, 2 Jul 2024 19:30:53 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] mm, slab: extend kmalloc() alignment for non
 power-of-two sizes
Message-ID: <ZoRVbdCxrBwmDF2s@google.com>
References: <20240702155800.166503-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702155800.166503-2-vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 02, 2024 at 05:58:01PM +0200, Vlastimil Babka wrote:
> Slab allocators have been guaranteeing natural alignment for
> power-of-two sizes since commit 59bb47985c1d ("mm, sl[aou]b: guarantee
> natural alignment for kmalloc(power-of-two)"), while any other sizes are
> aligned only to ARCH_KMALLOC_MINALIGN bytes.
> 
> Rust's allocator API specifies size and alignment per allocation, which
> have to satisfy the following rules, per Alice Ryhl [1]:
> 
>   1. The alignment is a power of two.
>   2. The size is non-zero.
>   3. When you round up the size to the next multiple of the alignment,
>      then it must not overflow the signed type isize / ssize_t.
> 
> In order to map this to kmalloc()'s guarantees, some requested
> allocation sizes have to be enlarged to the next power-of-two size [2].
> For example, an allocation of size 96 and alignment of 32 will be
> enlarged to an allocation of size 128, because the existing kmalloc-96
> bucket doesn't guarantee alignent above ARCH_KMALLOC_MINALIGN. Without
> slab debugging active, the layout of the kmalloc-96 slabs however
> naturally aligns the objects to 32 bytes, so extending the size to 128
> bytes is wasteful.
> 
> To improve the situation we can extend the kmalloc() alignment
> guarantees in a way that
> 
> 1) doesn't change the current slab layout (and thus does not increase
>    internal fragmentation) when slab debugging is not active
> 2) reduces waste in the Rust allocator use case
> 3) is a superset of the current guarantee for power-of-two sizes.
> 
> The extended guarantee is that alignment is at least the largest
> power-of-two divisor of the requested size. For power-of-two sizes the
> largest divisor is the size itself, but let's keep this case documented
> separately for clarity.
> 
> For current kmalloc size buckets, it means kmalloc-96 will guarantee
> alignment of 32 bytes and kmalloc-196 will guarantee 64 bytes.
> 
> This covers the rules 1 and 2 above of Rust's API as long as the size is
> a multiple of the alignment. The Rust layer should now only need to
> round up the size to the next multiple if it isn't, while enforcing the
> rule 3.
> 
> Implementation-wise, this changes the alignment calculation in
> create_boot_cache(). While at it also do the calulation only for caches
> with the SLAB_KMALLOC flag, because the function is also used to create
> the initial kmem_cache and kmem_cache_node caches, where no alignment
> guarantee is necessary.
> 
> Link: https://lore.kernel.org/all/CAH5fLggjrbdUuT-H-5vbQfMazjRDpp2%2Bk3%3DYhPyS17ezEqxwcw@mail.gmail.com/ [1]
> Link: https://lore.kernel.org/all/CAH5fLghsZRemYUwVvhk77o6y1foqnCeDzW4WZv6ScEWna2+_jw@mail.gmail.com/ [2]
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Hello Vlastimil,

the idea and the implementation makes total sense to me.

Do you have an estimate for the memory overhead it will typically introduce?
I don't think it will be too large though and actually can be compensated
by potential performance gains due to a better memory alignment. What do you
think?

Thanks!
