Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2768CAD2D
	for <patches@lists.linux.dev>; Mon, 17 Apr 2023 22:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U5ZyEMDy9cwOLuCvHr2OAy9M7iqscgHDIWUXBtsfJUs=; b=Tdx4lOPNDHR7SzR2upVakzozCb
	TxSs2fNt2ADiBh6Q/hUjNST2xWdXbILtXVYc49laIBLRHU/GFQaOaZgl7tKKdMThqbrtTY4UHA0T1
	djYlZ1NZk56EPSXHH1SibN549ObLQNdYzf/x/4+2kfky/qDcd+ssIiyMkQbn5X/XqgvFF81FoCkx6
	NDN5qRRS4iddN+CbtpziwVxKd3jjald+YC0O7jQHzJjBuarC+d62RuNkIeuA53c7qA05vwqoitDJh
	7aNNI0Zb1o6kYC5XD7nchFU9KP5ywLreZuCUukQY44smLPpqNx2c/bUGyEh7EYy3mABIJNp9HOB7G
	wYyoHSlA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1poWz0-000EUW-22;
	Mon, 17 Apr 2023 22:05:58 +0000
Date: Mon, 17 Apr 2023 15:05:58 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Kees Cook <keescook@chromium.org>, david@redhat.com,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com,
	petr.pavlu@suse.com, prarit@redhat.com,
	torvalds@linux-foundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [RFC 2/2] kread: avoid duplicates
Message-ID: <ZD3CxlsVXniQvxe9@bombadil.infradead.org>
References: <20230414052840.1994456-1-mcgrof@kernel.org>
 <20230414052840.1994456-3-mcgrof@kernel.org>
 <ZDuP3OCzN3x4NxRZ@infradead.org>
 <ZDuYmPB5oqKQLcQd@bombadil.infradead.org>
 <2023041637-glamorous-appetite-dc12@gregkh>
 <ZDxClHwnTNqtuSbD@bombadil.infradead.org>
 <ZDzhqxShqmmQOKjU@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDzhqxShqmmQOKjU@kroah.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 17, 2023 at 08:05:31AM +0200, Greg KH wrote:
> On Sun, Apr 16, 2023 at 11:46:44AM -0700, Luis Chamberlain wrote:
> > On Sun, Apr 16, 2023 at 02:50:01PM +0200, Greg KH wrote:
> > > On Sat, Apr 15, 2023 at 11:41:28PM -0700, Luis Chamberlain wrote:
> > > > On Sat, Apr 15, 2023 at 11:04:12PM -0700, Christoph Hellwig wrote:
> > > > > On Thu, Apr 13, 2023 at 10:28:40PM -0700, Luis Chamberlain wrote:
> > > > > > With this we run into 0 wasted virtual memory bytes.
> > > > > 
> > > > > Avoid what duplicates?
> > > > 
> > > > David Hildenbrand had reported that with over 400 CPUs vmap space
> > > > runs out and it seems it was related to module loading. I took a
> > > > look and confirmed it. Module loading ends up requiring in the
> > > > worst case 3 vmalloc allocations, so typically at least twice
> > > > the size of the module size and in the worst case just add
> > > > the decompressed module size:
> > > > 
> > > > a) initial kernel_read*() call
> > > > b) optional module decompression
> > > > c) the actual module data copy we will keep
> > > > 
> > > > Duplicate module requests that come from userspace end up being thrown
> > > > in the trash bin, as only one module will be allocated.  Although there
> > > > are checks for a module prior to requesting a module udev still doesn't
> > > > do the best of a job to avoid that and so we end up with tons of
> > > > duplicate module requests. We're talking about gigabytes of vmalloc
> > > > bytes just lost because of this for large systems and megabytes for
> > > > average systems. So for example with just 255 CPUs we can loose about
> > > > 13.58 GiB, and for 8 CPUs about 226.53 MiB.
> > > 
> > > How does the memory get "lost"?  Shouldn't it be properly freed when the
> > > duplicate module load fails?
> > 
> > Yes memory gets freed, but since virtual memory space can be limitted it
> > also means you can end up eventually getting to the point -ENOMEMs will
> > happen as you have more CPUS and you cannot use virtual memory for other
> > things during kernel bootup and bootup fails. This is apparently
> > exacerbated with KASAN enabled.
> 
> Then why not just rate-limit the module loader in userspace on such
> large systems if that's an issue?  No kernel changes needed to do that.

We can certainly just take a stance punt this as a userspace problem. I thought
it would be good to see what a kernel style of workaround would look like for
us to evluate.

  Luis
