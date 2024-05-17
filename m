Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6736812DD9F;
	Fri, 17 May 2024 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715959116; cv=none; b=IiMsWGixv55Y1/yKRyXACI9EmxPNVNmMhT/a6OaTFRK961EmBRHDeGzlHbYHtgjNqgHgfmVb727jYLoiF9Ex+8G1nkEDjaQnzfYVjkNjCskvXBhAhVlZhYeOCIGdvuo1PNUiAsZ48kZeGIX1ZYW4IcVzS2cKPhDAfcK5WJXsI1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715959116; c=relaxed/simple;
	bh=UoxzRiDZ+O5N/jgmjQRwGygnUVsa2VMjATeBWNTgTzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKq9lowx+g9uLAA3VLjb/SeNNw5Q01lB6iiDOS3SbZnHhqSlHpGQ9Uc2YW5cFWaGWMvSRjdZGurxJorw91KDnWZePoaR9GE8luCYzHIZch0QjBGqZkvaFwD/lYp4TotRw2iAhosTJOgsszflh9hX2sPiCqwvN/FCO4s5rlDsztg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUp1JG1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUp1JG1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3890AC2BD10;
	Fri, 17 May 2024 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715959115;
	bh=UoxzRiDZ+O5N/jgmjQRwGygnUVsa2VMjATeBWNTgTzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mUp1JG1xjhlBGV5rWRPDwtlRWArHUCcp6+UL669IQBFyXAohqu2zRvQ7S3yM4pi6O
	 BXr5RCG18AGMN28M9xDJTgQ+SBrbNUbhEZJXEuZiAK/9H6rPRC4xDLv7OWPpyD0ESC
	 B9Vq08mIQU/S0YbYmkE+dplgrTD9pt9UaeykKLamyhSrp+RZ/hhEZEYYLYTJ2eSyew
	 U8wgOq0VEe87HFPDW7m/BJ29Rtd35K5HdNmodHDcDvWLJ/P+51Iw8BrZbsB24UKEUy
	 EVQCyx/NtHR08QOeeRh8qiGYa2oXNLH0Dt8Q2pVujHYSHr64o3i8dh0IyS1OVUDzPq
	 clJtycJRMGyHw==
Date: Fri, 17 May 2024 08:18:33 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86/boot: Address clang -Wimplicit-fallthrough in
 vsprintf()
Message-ID: <20240517151833.GB3660288@thelio-3990X>
References: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
 <20240517095110.GAZkcojmJQoY_zU-OT@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240517095110.GAZkcojmJQoY_zU-OT@fat_crate.local>

On Fri, May 17, 2024 at 11:51:10AM +0200, Borislav Petkov wrote:
> On Thu, May 16, 2024 at 07:03:41AM -0700, Nathan Chancellor wrote:
> > After enabling -Wimplicit-fallthrough for the x86 boot code, clang
> > warns:
> > 
> >   arch/x86/boot/printf.c:257:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> >     257 |                 case 'u':
> >         |                 ^
> > 
> > Clang is a little more pedantic than GCC, which does not warn when
> > falling through to a case that is just break or return.
> 
> Is anyone fixing Clang?
> 
> :-P

There was a patch to make Clang match GCC's behavior a few years ago but
I think Kees made a good argument that GCC's behavior leaves potential
bugs on the table, so that was not pursued further.

https://reviews.llvm.org/D91895#2417170

It was brought up to GCC as well but they did not want to change their
behavior:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91432

Cheers,
Nathan
