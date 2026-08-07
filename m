Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4FF1A238F;
	Fri,  7 Aug 2026 18:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786125771; cv=none; b=IKQxHSAiuverD81g+P2UnZ9tKg48Hn97F9WYQKKLeTgwr99fD/Mkakr6hqBU5/DTXDrqUv/e3ggKnUFFA21uiRTga8wg9h8CXYmvELwRjxtLWQcDZck28xnJZdR2gcEEFR53Fc9hJpF+ZuIhs++NEPLW0H1qhCkoGvj9eU4B5Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786125771; c=relaxed/simple;
	bh=RxyQK3gR41pgfj9aHowx/q7MbOyJ6ZdxFWz0PEZrQIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGhd8+xGHeyFA7+mc9k6qvzDVn7JkNBp22jp6Os5m8r1w4pRfl38DNQyn8zUApZ62xArhiFLgXtf4nGdI+RsNtkxuJlKKywIKThYKGYNA+yFtxAzXg22ZdhhOk1cXvxaWUYn3KeSHdTkK+GSaLDjmmuNALLcvSihsqK1Rz192f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwqmqUXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwqmqUXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6145A1F000E9;
	Fri,  7 Aug 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786125770;
	bh=yPChVXoYVNGUn/NmW1gqR/GKKqRaql6iyBiVHocHgSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nwqmqUXqMXBEHaT0FaM+SICMoOQdlsgDaD09KuIhBuHIfYXAr7gVMKXunO3vatMCs
	 1IjCFAGPrM2trDgzXhxu2bDiD0cAcscp8BrAA0OpA3ruzcrV4cXBNjMsDD833Sk9s0
	 KkpBjgPJpoLlj+yas0h7ZoIjqW+glsizQsaScHTUn7RI+d1AxF/8FS/Vcl53QAAb1D
	 6r5asQQapdNIhMa8laToHlqgXoks2UBgRa/uZsPURWQMEbeNkgzqfnrIbP8+W1JrHq
	 O2dH9MV14Ea1gfT24k+LX/gGfk/6SVJ8Qm6psYTtjWBA9+/ASFNbmAuQl4pCNpLBGd
	 Q716PT38xmVkg==
Date: Fri, 7 Aug 2026 11:02:45 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 289/337] mm/slab: prevent unbounded recursion in
 free path with new kmalloc type
Message-ID: <20260807180245.GA4067747@ax162>
References: <20260807143418.516897842@linuxfoundation.org>
 <20260807143424.797445703@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807143424.797445703@linuxfoundation.org>

On Fri, Aug 07, 2026 at 04:38:12PM +0200, Greg Kroah-Hartman wrote:
...
>  - Mark need_kmalloc_no_objext() __always_inline to make sure
>    the compiler does not generate a out-of-line function that could
>    access mem_profiling_support (which is marked __init)
...
> diff --git a/mm/slab.h b/mm/slab.h
> index b65d2462b3fdb..34a3d65b4ef5f 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -557,6 +562,25 @@ bool slab_in_kunit_test(void);
>  static inline bool slab_in_kunit_test(void) { return false; }
>  #endif
>  
> +/*
> + * Return true if KMALLOC_NORMAL caches may need obj_exts arrays.
> + *
> + * Memory allocation profiling requires obj_exts for all caches.
> + * Memcg usually doesn't need them for normal kmalloc caches, but kmalloc types
> + * with a priority higher than KMALLOC_CGROUP can be aliased with KMALLOC_NORMAL.
> + */
> +static __always_inline inline bool need_kmalloc_no_objext(void)

This adjustment causes a clang warning (or error with CONFIG_WERROR):

  In file included from linux/mm/mempool.c:21:
  linux/mm/slab.h:572:24: error: duplicate 'inline' declaration specifier [-Werror,-Wduplicate-decl-specifier]
    572 | static __always_inline inline bool need_kmalloc_no_objext(void)
        |                        ^
  linux/include/linux/compiler_types.h:249:16: note: expanded from macro 'inline'
    249 | #define inline inline __gnu_inline __inline_maybe_unused notrace
        |                ^

As originally reported by KernelCI at

  https://lore.kernel.org/178611474407.7658.14431237412617748501@kernelci.org/

The 'inline' should be dropped, as '__always_inline' includes 'inline'
already.

-- 
Cheers,
Nathan
