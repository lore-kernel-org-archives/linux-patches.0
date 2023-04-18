Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40139C944
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hop1fEe65zKGXXNu/5+0Rw5BriX00BK5FU++RoHMVYA=; b=42V5GM4Q6rHtbzuNp4c3GaIPb8
	R16wQPo6gWN510hi8DmyS9t0kCnaxgnkYHjPVGrBZqyEjKmbvnT9l9IntqHs/Qg9IxSnO6AlyEC4V
	hTY481MQwzMcu2Z8sAunravYKfHWfj3FwcVcI3+uT/c6DSoPjVnCbLw7EWo4hm7loD6iCkcH4cMEL
	K1+aYzX8K/20Ijw+Zqz2OzZ+7dq6P+TL/yUoddlCey298ckQfhDcz2jZbJTnQFCz+gbP1DgmmAFgq
	FSx+nOpjQajMXBpV7SPsq46Q6BCCAnpmQNUZ+u15Vu4y1FY05AwGVhdQ4WqgIQzPfOIqGhL5zsVU/
	botzBmug==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1posbf-003MGN-2s;
	Tue, 18 Apr 2023 21:11:19 +0000
Date: Tue, 18 Apr 2023 14:11:19 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org,
	linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 4/6] shmem: skip page split if we're not reclaiming
Message-ID: <ZD8HdxbwhUUGvmNC@bombadil.infradead.org>
References: <20230309230545.2930737-1-mcgrof@kernel.org>
 <20230309230545.2930737-5-mcgrof@kernel.org>
 <cfaac1a4-20c6-bdd6-ff68-981e9a8858e@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfaac1a4-20c6-bdd6-ff68-981e9a8858e@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 17, 2023 at 09:41:41PM -0700, Hugh Dickins wrote:
> On Thu, 9 Mar 2023, Luis Chamberlain wrote:
> 
> > In theory when info->flags & VM_LOCKED we should not be getting
> > shem_writepage() called so we should be verifying this with a
> > WARN_ON_ONCE(). Since we should not be swapping then best to ensure
> > we also don't do the folio split earlier too. So just move the check
> > early to avoid folio splits in case its a dubious call.
> > 
> > We also have a similar early bail when !total_swap_pages so just move
> > that earlier to avoid the possible folio split in the same situation.
> > 
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Reviewed-by: Christian Brauner <brauner@kernel.org>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  mm/shmem.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 68e9970baf1e..dfd995da77b4 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1350,6 +1350,12 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
> >  	if (WARN_ON_ONCE(!wbc->for_reclaim))
> >  		goto redirty;
> >  
> > +	if (WARN_ON_ONCE(info->flags & VM_LOCKED))
> > +		goto redirty;
> 
> Well, okay, I don't mind that.  But shall we take bets on how soon syzbot
> (hope it's not watching) will try flipping SHM_LOCK on while swapping out
> pages from a SHM segment, and hit that warning?  Perhaps I'm wrong, but I
> don't think any serialization prevents that.

I though that may be the case. Would such serialization be welcomed?

  Luis
