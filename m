Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8A936654A;
	Fri, 30 Jan 2026 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769814867; cv=none; b=aFRwastrJgh7/5VGP8KWNcAl1zf9sisGeb9gusIhe+l+0wvLC8ygB2oxb0L4tJQFTfy586zePmKeppyn343QO6QelmNMh3Yx2sCwPCxPYaRqi3h8dFlgCKdiFA/6ehdAb9u8jzP7AjOMj0jRM7FMrUJ/hj5WgwHoP9wszFJmlQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769814867; c=relaxed/simple;
	bh=BYVLMfjlzugSV06GJuMhIdNz3ii0H/2nYGc7SJ5HKu4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HaS1swpS6pU5gbgM1++atmGQM41tUkPL3TFjIQE8sRlxwgPPmqNOrSPuWl8fafYOBXVputFyNEMzfhBPOfNBzRKE/LgHpXGzLZ2LtdHs2k3wX5/1OZAa6fp8cA4D4TTF0jF3OammyENmysp39i/IPrAWaTWSo6x4GBVK9nun49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdD+wVPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdD+wVPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C2FC4CEF7;
	Fri, 30 Jan 2026 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769814867;
	bh=BYVLMfjlzugSV06GJuMhIdNz3ii0H/2nYGc7SJ5HKu4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=GdD+wVPUvvGQjp73geEyDLrh0soCtHBNZVcAcWAkgcbjjCCdvJ206yPdVnVWBjCnP
	 mMGJsYvquL1KVKDccli3glI2w+MfbL0yQQ1BJ1+QlXap0Ck+AUpgMqo7NEA7mYCxkG
	 gPEctX/SPOsnWU8xXeUjNb9rc1TPsQhJJgyYBqY+q7KZ7T5WX/YYj3qLABuPAhnTR0
	 SVQq2j8zeYLJ+lzqZwR4j0RKA5GZqDDsRMuYb5WzLVrkkFaIAQz7k0wUEzSSHsljMb
	 d0NiQe7Dc/j4TFzw3+mqE3QQejUhbT62cgpkhlIOonOFqhy2h+4NY10ZmyOO234yn1
	 CrojXD2jTfg1g==
Date: Fri, 30 Jan 2026 16:14:24 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>
cc: Tomasz Jeznach <tjeznach@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>, 
    Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, 
    linux-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>, 
    Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
    Will Deacon <will@kernel.org>, lihangjing@bytedance.com, 
    Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev, 
    xieyongji@bytedance.com
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page
 table
In-Reply-To: <20260129004640.GB1641016@ziepe.ca>
Message-ID: <63c38161-762f-bff5-0b9c-0148140c695b@kernel.org>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com> <72olk767l4goaqsrkyelhtnzg33nxbtwnammy4asnqxukbolnh@gwypmg6n5t3e> <20260129004640.GB1641016@ziepe.ca>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 28 Jan 2026, Jason Gunthorpe wrote:

> On Thu, Jan 22, 2026 at 08:56:12AM +0100, Joerg Roedel wrote:
> > Tomasz,
> > 
> > On Tue, Jan 06, 2026 at 11:06:44AM -0400, Jason Gunthorpe wrote:
> > > Jason Gunthorpe (5):
> > >   iommupt: Add the RISC-V page table format
> > >   iommu/riscv: Disable SADE
> > >   iommu/riscv: Use the generic iommu page table
> > >   iommu/riscv: Enable SVNAPOT support for contiguous ptes
> > >   iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
> > 
> > Any opinion on that series?
> 
> Let's take it if we don't hear from Tomasz this week? It brings
> the contiguous page feature people wanted and now that it is tested
> I'm not especially worried about it.

In the event that you don't hear from Tomasz:

Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv 


- Paul
