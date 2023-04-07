Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C262582
	for <patches@lists.linux.dev>; Fri,  7 Apr 2023 20:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5XaRDW3OetA625hdcSwN0p/tnpqaSBDliFuySM4XEd8=; b=eqb9e1JTvWzk3hxUjexfZZJCkP
	gffH1elQTuqL4yXVNnbJRrvwo6WPKTIqffiOz2+o1VXx8TE5/D4WmjNMPr4Ac8M4nJh/jXGWaYaOl
	ZK7+2PafVo0toBktdP3YUQ5o+XBmwmbQmGQfkzqiaogbhMYLJpt+aRYSfKfc+oF27G5KfkP+8D5S0
	luculWVhA2WYxBLLVA1YiHa5ZjTYv/nQaM9rDs502ddXfxA3OFwDOEK2EZ9c6DOh29pnyBPiRi2OR
	7dmXbbU+x35WgDNqNAfrC8oLQ29IIfMbAbfWSKxVCaji8jD45gXjrzPe4t5DVTXjivy3iw0Zkval0
	e08s/Cjw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pksow-001Bg4-Fv; Fri, 07 Apr 2023 20:36:30 +0000
Date: Fri, 7 Apr 2023 21:36:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, vbabka@suse.cz, mhocko@suse.com,
	dave.hansen@linux.intel.com, colin.i.king@gmail.com,
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 1/2] Change DEFINE_SEMAPHORE() to take a number
 argument
Message-ID: <ZDB+zn3X4sac9DFU@casper.infradead.org>
References: <20230405203505.1343562-1-mcgrof@kernel.org>
 <20230405203505.1343562-2-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405203505.1343562-2-mcgrof@kernel.org>

On Wed, Apr 05, 2023 at 01:35:04PM -0700, Luis Chamberlain wrote:
> diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
> index 6694d0019a68..2d6aa3fd7861 100644
> --- a/include/linux/semaphore.h
> +++ b/include/linux/semaphore.h
> @@ -25,8 +25,15 @@ struct semaphore {
>  	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
>  }
>  
> -#define DEFINE_SEMAPHORE(name)	\
> -	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
> +/*
> + * There is a big difference between a binary semaphore and a mutex.
> + * You cannot call mutex_unlock() from IRQ context because it takes an
> + * internal mutex spin_lock in a non-IRQ-safe manner. Both try_lock()
> + * and unlock() can be called from IRQ context. A mutex must also be
> + * released in the same context that locked it.
> + */

I think this confuses cause and effect.  How about this:

/*
 * Binary semaphores and mutexes differ in that mutexes have an owner
 * so they cannot be used from interrupt context and cannot be passed
 * from one thread to another.  down_trylock() and up() can be called
 * from interrupt context.
 */

Or this:

/*
 * Unlike mutexes, binary semaphores do not have an owner, so up() can
 * be called in a different thread from the one which called down().
 * It is also safe to call down_trylock() and up() from interrupt
 * context.
 */

I'd like to mention completions as an alternative to semaphores, but
can't figure out a nice way to fit that in.
