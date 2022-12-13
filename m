Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A76515AC
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 03:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670900683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ToI7hZ2DBEkG61hu0i1tPmmNJiNnyQodEsagogpyA4=;
	b=L1W0F1Hgd5FKgAHta63BtNmD+n8pEEqr+FghJlaIgE4mYfrpojPoBU95WGBBi/AQeTkjdA
	XQM6IxYxiOnNp6Vjsuqc9AqJsNT8smpW/O0JuJr7M6/ySvEQTBxqD/N0NaY7KsOl+ezq88
	CNu7/XslORpOYDznuEspHb6L3KCn9qo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-T9RFYZ6OPNKcz28DZtS-yA-1; Mon, 12 Dec 2022 22:04:39 -0500
X-MC-Unique: T9RFYZ6OPNKcz28DZtS-yA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE79D1C05AE8;
	Tue, 13 Dec 2022 03:04:38 +0000 (UTC)
Received: from localhost (ovpn-12-126.pek2.redhat.com [10.72.12.126])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A3FE140E949;
	Tue, 13 Dec 2022 03:04:37 +0000 (UTC)
Date: Tue, 13 Dec 2022 11:04:33 +0800
From: Baoquan He <bhe@redhat.com>
To: Dennis Zhou <dennis@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] mm, slub: remove percpu slabs with CONFIG_SLUB_TINY
Message-ID: <Y5frwZNPN++sqHLY@MiWiFi-R3L-srv>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-11-vbabka@suse.cz>
 <Y4NEkF8DI1uXFRv4@hyeyoo>
 <f318ccc3-eb03-e359-cb6f-157d0b4aed31@suse.cz>
 <Y5cob2jicdNoviU3@fedora>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5cob2jicdNoviU3@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

On 12/12/22 at 05:11am, Dennis Zhou wrote:
> Hello,
> 
> On Mon, Dec 12, 2022 at 11:54:28AM +0100, Vlastimil Babka wrote:
> > On 11/27/22 12:05, Hyeonggon Yoo wrote:
> > > On Mon, Nov 21, 2022 at 06:12:00PM +0100, Vlastimil Babka wrote:
> > >> SLUB gets most of its scalability by percpu slabs. However for
> > >> CONFIG_SLUB_TINY the goal is minimal memory overhead, not scalability.
> > >> Thus, #ifdef out the whole kmem_cache_cpu percpu structure and
> > >> associated code. Additionally to the slab page savings, this reduces
> > >> percpu allocator usage, and code size.
> > > 
> > > [+Cc Dennis]
> > 
> > +To: Baoquan also.

Thanks for adding me.

> > 
> > > Wondering if we can reduce (or zero) early reservation of percpu area
> > > when #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_TINY)?
> > 
> > Good point. I've sent a PR as it was [1], but (if merged) we can still
> > improve that during RC series, if it means more memory saved thanks to less
> > percpu usage with CONFIG_SLUB_TINY.
> > 
> > [1]
> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/tag/?h=slab-for-6.2-rc1
> 
> The early reservation area not used at boot is then used to serve normal
> percpu allocations. Percpu allocates additional chunks based on a free
> page float count and is backed page by page, not all at once. I get
> slabs is the main motivator of early reservation, but if there are other
> users of percpu, then shrinking the early reservation area is a bit
> moot.

Agree. Before kmem_cache_init() is done, anyone calling alloc_percpu()
can only get allocation done from early reservatoin of percpu area.
So, unless we can make sure nobody need to call alloc_percpu() before
kmem_cache_init() now and future.

The only drawback of early reservation is it's not so flexible. We can
only dynamically create chunk to increase percpu areas when early
reservation is run out, but can't shrink early reservation if system
doesn't need that much.

So we may need weigh the two ideas:
  - Not allowing to alloc_percpu() before kmem_cache_init();
  - Keep early reservation, and think of a economic value for
    CONFIG_SLUB_TINY.
 
start_kernel()
  ->setup_per_cpu_areas();
  ......
  ->mm_init();
      ......
      -->kmem_cache_init();


__alloc_percpu()
  -->pcpu_alloc()
     --> succeed to allocate from early reservation
      or
     -->pcpu_create_chunk()
        -->pcpu_alloc_chunk()
           -->pcpu_mem_zalloc()

