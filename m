Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2E419F135;
	Sat, 23 Aug 2025 05:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755926880; cv=none; b=hI/ydkjaPsYtcpg4kdEM2HTaHFUr4IXH2CjJk9cW1g1tVsxm3i7mQpoRXZQg/E786n0NfbL4xEKYSPwjPwqRA26Mu0SgKri7xICVfW1U2uwAh1eHxuNCRKWin0jfMU0xGd+sZD1wWij+7Bnp1KyZvfWB224u1lWuCUjNuLJ9XjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755926880; c=relaxed/simple;
	bh=+fImkWUgacin2LSzWHOkqtqjjNvlT3yYhpgVrHNgVg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5IaQ5j44J+qyvrHpzZqtRYJEusZJ4KQkn/GyVThelX502zDA4QL8gKBUahLJsq+Z0Mi6k3HrGDViM7I2qbrqDIWFXlUa1P4TshL9yRSRwGkZRJmlIRAkA11UO6S0S7U+GqIFqWWdRjeju/z/iJs5knjoMEusUDUAFIu3ZcJRKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXn1jbMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXn1jbMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537B8C4CEE7;
	Sat, 23 Aug 2025 05:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755926879;
	bh=+fImkWUgacin2LSzWHOkqtqjjNvlT3yYhpgVrHNgVg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IXn1jbMzld+vE1HJyoRCdzBCg4GcYpRUPyzrcRFDcIj/m3PrJvLDvozXB0OOGlpet
	 mM44oqPnN4Cq6hfsYkrbP9uXsmDTvuBGDOA/y8KDF6DXENZ7iSE6BD26MdXxc/XJaC
	 5ti3q7tnFBULKx8eVnk1qq9DlDISNhak35x7x2OxFTSItOHfHBSCHvLG6B0YavZhus
	 0/eknHbzJrNvQ+ZDJQBsWNPkxu8Lvz8HVTxPAwYEKmbPLbEsm8MbMaaDz6CljSbO9Q
	 ng7r3+qm3M1j3Ti+5JTsZYFSdTL5/Mridb7+7f7+eHi6hDO79hY7MnoIOySQo9N6QE
	 PGLuK+xi7B2Fw==
Date: Fri, 22 Aug 2025 22:27:55 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: Zheng Gu <cengku@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] dm-pcache: Fix 64-bit division for 32-bit platforms in
 get_kset_id()
Message-ID: <20250823052755.GB4056405@ax162>
References: <20250821-dm-pcache-fix-32-bit-div-err-v1-1-cab5448f44e6@kernel.org>
 <2f5aa331-aa47-4e81-9bb3-65c771b39913@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f5aa331-aa47-4e81-9bb3-65c771b39913@linux.dev>

Hi Dongsheng,

On Fri, Aug 22, 2025 at 02:53:42PM +0800, Dongsheng Yang wrote:
> 
> 在 8/22/2025 4:09 AM, Nathan Chancellor 写道:
> > When building for a 32-bit platform (such as ARCH=i386 allmodconfig),
> > there is a modpost error:
> > 
> >    ERROR: modpost: "__umoddi3" [drivers/md/dm-pcache/dm-pcache.ko] undefined!
> > 
> > Hacking up the driver Makefile to allow building into the kernel shows
> > that the division comes from get_kset_id(), which is inlined into
> > cache_key_append() in cache_key.c.
> > 
> > Use the helper div_u64_rem() to avoid emitting a libcall on 32-bit targets.
> > 
> > Fixes: fd5cc4922bef ("dm-pcache: add persistent cache target in device-mapper")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >   drivers/md/dm-pcache/cache.h | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
> > index b3b361cc406e..b10e721ab1b7 100644
> > --- a/drivers/md/dm-pcache/cache.h
> > +++ b/drivers/md/dm-pcache/cache.h
> > @@ -373,7 +373,9 @@ static inline void *get_key_head_addr(struct pcache_cache *cache)
> >   static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
> >   {
> > -	return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
> > +	u32 rem;
> > +	div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT, cache->n_ksets, &rem);
> > +	return rem;
> >   }
> 
> 
> Hi Nathan,
> 
> Thanx for your fix. It looks good to me.
> 
> Just one nit about the variable name. I prefer kset_id to rem.

Thanks, seems entirely reasonable, thanks for sending the diff!

> Mikulas, if this looks good to you, could you apply this change to dm-6.18?
> 
> diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
> index b3b361cc406e..f005c9d9a7aa 100644
> --- a/drivers/md/dm-pcache/cache.h
> +++ b/drivers/md/dm-pcache/cache.h
> @@ -373,7 +373,11 @@ static inline void *get_key_head_addr(struct
> pcache_cache *cache)
> 
>  static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
>  {
> -       return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
> +       u32 kset_id;
> +
> +       div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT, cache->n_ksets,
> &kset_id);
> +
> +       return kset_id;
>  }
> 
>  static inline struct pcache_cache_kset *get_kset(struct pcache_cache
> *cache, u32 kset_id)
> 
> > re
> >   static inline struct pcache_cache_kset *get_kset(struct pcache_cache *cache, u32 kset_id)
> > 
> > ---
> > base-commit: fd5cc4922bef4b3c3cd0452f38dcfd066322e9a9
> > change-id: 20250821-dm-pcache-fix-32-bit-div-err-4f0695e94784
> > 
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> > 
