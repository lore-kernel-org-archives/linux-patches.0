Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892F92C99
	for <patches@lists.linux.dev>; Sat, 11 Dec 2021 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u/N0Z1R4JJJOrnFGUtTYcDRphW4OI/ZTkZQ/n5WMmxo=; b=BAKk3TlOpDapjy+sRZ5EwPj9XL
	EW+Xw1yKvik4prj+1S5dwaee8Wi1otnWT5eQd09a/q4iJGPFGMss9Q4sD5QyXMKDt/I1D+BQ11FfF
	LkCJDdd89XQmKiXTMXfaQ9WSaXb4ctBhY0ZDOk4Mh6uGKPiiLYDbsTFn9rJ59CBn/nE69rGmPFJI7
	zyz9SVGOkWxh4aKb5EiR4acweKJpzBpNeWr44DfR+fWDXE6v8bdv7xN42jkh8rHEUenIfCowRvHQF
	noKgz8PWjRVTHL1jUwHyOUgSH1NyNgrn5dL6vVSHW1Dku1BAUMYFaeuKAmXNLeYO9vkJUQlqyoR34
	NbujTehg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mw5c7-00BKuT-BZ; Sat, 11 Dec 2021 16:52:47 +0000
Date: Sat, 11 Dec 2021 16:52:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v2 31/33] mm/sl*b: Differentiate struct slab fields by
 sl*b implementations
Message-ID: <YbTXXwVy/a+/9PCn@casper.infradead.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-32-vbabka@suse.cz>
 <20211210163757.GA717823@odroid>
 <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>
 <20211211115527.GA822127@odroid>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211115527.GA822127@odroid>

On Sat, Dec 11, 2021 at 11:55:27AM +0000, Hyeonggon Yoo wrote:
> On Fri, Dec 10, 2021 at 07:26:11PM +0100, Vlastimil Babka wrote:
> > On 12/10/21 17:37, Hyeonggon Yoo wrote:
> > > On Wed, Dec 01, 2021 at 07:15:08PM +0100, Vlastimil Babka wrote:
> > >> With a struct slab definition separate from struct page, we can go further and
> > >> define only fields that the chosen sl*b implementation uses. This means
> > >> everything between __page_flags and __page_refcount placeholders now depends on
> > >> the chosen CONFIG_SL*B.
> > > 
> > > When I read this patch series first, I thought struct slab is allocated
> > > separately from struct page.
> > > 
> > > But after reading it again, It uses same allocated space of struct page.
> > 
> > Yes. Allocating it elsewhere is something that can be discussed later. It's
> > not a simple clear win - more memory used, more overhead, complicated code...
> >
> 
> Right. That is a something that can be discussed,
> But I don't think there will be much win.

Oh no, there's a substantial win.  If we can reduce struct page to a
single pointer, that shrinks it from 64 bytes/4k to 8 bytes/4k.  Set
against that, you have to allocate the struct folio / struct slab / ...
but then it's one _per allocation_ rather than one per page.  So for
an order-2 allocation, it takes 32 bytes + 64 bytes (= 96 bytes)
rather than 4*64 = 256 bytes.  It's an even bigger win for larger
allocations, and it lets us grow the memory descriptors independently
of each other.

But it's also a substantial amount of work, so don't expect us to get
there any time soon.  Everything currently using struct page needs to
be converted to use another type, and that's just the pre-requisite
step.

Some more thoughts on this here:
https://lore.kernel.org/linux-mm/YXcLqcFhDq3uUwIj@casper.infradead.org/

> > Yeah. Also whatever aliases with compound_head must not have bit zero set as
> > that means a tail page.
> > 
> 
> Oh I was missing that. Thank you.
> 
> Hmm then in struct slab, page->compound_head and slab->list_head (or
> slab->rcu_head) has same offset. And list_head / rcu_head both store pointers.
> 
> then it has a alignment requirement. (address saved in list_head/rcu_head
> should be multiple of 2)
> 
> Anyway, it was required long time before this patch,
> so it is not a problem for this patch.

Yes, that's why there's an assert that the list_heads all line up.  This
requirement will go away if we do get separately allocated memory
descriptors (because that bottom bit is no longer PageTail).

