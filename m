Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92C91102
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 07:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TigSEg1djEXPrkuxPW2lyV2vRmsAR0uM58cPep7eGHs=; b=ObN04MAy6fhCJk24L8ngDoXvMu
	nvkYITrwohLM7kYn3MXEIUjcG7ORTAtlI2QgHVdv1vSRyMlkYRJqGvXhKZUaLPf+CsyITZbhDV4Ih
	/AYbnQy1jDHS6D4I3GAOrxhcBndmdNFmVAznHtq+h/skdTYYNTvO15l7AbuNZwdt7nc2fLaS+0LK8
	FD3eIfo6Q+znZLU2e+F/8CHxA1NTqtMOX+A3kMj/b4RR+CQ1nggTsS/aiHGlc8mxhTF8WzsR/CuFv
	f7A9Ym6NlMNB4Ho2wBZ9Gphb37kBMCyC11jdRhxaUpLpCSiNWDeRkH9kR3kaRHQBMA5XjfvbWO/TH
	jzinN9aw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1phQ7O-006msJ-22;
	Wed, 29 Mar 2023 07:21:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 89D5C3002A3;
	Wed, 29 Mar 2023 09:21:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2C6962CBE6E9B; Wed, 29 Mar 2023 09:21:12 +0200 (CEST)
Date: Wed, 29 Mar 2023 09:21:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de, song@kernel.org,
	rppt@kernel.org, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
Message-ID: <20230329072112.GG4253@hirez.programming.kicks-ass.net>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
 <20230329053149.3976378-5-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329053149.3976378-5-mcgrof@kernel.org>

On Tue, Mar 28, 2023 at 10:31:46PM -0700, Luis Chamberlain wrote:
> While I looked at re-using the old kernel/kmod.c (now kernel/module/kmod.c)
> concurrency delimiter methodology for another place in the kernel Linus
> noted that this could be simply replaced with a sempahore [0].
> 
> So add that so we we don't re-invent the wheel and make it obvious to use.
> 
> [0] https://lore.kernel.org/all/CAHk-=whkj6=wyi201JXkw9iT_eTUTsSx+Yb9d4OgmZFjDJA18g@mail.gmail.com/
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  include/linux/semaphore.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
> index 6694d0019a68..2ecdffdb9814 100644
> --- a/include/linux/semaphore.h
> +++ b/include/linux/semaphore.h
> @@ -28,6 +28,9 @@ struct semaphore {
>  #define DEFINE_SEMAPHORE(name)	\
>  	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
>  
> +#define CONCURRENCY_LIMITER(name, n) \
> +	struct semaphore name = __SEMAPHORE_INITIALIZER(name, n)
> +

Why should this live in semaphore.h?
