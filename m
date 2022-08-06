Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7943A187A
	for <patches@lists.linux.dev>; Sat,  6 Aug 2022 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+C2JGsO6va2bAMADh5JeyUWmHXKyyjTMWItjMMImrbg=; b=WdpKBQw/h4Z6oKiLfUMLRUHbhr
	16GLQX8j2fEzsJqERsJugasQvW5MYH+A+/EQ5cdR5MOOvfVvegwK2YFUlWaAcnb8zjj01dqJ4kzqr
	j7sgHCoSDRkPUZPl4ehuP1bq8l3p0Js/AemsYZprDGgKYMM5gQFmTRQNGKRn6A8Dch1F2YLVfr29Y
	dvVWwaAS1dbeHb34kuGgjMZgfFVPhb0zs04jPIsuoYhJeEusJ/AijPnZxkwSShJYbpnpc4cqn17XE
	q6J3eTiZ0nAZRfMw9iDS3f7FV4Hmi3uv9ndKcYE2dTExXND/TxdxO/Ea5wIQ8xPjHvxhBDZ9/Gxuw
	9trYO3cA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oKLF9-00CE0u-CC; Sat, 06 Aug 2022 14:57:35 +0000
Date: Sat, 6 Aug 2022 15:57:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org,
	alex.gaynor@gmail.com, ark.email@gmail.com,
	bjorn3_gh@protonmail.com, bobo1239@web.de, bonifaido@gmail.com,
	boqun.feng@gmail.com, davidgow@google.com, dev@niklasmohrin.de,
	dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, gary@garyguo.net,
	geofft@ldpreload.com, gregkh@linuxfoundation.org, jarkko@kernel.org,
	john.m.baublitz@gmail.com, leseulartichaut@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	m.falkowski@samsung.com, me@kloenk.de, milan@mdaverde.com,
	mjmouse9999@gmail.com, patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org, thesven73@gmail.com,
	torvalds@linux-foundation.org, viktor@v-gar.de, wedsonaf@google.com,
	Andreas Hindborg <andreas.hindborg@wdc.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
Message-ID: <Yu6BXwtPZwYPIDT6@casper.infradead.org>
References: <20220805154231.31257-13-ojeda@kernel.org>
 <Yu5Bex9zU6KJpcEm@yadro.com>
 <CANiq72=3j2NM2kS8iw14G6MnGirb0=O6XQyCsY9vVgsZ1DfLaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72=3j2NM2kS8iw14G6MnGirb0=O6XQyCsY9vVgsZ1DfLaQ@mail.gmail.com>

On Sat, Aug 06, 2022 at 01:22:52PM +0200, Miguel Ojeda wrote:
> On Sat, Aug 6, 2022 at 12:25 PM Konstantin Shelekhin
> <k.shelekhin@yadro.com> wrote:
> >
> > I sense possible problems here. It's common for a kernel code to pass
> > flags during memory allocations.
> 
> Yes, of course. We will support this, but how exactly it will look
> like, to what extent upstream Rust's `alloc` could support our use
> cases, etc. has been on discussion for a long time.
> 
> For instance, see https://github.com/Rust-for-Linux/linux/pull/815 for
> a potential extension trait approach with no allocator carried on the
> type that Andreas wrote after a discussion in the last informal call:
> 
>     let a = Box::try_new_atomic(101)?;

Something I've been wondering about for a while is ...

struct task_struct {
...
+	gfp_t gfp_flags;
...
};

We've already done some work towards this with the scoped allocation
API for NOIO and NOFS, but having spin_lock() turn current->gfp_flags
into GFP_ATOMIC might not be the worst idea in the world.
