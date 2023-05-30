Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E9F12B9C
	for <patches@lists.linux.dev>; Tue, 30 May 2023 09:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6904C433EF;
	Tue, 30 May 2023 09:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685439634;
	bh=rNtDxPIemUYMFmDRq+2vO1N6CRtzqiO5qUW2YSDslnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fVWCl+PdPozcwC62Y6L97YzJzDzJtHQQMnW9S2GOh4IlKRTtDE1NzxUxWU59ZEc4W
	 iPECpa8+tqxLd3ZkYeYq4ROellwQksMrelI2RSqOljy2x5OT1wolysjDdffhmBms+X
	 /i0tiBcH5MSwvo6em5tPHOA9/QaOytmnBVwVAL+2TtNpSw5fdUiSOX5r9N+Sco7nBI
	 aK0BQsipGmChcVfwRSE9LZXPOaCUVBCizzVlgw1m9mG4bbZdLjkSVTjhlPTfdrGPg+
	 BvRQOXd5jiIRC5GcyHmIgY2+CB1EmpfgwUO+GZnoJRtF0PlfGF/yxDmDEOYNaUxwkL
	 Q+YqAQLhAZs4w==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1q3vqE-0008S2-F8; Tue, 30 May 2023 11:40:35 +0200
Date: Tue, 30 May 2023 11:40:34 +0200
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
Message-ID: <ZHXEktFq7NPYLtGn@hovoldconsulting.com>
References: <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
 <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
 <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
 <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
 <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>

On Mon, May 29, 2023 at 09:55:15PM -0400, Linus Torvalds wrote:
> On Mon, May 29, 2023 at 11:18 AM Johan Hovold <johan@kernel.org> wrote:
> >
> > I took a closer look at some of the modules that failed to load and
> > noticed a pattern in that they have dependencies that are needed by more
> > than one device.
> 
> Ok, this is a "maybe something like this" RFC series of two patches -
> one trivial one to re-organize things a bit so that we can then do the
> real one which uses a filter based on the inode pointer to return an
> "idempotent return value" for module loads that share the same inode.
> 
> It's entirely untested, and since I'm on the road I'm going to not
> really be able to test it. It compiles for me, and the code looks
> fairly straightforward, but it's probably buggy.
> 
> It's very loosely based on Luis' attempt,  but it
>  (a) is internal to module loading
>  (b) uses a reliable cookie
>  (c) doesn't leave the cookie around randomly for later
>  (d) has seen absolutely no testing
> 
> Put another way: if somebody wants to play with this, please treat it
> as a starting point, not the final thing. You might need to debug
> things, and fix silly mistakes.

With the missing spinlock initialisation fixed:

-static struct spinlock idem_lock;
+static DEFINE_SPINLOCK(idem_lock);

this passes basic smoke testing and allows the X13s to boot.

It does not seem to have any significant impact on boot time, but it
avoids some of the unnecessary load attempts as intended:

Before:

         Mods ever loaded       131
     Mods failed on kread       0
Mods failed on decompress       0
  Mods failed on becoming       24
      Mods failed on load       14
        Total module size       12587008
      Total mod text size       5058560
       Failed kread bytes       0
  Failed decompress bytes       0
    Failed becoming bytes       2437992
        Failed kmod bytes       1858992
 Virtual mem wasted bytes       4296984
         Average mod size       96085
    Average mod text size       38615
  Avg fail becoming bytes       101583
  Average fail load bytes       132786

After:

         Mods ever loaded       131
     Mods failed on kread       0
Mods failed on decompress       0
  Mods failed on becoming       4
      Mods failed on load       0
        Total module size       12587008
      Total mod text size       5058560
       Failed kread bytes       0
  Failed decompress bytes       0
    Failed becoming bytes       109776
        Failed kmod bytes       0
 Virtual mem wasted bytes       109776
         Average mod size       96085
    Average mod text size       38615
  Avg fail becoming bytes       27444

Johan
