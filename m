Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E7B10F2
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 16:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F364C433EF;
	Mon, 13 Mar 2023 16:31:48 +0000 (UTC)
Date: Mon, 13 Mar 2023 12:31:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org, rcu@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, Joel Fernandes <joel@joelfernandes.org>,
 Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mike Rapoport <rppt@kernel.org>, Neeraj
 Upadhyay <quic_neeraju@quicinc.com>, Paolo Abeni <pabeni@redhat.com>, "Paul
 E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with
 kmem_cache_alloc()
Message-ID: <20230313123147.6d28c47e@gandalf.local.home>
In-Reply-To: <ZA2gofYkXRcJ8cLA@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
	<ZA2gofYkXRcJ8cLA@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 12 Mar 2023 11:51:29 +0200
Mike Rapoport <mike.rapoport@gmail.com> wrote:

> git grep -in slob still gives a couple of matches. I've dropped the
> irrelevant ones it it left me with these:
> 
> CREDITS:14:D: SLOB slab allocator
> kernel/trace/ring_buffer.c:358: * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
> mm/Kconfig:251:    SLOB allocator and is not recommended for systems with more than
> mm/Makefile:25:KCOV_INSTRUMENT_slob.o := n
>  
> Except the comment in kernel/trace/ring_buffer.c all are trivial.
> 
> As for the comment in ring_buffer.c, it looks completely irrelevant at this
> point.
> 
> @Steve?

You want me to remember something I wrote almost 15 years ago? I think I
understand that comment as much as you do. Yeah, that was when I was still
learning to write comments for my older self to understand, and I failed
miserably!

But git history comes to the rescue. The commit that added that comment was:

ed56829cb3195 ("ring_buffer: reset buffer page when freeing")

This was at a time when it was suggested to me to use the struct page
directly in the ring buffer and where we could do fun "tricks" for
"performance". (I was never really for this, but I wasn't going to argue).

And the code in question then had:

/*
 * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
 * this issue out.
 */
static inline void free_buffer_page(struct buffer_page *bpage)
{
        reset_page_mapcount(&bpage->page);
        bpage->page.mapping = NULL;
        __free_page(&bpage->page);
}


But looking at commit: e4c2ce82ca27 ("ring_buffer: allocate buffer page
pointer")

It was finally decided that method was not safe, and we should not be using
struct page but just allocate an actual page (much safer!).

I never got rid of the comment, which was more about that
"reset_page_mapcount()", and should have been deleted back then.

Just remove that comment. And you could even add:

Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")

-- Steve
