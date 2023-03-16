Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BED17CF
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 07:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7F8C4339C;
	Thu, 16 Mar 2023 07:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678951618;
	bh=8UA1ZnV3rYywyGvOKwKZGe8p+PY9MmX+mvJ0vb50Sjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QEJsAteSG5trkt0dbhmhrldSCTD72jLBiZTovWast/GbY2oUJ2OoRmmeYolf5L9jv
	 j+TTCcezcv/zwCH3FUZBdfosCgFt1ejyogDPIiv68FtWrGY975nYbWT/8eF4dqZbE2
	 ZH3r4NP3i8am6C0kF2UwCzx4KgEapqyfJ4nzObtM=
Date: Thu, 16 Mar 2023 08:26:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Conor Dooley <conor.dooley@microchip.com>,
	Samuel Holland <samuel@sholland.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 113/141] RISC-V: take text_mutex during alternative
 patching
Message-ID: <ZBLEv2MdkAijCx44@kroah.com>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.437505798@linuxfoundation.org>
 <43a91137-87bd-490a-bd53-196aedb497e8@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43a91137-87bd-490a-bd53-196aedb497e8@spud>

On Wed, Mar 15, 2023 at 01:10:04PM +0000, Conor Dooley wrote:
> Hey Greg,
> 
> Looks like the authorship for this commit has been lost as part of
> backporting.
> 
> On Wed, Mar 15, 2023 at 01:13:36PM +0100, Greg Kroah-Hartman wrote:
> > [ Upstream commit 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06 ]
> > 
> > Guenter reported a splat during boot, that Samuel pointed out was the
> > lockdep assertion failing in patch_insn_write():
> > 
> > WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:63 patch_insn_write+0x222/0x2f6
> > epc : patch_insn_write+0x222/0x2f6
> >  ra : patch_insn_write+0x21e/0x2f6
> > epc : ffffffff800068c6 ra : ffffffff800068c2 sp : ffffffff81803df0
> >  gp : ffffffff81a1ab78 tp : ffffffff81814f80 t0 : ffffffffffffe000
> >  t1 : 0000000000000001 t2 : 4c45203a76637369 s0 : ffffffff81803e40
> >  s1 : 0000000000000004 a0 : 0000000000000000 a1 : ffffffffffffffff
> >  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000001
> >  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000052464e43
> >  s2 : ffffffff80b4889c s3 : 000000000000082c s4 : ffffffff80b48828
> >  s5 : 0000000000000828 s6 : ffffffff8131a0a0 s7 : 0000000000000fff
> >  s8 : 0000000008000200 s9 : ffffffff8131a520 s10: 0000000000000018
> >  s11: 000000000000000b t3 : 0000000000000001 t4 : 000000000000000d
> >  t5 : ffffffffd8180000 t6 : ffffffff81803bc8
> > status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
> > [<ffffffff800068c6>] patch_insn_write+0x222/0x2f6
> > [<ffffffff80006a36>] patch_text_nosync+0xc/0x2a
> > [<ffffffff80003b86>] riscv_cpufeature_patch_func+0x52/0x98
> > [<ffffffff80003348>] _apply_alternatives+0x46/0x86
> > [<ffffffff80c02d36>] apply_boot_alternatives+0x3c/0xfa
> > [<ffffffff80c03ad8>] setup_arch+0x584/0x5b8
> > [<ffffffff80c0075a>] start_kernel+0xa2/0x8f8
> > 
> > This issue was exposed by 702e64550b12 ("riscv: fpu: switch has_fpu() to
> > riscv_has_extension_likely()"), as it is the patching in has_fpu() that
> > triggers the splats in Guenter's report.
> > 
> > Take the text_mutex before doing any code patching to satisfy lockdep.
> > 
> > Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
> > Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
> > Fixes: 1a0e5dbd3723 ("riscv: sifive: Add SiFive alternative ports")
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Link: https://lore.kernel.org/all/20230212154333.GA3760469@roeck-us.net/
> > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> 
> The original author on the submitted patch matched this signoff here,
> not sure what went wrong along the way.

I do not understand, sorry, the signed off by area of this commit in the
queue seems to match up with what is in Linus's tree with the exception
that Sasha:

> > Reviewed-by: Samuel Holland <samuel@sholland.org>
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> > Link: https://lore.kernel.org/r/20230212194735.491785-1-conor@kernel.org
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>

Added himself to the end of it.

What exactly is not correct here?

confused,

greg k-h
