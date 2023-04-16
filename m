Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035D0EA4
	for <patches@lists.linux.dev>; Sun, 16 Apr 2023 06:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=feNbonEkJBZpWgMwe8jt6vuLvISXrUj/SEXS0kUAnlc=; b=uI2vWvZiRzbowyrTuwWuv3DGFt
	wJPQJ+LEhJc1KTs+6wAShf2paCygyaRrvABmu2+l1jqQNg3PhICDLlhr50BtqIoL9D5mnXRCDCmVh
	dUzkbSV0gkiuxdN0MWKYXzIiqiJXk6at5GkEiw/0CeJ8IFzH9R92b9QO8L3YR6OJAU0sTwO1mMjpP
	KoF2uPLBtgHoqzG/vDxlgkUqzer3SIp30WRSrnF3AgP2b05g7mzOZrm3GEtkFGHhDLQ2DTi5GmUXP
	amW2thIB4qoG7Rr/csp8axVft5ZI+cm1c2Ix6nBhjiM2fdNh3Sfwk+izpgnFjejiMctGJRn/d6+TV
	wKqo2Hsg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pnw4m-00DFIg-2j;
	Sun, 16 Apr 2023 06:41:28 +0000
Date: Sat, 15 Apr 2023 23:41:28 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Kees Cook <keescook@chromium.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [RFC 2/2] kread: avoid duplicates
Message-ID: <ZDuYmPB5oqKQLcQd@bombadil.infradead.org>
References: <20230414052840.1994456-1-mcgrof@kernel.org>
 <20230414052840.1994456-3-mcgrof@kernel.org>
 <ZDuP3OCzN3x4NxRZ@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDuP3OCzN3x4NxRZ@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Sat, Apr 15, 2023 at 11:04:12PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 13, 2023 at 10:28:40PM -0700, Luis Chamberlain wrote:
> > With this we run into 0 wasted virtual memory bytes.
> 
> Avoid what duplicates?

David Hildenbrand had reported that with over 400 CPUs vmap space
runs out and it seems it was related to module loading. I took a
look and confirmed it. Module loading ends up requiring in the
worst case 3 vmalloc allocations, so typically at least twice
the size of the module size and in the worst case just add
the decompressed module size:

a) initial kernel_read*() call
b) optional module decompression
c) the actual module data copy we will keep

Duplicate module requests that come from userspace end up being thrown
in the trash bin, as only one module will be allocated.  Although there
are checks for a module prior to requesting a module udev still doesn't
do the best of a job to avoid that and so we end up with tons of
duplicate module requests. We're talking about gigabytes of vmalloc
bytes just lost because of this for large systems and megabytes for
average systems. So for example with just 255 CPUs we can loose about
13.58 GiB, and for 8 CPUs about 226.53 MiB.

I have patches to curtail 1/2 of that space by doing a check in kernel
before we do the allocation in c) if the module is already present. For
a) it is harder because userspace just passes a file descriptor. But
since we can get the file path without the vmalloc this RFC suggest
maybe we can add a new kernel_read*() for module loading where it makes
sense to have only one read happen at a time.

  Luis
