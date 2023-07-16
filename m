Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8EF1FB7
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 15:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95A0C433C7;
	Sun, 16 Jul 2023 15:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689520698;
	bh=wdzrjiRF1UzNEzLy6JH3W2VtncpZ6QgP8nNgQQA1Eig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WtygqVOipt1wiISgL4CHSNIVJ+4iNmvt4RugTePJxkAraZ18DtlD1vvwdXyiXzNkk
	 yPYi+uw2bqsUnrADuWwmuzmbsscUh0AgBZQhl9ueRk+MaEDiVKhR6m3xrbOgImczUS
	 NqOJ8gK4ld1XtREUjvojRFyTPuXGkXy7GSSiJF2Q=
Date: Sun, 16 Jul 2023 17:18:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	Felix Riemann <felix.riemann@sma.de>, patches@lists.linux.dev,
	sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before writing
 interrupt registers
Message-ID: <2023071600-backdrop-carless-b990@gregkh>
References: <20230508094814.897191675@linuxfoundation.org>
 <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
 <382309d7c0ae593d507eb816982f6a66c2cda00a.camel@kernel.org>
 <2023060906-starter-scrounger-1bca@gregkh>
 <3bdaa40e-16dc-6c04-b9e4-9e5951267e7e@kunbus.com>
 <2023062100-retrace-kitten-7241@gregkh>
 <c9c3fe87-9f70-2131-24d3-bbb626042c16@kunbus.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9c3fe87-9f70-2131-24d3-bbb626042c16@kunbus.com>

On Fri, Jul 14, 2023 at 07:15:38PM +0200, Lino Sanfilippo wrote:
> Hi Greg,
> 
> On 21.06.23 20:45, Greg KH wrote:
> 
> > On Fri, Jun 09, 2023 at 05:42:20PM +0200, Lino Sanfilippo wrote:
> >> Hi,
> >>
> >> On 09.06.23 11:07, Greg KH wrote:
> >>>
> >>> On Wed, May 24, 2023 at 04:07:41AM +0300, Jarkko Sakkinen wrote:
> >>>> On Mon, 2023-05-15 at 17:37 +0200, Felix Riemann wrote:
> >>>>> Hi!
> >>>>>
> >>>>>> [ Upstream commit 15d7aa4e46eba87242a320f39773aa16faddadee ]
> >>>>>>
> >>>>>> In tpm_tis_probe_single_irq() interrupt registers TPM_INT_VECTOR,
> >>>>>> TPM_INT_STATUS and TPM_INT_ENABLE are modified to setup the interrupts.
> >>>>>> Currently these modifications are done without holding a locality thus they
> >>>>>> have no effect. Fix this by claiming the (default) locality before the
> >>>>>> registers are written.
> >>>>>>
> >>>>>> Since now tpm_tis_gen_interrupt() is called with the locality already
> >>>>>> claimed remove locality request and release from this function.
> >>>>>
> >>>>> On systems with SPI-connected TPM and the interrupt still configured
> >>>>> (despite it not working before) this may introduce a kernel crash.
> >>>>> The issue is that it will now trigger an SPI transfer (which will wait)
> >>>>> from the IRQ handler:
> >>>>>
> >>>>> BUG: scheduling while atomic: systemd-journal/272/0x00010001
> >>>>> Modules linked in: spi_fsl_lpspi
> >>>>> CPU: 0 PID: 272 Comm: systemd-journal Not tainted 5.15.111-06679-g56b9923f2840 #50
> >>>>> Call trace:
> >>>>>  dump_backtrace+0x0/0x1e0
> >>>>>  show_stack+0x18/0x40
> >>>>>  dump_stack_lvl+0x68/0x84
> >>>>>  dump_stack+0x18/0x34
> >>>>>  __schedule_bug+0x54/0x70
> >>>>>  __schedule+0x664/0x760
> >>>>>  schedule+0x88/0x100
> >>>>>  schedule_timeout+0x80/0xf0
> >>>>>  wait_for_completion_timeout+0x80/0x10c
> >>>>>  fsl_lpspi_transfer_one+0x25c/0x4ac [spi_fsl_lpspi]
> >>>>>  spi_transfer_one_message+0x22c/0x440
> >>>>>  __spi_pump_messages+0x330/0x5b4
> >>>>>  __spi_sync+0x230/0x264
> >>>>>  spi_sync_locked+0x10/0x20
> >>>>>  tpm_tis_spi_transfer+0x1ec/0x250
> >>>>>  tpm_tis_spi_read_bytes+0x14/0x20
> >>>>>  tpm_tis_spi_read32+0x38/0x70
> >>>>>  tis_int_handler+0x48/0x15c
> >>>>>  *snip*
> >>>>>
> >>>>> The immediate error is fixable by also picking 0c7e66e5fd ("tpm, tpm_tis:
> >>>>> Request threaded interrupt handler") from the same patchset[1].
> >>>>> However, as
> >>>>> the driver's IRQ test logic is still faulty it will fail the check and fall
> >>>>> back to the polling behaviour without actually disabling the IRQ in hard-
> >>>>> and software again. For this at least e644b2f498 ("tpm, tpm_tis: Enable
> >>>>> interrupt test") and 0e069265bc ("tpm, tpm_tis: Claim locality in interrupt
> >>>>> handler") are necessary.
> >>>>>
> >>>>> At this point 9 of the set's 14 patches are applied and I am not sure
> >>>>> whether it's better to pick the remaining five patches as well or just
> >>>>> revert the initial six patches. Especially considering there were initially
> >>>>> no plans to submit these patches to stable[2] and the IRQ feature was (at
> >>>>> least on SPI) not working before.
> >>>>
> >>>> I think the right thing to do would be to revert 6 initial patches.
> >>>
> >>> Ok, I think this isn't needed anymore with the latest 5.15.116 release,
> >>> right?  If not, please let me know.
> >>>
> >>
> >>
> 
> 
> >> With 0c7e66e5fd ("tpm, tpm_tis: Request threaded interrupt handler") applied the
> >> above bug is fixed in 5.15.y. There is however still the issue that the interrupts may
> >> not be acknowledged properly in the interrupt handler, since the concerning register is written
> >> without the required locality held (Felix mentions this above).
> >> This can be fixed with 0e069265bce5 ("tpm, tpm_tis: Claim locality in interrupt handler").
> >>
> >> So instead of reverting the initial patches, I suggest to
> >>
> >> 1. also apply 0e069265bce5 ("tpm, tpm_tis: Claim locality in interrupt handler")
> > 
> > I've now done this, thanks.
> > 
> > greg k-h
> 
> While 5.15.y, 6.1.y and 6.3.y should be fine AFAICS commit 
> 0e069265bc ("tpm, tpm_tis: Claim locality in interrupt handler") is
> still missing in 5.10.y. This commit is needed to make sure that TPM interrupts
> are properly acknowledge (see text above).

Ok, now queued up, thanks.

greg k-h
