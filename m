Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D8E3FF889;
	Mon, 29 Jun 2026 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737416; cv=none; b=Z9U5f0FniKKP40sPRmN2b0AbdBHKl1YaKV4i7jD7TushE8SsumdtpczdkV2KMMcCvVXXZWS8sSUYaF1ELX7rlXiV3Xe5fQug5tUNi9sJRACsh0maBZkAM6BcjqrMbjSCnQYE7AJ5UAV1y5jtAJO9GZV48lwZauVnjEQYjrnZFSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737416; c=relaxed/simple;
	bh=1vkFsm/C73sLLTMbFwcK9c4kgPWMv/1AfkorNae0fls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQWRK4NjKv+lTa2RDZ1444xXMvtU/icN0X1BIx5cSW3X52NqDlnH6RWZJ4nVDE+bKYmbW8Uyrk0sgpn3EZB77s8EPr6PbZKStI0j877t0qbz2vDwz8xKrEvyLEu997nkGfw9WAniWGcOG8uxlKujwx/yhUXHqzmZ1/JxycXpY1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDkIDnL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDkIDnL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8711F00A3A;
	Mon, 29 Jun 2026 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782737415;
	bh=AEvcL4eAJdQvW0mI6HKHdq0ilBCt30WgNyC54gIx2CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VDkIDnL15o3M8f4zo4AGU7YEQMIl5UgoBJmoENdTz3injrYVyiI70r951xn34x3RT
	 Pw9QIawJBv0eTJ/Q5XIwzpOrc92S10duEN6s4paizdMeFEI0frzAIFGcm56IRPJXqE
	 tJMQMqdNYR1KJm6hqjvILDk+/RKKHhhLdfAoi8N+AvQa8HDlnL/e2iGyAWs36q9vYT
	 gLKqinDNO7AeOuRkbBvvXuroiMdBSMyzyE7XMgvM5M+u+mYEhM/JEi6qxqzjsB7IaG
	 eWbkeBz79q7UNXb6hA7NI2OTcn1xxev064bnsQilEQZx4T2e7YolKesHZa4tL0mxIi
	 29l+SSejuBXUQ==
Date: Mon, 29 Jun 2026 13:50:09 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	stable <stable@vger.kernel.org>, mark.rutland@arm.com
Subject: Re: [PATCH 6.1 337/522] arm64/mm: Enable batched TLB flush in
 unmap_hotplug_range()
Message-ID: <akJqAZ8CdhHqGJIS@willie-the-truck>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145141.584613180@linuxfoundation.org>
 <b0d5836032ce3135bfc473f6bff791306d086925.camel@decadent.org.uk>
 <ajqXWqiAol6Shdd6@willie-the-truck>
 <d2a633c8-496e-48e1-bfa0-a0fc75bd0a08@arm.com>
 <2026062451-bluff-coherent-672d@gregkh>
 <b51f82ed-aa54-4c67-bcef-e59acd10c789@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b51f82ed-aa54-4c67-bcef-e59acd10c789@arm.com>

On Thu, Jun 25, 2026 at 07:59:51AM +0530, Anshuman Khandual wrote:
> On 24/06/26 9:59 PM, Greg Kroah-Hartman wrote:
> > On Wed, Jun 24, 2026 at 04:05:01PM +0100, Ryan Roberts wrote:
> >> On 23/06/2026 15:25, Will Deacon wrote:
> >>> On Sun, Jun 21, 2026 at 05:02:27PM +0200, Ben Hutchings wrote:
> >>>>> @@ -949,15 +953,14 @@ static void unmap_hotplug_pmd_range(pud_
> >>>>>  		WARN_ON(!pmd_present(pmd));
> >>>>>  		if (pmd_sect(pmd)) {
> >>>>>  			pmd_clear(pmdp);
> >>>>> -
> >>>>> -			/*
> >>>>> -			 * One TLBI should be sufficient here as the PMD_SIZE
> >>>>> -			 * range is mapped with a single block entry.
> >>>>> -			 */
> >>>>> -			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> >>>>> -			if (free_mapped)
> >>>>> +			if (free_mapped) {
> >>>>> +				/* CONT blocks are not supported in the vmemmap */
> >>>>> +				WARN_ON(pmd_cont(pmd));
> >>>>> +				flush_tlb_kernel_range(addr, addr + PMD_SIZE);
> >>>>
> >>>> It wasn't clear to me from the commit message why this now adds PMD_SIZE
> >>>> rather than PAGE_SIZE.  It seems like this change is fine for Linux
> >>>> 6.13+ with a CPU that supports TLB range flushing, but otherwise results
> >>>> in unnecessarily executing multiple TLB invalidations at intervals of
> >>>> the base page size.
> >>>
> >>> Hmm, the commit message also makes very little sense to me and so I don't
> >>> understand why this patch has us doing multiple TLB invalidations when
> >>> we run into a !cont, block mapping at the PMD level. The old comment
> >>> (which this patch removes) should still apply afaict.
> >>>
> >>> Anshuman, Ryan, any ideas what's going on here?
> >>
> >> I think this change was probably my fault; Given the API is called
> >> flush_tlb_kernel_range() it seemed like an abuse/hack to pretend we are only
> >> flushing the first PAGE_SIZE of the range. But as I understand it, even if the
> >> HW shatters a block mapping into multiple TLB entries, all of the entries
> >> relating to the block mapping will be invalidated if just one of them intersects
> >> the TLBI range/address. So it should be safe to reapply this hack.
> >>
> >> Although ideally I think it would be better if this API took a stride argument;
> >> then intent is clear.
> >>
> >> What's the best way to handle this? Submit a patch for mainline that reverts
> >> this part, then get it backported to stable (implying this current patch will
> >> have been applied to stable)?
> > 
> > yes, that's probably the best way.
> Sure, will send out the change as suggested.

In case anybody ends up following the breadcrumbs, the patch is here:

https://lore.kernel.org/r/20260626012845.475959-1-anshuman.khandual@arm.com

Will
