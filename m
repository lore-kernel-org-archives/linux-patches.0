Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFA53E25;
	Mon,  8 Jan 2024 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3/IumgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA81C433C8;
	Mon,  8 Jan 2024 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704733091;
	bh=MLbyWZCbBY7S1qs/60XLVtY/x8286TrQ+vh4hv63ZUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k3/IumgF0wilX2Rn+KI+MkXI3uzKAEotVQPg/HsUcj2vdg6IoUoTg3lOZFgpBOiun
	 m41UwVPD9M9wMzCsJGQ16yu5osJ5DwjKc9Uh8D3T6cbL8l+D0W5c6jjZLOc7p/jkmr
	 VrWvJNwEPX2uNOdCBxIWCy/1xlwQffo5fNlnip6k1tf4AeuT1CUtc2JL3WiBFiZKAd
	 yt8+K9pFWjPyUOT+kulVgoXtU7tdHegKezqlGJO9C7xkQ/QU3iZwesPS0LZDEC3zkP
	 ApnRdisBqbUl181j6VIvJETPnmngExNc2p9gfZWfHfA9djU8l355RgTOImzU6t6p4r
	 7xzhv5vAqAObA==
Date: Mon, 8 Jan 2024 16:58:06 +0000
From: Lee Jones <lee@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.4 062/165] net: usb: lan78xx: reorder cleanup
 operations to avoid UAF bugs
Message-ID: <20240108165806.GA7948@google.com>
References: <20230809103642.720851262@linuxfoundation.org>
 <20230809103644.851543936@linuxfoundation.org>
 <20240108145224.GA641998@google.com>
 <2024010807-fantasy-species-3607@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2024010807-fantasy-species-3607@gregkh>

On Mon, 08 Jan 2024, Greg Kroah-Hartman wrote:

> On Mon, Jan 08, 2024 at 02:52:24PM +0000, Lee Jones wrote:
> > On Wed, 09 Aug 2023, Greg Kroah-Hartman wrote:
> > 
> > > From: Duoming Zhou <duoming@zju.edu.cn>
> > > 
> > > [ Upstream commit 1e7417c188d0a83fb385ba2dbe35fd2563f2b6f3 ]
> > > 
> > > The timer dev->stat_monitor can schedule the delayed work dev->wq and
> > > the delayed work dev->wq can also arm the dev->stat_monitor timer.
> > > 
> > > When the device is detaching, the net_device will be deallocated. but
> > > the net_device private data could still be dereferenced in delayed work
> > > or timer handler. As a result, the UAF bugs will happen.
> > > 
> > > One racy situation is shown below:
> > > 
> > >       (Thread 1)                 |      (Thread 2)
> > > lan78xx_stat_monitor()           |
> > >  ...                             |  lan78xx_disconnect()
> > >  lan78xx_defer_kevent()          |    ...
> > >   ...                            |    cancel_delayed_work_sync(&dev->wq);
> > >   schedule_delayed_work()        |    ...
> > >   (wait some time)               |    free_netdev(net); //free net_device
> > >   lan78xx_delayedwork()          |
> > >   //use net_device private data  |
> > >   dev-> //use                    |
> > > 
> > > Although we use cancel_delayed_work_sync() to cancel the delayed work
> > > in lan78xx_disconnect(), it could still be scheduled in timer handler
> > > lan78xx_stat_monitor().
> > > 
> > > Another racy situation is shown below:
> > > 
> > >       (Thread 1)                |      (Thread 2)
> > > lan78xx_delayedwork             |
> > >  mod_timer()                    |  lan78xx_disconnect()
> > >                                 |   cancel_delayed_work_sync()
> > >  (wait some time)               |   if (timer_pending(&dev->stat_monitor))
> > >              	                |       del_timer_sync(&dev->stat_monitor);
> > >  lan78xx_stat_monitor()         |   ...
> > >   lan78xx_defer_kevent()        |   free_netdev(net); //free
> > >    //use net_device private data|
> > >    dev-> //use                  |
> > > 
> > > Although we use del_timer_sync() to delete the timer, the function
> > > timer_pending() returns 0 when the timer is activated. As a result,
> > > the del_timer_sync() will not be executed and the timer could be
> > > re-armed.
> > > 
> > > In order to mitigate this bug, We use timer_shutdown_sync() to shutdown
> > > the timer and then use cancel_delayed_work_sync() to cancel the delayed
> > > work. As a result, the net_device could be deallocated safely.
> > > 
> > > What's more, the dev->flags is set to EVENT_DEV_DISCONNECT in
> > > lan78xx_disconnect(). But it could still be set to EVENT_STAT_UPDATE
> > > in lan78xx_stat_monitor(). So this patch put the set_bit() behind
> > > timer_shutdown_sync().
> > > 
> > > Fixes: 77dfff5bb7e2 ("lan78xx: Fix race condition in disconnect handling")
> > 
> > Any idea why this stopped at linux-6.4.y?  The aforementioned Fixes:
> > commit also exists in linux-6.1.y and linux-5.15.y.  I don't see any
> > earlier backport attempts or failure reports that would otherwise
> > explain this.
> 
> Did you try to build it:

No, I just noticed that it was missing.

> 	drivers/net/usb/lan78xx.c: In function ‘lan78xx_disconnect’:
> 	drivers/net/usb/lan78xx.c:4234:9: error: implicit declaration of function ‘timer_shutdown_sync’ [-Werror=implicit-function-declaration]
> 	 4234 |         timer_shutdown_sync(&dev->stat_monitor);
> 	      |         ^~~~~~~~~~~~~~~~~~~
> 	cc1: all warnings being treated as errors
> 
> That's a good reason to not include it...

It's a perfect reason not to include it.

The issue is not that the patch is not present.  It's more the lack of
transparency in terms of searchable information on why it was not
included.

I was under the impression that a report is usually sent out when a
patch failed to apply for any reason?

[...]

-- 
Lee Jones [李琼斯]
