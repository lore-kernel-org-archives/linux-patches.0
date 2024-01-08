Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268B94777C;
	Mon,  8 Jan 2024 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRgG5hW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCB4C433C7;
	Mon,  8 Jan 2024 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704725548;
	bh=wdN+qxLwvdtOT6W/sXpFUa78ssD1EepeKJXNbsHBzuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mRgG5hW+BKXr4DywkFqG48Vvtv1NQoyGPLh0gTgv1mGnJujs1MFUnl8KA/t1egtBu
	 TzFTQnUdA/Nng8dovQYlXKiclk/OSqfDYjfkpLjMnyNG3P3Vsj16JPlCjKzjWSO+v4
	 8d4SKcMummiHZB4aQopBeKANOXQCGHNmXN3LKPxY/IpkO7Fn+fjau9PFl7czYGka9Q
	 7CyaL4zDBYkx1Eel8SGc4CUM0Ey/RlhFkMcFG9ISoWXaZxazuB2GnE/rpLwdE9SOes
	 MpSwM9ppK/40LVoXVfaG6VajZK1EjrvJMZnL0MyKDr8Gsfwt6FhZZRQZEanCHY8q1b
	 Dyt5Sqx03Y2mg==
Date: Mon, 8 Jan 2024 14:52:24 +0000
From: Lee Jones <lee@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.4 062/165] net: usb: lan78xx: reorder cleanup
 operations to avoid UAF bugs
Message-ID: <20240108145224.GA641998@google.com>
References: <20230809103642.720851262@linuxfoundation.org>
 <20230809103644.851543936@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230809103644.851543936@linuxfoundation.org>

On Wed, 09 Aug 2023, Greg Kroah-Hartman wrote:

> From: Duoming Zhou <duoming@zju.edu.cn>
> 
> [ Upstream commit 1e7417c188d0a83fb385ba2dbe35fd2563f2b6f3 ]
> 
> The timer dev->stat_monitor can schedule the delayed work dev->wq and
> the delayed work dev->wq can also arm the dev->stat_monitor timer.
> 
> When the device is detaching, the net_device will be deallocated. but
> the net_device private data could still be dereferenced in delayed work
> or timer handler. As a result, the UAF bugs will happen.
> 
> One racy situation is shown below:
> 
>       (Thread 1)                 |      (Thread 2)
> lan78xx_stat_monitor()           |
>  ...                             |  lan78xx_disconnect()
>  lan78xx_defer_kevent()          |    ...
>   ...                            |    cancel_delayed_work_sync(&dev->wq);
>   schedule_delayed_work()        |    ...
>   (wait some time)               |    free_netdev(net); //free net_device
>   lan78xx_delayedwork()          |
>   //use net_device private data  |
>   dev-> //use                    |
> 
> Although we use cancel_delayed_work_sync() to cancel the delayed work
> in lan78xx_disconnect(), it could still be scheduled in timer handler
> lan78xx_stat_monitor().
> 
> Another racy situation is shown below:
> 
>       (Thread 1)                |      (Thread 2)
> lan78xx_delayedwork             |
>  mod_timer()                    |  lan78xx_disconnect()
>                                 |   cancel_delayed_work_sync()
>  (wait some time)               |   if (timer_pending(&dev->stat_monitor))
>              	                |       del_timer_sync(&dev->stat_monitor);
>  lan78xx_stat_monitor()         |   ...
>   lan78xx_defer_kevent()        |   free_netdev(net); //free
>    //use net_device private data|
>    dev-> //use                  |
> 
> Although we use del_timer_sync() to delete the timer, the function
> timer_pending() returns 0 when the timer is activated. As a result,
> the del_timer_sync() will not be executed and the timer could be
> re-armed.
> 
> In order to mitigate this bug, We use timer_shutdown_sync() to shutdown
> the timer and then use cancel_delayed_work_sync() to cancel the delayed
> work. As a result, the net_device could be deallocated safely.
> 
> What's more, the dev->flags is set to EVENT_DEV_DISCONNECT in
> lan78xx_disconnect(). But it could still be set to EVENT_STAT_UPDATE
> in lan78xx_stat_monitor(). So this patch put the set_bit() behind
> timer_shutdown_sync().
> 
> Fixes: 77dfff5bb7e2 ("lan78xx: Fix race condition in disconnect handling")

Any idea why this stopped at linux-6.4.y?  The aforementioned Fixes:
commit also exists in linux-6.1.y and linux-5.15.y.  I don't see any
earlier backport attempts or failure reports that would otherwise
explain this.

> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/usb/lan78xx.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

-- 
Lee Jones [李琼斯]
