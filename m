Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A84958212;
	Wed, 14 Feb 2024 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707920960; cv=none; b=rloZFSZmZcITMZn+nRQTw+9dAmm+mm6aHNgFxh7JPeT2/45ETU0ItIZ0H8zL1VkmexqWmnuvqwpcck5tturckhzUNnvUJdnb3aH7C/5PuCzf0DLRtGz255qFty8uS04d3L4+rSrklMjxNRliS5OovQ2JifwZ2+tqLW6MFvcdKPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707920960; c=relaxed/simple;
	bh=5QDNetF2lT9g14JYUFe7R5aDCKquhXQ2KDFh/pGqANM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KaTqYslmwyefdYAOOidGjqbCih6gqjR3VysBbiJAWpw8Zl8u3mscJbtdshe24ceVyZWfTXtqDPpPdWC5vR0sQbpDQaKwhWKnXRIU8GGsgZOcSaiAjdILvyQSzbv82O89Q+Ttoa3ALuFGHa7CwSBw5oIIwSu8GernCX29+UZMI30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3oT26on; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3oT26on"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69598C433C7;
	Wed, 14 Feb 2024 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707920959;
	bh=5QDNetF2lT9g14JYUFe7R5aDCKquhXQ2KDFh/pGqANM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3oT26onrIHJr8oFhwQPHwQ+UJDq0pZ9gVbtULcJkYDcGy+Umnje/Gbvneaj/uX+k
	 i120vpmDTx9gXh2wyUxK+6VrHsMHsesPSbjXurgd/ntJFlFjaCSkB+F99v05it+E3z
	 VtAITNjQuWn40Q/kqVkXyWm6zrefCHaWSsLoG6kI=
Date: Wed, 14 Feb 2024 15:29:16 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Dennis Zhou <dennis@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.7 073/124] mm: Introduce flush_cache_vmap_early()
Message-ID: <2024021407-blade-pliable-0367@gregkh>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171855.870608761@linuxfoundation.org>
 <04565cd3-c6ee-4678-af6e-a00fa6d415d4@kernel.org>
 <75751649-d6b8-467e-ae52-59a6740d6145@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75751649-d6b8-467e-ae52-59a6740d6145@kernel.org>

On Wed, Feb 14, 2024 at 10:59:12AM +0100, Jiri Slaby wrote:
> On 14. 02. 24, 10:04, Jiri Slaby wrote:
> > On 13. 02. 24, 18:21, Greg Kroah-Hartman wrote:
> > > 6.7-stable review patch.  If anyone has any objections, please let
> > > me know.
> > > 
> > > ------------------
> > > 
> > > From: Alexandre Ghiti <alexghiti@rivosinc.com>
> > > 
> > > [ Upstream commit 7a92fc8b4d20680e4c20289a670d8fca2d1f2c1b ]
> > > 
> > > The pcpu setup when using the page allocator sets up a new vmalloc
> > > mapping very early in the boot process, so early that it cannot use the
> > > flush_cache_vmap() function which may depend on structures not yet
> > > initialized (for example in riscv, we currently send an IPI to flush
> > > other cpus TLB).
> > ...
> > > --- a/arch/riscv/mm/tlbflush.c
> > > +++ b/arch/riscv/mm/tlbflush.c
> > > @@ -66,6 +66,11 @@ static inline void
> > > local_flush_tlb_range_asid(unsigned long start,
> > >           local_flush_tlb_range_threshold_asid(start, size, stride,
> > > asid);
> > >   }
> > > +void local_flush_tlb_kernel_range(unsigned long start, unsigned
> > > long end)
> > > +{
> > > +    local_flush_tlb_range_asid(start, end, PAGE_SIZE,
> > > FLUSH_TLB_NO_ASID);
> > 
> > This apparently requires also:
> > commit ebd4acc0cbeae9efea15993b11b05bd32942f3f0
> > Author: Alexandre Ghiti <alexghiti@rivosinc.com>
> > Date:   Tue Jan 23 14:27:30 2024 +0100
> > 
> >      riscv: Fix wrong size passed to local_flush_tlb_range_asid()
> 
> Ah,
> 
> the very same fix is contained in 074 as:
> commit d9807d60c145836043ffa602328ea1d66dc458b1
> Author: Vincent Chen <vincent.chen@sifive.com>
> Date:   Wed Jan 17 22:03:33 2024 +0800
> 
>     riscv: mm: execute local TLB flush after populating vmemmap
> 
> 
> So ebd4acc0c above is redundant (nothing is needed to be done here).

Not noise at all, thanks for checking!

greg k-h
