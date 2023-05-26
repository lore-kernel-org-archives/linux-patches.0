Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B218B0D
	for <patches@lists.linux.dev>; Fri, 26 May 2023 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mSsoE+0p2sc9kGpcn+WU5AUctLzpkgWUGD8f1AoBzvo=; b=ltD/wwR9voMJdzOfZ705IzKtCB
	eZA7RNSbiHcpZdR1w/wBRURZPc/ijS/ori312B41S0Xufrmw922txQtPZmPY5+qP7FUIDuM4hr1ug
	8d8UfgpK2eQOcxlveydCE6bMK2cbIXaKTL2pTOCI+ZAwJz2C2e8g7WFv21oqk8rYJaMQzBL2vqCsT
	/FPZsbcufMQFKMJoeBRxZMGJQv8E5b41Ajp9qlQLTNUnWkA07uvkkW0OZ1+PePVtaAvQqQSBO8N0T
	0raE2IBPXMiOsqaWqfVKuHy/9DDEOR8NyExErim0sjxvhnMKn/DdO77faDX89uXK5n7vdl26kjTRW
	hATqoiAA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1q2cNe-0032Q1-F3; Fri, 26 May 2023 18:41:38 +0000
Date: Fri, 26 May 2023 19:41:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 2/8] shmem: convert to use is_folio_hwpoison()
Message-ID: <ZHD9Yi04AvbawW8d@casper.infradead.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
 <20230526075552.363524-3-mcgrof@kernel.org>
 <ZHDDFoXs51Be8FcZ@casper.infradead.org>
 <ZHDvLD3vwt11EYFg@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHDvLD3vwt11EYFg@bombadil.infradead.org>

On Fri, May 26, 2023 at 10:41:00AM -0700, Luis Chamberlain wrote:
> On Fri, May 26, 2023 at 03:32:54PM +0100, Matthew Wilcox wrote:
> > On Fri, May 26, 2023 at 12:55:46AM -0700, Luis Chamberlain wrote:
> > > The PageHWPoison() call can be converted over to the respective folio
> > > call is_folio_hwpoison(). This introduces no functional changes.
> > 
> > Yes, it very much does!
> > 
> > > @@ -4548,7 +4548,7 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
> > >  		return &folio->page;
> > >  
> > >  	page = folio_file_page(folio, index);
> > > -	if (PageHWPoison(page)) {
> > > +	if (is_folio_hwpoison(folio)) {
> > >  		folio_put(folio);
> > 
> > Imagine you have an order-9 folio and one of the pages in it gets
> > HWPoison.  Before, you can read the other 511 pages in the folio.
> 
> But before we didn't use high order folios for reads on tmpfs?

Sure we did!  If SHMEM_HUGE_ALWAYS is set, we can see reads of THPs
(order-9 folios) in this path.

