Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6D1E536
	for <patches@lists.linux.dev>; Fri, 26 May 2023 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IlhXisbqRI4JCa1p0EpJL3g9WoXpQt0xT0Nj4ndM20E=; b=mnWv9xxpTNuhG9+/dZEP0422ih
	ZPvYZFFcScZsfnA2f4wknjp8Fp0JtupSp2LqseWHGM7ee9+lvA+QH1ioyjPQBJPaRm09DAuRuIwZv
	eMymAmHrmXat4ByJhquy0fed6ttcWGo5OSwCD4DS0hOTJZVIw3e/jKAfZPk/Dyoj6Bc7pa3JwUyTm
	U4mdVm/BmYresJJJ/2b5LrnxT1pJH71T53E4VxJMDnaNm+3584FVJJ9t93+Mkg4BRTKHwwm3KUvzM
	CVPnRwfPFh9kSVefDR9cPVvUJy8aevpvmdUAx0lYoGi0npASsDLKiy7j4Zyju9aD90/HrStecaqc4
	MyH9ayMg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2bQy-003KpZ-2Y;
	Fri, 26 May 2023 17:41:00 +0000
Date: Fri, 26 May 2023 10:41:00 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: hughd@google.com, akpm@linux-foundation.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 2/8] shmem: convert to use is_folio_hwpoison()
Message-ID: <ZHDvLD3vwt11EYFg@bombadil.infradead.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
 <20230526075552.363524-3-mcgrof@kernel.org>
 <ZHDDFoXs51Be8FcZ@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHDDFoXs51Be8FcZ@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, May 26, 2023 at 03:32:54PM +0100, Matthew Wilcox wrote:
> On Fri, May 26, 2023 at 12:55:46AM -0700, Luis Chamberlain wrote:
> > The PageHWPoison() call can be converted over to the respective folio
> > call is_folio_hwpoison(). This introduces no functional changes.
> 
> Yes, it very much does!
> 
> > @@ -4548,7 +4548,7 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
> >  		return &folio->page;
> >  
> >  	page = folio_file_page(folio, index);
> > -	if (PageHWPoison(page)) {
> > +	if (is_folio_hwpoison(folio)) {
> >  		folio_put(folio);
> 
> Imagine you have an order-9 folio and one of the pages in it gets
> HWPoison.  Before, you can read the other 511 pages in the folio.

But before we didn't use high order folios for reads on tmpfs?

But I get the idea.

> After your patch, you can't read any of them.  You've effectively
> increased the blast radius of any hwerror, and I don't think that's an
> acceptable change.

I see, thanks! Will fix if we move forward with this.

  Luis
