Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1623C38;
	Fri, 15 Nov 2024 05:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731647775; cv=none; b=hRuPdBkkMCAzndqIproZCBBi1ESZbekhXLZonhiNFAaUT9u7ofGoF+JNeGv1WhfFzWum/QDfKVbRkVDHZOH1uGSAvZdthDmuryEnpLYYHrKJY2qkIF2Gx9fnm+rNBpBv3zsgGd5OBH8cOYjOYGaDfAU2ifM9rgR/1EJznnqYLIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731647775; c=relaxed/simple;
	bh=eHkERqEjvTZgaM7l20hGxpli69x0Yab9FNcVqFqHGMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak8ncbt4rKcV7+z4qAwbOY620YsvWrigQtwqvkB1aDIG2sC/7KCJ+GmJ6KtrRMtt58s1vWXWOQUytNOiq7xdVN9ksdCXBqGGsHnHhTVWT1RVrbTj5wsynByY8nx374/eTP2etOG/IAKGCYSj+fAxZdhLUrX/jCv+hC13ldukw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3vF1ft0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3vF1ft0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08328C4CECF;
	Fri, 15 Nov 2024 05:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731647774;
	bh=eHkERqEjvTZgaM7l20hGxpli69x0Yab9FNcVqFqHGMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W3vF1ft0g04H6At1xle4IUwl7kMvhgWN0pjo8U/nj92Woojwyc8K67H97tfvPw6AK
	 QGgxEMkqLd5diuZLvC1Fd2NP4kyHr3RKhzoKLd3jqi0Hy/Hzr2q5q4v4ox5mVCnvZy
	 7zZ2zXH/ILlqGnftUDQ6ictrVc2y9SI7qmH2+TZo=
Date: Fri, 15 Nov 2024 06:16:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Qun-Wei Lin <qun-wei.lin@mediatek.com>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 5.4 462/462] mm: krealloc: Fix MTE false alarm in
 __do_krealloc
Message-ID: <2024111543-villain-graves-6111@gregkh>
References: <20241106120331.497003148@linuxfoundation.org>
 <20241106120342.916487840@linuxfoundation.org>
 <ZzPe9ossmfQP_s77@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzPe9ossmfQP_s77@google.com>

On Tue, Nov 12, 2024 at 03:04:22PM -0800, Peter Collingbourne wrote:
> On Wed, Nov 06, 2024 at 01:05:55PM +0100, Greg Kroah-Hartman wrote:
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Qun-Wei Lin <qun-wei.lin@mediatek.com>
> > 
> > commit 704573851b51808b45dae2d62059d1d8189138a2 upstream.
> > 
> > This patch addresses an issue introduced by commit 1a83a716ec233 ("mm:
> > krealloc: consider spare memory for __GFP_ZERO") which causes MTE
> > (Memory Tagging Extension) to falsely report a slab-out-of-bounds error.
> > 
> > The problem occurs when zeroing out spare memory in __do_krealloc. The
> > original code only considered software-based KASAN and did not account
> > for MTE. It does not reset the KASAN tag before calling memset, leading
> > to a mismatch between the pointer tag and the memory tag, resulting
> > in a false positive.
> > 
> > Example of the error:
> > ==================================================================
> > swapper/0: BUG: KASAN: slab-out-of-bounds in __memset+0x84/0x188
> > swapper/0: Write at addr f4ffff8005f0fdf0 by task swapper/0/1
> > swapper/0: Pointer tag: [f4], memory tag: [fe]
> > swapper/0:
> > swapper/0: CPU: 4 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.
> > swapper/0: Hardware name: MT6991(ENG) (DT)
> > swapper/0: Call trace:
> > swapper/0:  dump_backtrace+0xfc/0x17c
> > swapper/0:  show_stack+0x18/0x28
> > swapper/0:  dump_stack_lvl+0x40/0xa0
> > swapper/0:  print_report+0x1b8/0x71c
> > swapper/0:  kasan_report+0xec/0x14c
> > swapper/0:  __do_kernel_fault+0x60/0x29c
> > swapper/0:  do_bad_area+0x30/0xdc
> > swapper/0:  do_tag_check_fault+0x20/0x34
> > swapper/0:  do_mem_abort+0x58/0x104
> > swapper/0:  el1_abort+0x3c/0x5c
> > swapper/0:  el1h_64_sync_handler+0x80/0xcc
> > swapper/0:  el1h_64_sync+0x68/0x6c
> > swapper/0:  __memset+0x84/0x188
> > swapper/0:  btf_populate_kfunc_set+0x280/0x3d8
> > swapper/0:  __register_btf_kfunc_id_set+0x43c/0x468
> > swapper/0:  register_btf_kfunc_id_set+0x48/0x60
> > swapper/0:  register_nf_nat_bpf+0x1c/0x40
> > swapper/0:  nf_nat_init+0xc0/0x128
> > swapper/0:  do_one_initcall+0x184/0x464
> > swapper/0:  do_initcall_level+0xdc/0x1b0
> > swapper/0:  do_initcalls+0x70/0xc0
> > swapper/0:  do_basic_setup+0x1c/0x28
> > swapper/0:  kernel_init_freeable+0x144/0x1b8
> > swapper/0:  kernel_init+0x20/0x1a8
> > swapper/0:  ret_from_fork+0x10/0x20
> > ==================================================================
> > 
> > Fixes: 1a83a716ec233 ("mm: krealloc: consider spare memory for __GFP_ZERO")
> > Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  mm/slab_common.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Hi Greg,
> 
> Can this be picked up for the other stable trees as well please? The
> patch that caused MTE false positives is in linux-5.10.y, linux-5.15.y,
> linux-6.1.y and linux-6.6.y but this fix is not. I checked that it
> applies cleanly to all of them.

Yes, that's odd it only went to 5.4.y, something must have gone wonky
with Sasha's scripts here and we didn't catch that in review, sorry.

Now queued up, thanks!

greg k-h
