Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA77E
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 09:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE52C433EF;
	Fri, 30 Dec 2022 09:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672391741;
	bh=BXHST6oJdELxRy9pLqNJ3XHH0A1M/4Hj9g4PvQ6Ef0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=im+nL03/Lx02u9KH/CiH+MIp3KDMmLLX/GOASnEVFOPqtMOzmgkJX8Rs/ed2vvC+J
	 OP8TxiyyEoB9CDclqXxzpY7J2ZcGOfoPEJqmXpn06OGIFTJA2WHrG/BZKZaqntnrBv
	 QWHsVT9tW5qa0p3qdbTMKg5UgSzzAVes1KZl+awI=
Date: Fri, 30 Dec 2022 10:15:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Rosin <peda@axentia.se>
Cc: Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
	Marek Vasut <marex@denx.de>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 456/731] extcon: usbc-tusb320: Update state on probe
 even if no IRQ pending
Message-ID: <Y66sOhyNvhvYROSL@kroah.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144309.770876879@linuxfoundation.org>
 <20221228154501.tinymudo2j3kzyii@bang-olufsen.dk>
 <a3b6d80d-cc1a-be21-9842-d9362bc372e6@axentia.se>
 <44c25160-0cab-1a41-0551-57c8efc5f058@axentia.se>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44c25160-0cab-1a41-0551-57c8efc5f058@axentia.se>

On Thu, Dec 29, 2022 at 01:09:13AM +0100, Peter Rosin wrote:
> 2022-12-28 at 22:04, Peter Rosin wrote:
> > Hi!
> > 
> > 2022-12-28 at 16:45, Alvin Šipraga wrote:
> >> On Wed, Dec 28, 2022 at 03:39:23PM +0100, Greg Kroah-Hartman wrote:
> >>> From: Marek Vasut <marex@denx.de>
> >>>
> >>> [ Upstream commit 581c848b610dbf3fe1ed4d85fd53d0743c61faba ]
> >>>
> >>> Currently this driver triggers extcon and typec state update in its
> >>> probe function, to read out current state reported by the chip and
> >>> report the correct state to upper layers. This synchronization is
> >>> performed correctly, but only in case the chip indicates a pending
> >>> interrupt in reg09 register.
> >>>
> >>> This fails to cover the situation where all interrupts reported by
> >>> the chip were already handled by Linux before reboot, then the system
> >>> rebooted, and then Linux starts again. In this case, the TUSB320 no
> >>> longer reports any interrupts in reg09, and the state update does not
> >>> perform any update as it depends on that interrupt indication.
> >>>
> >>> Fix this by turning tusb320_irq_handler() into a thin wrapper around
> >>> tusb320_state_update_handler(), where the later now contains the bulk
> >>> of the code of tusb320_irq_handler(), but adds new function parameter
> >>> "force_update". The "force_update" parameter can be used by the probe
> >>> function to assure that the state synchronization is always performed,
> >>> independent of the interrupt indicated in reg09. The interrupt handler
> >>> tusb320_irq_handler() callback uses force_update=false to avoid state
> >>> updates on potential spurious interrupts and retain current behavior.
> >>>
> >>> Fixes: 06bc4ca115cdd ("extcon: Add driver for TI TUSB320")
> >>> Signed-off-by: Marek Vasut <marex@denx.de>
> >>> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> >>> Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >>> Link: https://lore.kernel.org/r/20221120141509.81012-1-marex@denx.de
> >>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>> ---
> >>
> >> Is the Fixes: tag here actually wrong? There was a regression report here:
> >>
> >> https://lore.kernel.org/all/fd0f2d56-495e-6fdd-d1e8-ff40b558101e@axentia.se/
> >>
> >> which this patch fixed. But according to the report, it was a regression
> >> introduced by Marek's recent addition of typec support. Since that new
> > 
> > The fixes tag is correct here. What is wrong is that this patch does not fix
> > the above reported regression which was instead fixed by
> > 341fd15e2e18 ("extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is registered")
> > 
> > However, this patch still fixes a problem so it should be considered for stable.
> > 
> > From only looking at this patch, it looks easy to backport to kernels that do
> > not have
> > bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
> > and its followup fix.
> > 
> > But I have of course not tried, so maybe I'm wrong...
> 
> Sorry for the reply to self, but here's a backport for v5.15
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>

Can you send this as a new thread with the proper header and subject
line so that we can apply it correctly?

Right now it's burried down in this thread...

thanks,

greg k-h
