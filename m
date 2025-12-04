Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161FD2D877A;
	Thu,  4 Dec 2025 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865737; cv=none; b=C5ovkWqCVFdlC9izUIBGRXA33GNVv4arlyDyrEOXTXb884Nto93jm8OmfmT3PRvXCUSleFnGeP82x8azhVdecQnKaqidWNXrpu4BrRqNQ2O8DoAffb0/8b48xXKP7oYWXv4vAxt/hVoq1vNS0bSwb/9Oa3T4WVORY/GWxSXrxR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865737; c=relaxed/simple;
	bh=Z/UgjbyXa+rOnoADWCIqkqSJxi3WJ4msOlCGSaiW+XM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCZ4Nf6PvxULFfY2Hk3n4qucAkUun4gEDoz8IKpEpoS2fdh4VFUTVM538KBMF95v9LsX5O4bUJBFGcYUB+jomGGgRTE22rb1kxRXRs1R8ZKeVkuAM7bE/FZYPZPL/ZyFNMynVIhyD9zqL5VgDJmwddA4hNKYhv3p8PM47gH+oi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfrlgIhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfrlgIhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5374C4CEFB;
	Thu,  4 Dec 2025 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764865736;
	bh=Z/UgjbyXa+rOnoADWCIqkqSJxi3WJ4msOlCGSaiW+XM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VfrlgIhNpzVgXUsRIq1aM8dXtkB6siQORHD2L9welWFhoTP5bKqtZHxogJd4UCfA2
	 WQDmE7SZjXCwZNwPSdvjpS1FkzHc7Y6rJQLtI2XhW0TdZv1bvjhmX73KqkdtwZbh+X
	 nqL0I17/6fGWpRm0Zdag1TTNY55IhaIvle0TJgDU=
Date: Thu, 4 Dec 2025 17:28:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org,
	sr@sladewatkins.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
Message-ID: <2025120440-baboon-curfew-e3aa@gregkh>
References: <20251203152440.645416925@linuxfoundation.org>
 <bae0cb4e-9498-4ceb-945c-55a00725d10e@sirena.org.uk>
 <481f5985-da16-4b06-912d-dbc831504068@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481f5985-da16-4b06-912d-dbc831504068@w6rz.net>

On Thu, Dec 04, 2025 at 05:51:18AM -0800, Ron Economos wrote:
> On 12/4/25 04:06, Mark Brown wrote:
> > On Wed, Dec 03, 2025 at 04:20:02PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.159 release.
> > > There are 568 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > I'm seeing a bunch of systems start failing with this release, they
> > start OOMing when previously they ran OK.  Most of them aren't exactly
> > overburned with memory.  These failures bisect to 61717acddadf66
> > (mm/memory: do not populate page table entries beyond i_size), sample
> > bisect from one of the systems including links to test jobs (the bisects
> > for other systems/test sets look very similar):
> > 
> > # bad: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] Linux 6.1.159-rc1
> > # good: [f6e38ae624cf7eb96fb444a8ca2d07caa8d9c8fe] Linux 6.1.158
> > git bisect start 'abd89c70c9382759c14c5e7e0b383c2a19594c5c' 'f6e38ae624cf7eb96fb444a8ca2d07caa8d9c8fe'
> > # test job: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] https://lava.sirena.org.uk/scheduler/job/2168338
> > # bad: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] Linux 6.1.159-rc1
> > git bisect bad abd89c70c9382759c14c5e7e0b383c2a19594c5c
> > # test job: [43c650106e8558fa7cfec5a2e9c8de29233b6552] https://lava.sirena.org.uk/scheduler/job/2168373
> > # good: [43c650106e8558fa7cfec5a2e9c8de29233b6552] rtc: pcf2127: clear minute/second interrupt
> > git bisect good 43c650106e8558fa7cfec5a2e9c8de29233b6552
> > # test job: [b56fbe428919e8c1a548f331d20b8c4608008845] https://lava.sirena.org.uk/scheduler/job/2168393
> > # good: [b56fbe428919e8c1a548f331d20b8c4608008845] net/mlx5e: Preserve shared buffer capacity during headroom updates
> > git bisect good b56fbe428919e8c1a548f331d20b8c4608008845
> > # test job: [445097729a995f87ff7c80d5a161c7e1b5456628] https://lava.sirena.org.uk/scheduler/job/2169640
> > # bad: [445097729a995f87ff7c80d5a161c7e1b5456628] platform/x86: intel: punit_ipc: fix memory corruption
> > git bisect bad 445097729a995f87ff7c80d5a161c7e1b5456628
> > # test job: [ad3b2ce45cce79ddaff01c977d0867d079fa8349] https://lava.sirena.org.uk/scheduler/job/2169710
> > # good: [ad3b2ce45cce79ddaff01c977d0867d079fa8349] kernel.h: Move ARRAY_SIZE() to a separate header
> > git bisect good ad3b2ce45cce79ddaff01c977d0867d079fa8349
> > # test job: [de07228674e9cee27f679ebcf8562f7e3b2cda21] https://lava.sirena.org.uk/scheduler/job/2169731
> > # good: [de07228674e9cee27f679ebcf8562f7e3b2cda21] mptcp: decouple mptcp fastclose from tcp close
> > git bisect good de07228674e9cee27f679ebcf8562f7e3b2cda21
> > # test job: [dca2a95e4ed753ed33da11d7bb78157441d69bad] https://lava.sirena.org.uk/scheduler/job/2169741
> > # good: [dca2a95e4ed753ed33da11d7bb78157441d69bad] pmdomain: samsung: plug potential memleak during probe
> > git bisect good dca2a95e4ed753ed33da11d7bb78157441d69bad
> > # test job: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] https://lava.sirena.org.uk/scheduler/job/2170912
> > # bad: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] mm/memory: do not populate page table entries beyond i_size
> > git bisect bad 61717acddadf660fa6969027bfa0d6fd38f8e3e2
> > # test job: [0de5c14c8e753a547d158530c37efb245f7b40ec] https://lava.sirena.org.uk/scheduler/job/2171171
> > # good: [0de5c14c8e753a547d158530c37efb245f7b40ec] pmdomain: imx: Fix reference count leak in imx_gpc_remove
> > git bisect good 0de5c14c8e753a547d158530c37efb245f7b40ec
> > # test job: [1457e122dd70574a0ca895eea6d6c12ba91312bf] https://lava.sirena.org.uk/scheduler/job/2171268
> > # good: [1457e122dd70574a0ca895eea6d6c12ba91312bf] filemap: cap PTE range to be created to allowed zero fill in folio_map_range()
> > git bisect good 1457e122dd70574a0ca895eea6d6c12ba91312bf
> > # first bad commit: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] mm/memory: do not populate page table entries beyond i_size
> 
> This patch "mm/memory: do not populate page table entries beyond i_size"
> also causes an Oops on RISC-V.
> 
> [    5.940397] Unable to handle kernel paging request at virtual address
> ffffffc6fe000028
> [    5.947616] Oops [#1]
> [    5.949814] Modules linked in:
> [    5.952857] CPU: 0 PID: 147 Comm: exe Not tainted 6.1.158 #2
> [    5.958500] Hardware name: SiFive HiFive Unmatched A00 (DT)
> [    5.964060] epc : _raw_spin_lock+0x12/0x84
> [    5.968141]  ra : filemap_map_pages+0x23e/0x524
> [    5.972658] epc : ffffffff80b4d500 ra : ffffffff801e3d60 sp :
> ffffffd88c923c80
> [    5.979870]  gp : ffffffff81a3f228 tp : ffffffd88c8c1a80 t0 :
> 0000000000000000
> [    5.987078]  t1 : 0000000000000000 t2 : 0000000000000000 s0 :
> ffffffd88c923c90
> [    5.994287]  s1 : 0000000000000000 a0 : ffffffc6fe000028 a1 :
> ffffffc800000000
> [    6.001497]  a2 : 0000000100000000 a3 : 0000000000080000 a4 :
> 0000000000000ff8
> [    6.008706]  a5 : 0000000000010000 a6 : ffffffff813d5858 a7 :
> 0000000000000000
> [    6.015915]  s2 : 0000003f807ff000 s3 : ffffffd88c923d98 s4 :
> 0000000000000000
> [    6.023125]  s5 : ffffffd77fe00ff8 s6 : 0000000000000000 s7 :
> 0000000000000000
> [    6.030333]  s8 : 0000003f80829008 s9 : fffffffffffffffe s10:
> ffffffd880f866f8
> [    6.037543]  s11: ffffffc7020b67c0 t3 : ffffffffffffffff t4 :
> 0000003f807ff000
> [    6.044752]  t5 : 0000000000000000 t6 : 0000000000000000
> [    6.050047] status: 0000000200000120 badaddr: ffffffc6fe000028 cause:
> 000000000000000f
> [    6.057957] [<ffffffff80b4d500>] _raw_spin_lock+0x12/0x84
> [    6.063338] [<ffffffff801e3d60>] filemap_map_pages+0x23e/0x524
> [    6.069157] [<ffffffff80229ffc>] __handle_mm_fault+0xd44/0x1818
> [    6.075064] [<ffffffff8022ab84>] handle_mm_fault+0xb4/0x1b8
> [    6.080622] [<ffffffff8000cd54>] do_page_fault+0x142/0x462
> [    6.086095] [<ffffffff80003f20>] ret_from_exception+0x0/0x16
> [    6.091798] ---[ end trace 0000000000000000 ]---

Thanks all, I'll go drop this now and push out a -rc2 soon.

greg k-h
