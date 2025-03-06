Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5D720297E;
	Thu,  6 Mar 2025 11:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741262269; cv=none; b=lgA8YCDHHuTiO8wnptxLb7FaseJoAbz5A6d6+WO9zKFSm72WF1nefCIrZ6BTDQEcY/zW0fV10v1e/O+VRWqXYOhVp4rrD5bYRp1/QD/X4f+MgFk2M42Nte2U/7hTisdW9qPdQDfNkMdyF104Fqifzg6XJ751NYwIr9JvPUsu73c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741262269; c=relaxed/simple;
	bh=8EgS825X9yD37ft8hDnIHWNltuCEt3bM7u9HuOxEfT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d18C0CZgskJDVVbcPgArZdghcePUyLOXSat7M6lHJbVxJuEVVwuYXEhUCWBjthT5fB93EvXLKyxxNQeA7cVYwam6rYxb/XTjw/sVuxmBRP2P7E3XRonglYaa9o8+IG7uLwx2afyzNuFAYAB0Je4TYzK08T+XZqfQYOyzltCGCis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u50K4tTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u50K4tTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE54C4CEE0;
	Thu,  6 Mar 2025 11:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741262268;
	bh=8EgS825X9yD37ft8hDnIHWNltuCEt3bM7u9HuOxEfT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u50K4tTANqc24s+/iKR0pWIY1tFRCHvMvd8Xya0fPl6X7GCEtNJehV9dW7SivyeoR
	 ZcqvtbEL61pYOL8cBI4Px5oJHMpbV67i+2p/6/oDfRWLtAZp1D76ouNQhWM7vUX7FH
	 znbTssCYNQhhOesekCfNqTrR8Vqgcu6lOw9K4z4Q=
Date: Thu, 6 Mar 2025 12:57:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 6.13 100/157] arm64: hugetlb: Fix
 huge_ptep_get_and_clear() for non-present ptes
Message-ID: <2025030612-polio-handclasp-49f8@gregkh>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174509.330888653@linuxfoundation.org>
 <ebf8b6fc-33b8-408b-aeac-96b8495753e6@kernel.org>
 <44400ac2-4c46-498c-a5d1-5a0441dd5571@kernel.org>
 <4d1cfbc1-0bae-4d3a-a3c5-fb3668b14ae6@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d1cfbc1-0bae-4d3a-a3c5-fb3668b14ae6@arm.com>

On Thu, Mar 06, 2025 at 11:49:15AM +0000, Ryan Roberts wrote:
> On 06/03/2025 08:08, Jiri Slaby wrote:
> > On 06. 03. 25, 9:07, Jiri Slaby wrote:
> >> On 05. 03. 25, 18:48, Greg Kroah-Hartman wrote:
> >>> 6.13-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Ryan Roberts <ryan.roberts@arm.com>
> >>>
> >>> commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.
> > ...
> >>> @@ -401,13 +393,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
> >>>   {
> >>>       int ncontig;
> >>>       size_t pgsize;
> >>> -    pte_t orig_pte = __ptep_get(ptep);
> >>> -
> >>> -    if (!pte_cont(orig_pte))
> >>> -        return __ptep_get_and_clear(mm, addr, ptep);
> >>> -
> >>> -    ncontig = find_num_contig(mm, addr, ptep, &pgsize);
> >>> +    ncontig = num_contig_ptes(sz, &pgsize);
> >>
> >>
> >> This fails to build:
> >>
> >> /usr/bin/gcc-current/gcc (SUSE Linux) 14.2.1 20250220 [revision
> >> 9ffecde121af883b60bbe60d00425036bc873048]
> >> /usr/bin/aarch64-suse-linux-gcc (SUSE Linux) 14.2.1 20250220 [revision
> >> 9ffecde121af883b60bbe60d00425036bc873048]
> >> run_oldconfig.sh --check... PASS
> >> Build...                    FAIL
> >> + make -j48 -s -C /dev/shm/kbuild/linux.34170/current ARCH=arm64 HOSTCC=gcc
> >> CROSS_COMPILE=aarch64-suse-linux- clean
> >> arch/arm64/mm/hugetlbpage.c:397:35: error: 'sz' undeclared (first use in this
> >> function); did you mean 's8'?
> >>        |                                   s8
> >> arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclared identifier is
> >> reported only once for each function it appears in
> >> make[4]: *** [scripts/Makefile.build:197: arch/arm64/mm/hugetlbpage.o] Error 1
> > 
> > It looks like the stable tree is missing this pre-req:
> > commit 02410ac72ac3707936c07ede66e94360d0d65319
> > Author: Ryan Roberts <ryan.roberts@arm.com>
> > Date:   Wed Feb 26 12:06:51 2025 +0000
> > 
> >     mm: hugetlb: Add huge page size param to huge_ptep_get_and_clear()
> 
> Although this patch is marked for stable there was a conflict so it wasn't
> applied. I'll try to get the backport done in the next few days.

I'll just drop this one now, can you send me the backports for both of
these when they are ready?

thanks,

greg k-h
