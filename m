Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0609657
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 21:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IzQFIWT46znk5i0D+MsYj76CTFCg/0EZ16e6Y2m5SD0=; b=3w3cdJetO/jogLTcUKjz0RGSni
	IUo2+CUDSUDwyw1g5lIuMk93u9eS7FEdD66wbpagj57lKjufAMc7CxPIUqtTeQN8iBMftrOKARX4D
	8GprGyZL33+5LqB7mcTudokFAGvCDq9AU6ZyA9bKQSjgUS3iI/5Dajy4PmuuJaOrf0uIN74Ga1raI
	WQ3/7sV5LzeIlXx+GZSslVjv8KtL6eq7hh+OsX+fm/dv+qEj2fPc1hWmY2KNr8JAgc7Y2pdO161nM
	ONJc4YluOrPm0G+S/VeqCvSf97P7aDdqHlO2uXTWTxRniKRGfc7uxGXmAayHNlgCNxG1bNH+00OeP
	gpQrA7tQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pa1My-006qYJ-C6; Wed, 08 Mar 2023 21:30:44 +0000
Date: Wed, 8 Mar 2023 13:30:44 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org,
	brauner@kernel.org, linux-mm@kvack.org, p.raghav@samsung.com,
	da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net,
	yosryahmed@google.com, keescook@chromium.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] shmem: move reclaim check early on writepages()
Message-ID: <ZAj+hMFcr4NeclZs@bombadil.infradead.org>
References: <20230302232758.888157-1-mcgrof@kernel.org>
 <20230302232758.888157-4-mcgrof@kernel.org>
 <2a3386e7-9b09-f22e-ee39-a37a046d54ec@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a3386e7-9b09-f22e-ee39-a37a046d54ec@redhat.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Mar 06, 2023 at 03:01:52PM +0100, David Hildenbrand wrote:
> On 03.03.23 00:27, Luis Chamberlain wrote:
> > @@ -1340,6 +1340,18 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
> >   	swp_entry_t swap;
> >   	pgoff_t index;
> > +	/*
> > +	 * Our capabilities prevent regular writeback or sync from ever calling
> > +	 * shmem_writepage; but a stacking filesystem might use ->writepage of
> > +	 * its underlying filesystem, in which case tmpfs should write out to
> > +	 * swap only in response to memory pressure, and not for the writeback
> > +	 * threads or sync.
> > +	 */
> > +	if (!wbc->for_reclaim) {
> 
> if (WARN_ON_ONCE(!wbc->for_reclaim))
> 
> > +		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
> 
> And drop the comment :) That's what WARN_ON_ONCE is all about.

Good call, will add that to v2.

> Acked-by: David Hildenbrand <david@redhat.com>

Great thanks,

  Luis
