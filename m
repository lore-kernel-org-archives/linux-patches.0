Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E2EED5
	for <patches@lists.linux.dev>; Wed, 24 May 2023 01:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11301C433D2;
	Wed, 24 May 2023 01:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684890464;
	bh=ATkbGqj0UTcMa0WdL6+FZDTu+CmQwEatOeK6hkcHlMw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=UbD9edXq8IrzofEmJY2wYy1998mV+pU1HRunlfX+zYYqS/fE5IyOKbBw6Dc0bTOOM
	 /LnxbcjOEmL9DVKycLyOGtjJWs28KmiVpviet+/SVSAwxua6WyC3o0x9EVeL0AqLOo
	 kjHvM+Zx2r8HfeI0ZW3ZtVMRU/nyPtVQoCazDBOFr1GdHxp6Sjbw5E9iIsX0+kEucN
	 HOSQYt5sKChrt9DmdSFNOj1fq3vRAuIMAa971tzD3WkYAVVxWpboVptDf6Tk7fT0Zr
	 SRNSj523KdLsTRoqw7MXhd6qSHRIeSi6ta83hsEE9Z/vf84iNxJ/J6SIdnoioU1L7s
	 BuD6W/Ph8/flg==
Message-ID: <382309d7c0ae593d507eb816982f6a66c2cda00a.camel@kernel.org>
Subject: Re: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before
 writing interrupt registers
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Felix Riemann <felix.riemann@sma.de>, gregkh@linuxfoundation.org
Cc: l.sanfilippo@kunbus.com, patches@lists.linux.dev, sashal@kernel.org, 
	stable@vger.kernel.org
Date: Wed, 24 May 2023 04:07:41 +0300
In-Reply-To: <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
References: <20230508094814.897191675@linuxfoundation.org>
	 <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1-0ubuntu1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2023-05-15 at 17:37 +0200, Felix Riemann wrote:
> Hi!
>=20
> > [ Upstream commit 15d7aa4e46eba87242a320f39773aa16faddadee ]
> >=20
> > In tpm_tis_probe_single_irq() interrupt registers TPM_INT_VECTOR,
> > TPM_INT_STATUS and TPM_INT_ENABLE are modified to setup the interrupts.
> > Currently these modifications are done without holding a locality thus =
they
> > have no effect. Fix this by claiming the (default) locality before the
> > registers are written.
> >=20
> > Since now tpm_tis_gen_interrupt() is called with the locality already
> > claimed remove locality request and release from this function.
>=20
> On systems with SPI-connected TPM and the interrupt still configured
> (despite it not working before) this may introduce a kernel crash.
> The issue is that it will now trigger an SPI transfer (which will wait)=
=20
> from the IRQ handler:
>=20
> BUG: scheduling while atomic: systemd-journal/272/0x00010001
> Modules linked in: spi_fsl_lpspi
> CPU: 0 PID: 272 Comm: systemd-journal Not tainted 5.15.111-06679-g56b9923=
f2840 #50
> Call trace:
>  dump_backtrace+0x0/0x1e0
>  show_stack+0x18/0x40
>  dump_stack_lvl+0x68/0x84
>  dump_stack+0x18/0x34
>  __schedule_bug+0x54/0x70
>  __schedule+0x664/0x760
>  schedule+0x88/0x100
>  schedule_timeout+0x80/0xf0
>  wait_for_completion_timeout+0x80/0x10c
>  fsl_lpspi_transfer_one+0x25c/0x4ac [spi_fsl_lpspi]
>  spi_transfer_one_message+0x22c/0x440
>  __spi_pump_messages+0x330/0x5b4
>  __spi_sync+0x230/0x264
>  spi_sync_locked+0x10/0x20
>  tpm_tis_spi_transfer+0x1ec/0x250
>  tpm_tis_spi_read_bytes+0x14/0x20
>  tpm_tis_spi_read32+0x38/0x70
>  tis_int_handler+0x48/0x15c
>  *snip*
>=20
> The immediate error is fixable by also picking 0c7e66e5fd ("tpm, tpm_tis:=
=20
> Request threaded interrupt handler") from the same patchset[1]. However, =
as
> the driver's IRQ test logic is still faulty it will fail the check and fa=
ll
> back to the polling behaviour without actually disabling the IRQ in hard-
> and software again. For this at least e644b2f498 ("tpm, tpm_tis: Enable=
=20
> interrupt test") and 0e069265bc ("tpm, tpm_tis: Claim locality in interru=
pt
> handler") are necessary.
>=20
> At this point 9 of the set's 14 patches are applied and I am not sure
> whether it's better to pick the remaining five patches as well or just
> revert the initial six patches. Especially considering there were initial=
ly
> no plans to submit these patches to stable[2] and the IRQ feature was (at
> least on SPI) not working before.

I think the right thing to do would be to revert 6 initial patches.

>=20
> Regards,
>=20
> Felix
>=20
> [1] https://lore.kernel.org/lkml/20221124135538.31020-1-LinoSanfilippo@gm=
x.de/
> [2] https://lore.kernel.org/lkml/CS48ZBNWI6T9.1CU08I6KDVM65@suppilovahver=
o/

BR, Jarkko
