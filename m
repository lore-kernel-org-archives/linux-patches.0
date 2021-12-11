Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF8A173
	for <patches@lists.linux.dev>; Sat, 11 Dec 2021 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=duqWjPgqnpdR2SAcoAzM6rFQ0Wy0jzMQfoUHoYd8x4E=; b=ZVCnBQ0UgBu3mOSCPICSsiPhER
	YgywyrFU4f5c5Mw0lauY2ZAIlGNb415s6IbNFSQs3mro6qlzY8KVxnO83lf2LyIwB7FlSgITWEr88
	d6wtvAPDSi5AAetA962b/6A+jMpzyAMMCwLU2dWY7aOj+G/7/J9aBjbFTOVKt/zGWWFdoOBu0xKbh
	UFPBSFSglEbv8lJ9SLNovUbub03JugNmSo/Zah33tsUdTVLETA7E0OkYpGefdUeKYLBsy6SfZpSN5
	Wlg0r0ITWyyN6/euhSxL/FfEEvznPYCbpgtreGhLF/+ub5rBJOgng1NkvJ6UZ4yVMkYrOT22TLX30
	g35bw5gw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mw5A3-00BJr3-8n; Sat, 11 Dec 2021 16:23:47 +0000
Date: Sat, 11 Dec 2021 16:23:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v2 31/33] mm/sl*b: Differentiate struct slab fields by
 sl*b implementations
Message-ID: <YbTQk9Dj+kUYAX09@casper.infradead.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-32-vbabka@suse.cz>
 <20211210163757.GA717823@odroid>
 <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>

On Fri, Dec 10, 2021 at 07:26:11PM +0100, Vlastimil Babka wrote:
> > Because SLUB and SLAB sets slab->slab_cache = NULL (to set page->mapping = NULL),
> 
> Hm, now that you mention it, maybe it would be better to do a
> "folio->mapping = NULL" instead as we now have a more clearer view where we
> operate on struct slab, and where we transition between that and a plain
> folio. This is IMHO part of preparing the folio for freeing, not a struct
> slab cleanup as struct slab doesn't need this cleanup.

Yes, I did that as part of "mm/slub: Convert slab freeing to struct slab"
in my original series:

-       __ClearPageSlabPfmemalloc(page);
+       __slab_clear_pfmemalloc(slab);
        __ClearPageSlab(page);
-       /* In union with page->mapping where page allocator expects NULL */
-       page->slab_cache = NULL;
+       page->mapping = NULL;

