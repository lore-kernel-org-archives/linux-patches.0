Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1A1FB1
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 08:05:54 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 8F0681FE3F;
	Fri, 31 Mar 2023 08:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1680249952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yE/ElG/1JpRXabfjyDkXIDLPL4NCS4hNuektaT+pZc=;
	b=pBGRzBhCwblY4cH5PfbPazP0AAH8fDx/EeOAVNkAAR9AfzJF0UKffpv6nfN8JLc0wKK8nq
	MdioBBmsdz4Tlk/WdgrZG6RgICd9lF91+9CXZtjciNUwCZ71K9WM2BWqZdu8KA6OKRjhxR
	HY18hGaovwsWjLT5L3MM5FgmY+idds0=
Received: from suse.cz (unknown [10.100.208.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id A179D2C141;
	Fri, 31 Mar 2023 08:05:51 +0000 (UTC)
Date: Fri, 31 Mar 2023 10:05:48 +0200
From: Petr Mladek <pmladek@suse.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>, david@redhat.com,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	petr.pavlu@suse.com, prarit@redhat.com, gregkh@linuxfoundation.org,
	rafael@kernel.org, christophe.leroy@csgroup.eu, tglx@linutronix.de,
	song@kernel.org, rppt@kernel.org, willy@infradead.org,
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
Message-ID: <ZCaUXHxYiPolI/lu@alley>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
 <20230329053149.3976378-5-mcgrof@kernel.org>
 <20230329072112.GG4253@hirez.programming.kicks-ass.net>
 <ZCPuFLDgU5fBFtug@bombadil.infradead.org>
 <20230329091935.GP4253@hirez.programming.kicks-ass.net>
 <CAHk-=whF6Ta_KcJP2eC78+Mstv+vAku8ATRMbv98sf9VhdvySQ@mail.gmail.com>
 <20230330115626.GA124812@hirez.programming.kicks-ass.net>
 <CAHk-=wgF34MkhZnM_Kc1zggTWCAQ=BzEgAaAbE5wDM07bWiYeg@mail.gmail.com>
 <20230331034209.GA12892@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331034209.GA12892@google.com>

On Fri 2023-03-31 12:42:09, Sergey Senozhatsky wrote:
> On (23/03/30 09:23), Linus Torvalds wrote:
> > Although we also do have some other issues - I think down_trylock() is
> > ok in irq contexts, but mutex_trylock() is not. Maybe that's why
> > printk uses semaphores? I forget.
> 
> Yes, correct. IIRC we also cannot safely call mutex_unlock() from IRQ
> context because it takes some internal mutex spin_lock in a non-IRQ-safe
> manner. Semaphore is OK in this regard, both semaphore try_lock() and
> unlock() can be called from IRQ.

One more reason is that mutex must be released in the same context
that took it. And printk() tries to pass console_sem() to another context.

It was added by the commit dbdda842fe96 ("printk: Add console owner
and waiter logic to load balance console writes"). It was relatively
effective in reducing the risk of soft lockups.

Best Regards,
Petr
