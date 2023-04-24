Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B88863C5
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 21:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=6akZipOgCyOOOmc4me7AVkravhWsWCWWq0gvxN0yJCk=; b=BwNGtkc1It9/hiYefg9W7TUb9h
	VfrI4CpsywE7Cn23PP/H+pPg3bB4/+XqhDSzTzI10kylqbr0zUYrtfKH4fpF7jbXmzWPR8BKa9Qxe
	XKxCAxEZBB/y+uegoxqkP7ZVmyZEuO4MLF+cXj0OUyaT/6QvMFZsXhVhD0pvTwULWA5BBKEMhyFpE
	BTpcpzIdLWw5WK77ADuFBGsOP69VgFKamaSs8CInuYF6h37pmVVgHzuNh37CxixhnmfkAH4AYXga6
	fk8t7IeW+KYPfCqzANDRiQXYlLExFCV1eAmYFuyx79OSf0axdIfSK8XcySzi8tnI5++ujeiHIjSga
	xmHQOXWA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pr3rl-000pf0-Kd; Mon, 24 Apr 2023 21:36:57 +0000
Date: Mon, 24 Apr 2023 22:36:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yang Shi <shy828301@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, hughd@google.com,
	akpm@linux-foundation.org, brauner@kernel.org, djwong@kernel.org,
	p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/8] shmem: convert to use folio_test_hwpoison()
Message-ID: <ZEb2eYX5btfLrUtQ@casper.infradead.org>
References: <20230421214400.2836131-1-mcgrof@kernel.org>
 <20230421214400.2836131-3-mcgrof@kernel.org>
 <ZEMRbcHSQqyek8Ov@casper.infradead.org>
 <ZENO4vZzmN8lJocK@bombadil.infradead.org>
 <CAHbLzkoEAJhz8GG91MSM9+wCYVqseSFzBQdVAP78W5WPq26GHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkoEAJhz8GG91MSM9+wCYVqseSFzBQdVAP78W5WPq26GHQ@mail.gmail.com>

On Mon, Apr 24, 2023 at 02:17:12PM -0700, Yang Shi wrote:
> On Fri, Apr 21, 2023 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Fri, Apr 21, 2023 at 11:42:53PM +0100, Matthew Wilcox wrote:
> > > On Fri, Apr 21, 2023 at 02:43:54PM -0700, Luis Chamberlain wrote:
> > > > The PageHWPoison() call can be converted over to the respective folio call
> > > > folio_test_hwpoison(). This introduces no functional changes.
> > >
> > > Um, no.  Nobody should use folio_test_hwpoison(), it's a nonsense.
> > >
> > > Individual pages are hwpoisoned.  You're only testing the head page
> > > if you use folio_test_hwpoison().  There's folio_has_hwpoisoned() to
> > > test if _any_ page in the folio is poisoned.  But blindly converting
> > > PageHWPoison to folio_test_hwpoison() is wrong.
> >
> > Thanks! I don't see folio_has_hwpoisoned() though.
> 
> We do have PageHasHWPoisoned(), which indicates at least one subpage
> is hwpoisoned in the huge page.
> 
> You may need to add a folio variant.

PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
        TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)

That generates folio_has_hwpoisoned() along with
folio_set_has_hwpoisoned(), folio_clear_has_hwpoisoned(),
folio_test_set_has_hwpoisoned() and folio_test_clear_has_hwpoisoned().
