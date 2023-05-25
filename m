Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6254A101DA
	for <patches@lists.linux.dev>; Thu, 25 May 2023 18:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m2jbDk7u7GUsanEzNXYDV8mzwCqACS/cVryC2d/KCe0=; b=arJjVz8fCi2w7pH4aG8Qcc72Lt
	qwJ8Uzgl2PChws+dY0KQt9yDDggXsZ+m64XLj1uEPmyMnptgEeQx4MoQrDWfR30BxN39v/dKwLSOP
	qGL/ID22hQJVq/w0Db7ruufoezVYuJwj0u59qhIePZtB4T9Rvbtm7T756QB+PrcFZHtgexk4jWpN9
	md6OTayJ6riJww8EWIRq/1iqPTigBXNrJCfgNYZrYly97dEOeeoV+VcFMnzycYZ9CJizymL9OH7ll
	5vEvxEJDaZfEAyVnl4S0wjcXR9GMWBxD12zm+ztbIN4fGDc/wKJjCpw2yv857M28Khwd/trGAhyFT
	dDx9oV3A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2Fbt-00HNc8-1d;
	Thu, 25 May 2023 18:22:49 +0000
Date: Thu, 25 May 2023 11:22:49 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Petr Pavlu <petr.pavlu@suse.com>, rafael@kernel.org,
	song@kernel.org, lucas.de.marchi@gmail.com,
	lucas.demarchi@intel.com, christophe.leroy@csgroup.eu,
	peterz@infradead.org, rppt@kernel.org, dave@stgolabs.net,
	willy@infradead.org, vbabka@suse.cz, mhocko@suse.com,
	dave.hansen@linux.intel.com, colin.i.king@gmail.com,
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, david@redhat.com,
	tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com,
	lennart@poettering.net
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
Message-ID: <ZG+neXsD9QSJXzUL@bombadil.infradead.org>
References: <20230524213620.3509138-1-mcgrof@kernel.org>
 <20230524213620.3509138-3-mcgrof@kernel.org>
 <8fc5b26b-d2f6-0c8f-34a1-af085dbef155@suse.com>
 <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <2023052518-unable-mortician-4365@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023052518-unable-mortician-4365@gregkh>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, May 25, 2023 at 05:42:10PM +0100, Greg KH wrote:
> Luis, I asked last time what modules are being asked by the kernel to be
> loaded thousands of times at boot and can't seem to find an answer
> anywhere, did I miss that?

Yes you missed it, I had explained it:

https://lore.kernel.org/all/ZEGopJ8VAYnE7LQ2@bombadil.infradead.org/

"My best assessment of the situation is that each CPU in udev ends up
triggering a load of duplicate set of modules, not just one, but *a
lot*. Not sure what heuristics udev uses to load a set of modules per
CPU."

Petr Pavlu then finishes the assessment:

https://lore.kernel.org/all/23bd0ce6-ef78-1cd8-1f21-0e706a00424a@suse.com/

But let me quote it, so it is not missed:

"My understanding is that udev workers are forked. An initial kmod
context is created by the main udevd process but no sharing happens
after the fork.  It means that the mentioned memory pool logic doesn't
really kick in.

Multiple parallel load requests come from multiple udev workers, for
instance, each handling an udev event for one CPU device and making the
exactly same requests as all others are doing at the same time.

The optimization idea would be to recognize these duplicate requests at
the udevd/kmod level and converge them."

> This should be very easy to handle in
> userspace if systems need it, so that begs the questions, what types of
> systems need this? 

I had explained, this has existed for a long time.

> We have handled booting with tens of thousands of
> devices attached for decades now with no reports of boot/udev/kmod
> issues before, what has recently changed to cause issues?

Doesn't mean this didn't happen before, just because memory is freed due
to duplicates does not mean that the memory pressure induced by them is
not stupid. It is stupid, but hasn't come up as a possible real issue
nowadays where systems require more vmalloc space used during boot with
new features. I had explained also the context where this came from.
David Hildenbrand had reported failure to boot on many CPUs.  If you
induce more vmap memory pressure on boot with multiple CPUs eventually
you can't boot. Enabling KASAN will make this worse today.

  Luis
