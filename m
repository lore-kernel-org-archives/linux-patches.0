Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD70A186B
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 09:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nK7v3iVAGBAaAFOk1b449WFvKlocBCO05/yVMzqW7y0=; b=QQtGt54LoluqXGtBJyUsYl+J8K
	6kg5fETS6rR2KHtQ3iZ1MnQTZnXolmL4Z5dWBQcT0+rZFJ8JwGcLzLcQZ2CMoNESc3bYgnyw9geNY
	5WL52Dashy9KHEM31MV+uaDrPEAvgHzUCBVNUtJv+jhwJ0OTHCKGTFvWLOn6ACs6Qt8z2FdanJPOA
	PSXPFCi3p0ZyJ/jP5KOh5369P9p57Pubwh/3nTO1J8MctcbLlIORr52au3+EUpzLkXc9KGj5Cs5Sv
	Ln1XJydA3ocosqTpRq7bRzKtCMA6ZokRxi/aHXyblWJ6o6hcAtO5hGFAcZqd4FMS90SATtYNgs3bv
	04U28J+Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1phSR5-00HMbf-0W;
	Wed, 29 Mar 2023 09:49:43 +0000
Date: Wed, 29 Mar 2023 02:49:43 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de, song@kernel.org,
	rppt@kernel.org, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
Message-ID: <ZCQJtz/P+/Mog3Wm@bombadil.infradead.org>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
 <20230329053149.3976378-5-mcgrof@kernel.org>
 <20230329072112.GG4253@hirez.programming.kicks-ass.net>
 <ZCPuFLDgU5fBFtug@bombadil.infradead.org>
 <20230329091935.GP4253@hirez.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329091935.GP4253@hirez.programming.kicks-ass.net>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Mar 29, 2023 at 11:19:35AM +0200, Peter Zijlstra wrote:
> On Wed, Mar 29, 2023 at 12:51:48AM -0700, Luis Chamberlain wrote:
> > On Wed, Mar 29, 2023 at 09:21:12AM +0200, Peter Zijlstra wrote:
> > > On Tue, Mar 28, 2023 at 10:31:46PM -0700, Luis Chamberlain wrote:
> > > > While I looked at re-using the old kernel/kmod.c (now kernel/module/kmod.c)
> > > > concurrency delimiter methodology for another place in the kernel Linus
> > > > noted that this could be simply replaced with a sempahore [0].
> > > > 
> > > > So add that so we we don't re-invent the wheel and make it obvious to use.
> > > > 
> > > > [0] https://lore.kernel.org/all/CAHk-=whkj6=wyi201JXkw9iT_eTUTsSx+Yb9d4OgmZFjDJA18g@mail.gmail.com/
> > > > 
> > > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > > ---
> > > >  include/linux/semaphore.h | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
> > > > index 6694d0019a68..2ecdffdb9814 100644
> > > > --- a/include/linux/semaphore.h
> > > > +++ b/include/linux/semaphore.h
> > > > @@ -28,6 +28,9 @@ struct semaphore {
> > > >  #define DEFINE_SEMAPHORE(name)	\
> > > >  	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
> > > >  
> > > > +#define CONCURRENCY_LIMITER(name, n) \
> > > > +	struct semaphore name = __SEMAPHORE_INITIALIZER(name, n)
> > > > +
> > > 
> > > Why should this live in semaphore.h?
> > 
> > I have no preference, but sharing seems to have been better. Do you
> > have any recommendations?
> 
> Call is DEFINE_SEMAPHORE_N() ?
> 
> Arguably DEFINE_SEMAPHORE() should have the argument, as binary
> semaphores are a special case, but then we gotta go and fix up all
> users.
> 
> /me git-greps a little.. Hmm, not too bad.
> 
> How's this?

Seems OK to me. Either way works. Should I carry a patch from you for this
series?

  Luis
