Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAEF525E
	for <patches@lists.linux.dev>; Mon,  5 Jun 2023 12:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC63C433EF;
	Mon,  5 Jun 2023 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685967931;
	bh=cZJzFLsF6i4kH324DdxlGdpR2ToC2WJiPoKfYRlxZXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M/9p+BYjzxF5Im7GiWUbXX303ugAaC3hz6XRX9Beg6GNf1oGQFru/3MxiwhR/P66+
	 5uoN1PuSGAj1dui7u+QS8lV6s6Uf0J0xa+qTQzqgB9Ec7+/hUtNocFtJf8uUC6CYXN
	 UXLhFHDWsbG1ciFt26IfpwQEU8wsfCiIVypx9XaS/LnOtOSJi1lOnmHHmbrW8lKPsO
	 YmiEbcr/DPQxP5xyyK2eVDVSxNZuoYT3N6j5mI68flUmF3A/Aotnx4sHQm8aQRWgX2
	 kocLP8mSJuPLl/hzAPmM9W4Z+/7jhjROxLcIYSVmmhfXEHuWLZtjzYpkUqnmIykiO6
	 za8nwqPGyVoAw==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1q69HQ-0007fY-0W; Mon, 05 Jun 2023 14:25:48 +0200
Date: Mon, 5 Jun 2023 14:25:48 +0200
From: Johan Hovold <johan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org,
	rafael@kernel.org, song@kernel.org, lucas.de.marchi@gmail.com,
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, david@redhat.com,
	tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com,
	lennart@poettering.net
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
Message-ID: <ZH3UTOaBD7f5KH6Q@hovoldconsulting.com>
References: <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
 <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
 <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
 <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
 <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
 <ZHXEktFq7NPYLtGn@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZHXEktFq7NPYLtGn@hovoldconsulting.com>

On Tue, May 30, 2023 at 11:40:35AM +0200, Johan Hovold wrote:
> On Mon, May 29, 2023 at 09:55:15PM -0400, Linus Torvalds wrote:
> > On Mon, May 29, 2023 at 11:18 AM Johan Hovold <johan@kernel.org> wrote:
> > >
> > > I took a closer look at some of the modules that failed to load and
> > > noticed a pattern in that they have dependencies that are needed by more
> > > than one device.
> > 
> > Ok, this is a "maybe something like this" RFC series of two patches -
> > one trivial one to re-organize things a bit so that we can then do the
> > real one which uses a filter based on the inode pointer to return an
> > "idempotent return value" for module loads that share the same inode.
> > 
> > It's entirely untested, and since I'm on the road I'm going to not
> > really be able to test it. It compiles for me, and the code looks
> > fairly straightforward, but it's probably buggy.
> > 
> > It's very loosely based on Luis' attempt,  but it
> >  (a) is internal to module loading
> >  (b) uses a reliable cookie
> >  (c) doesn't leave the cookie around randomly for later
> >  (d) has seen absolutely no testing
> > 
> > Put another way: if somebody wants to play with this, please treat it
> > as a starting point, not the final thing. You might need to debug
> > things, and fix silly mistakes.
> 
> With the missing spinlock initialisation fixed:
> 
> -static struct spinlock idem_lock;
> +static DEFINE_SPINLOCK(idem_lock);
> 
> this passes basic smoke testing and allows the X13s to boot.
> 
> It does not seem to have any significant impact on boot time, but it
> avoids some of the unnecessary load attempts as intended:

Took another look at code which modulo some nits like missing spaces
around a + operator and an "ourselfs" typo looks good to me. So with the
spinlock initialisation fixed:

Reviewed-by: Johan Hovold <johan@kernel.org>
Tested-by: Johan Hovold <johan@kernel.org>

Johan
