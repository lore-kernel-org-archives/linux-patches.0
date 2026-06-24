Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9534230ACEE;
	Wed, 24 Jun 2026 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782318613; cv=none; b=SNoiFlB2FOLP+M1q49g9M7dlBKnlMbNuiCVYWcJMYHR6X/fGZTgLKB5Me8D5dL5P0GO4SaELwUQJNImJQfIZQKrQSlq5Ae7RFtjWqehSEdD4CYW0BcBtAK5/XgZtmfAc5jA5MUhxJI0WlW51zXiDSITMxqic4iad2filYTSgLbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782318613; c=relaxed/simple;
	bh=/To/JJJKIU3LIEbSv13kJAVPlpEl3xbd49hOg9zjcVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RS/BHXnoKGI0O5ottBJ9zYSC0iSNzYKHfSQu5vhA6HFvdkhcI2ntN87vhSDIUIAXKrFPwyvp85M1EtsxkhjlaYSW9HyL5Z4WAO13YTvTr4GNFELCZ/fMpjABTN8uEAdYgvgHfiOzQaa7OAMj/7RGWaecs5n3rsMM1MMn2G95NFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=od2yYyf/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="od2yYyf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939161F00AC4;
	Wed, 24 Jun 2026 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782318612;
	bh=mbyuAlSoRh47aaPkX7JF2oGMTEIdF1Zcr15uiIt8usA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=od2yYyf/sl8pz4IJPQDnQOrhYkXrpXNEKFtjPgBBO8QmuXmuUJUW1LX14FDxlYUHS
	 Kw2kXlsRYdoRkjieZwt375+G5/EYfc5MLvG0MXBfetqiJGWAU7reZ5yiJUSXhZyrRO
	 V9QwT7TTke2/Ucc705VGL2T6GpiWzVWpsj62SWyo=
Date: Wed, 24 Jun 2026 17:29:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	stable <stable@vger.kernel.org>, mark.rutland@arm.com
Subject: Re: [PATCH 6.1 337/522] arm64/mm: Enable batched TLB flush in
 unmap_hotplug_range()
Message-ID: <2026062451-bluff-coherent-672d@gregkh>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145141.584613180@linuxfoundation.org>
 <b0d5836032ce3135bfc473f6bff791306d086925.camel@decadent.org.uk>
 <ajqXWqiAol6Shdd6@willie-the-truck>
 <d2a633c8-496e-48e1-bfa0-a0fc75bd0a08@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2a633c8-496e-48e1-bfa0-a0fc75bd0a08@arm.com>

On Wed, Jun 24, 2026 at 04:05:01PM +0100, Ryan Roberts wrote:
> On 23/06/2026 15:25, Will Deacon wrote:
> > On Sun, Jun 21, 2026 at 05:02:27PM +0200, Ben Hutchings wrote:
> >> On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
> >>> 6.1-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Anshuman Khandual <anshuman.khandual@arm.com>
> >>>
> >>> [ Upstream commit 48478b9f791376b4b89018d7afdfd06865498f65 ]
> >> [...]
> >>> @@ -949,15 +953,14 @@ static void unmap_hotplug_pmd_range(pud_
> >>>  		WARN_ON(!pmd_present(pmd));
> >>>  		if (pmd_sect(pmd)) {
> >>>  			pmd_clear(pmdp);
> >>> -
> >>> -			/*
> >>> -			 * One TLBI should be sufficient here as the PMD_SIZE
> >>> -			 * range is mapped with a single block entry.
> >>> -			 */
> >>> -			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> >>> -			if (free_mapped)
> >>> +			if (free_mapped) {
> >>> +				/* CONT blocks are not supported in the vmemmap */
> >>> +				WARN_ON(pmd_cont(pmd));
> >>> +				flush_tlb_kernel_range(addr, addr + PMD_SIZE);
> >>
> >> It wasn't clear to me from the commit message why this now adds PMD_SIZE
> >> rather than PAGE_SIZE.  It seems like this change is fine for Linux
> >> 6.13+ with a CPU that supports TLB range flushing, but otherwise results
> >> in unnecessarily executing multiple TLB invalidations at intervals of
> >> the base page size.
> > 
> > Hmm, the commit message also makes very little sense to me and so I don't
> > understand why this patch has us doing multiple TLB invalidations when
> > we run into a !cont, block mapping at the PMD level. The old comment
> > (which this patch removes) should still apply afaict.
> > 
> > Anshuman, Ryan, any ideas what's going on here?
> 
> I think this change was probably my fault; Given the API is called
> flush_tlb_kernel_range() it seemed like an abuse/hack to pretend we are only
> flushing the first PAGE_SIZE of the range. But as I understand it, even if the
> HW shatters a block mapping into multiple TLB entries, all of the entries
> relating to the block mapping will be invalidated if just one of them intersects
> the TLBI range/address. So it should be safe to reapply this hack.
> 
> Although ideally I think it would be better if this API took a stride argument;
> then intent is clear.
> 
> What's the best way to handle this? Submit a patch for mainline that reverts
> this part, then get it backported to stable (implying this current patch will
> have been applied to stable)?

yes, that's probably the best way.

thanks,

greg k-h
