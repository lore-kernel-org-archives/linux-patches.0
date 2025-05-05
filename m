Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D901F4184;
	Mon,  5 May 2025 09:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746437299; cv=none; b=jbWUdBA3R8AHaJyFEIzAAiBG9bZ+yrHOXG/OFJy5Tl3kaD/DqAxmfip2mubDYGVSBbjYbG+9NvpbbBPvpukEqs5Dcq9Yk2GmhboBkNCNQlTsiN6a8Lr8zdFrOaKjbHyktkuUYVu9vR/ihSFqHyn/Ow39rPtLA0Z22vbqygg3olM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746437299; c=relaxed/simple;
	bh=dCOuf1fuJW62yJ0CcdQm/lsVYvmHoGYJFQZUHRvn+jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOEaKqSMl8j5MrRzveO/AgjaFvIkvmWxkIhp8cuQkho2yz1kIJuF4UwVJIKDsPg+3ClKtmBVHd+V4SaQYyAfxT24kPqG/3dTxjFFdiM0PFbzTgcwDXc/59Q4ENtjkQt5Xgde6NVHam+bx4FpNMZZYZxy86JbVM8B8oqfKFdtQow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSZCvqlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSZCvqlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE25DC4CEE4;
	Mon,  5 May 2025 09:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746437298;
	bh=dCOuf1fuJW62yJ0CcdQm/lsVYvmHoGYJFQZUHRvn+jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KSZCvqlUzTvtM0CoA5F1U0jzoN2XfHErluwYePeV6ewy+5JQGb+/XEN3nT/mBkh5E
	 OSjXEbePEa56Y4nGNwRsACtOjWcLBaQQ1Tn64w4aZ8H1QpcA4nJziFNolfVjJAgsBC
	 SUGGoErqNu3vAsCcQBeRcoefK31rsDWKb7DYHcPs=
Date: Mon, 5 May 2025 11:28:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Tai, Gerrard" <gerrard.tai@starlabs.sg>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: net/sched: codel: Inclusion of patchset
Message-ID: <2025050519-stem-fidelity-25b1@gregkh>
References: <CAHcdcOkW1D_zKh-HPsfjX-oGYhv-OwojPXVwcA=NYoO0hcCbZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHcdcOkW1D_zKh-HPsfjX-oGYhv-OwojPXVwcA=NYoO0hcCbZQ@mail.gmail.com>

On Fri, May 02, 2025 at 12:49:48PM +0800, Tai, Gerrard wrote:
> Upstream commits:
> 01: 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
> htb_qlen_notify() idempotent")
> 02: df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
> drr_qlen_notify() idempotent")
> 03: 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
> hfsc_qlen_notify() idempotent")
> 04: 55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
> qfq_qlen_notify() idempotent")
> 05: a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
> est_qlen_notify() idempotent")
> 06: 342debc12183b51773b3345ba267e9263bdfaaef ("codel: remove
> sch->q.qlen check before qdisc_tree_reduce_backlog()")
> 
> These patches are patch 01-06 of the original patchset ([1]) authored by
> Cong Wang. I have omitted patches 07-11 which are selftests. This patchset
> addresses a UAF vulnerability.
> 
> Originally, only the last commit (06) was picked to merge into the latest
> round of stable queues 5.15,5.10,5.4. For 6.x stable branches, that sole
> commit has already been merged in a previous cycle.
> 
> >From my understanding, this patch depends on the previous patches to work.
> Without patches 01-05 which make various classful qdiscs' qlen_notify()
> idempotent, if an fq_codel's dequeue() routine empties the fq_codel qdisc,
> it will be doubly deactivated - first in the parent qlen_notify and then
> again in the parent dequeue. For instance, in the case of parent drr,
> the double deactivation will either cause a fault on an invalid address,
> or trigger a splat if list checks are compiled into the kernel. This is
> also why the original unpatched code included the qlen check in the first
> place.
> 
> After discussion with Greg, he has helped to temporarily drop the patch
> from the 5.x queues ([2]). My suggestion is to include patches 01-06 of the
> patchset, as listed above, for the 5.x queues. For the 6.x queues that have
> already merged patch 06, the earlier patches 01-05 should be merged too.
> 
> I'm not too familiar with the stable patch process, so I may be completely
> mistaken here.

I'll be glad to take what is needed, but please list what commits need
to go to what branches and in what exact order please.

Or better yet, send backported patches to us, as patch series emails,
which we can import that way as we know you have tested them properly.

thanks!

greg k-h
