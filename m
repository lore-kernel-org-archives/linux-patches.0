Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7B03DB336;
	Mon,  1 Jun 2026 15:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780327085; cv=none; b=QyqHLKpj6FTIEYefF5xVr2LvonM4BhLRqD/urPTIdCUGSksukaM9k+dmxffdWQxDtmIAdRNnkqT68F6POCKBN0UpHmMgYoIqo8bCyvnWkv8ldcWh02SkPhUNmoWAHYdOS933Zkgq1j5hlBAyNpySxaoymaML6ux7N3ugTKn1qd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780327085; c=relaxed/simple;
	bh=Ta6Hhjw5wnwxmjUl0cq3b3LcI87V05svsG3XhxKg7FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f83ITXjh4yyiRIjp4CN1eUcEIgJQEWA6SlxV0uz2nR791Y5lelgUdGyXx/IGNYB7Qd4fnBR5fo0BZUhu7bvGtWbffEwQ+Jg0FR52x8+ZOkUKM2tR8fxLwYyWLMtuqjN6NyRE5U2KqJZGkKxzwdfk5GrrnlJEMXMLz2Kr1CMW9kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fz0lQnve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fz0lQnve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746CF1F00893;
	Mon,  1 Jun 2026 15:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780327078;
	bh=ilT/dy8eCGRed+zU5jpKOtp3O9ZtC9y+Fr0OeUTnYGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fz0lQnveH3TZsbgLg6McLfZl3weIteReQoB7jiCsn+YWJJWWFZGUWgFR2nyhkioyV
	 2KBoGJsgv7o+LMlBQZDppuMEorA/jaSvYwDGG9t6G2vpLvw1gRdvPY5mxdyDplA9gI
	 O5rKmp0JJ6+LF0h+LnXbtXjF+b2IS4D5JEZYgVSU=
Date: Mon, 1 Jun 2026 17:17:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jianqiang kang <jianqkang@sina.cn>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 041/272] i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT
 handling in DMA dequeue
Message-ID: <2026060128-unspoiled-twenty-1a69@gregkh>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194630.531977894@linuxfoundation.org>
 <fad22bda-4493-4f92-a5f3-e8b802277e0f@oracle.com>
 <c6fe43ca-a707-44a9-a98b-5a687588454c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6fe43ca-a707-44a9-a98b-5a687588454c@oracle.com>

On Mon, Jun 01, 2026 at 07:30:15PM +0530, Harshit Mogalapalli wrote:
> On 01/06/26 19:27, Harshit Mogalapalli wrote:
> > Hi Greg/Sasha,
> > 
> > On 29/05/26 01:16, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let
> > > me know.
> > > 
> > > ------------------
> > > 
> > > From: Adrian Hunter <adrian.hunter@intel.com>
> > > 
> > > [ Upstream commit b795e68bf3073d67bebbb5a44d93f49efc5b8cc7 ]
> > > 
> > > The logic used to abort the DMA ring contains several flaws:
> > > 
> > >   1. The driver unconditionally issues a ring abort even when the
> > > ring has
> > >      already stopped.
> > >   2. The completion used to wait for abort completion is never
> > >      re-initialized, resulting in incorrect wait behavior.
> > >   3. The abort sequence unintentionally clears RING_CTRL_ENABLE, which
> > >      resets hardware ring pointers and disrupts the controller state.
> > >   4. If the ring is already stopped, the abort operation should be
> > >      considered successful without attempting further action.
> > > 
> > > Fix the abort handling by checking whether the ring is running before
> > > issuing an abort, re-initializing the completion when needed,
> > > ensuring that
> > > RING_CTRL_ENABLE remains asserted during abort, and treating an already
> > > stopped ring as a successful condition.
> > > 
> > > Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > > Reviewed-by: Frank Li <Frank.Li@nxp.com>
> > > Link: https://patch.msgid.link/20260306072451.11131-9-
> > > adrian.hunter@intel.com
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > > Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >   drivers/i3c/master/mipi-i3c-hci/dma.c | 27 +++++++++++++++++----------
> > >   1 file changed, 17 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/
> > > master/mipi-i3c-hci/dma.c
> > > index b9496e8c4784d..44461f13b54cd 100644
> > > --- a/drivers/i3c/master/mipi-i3c-hci/dma.c
> > > +++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
> > > @@ -457,16 +457,23 @@ static bool hci_dma_dequeue_xfer(struct
> > > i3c_hci *hci,
> > >       struct hci_rh_data *rh = &rings->headers[xfer_list[0].ring_number];
> > >       unsigned int i;
> > >       bool did_unqueue = false;
> > > -
> > > -    /* stop the ring */
> > > -    rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
> > > -    if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
> > > -        /*
> > > -         * We're deep in it if ever this condition is ever met.
> > > -         * Hardware might still be writing to memory, etc.
> > > -         */
> > > -        dev_crit(&hci->master.dev, "unable to abort the ring\n");
> > > -        WARN_ON(1);
> > > +    u32 ring_status;
> > > +
> > > +    ring_status = rh_reg_read(RING_STATUS);
> > > +    if (ring_status & RING_STATUS_RUNNING) {
> > > +        /* stop the ring */
> > > +        reinit_completion(&rh->op_done);
> > > +        rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
> > > +        wait_for_completion_timeout(&rh->op_done, HZ);
> > > +        ring_status = rh_reg_read(RING_STATUS);
> > > +        if (ring_status & RING_STATUS_RUNNING) {
> > > +            /*
> > > +             * We're deep in it if ever this condition is ever met.
> > > +             * Hardware might still be writing to memory, etc.
> > > +             */
> > > +            dev_crit(&hci->master.dev, "unable to abort the ring\n");
> > > +            WARN_ON(1);
> > > +        }
> > 
> > 
> > I ran an AI-assisted backport review and checked the 6.12.y tree.
> > 
> > The posted backport adds the RING_CTRL_ABORT completion handling,
> > including:
> > 
> >      reinit_completion(&rh->op_done);
> >      rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
> >      wait_for_completion_timeout(&rh->op_done, HZ);
> > 
> > In upstream b795e68bf307, that path runs under hci->control_mutex, and
> > the ring bookkeeping is also serialized with hci->lock.
> > 
> > @@ -546,18 +546,25 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
> >          struct hci_rh_data *rh = &rings-
> > >headers[xfer_list[0].ring_number];
> >          unsigned int i;
> >          bool did_unqueue = false;
> > +       u32 ring_status;
> > 
> >          guard(mutex)(&hci->control_mutex);
> > 
> > -       /* stop the ring */
> > -       rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
> > -       if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
> > -               /*
> > -                * We're deep in it if ever this condition is ever met.
> > -                * Hardware might still be writing to memory, etc.
> > -                */
> > -               dev_crit(&hci->master.dev, "unable to abort the ring\n");
> > -               WARN_ON(1);
> > +       ring_status = rh_reg_read(RING_STATUS);
> > +       if (ring_status & RING_STATUS_RUNNING) {
> > +               /* stop the ring */
> > +               reinit_completion(&rh->op_done);
> > +               rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE |
> > RING_CTRL_ABORT);
> > +               wait_for_completion_timeout(&rh->op_done, HZ);
> > +               ring_status = rh_reg_read(RING_STATUS);
> > +               if (ring_status & RING_STATUS_RUNNING) {
> > +                       /*
> > +                        * We're deep in it if ever this condition is
> > ever met.
> > +                        * Hardware might still be writing to memory, etc.
> > +                        */
> > +                       dev_crit(&hci->master.dev, "unable to abort the
> > ring\n");
> > +                       WARN_ON(1);
> > +               }
> >          }
> > 
> >          spin_lock_irq(&hci->lock);
> > 
> > 
> > 
> > 
> > Downstream 6.12.y has the new reinit_completion() path, but it still
> > lacks the MIPI I3C HCI control_mutex and the IRQ/dequeue ring-state
> > locking.
> > 
> > So the backport can reinitialize and wait on the shared ring completion
> > while another timeout/dequeue or IRQ completion path is still touching
> > the same transfer state. Thoughts ?
> > 
> > Maybe we should drop this for now and queue it up with its prerequisites
> > together ?
> 
> Forgot to metnion,  the prerequisites are 1dca8aee80ee ("i3c: mipi-i3c-hci:
> Fix race in DMA ring dequeue") and f0b5159637ca ("i3c: mipi-i3c-hci: Fix
> race between DMA ring dequeue and interrupt handler")

I'll just drop it for now for all branches as I doubt anyone has i3c
hardware on those old branches just yet (or if they do, they can send
the needed backports...)

thanks,

greg k-h
