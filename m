Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3961BDCD;
	Sat, 13 Apr 2024 05:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712986388; cv=none; b=Dr7SYkxBY7CiPQfqNOQlmiHSe+7Gu6Wm2zSKpK4jbmNLPMMd9Au8GYT2g6hbEtFKtUVQJxN+Y2Ylywd2D80vEMR8g2Li31HVQ7jC4pa6NjWD6IG2a7x2QGhvxSFB+f/CoJzIBkvi9nEdyIbTM2+wYXFsaKjbJYyQ2QTg4d2Dne4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712986388; c=relaxed/simple;
	bh=0Fo4DOGbiEVoyUC14vYeQXNWKxP76fZ2K3xNhDzb6ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJT4O+XKHp+y4khmSw9pFkxCxqEAaQpMroZSVtL1bVOl+lPnW76zm1flolrplX9pTxaoTz/FRKCqq3e4y4uBi1CHY1IOHl3VYTaeMKvZI3I+rCMD1NZmeNHSkqI4SRG6GWaZ6O6mBQC+e6g1jcXHZGbYierC2JLiEoxWF5wW9C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pl8y/Jtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pl8y/Jtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4ECC113CD;
	Sat, 13 Apr 2024 05:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712986387;
	bh=0Fo4DOGbiEVoyUC14vYeQXNWKxP76fZ2K3xNhDzb6ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pl8y/Jtwwp8Zs3VmxnkiETlT3ehrfUCySiI94Chkbo+hHhYrTIa9ZTnUG8XmqC0gu
	 MTP+eHzW9dpIIVsXkdpLGSvlpVTazFIIA1aRin10BEW9REI8uiPb1bi8XrgwXcotHr
	 JAdkOkspVW7ttfM/WwkF1Oiw99Bgr+iIavRt9Ruo=
Date: Sat, 13 Apr 2024 07:33:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Pascal Ernster <git@hardfalcon.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
Message-ID: <2024041333-perpetual-garnish-8da0@gregkh>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net>
 <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <2024041024-boney-sputter-6b71@gregkh>
 <CAMj1kXHjwJnfjVgm=cOaJtJ=mF-mTLaoDM0wQyvvjL3ps9JEog@mail.gmail.com>
 <2024041047-upright-smudgy-c380@gregkh>
 <DB55FDF8-3405-4678-8BC1-2226950BC246@cloudflare.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB55FDF8-3405-4678-8BC1-2226950BC246@cloudflare.com>

On Fri, Apr 12, 2024 at 10:32:15PM +0100, Ignat Korchagin wrote:
> 
> > On 10 Apr 2024, at 15:11, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > On Wed, Apr 10, 2024 at 08:43:24AM +0200, Ard Biesheuvel wrote:
> >> On Wed, 10 Apr 2024 at 07:46, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >>> 
> >>> On Wed, Apr 10, 2024 at 07:34:33AM +0200, Borislav Petkov wrote:
> >>>> On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
> >>>>> Just to make sure this doesn't get lost: This patch causes the kernel to not
> >>>>> boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
> >>>>> machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> >>>> 
> >>>> I see your .config there. How are you booting the VMs? qemu cmdline?
> >>>> 
> >>>> Ard, anything missing in the backport?
> >>>> 
> >>>> I'm busy and won't be able to look in the next couple of days...
> >>> 
> >>> As reverting seems to resolve this, I'll go do that after my morning
> >>> coffee kicks in...
> >> 
> >> Fair enough. I'll look into this today, but I guess you're on a tight
> >> schedule with this release.
> >> 
> >> Please drop the subsequent patch as well:
> >> 
> >> x86/efistub: Remap kernel text read-only before dropping NX attribute
> >> 
> >> as it assumes that all code reachable from the startup entrypoint is
> >> in .head.text and this will no longer be the case.
> > 
> > Given this is the only report, and it seems to be with an "odd" linker,
> > I'll leave it in for now to keep in sync with 6.9-rc.  If this is a
> > problem, we can revert the commits in a later release at any time.
> 
> We encountered this issue in our production machines and reproduced on a simple QEMU in standard Debian Bookworm
> 
> Steps:
> 1. Download source
> 2. $ make defconfig
> 3. Enable CONFIG_AMD_MEM_ENCRYPT and CONFIG_GCC_PLUGIN_STACKLEAK through make menuconfig
> 4. Compile
> 5. $ qemu-system-x86_64 -smp 2 -m 1G -enable-kvm -cpu host -kernel arch/x86/boot/bzImage -nographic -append "console=ttyS0”
> 
> You will notice that the VM will go into reboot loop (same happens in our bare metal production servers). Do note that you would need a compiler with CONFIG_GCC_PLUGIN_STACKLEAK support (not the standard Debian one - unless I don’t know how to install GCC plugins)

Thanks for th ereport, we have a fix for this in the latest -rc testing
kernel out for review and will be in the next release in a day or so.

thanks,

greg k-h
