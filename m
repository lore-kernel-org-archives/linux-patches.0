Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC574503B;
	Thu, 10 Apr 2025 18:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744308271; cv=none; b=X8RXnJSuBnAAn29cR8yYhg6RlKuhbSZzWnFeYcOz6WIYThz2YsD1Vpsj5ENgtRan+xGjgMYeB7YqbEmvvpugqfm69Fo6YMXYJPO2u3cPJZufdO3b1ArRrSQk44HiNNvaiuzSeDjE5aehaSZb5n7w9L8C4RbyklCoAdBUt0QUhxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744308271; c=relaxed/simple;
	bh=mDoRJUXtXcDIMeXCPrjyuLAtzIe9Q1iE36bto3cBH7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdBFU5s+9ToM8tfranwz6ccRVy0Cj3e+e1imIanPfG5y9P5a5LBiaQfrULcVnfWqnI5kLqO/BwpPtMguQAd3vJriMhEEV2zSFwtgCfNi9fcpaDkARAo3+TtBgHC17iJHcyonl/+jZs82juKDXkPkusMa7/0/EWvK0u5ZPSsAWlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMSECXgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMSECXgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CF5C4CEDD;
	Thu, 10 Apr 2025 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744308269;
	bh=mDoRJUXtXcDIMeXCPrjyuLAtzIe9Q1iE36bto3cBH7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SMSECXgxpkOms/huatTuWIzSj0ooL1n2vPYZ6yt9J9dQDN4Mw8lihibRl9I1FOXje
	 hZtmzQPW9NBEnVQ6edUTFPENbZTBIlYapNewRMZq17MiTDTbAMc8ZIFznGYJbquZLL
	 ZZxUMo66ahDO7cjJtu9kBkg74BaDXLEsROfzdvRAv4pvpgFTNF5QHBhW8s8Xng1GWV
	 RYHQ03s1CiHREnsMrWe7SPJi6IGI9rBjhX9FT4qEca6TmM0G9epGWUmf4mbQbEm+yv
	 QUUvKLH4oTK3dW0SjFQKI6OloX+QysFFHdl1mA9ZRc2xifPmAcmFlZ32M/ccHOdOAU
	 wfX+Qnm8oIyjg==
Date: Thu, 10 Apr 2025 11:04:23 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <20250410180423.GA3430900@ax162>
References: <20250408104851.256868745@linuxfoundation.org>
 <20250408104902.301772019@linuxfoundation.org>
 <CAGtprH_Sm7ycECq_p+Qz3tMK0y10qenJ=DFiw-kKNn3d9YwPaQ@mail.gmail.com>
 <2025040829-surgical-saddlebag-56fa@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025040829-surgical-saddlebag-56fa@gregkh>

Hi Greg,

On Tue, Apr 08, 2025 at 05:15:46PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 08, 2025 at 05:55:57AM -0700, Vishal Annapurve wrote:
> > Hi Greg,
> > 
> > This patch depends on commit 22cc5ca5de52 ("x86/paravirt: Move halt
> > paravirt calls under CONFIG_PARAVIRT"). I will respond to the other
> > thread with a patch for commit 22cc5ca5de52 after resolving conflicts.
> 
> That commit is already in this series, do I need to add it again? :)

Is it? I don't see it in the stable review on lore and it does not look
like it made it into 6.13.11 final because the build errors if
CONFIG_PARAVIRT_XXL is disabled (for example, allmodconfig with
CONFIG_XEN_PV disabled):

  arch/x86/coco/tdx/tdx.c: In function 'tdx_early_init':
  arch/x86/coco/tdx/tdx.c:1107:19: error: 'struct pv_irq_ops' has no member named 'safe_halt'
   1107 |         pv_ops.irq.safe_halt = tdx_safe_halt;
        |                   ^
  arch/x86/coco/tdx/tdx.c:1108:19: error: 'struct pv_irq_ops' has no member named 'halt'
   1108 |         pv_ops.irq.halt = tdx_halt;
        |                   ^

This was initially reported downstream by Marcus:
https://github.com/ClangBuiltLinux/linux/issues/2081

Cheers,
Nathan
