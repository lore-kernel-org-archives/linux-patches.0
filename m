Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4BD32F759;
	Fri, 21 Nov 2025 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763740370; cv=none; b=MC4KxpqQNXcc4vWxnhuv5jQewalhr88E+qV7s4Xdp8BQuqzW0w94veK10Yv6zAA1C3/51pwt5V8jPMsze5tPXa7SZ/dbUWO8Ftsi2006W7PyLF5D1puqGoau5Zk0nTRZzyoUA9tg7GOqkSq4hb+PoT/unGmDRGFc7p65TmcpiAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763740370; c=relaxed/simple;
	bh=GoZm8lNdtiFSosELTsEndzB4/4WVmjswdcJL6FDpoDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ev9wgnlA8365vart/1XOie+HonE6ORPDP9IbbVvCu1gkbii9Oxpb5PrBgSTfo1XkHtySZNUd/peJ9+jzEje4ayRlJ+RAA8uLnxjWUtgfxb4cS3BraWUVRtzzXroIU0fu0SDHHSiQdOBoU8iGBBkWlhc0DP26FTrGJIHSvpJlLdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeVHyPvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeVHyPvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE49C4CEF1;
	Fri, 21 Nov 2025 15:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763740370;
	bh=GoZm8lNdtiFSosELTsEndzB4/4WVmjswdcJL6FDpoDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GeVHyPvEQLpj6FqztBVH9f/lp+9FZc+zMsZO9qaExHsKcab2onWzCPHw/evZ4diMQ
	 t7K1zxCZnBfjcWygr7aYjg13ywNRd8JcCR9f8od+9W80qPEYR8evnlyTfXVlgL3+CX
	 qUhmvssxKzUnBiwn0mRa5XmFria5H8t1lErLzwrE=
Date: Fri, 21 Nov 2025 16:52:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Mike Rapoport <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Christian Brauner <brauner@kernel.org>,
	David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.17 164/247] kho: warn and fail on metadata or preserved
 memory in scratch area
Message-ID: <2025112122-class-letdown-7be7@gregkh>
References: <20251121130154.587656062@linuxfoundation.org>
 <20251121130200.607393324@linuxfoundation.org>
 <489a925f-ba57-432d-ac50-dcd78229c2ff@leemhuis.info>
 <mafs0ldjz1jkh.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mafs0ldjz1jkh.fsf@kernel.org>

On Fri, Nov 21, 2025 at 04:39:26PM +0100, Pratyush Yadav wrote:
> On Fri, Nov 21 2025, Thorsten Leemhuis wrote:
> 
> > On 11/21/25 14:11, Greg Kroah-Hartman wrote:
> >> 6.17-stable review patch.  If anyone has any objections, please let me know.
> >> 
> >> ------------------
> >> 
> >> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> >> 
> >> commit e38f65d317df1fd2dcafe614d9c537475ecf9992 upstream.
> >> 
> >> Patch series "KHO: kfence + KHO memory corruption fix", v3.
> >> 
> >> This series fixes a memory corruption bug in KHO that occurs when KFENCE
> >> is enabled.
> >
> > I ran into a build problem that afaics is caused by this change:
> >
> > """
> > In file included from ./arch/x86/include/asm/bug.h:103,
> >                  from ./arch/x86/include/asm/alternative.h:9,
> >                  from ./arch/x86/include/asm/barrier.h:5,
> >                  from ./include/asm-generic/bitops/generic-non-atomic.h:7,
> >                  from ./include/linux/bitops.h:28,
> >                  from ./include/linux/bitmap.h:8,
> >                  from ./include/linux/nodemask.h:91,
> >                  from ./include/linux/numa.h:6,
> >                  from ./include/linux/cma.h:7,
> >                  from kernel/kexec_handover.c:12:
> > kernel/kexec_handover.c: In function ‘kho_preserve_phys’:
> > kernel/kexec_handover.c:732:41: error: ‘nr_pages’ undeclared (first use in this function); did you mean ‘dir_pages’?
> >   732 |                                         nr_pages << PAGE_SHIFT))) {
> >       |                                         ^~~~~~~~
> 
> 8375b76517cb5 ("kho: replace kho_preserve_phys() with
> kho_preserve_pages()") refactored this function to work on page
> granularity (nr_pages) instead of bytes (size). Since that commit wasn't
> backported, nr_pages does not exist.
> 
> Simple fix should be to replace "nr_pages << PAGE_SHIFT" with "size".

Great, can you provide a working version?  I'll go drop this patch from
the queue for now and push out a -rc2

thanks,

greg k-h
