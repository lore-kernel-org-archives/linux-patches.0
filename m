Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681788F6D;
	Sun, 29 Sep 2024 21:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727644248; cv=none; b=SJSSpyUKlUy3QYvF6mzNmYyXyk/eWWJJE/06gQVuKEyLNKF34RNoOdKbspbmyX468ze4TyNtwI2tRE5lwLSxLfejRMW/1M9BqlJEVxgp7f372HtnbcH32U8bG8nLafuyvMQ1EIGVbyHDdwYoh6DZ+gxLywqaJZF3D+d7iIf/veg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727644248; c=relaxed/simple;
	bh=wMsGjuR25mp/aKLm5jdecrsXtweYnx1xsGjy980bAAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGaYsodOr8oYGRcVrEQeKDakLvk2oVVIJtLBu1WDevQZiMTzLTY/NPqL1h5NzoO5hzol6Lxf5V9XgsNstGUG+VcbgQ4i3E3kPIUIbUDPkPpXIpSDY/wDfIxZBqYj9RHDD0tS8npUGaojfGktitE2I5eA0mYXn3Dcuu6d6fUdVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ailfhA+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ailfhA+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7716AC4CEC5;
	Sun, 29 Sep 2024 21:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727644247;
	bh=wMsGjuR25mp/aKLm5jdecrsXtweYnx1xsGjy980bAAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ailfhA+nrSea6SElDG0U/Cc1y+oPS+KYgI+z5SL2gEArxGC5LYugpzbRJJatos/9Z
	 S/i0zrIfP+kphjMaWAPypt+P2VwT11EqYV0l4iANf1gioqO55SKUBfSD3hCvjhjE9o
	 tDQkJqa28yMR47oW74Sk+gnh6mDUKkBJwwD60DbpWCbnZMQT8522dL15l/tev4KYnc
	 wcI6/of5M1WrUVWEA1oMrpd96WHHlaHKbGRPJ6rlaBVZl3RvXwEEPYfG9a2eq2A3c2
	 7vRPYtY883MHedfVVovhDSvwxWm6LJxXtEApVM9hvE1mjjHcol+WslyETsRNIuj51n
	 O9laykBPzogXQ==
Date: Sun, 29 Sep 2024 14:10:45 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] hardening: Adjust dependencies in selection of
 MODVERSIONS
Message-ID: <20240929211045.GA2111654@thelio-3990X>
References: <20240928-fix-randstruct-modversions-kconfig-warning-v1-1-27d3edc8571e@kernel.org>
 <CAHk-=wgdQ5TjbXX0D568GZebYnt5ZuhTW5-ffeim-aoyT9LnbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgdQ5TjbXX0D568GZebYnt5ZuhTW5-ffeim-aoyT9LnbA@mail.gmail.com>

On Sun, Sep 29, 2024 at 08:35:44AM -0700, Linus Torvalds wrote:
> On Sat, 28 Sept 2024 at 11:13, Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > MODVERSIONS recently grew a dependency on !COMPILE_TEST so that Rust
> > could be more easily tested. However, this introduces a Kconfig warning
> > when building allmodconfig with a clang version that supports RANDSTRUCT
> > natively because RANDSTRUCT_FULL and RANDSTRUCT_PERFORMANCE select
> > MODVERSIONS when MODULES is enabled, bypassing the !COMPILE_TEST
> > dependency:
> 
> Argh. I should have checked, but I didn't think anybody would 'select'
> MODVERSIONS.
> 
> That's such an odd thing to do in general, but I guess for RANDSTRUCT
> it actually makes sense (since a plain version check is nonsensical).
> 
> Now that 'select' statement is truly crazy and another level of odd
> duck, but I guess it still makes perfect sense ("give me the build
> coverage, but this is never going to be run, so don't bother with
> MODVERSIONS").

Yeah, I came to the same conclusion on both fronts (perhaps I should
have actually put that in the patch description).

> So Ack on the patch. And now I did check that there doesn't seem to be
> anything else with odd MODVERSIONS Kconfig rules.

Thanks, it looks like you'll get this via Kees soon.

Cheers,
Nathan
