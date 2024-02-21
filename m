Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3C880C08;
	Wed, 21 Feb 2024 16:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708534112; cv=none; b=pFAclY9PIJsD6PnrrxDRSLi/ZuVEdMdW4B3DP3bE1xx2XrbcAtD6IWXL4aamZ5im8IwGSYjxctXbfpUD15bzZ4unLfcrNsOfEJ4g8sKdqpk5zZRnM8rZa/gzOqaJMClFkKBfUiAf3fT6DxVsmFQJUORXX9c9qd6KSfKQhh/pQR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708534112; c=relaxed/simple;
	bh=E3KFvMLZM93hfbHg2L3W2NrtXBqubV8WcxzfaBbEJuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTJE3x1Y+kOZTzkfQne3njyB7yO0ApXncrzJmARLCsB+GRL8ICE/Z8GYHfwDGRLGGsoft7hFdextmfHERLKfE+QWs1AZi2EYUeQAgB5spc0Y7+EJh2sC4IJaUSV9rwitQI9hX3hcTlsBPKYarcfSWCwJMNHjBTNwTG8kHYhNMOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YU3BH+bQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YU3BH+bQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3331C433F1;
	Wed, 21 Feb 2024 16:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708534111;
	bh=E3KFvMLZM93hfbHg2L3W2NrtXBqubV8WcxzfaBbEJuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YU3BH+bQkI2cnrxR6M6veZQTZ+hzlxf+xyrqHnd3VSEWXiyFtgBkSgGQQI1emz+Uq
	 sOwcM4OhvpheEFmIiAy/YCfEA8Ov0nN7YWeZq2B6IACDynKSPVXDXMhoc21R0i//ZN
	 w+MgDa+iELYFGeiunBZaMAVZS2vBj495IfvhkjxKMwAz8ic/ozsZIO/HaYGGgnoweb
	 v411IOFRrKhlc2xH9x3wSYUbpJJhLxD0gjYyaAqXWYy/Oz/+y9/F+0CE8bAclGzrBs
	 ymDH8wXUa9UzAyUJUbkbYWYokFo/qHf3pWPKSdLjHlYZWKtUyPzRWsKRbB58WzQpVm
	 CxgLrCfne1kNA==
Date: Wed, 21 Feb 2024 09:48:29 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, morbo@google.com, justinstitt@google.com,
	linux-s390@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] s390/boot: Workaround current 'llvm-objdump -t -j ...'
 behavior
Message-ID: <20240221164829.GB1782141@dev-arch.thelio-3990X>
References: <20240220-s390-work-around-llvm-objdump-t-j-v1-1-47bb0366a831@kernel.org>
 <20240221091612.7561-A-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221091612.7561-A-hca@linux.ibm.com>

Hi Heiko,

On Wed, Feb 21, 2024 at 10:16:12AM +0100, Heiko Carstens wrote:
> On Tue, Feb 20, 2024 at 01:44:48PM -0700, Nathan Chancellor wrote:
> > When building with OBJDUMP=llvm-objdump, there are a series of warnings
> > from the section comparisons that arch/s390/boot/Makefile performs
> > between vmlinux and arch/s390/boot/vmlinux:
> ...
> > It may be possible to change llvm-objdump's behavior to match GNU
> > objdump's behavior but the difficulty of that task has not yet been
> > explored. The combination of '$(OBJDUMP) -t -j' is not common in the
> > kernel tree on a whole, so workaround this tool difference by grepping
> > for the sections in the full symbol table output in a similar manner to
> > the sed invocation. This results in no visible change for GNU objdump
> > users while fixing the warnings for OBJDUMP=llvm-objdump, further
> > enabling use of LLVM=1 for ARCH=s390 with versions of LLVM that have
> > support for s390 in ld.lld and llvm-objcopy.
> > 
> > Reported-by: Heiko Carstens <hca@linux.ibm.com>
> > Closes: https://lore.kernel.org/20240219113248.16287-C-hca@linux.ibm.com/
> > Link: https://github.com/ClangBuiltLinux/linux/issues/859
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > s390 llvm-objcopy support may be backported to LLVM 18.1.0 in time for
> > the final release.
> > 
> > https://github.com/llvm/llvm-project/pull/82324
> > 
> > s390 ld.lld has already made it into release/18.x:
> > 
> > https://github.com/llvm/llvm-project/commit/0a44c3792a6ff799df5f100670d7e19d1bc49f03
> > 
> > If the objcopy change makes 18.1.0 final, features + this change should
> > build cleanly with LLVM 18.1.0+ using LLVM=1 :)
> > ---
> >  arch/s390/boot/Makefile | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> This seems to work like expected (also verified with a couple of scenarios
> where things are supposed to break).
> 
> So compiling the kernel with LLVM=1 finally works on s390!
> 
> Patch applied - Thanks a lot!

Thanks a lot for testing and applying this quickly! Small update on the
LLVM side, the llvm-objcopy change made it into 18.1.0-rc3:

https://github.com/llvm/llvm-project/commit/5ef297ab611822537a385d45244867519563d3ef
https://github.com/llvm/llvm-project/commits/llvmorg-18.1.0-rc3

So it's pretty much official, 'ARCH=s390 LLVM=1' should build without
any issues with Linux 6.9+ and LLVM 18.1.0+ :)

Cheers,
Nathan
