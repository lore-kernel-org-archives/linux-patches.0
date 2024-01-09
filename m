Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734236FD2;
	Tue,  9 Jan 2024 08:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEd5RstA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4489DC433F1;
	Tue,  9 Jan 2024 08:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704790286;
	bh=0NnV4Q+N8tiajTzlw914LyJgO3ebqDG+xpa5VSy3tHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aEd5RstAoi9x2j99tBogTtGTtsFOxMUH5IWAXeWPr3GZTADuzLxoinUmQ5xsXdAE1
	 SWYRe+6+hkx5G6zgnJCr3LRUqBtvgFL+iFl1Wtzz7AuvmfaDaU2069LArg3fJbao2m
	 5wzI8KY82rZdNREic55Zilqj3AX9Gt2JL3GROzGE=
Date: Tue, 9 Jan 2024 09:51:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lee Jones <lee@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.4 062/165] net: usb: lan78xx: reorder cleanup
 operations to avoid UAF bugs
Message-ID: <2024010914-faceted-renounce-2b42@gregkh>
References: <20230809103642.720851262@linuxfoundation.org>
 <20230809103644.851543936@linuxfoundation.org>
 <20240108145224.GA641998@google.com>
 <2024010807-fantasy-species-3607@gregkh>
 <20240108165806.GA7948@google.com>
 <2024010845-foam-efficient-6ae4@gregkh>
 <20240109083251.GD7948@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240109083251.GD7948@google.com>

On Tue, Jan 09, 2024 at 08:32:51AM +0000, Lee Jones wrote:
> On Mon, 08 Jan 2024, Greg Kroah-Hartman wrote:
> 
> > On Mon, Jan 08, 2024 at 04:58:06PM +0000, Lee Jones wrote:
> > > On Mon, 08 Jan 2024, Greg Kroah-Hartman wrote:
> > > 
> > > > On Mon, Jan 08, 2024 at 02:52:24PM +0000, Lee Jones wrote:
> > > > > On Wed, 09 Aug 2023, Greg Kroah-Hartman wrote:
> > > > > 
> > > > > > From: Duoming Zhou <duoming@zju.edu.cn>
> > > > > > 
> > > > > > [ Upstream commit 1e7417c188d0a83fb385ba2dbe35fd2563f2b6f3 ]
> > > > > > 
> > > > > > The timer dev->stat_monitor can schedule the delayed work dev->wq and
> > > > > > the delayed work dev->wq can also arm the dev->stat_monitor timer.
> > > > > > 
> > > > > > When the device is detaching, the net_device will be deallocated. but
> > > > > > the net_device private data could still be dereferenced in delayed work
> > > > > > or timer handler. As a result, the UAF bugs will happen.
> > > > > > 
> > > > > > One racy situation is shown below:
> > > > > > 
> > > > > >       (Thread 1)                 |      (Thread 2)
> > > > > > lan78xx_stat_monitor()           |
> > > > > >  ...                             |  lan78xx_disconnect()
> > > > > >  lan78xx_defer_kevent()          |    ...
> > > > > >   ...                            |    cancel_delayed_work_sync(&dev->wq);
> > > > > >   schedule_delayed_work()        |    ...
> > > > > >   (wait some time)               |    free_netdev(net); //free net_device
> > > > > >   lan78xx_delayedwork()          |
> > > > > >   //use net_device private data  |
> > > > > >   dev-> //use                    |
> > > > > > 
> > > > > > Although we use cancel_delayed_work_sync() to cancel the delayed work
> > > > > > in lan78xx_disconnect(), it could still be scheduled in timer handler
> > > > > > lan78xx_stat_monitor().
> > > > > > 
> > > > > > Another racy situation is shown below:
> > > > > > 
> > > > > >       (Thread 1)                |      (Thread 2)
> > > > > > lan78xx_delayedwork             |
> > > > > >  mod_timer()                    |  lan78xx_disconnect()
> > > > > >                                 |   cancel_delayed_work_sync()
> > > > > >  (wait some time)               |   if (timer_pending(&dev->stat_monitor))
> > > > > >              	                |       del_timer_sync(&dev->stat_monitor);
> > > > > >  lan78xx_stat_monitor()         |   ...
> > > > > >   lan78xx_defer_kevent()        |   free_netdev(net); //free
> > > > > >    //use net_device private data|
> > > > > >    dev-> //use                  |
> > > > > > 
> > > > > > Although we use del_timer_sync() to delete the timer, the function
> > > > > > timer_pending() returns 0 when the timer is activated. As a result,
> > > > > > the del_timer_sync() will not be executed and the timer could be
> > > > > > re-armed.
> > > > > > 
> > > > > > In order to mitigate this bug, We use timer_shutdown_sync() to shutdown
> > > > > > the timer and then use cancel_delayed_work_sync() to cancel the delayed
> > > > > > work. As a result, the net_device could be deallocated safely.
> > > > > > 
> > > > > > What's more, the dev->flags is set to EVENT_DEV_DISCONNECT in
> > > > > > lan78xx_disconnect(). But it could still be set to EVENT_STAT_UPDATE
> > > > > > in lan78xx_stat_monitor(). So this patch put the set_bit() behind
> > > > > > timer_shutdown_sync().
> > > > > > 
> > > > > > Fixes: 77dfff5bb7e2 ("lan78xx: Fix race condition in disconnect handling")
> > > > > 
> > > > > Any idea why this stopped at linux-6.4.y?  The aforementioned Fixes:
> > > > > commit also exists in linux-6.1.y and linux-5.15.y.  I don't see any
> > > > > earlier backport attempts or failure reports that would otherwise
> > > > > explain this.
> > > > 
> > > > Did you try to build it:
> > > 
> > > No, I just noticed that it was missing.
> > > 
> > > > 	drivers/net/usb/lan78xx.c: In function ‘lan78xx_disconnect’:
> > > > 	drivers/net/usb/lan78xx.c:4234:9: error: implicit declaration of function ‘timer_shutdown_sync’ [-Werror=implicit-function-declaration]
> > > > 	 4234 |         timer_shutdown_sync(&dev->stat_monitor);
> > > > 	      |         ^~~~~~~~~~~~~~~~~~~
> > > > 	cc1: all warnings being treated as errors
> > > > 
> > > > That's a good reason to not include it...
> > > 
> > > It's a perfect reason not to include it.
> > > 
> > > The issue is not that the patch is not present.  It's more the lack of
> > > transparency in terms of searchable information on why it was not
> > > included.
> > > 
> > > I was under the impression that a report is usually sent out when a
> > > patch failed to apply for any reason?
> > 
> > For patches that are explicitly tagged for stable inclusion, yes, that
> > will happen.  That is not the case for this commit.
> > 
> > For patches that only have a "Fixes:" tag on it, those are gotten to on
> > a "best effort" basis when we get a chance, as those were obviously not
> > explicitly asked to be backported.  And when they are backported, if
> > they fail, they will fail silently as the author/maintainer was not
> > explicitly asking them to be applied to a stable tree, so it would just
> > be noise to complain about it.
> > 
> > So, it's lucky that this patch was backported at all to any stable tree :)
> 
> That's fair to a point.
> 
> Just know that if there are no other means to determine the actions
> taken place behind closed doors, then these queries are likely to
> reoccur.

There are no "closed doors" here, everything we apply is sent to the
public, so the lack of an email will mean it was not applied.  We can't
spam the lists with "well I tried this patch on this tree and it didn't
work" messages all the time, as that would be a mess, especially as
changes like this were NOT asked to be backported, we just took the time
to attempt to do so on our own accord.

Again, patches that are explicitly asked to be applied, and fail, will
be notified if they fail.  Patches that are not asked to be applied, and
we try to do so anyway because it looks like they might be relevant, and
they fail, will not be applied as it would seem that the original author
was correct in that it shouldn't have been applied.

> It would be far nicer if an automated mail was sent out when a failed
> backport attempt were made in all cases.  Even if we drop the individual
> contributor/maintainer addresses and only ping the mailing lists, since
> at least it then becomes helpfully searchable on LORE.  Is it really
> more work to duplicate the workflow between intended Stable inclusions
> and any other attempt?

It's a different patch stream and workflow.  One that some people have
suggested that we maybe just stop doing entirely (i.e. don't take
anything that is not explicitly marked), but that would mean that many
subsystems would never get any backports done for them because they
never mark anything.  So we do the best that we can, and do not bother
the subsystems that do not want to be part of the stable backport
process, which is totally legitimate as it is extra effort on their part
and that is the first rule of the stable kernel process when we created
them:
	- we will not impose any extra work on any maintainer or
	  developer if they do not want to do it.

Also, when asking "why wasn't this patch applied?", 90% of the time a
simple "let me go apply it and build it" will show that it either
doesn't apply, or breaks the build, which will save people a round-trip
in emails as that's the obvious answer :)

thanks,

greg k-h
