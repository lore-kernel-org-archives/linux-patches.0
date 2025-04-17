Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B12512EE;
	Thu, 17 Apr 2025 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744899385; cv=none; b=Kj9E7z2uQtEHhpDbOtWR9o2jc+qZXtXm4FuvOz01w69MggpKzbdA7rb3vTeNAwtSDPXZlC1qkquePONWGS2UJgIt+7ZuabjKM3uqG2NZquGIxK2geP32qD+qTt2381pYvfvWNktZ2MT5cSKsyFC9RWtE5JhletjjFpsc2MkMSwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744899385; c=relaxed/simple;
	bh=R33j6OK7a2RpqS6JYnEkK/3Da6JWsAHn975GfgwiU7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e68ERHljMY8nx0RiHSovLwR5U2lCSFIZJLODRvUrpJ1egcidptzHoOqAzPUfsslfK3+Ul0d8mteAYhC5atYMdsyVCjmrR2tqvTzU5N07APdn/JHJmrrD39QtNJk5yuizgPONFJPF46Qy3oZ5UrcBnutvU2O8yzShDtREC8vhggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRiGRkfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRiGRkfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BEFC4CEEA;
	Thu, 17 Apr 2025 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744899385;
	bh=R33j6OK7a2RpqS6JYnEkK/3Da6JWsAHn975GfgwiU7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cRiGRkfDh9Ei+yQvg/3DuHwDc+9ZyMQX/3jALk/g8L2nrGDiNoNsOPm+SxisddNMV
	 XMu93JFdmw/weV52gztpZQ8Q43tb6TFjEJnQ6C+D3demHQzsFqJ87/++N0zEM2+b2l
	 7IAzBLvy8nPeuDyHLTwSeYekPVCMv0h9Fp9xxUvs=
Date: Thu, 17 Apr 2025 16:16:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Vishal Annapurve <vannapurve@google.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Ingo Molnar <mingo@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ryan Afranji <afranji@google.com>,
	Andy Lutomirski <luto@kernel.org>, Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Marcus Seyfarth <m.seyfarth@gmail.com>
Subject: Re: [PATCH 6.13 444/499] x86/tdx: Fix arch_safe_halt() execution for
 TDX VMs
Message-ID: <2025041717-italicize-trickily-5a74@gregkh>
References: <20250408104851.256868745@linuxfoundation.org>
 <20250408104902.301772019@linuxfoundation.org>
 <CAGtprH_Sm7ycECq_p+Qz3tMK0y10qenJ=DFiw-kKNn3d9YwPaQ@mail.gmail.com>
 <2025040829-surgical-saddlebag-56fa@gregkh>
 <20250410180423.GA3430900@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410180423.GA3430900@ax162>

On Thu, Apr 10, 2025 at 11:04:23AM -0700, Nathan Chancellor wrote:
> Hi Greg,
> 
> On Tue, Apr 08, 2025 at 05:15:46PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Apr 08, 2025 at 05:55:57AM -0700, Vishal Annapurve wrote:
> > > Hi Greg,
> > > 
> > > This patch depends on commit 22cc5ca5de52 ("x86/paravirt: Move halt
> > > paravirt calls under CONFIG_PARAVIRT"). I will respond to the other
> > > thread with a patch for commit 22cc5ca5de52 after resolving conflicts.
> > 
> > That commit is already in this series, do I need to add it again? :)
> 
> Is it? I don't see it in the stable review on lore and it does not look
> like it made it into 6.13.11 final because the build errors if
> CONFIG_PARAVIRT_XXL is disabled (for example, allmodconfig with
> CONFIG_XEN_PV disabled):
> 
>   arch/x86/coco/tdx/tdx.c: In function 'tdx_early_init':
>   arch/x86/coco/tdx/tdx.c:1107:19: error: 'struct pv_irq_ops' has no member named 'safe_halt'
>    1107 |         pv_ops.irq.safe_halt = tdx_safe_halt;
>         |                   ^
>   arch/x86/coco/tdx/tdx.c:1108:19: error: 'struct pv_irq_ops' has no member named 'halt'
>    1108 |         pv_ops.irq.halt = tdx_halt;
>         |                   ^
> 
> This was initially reported downstream by Marcus:
> https://github.com/ClangBuiltLinux/linux/issues/2081

Now queued up, thanks.

greg k-h
