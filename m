Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3392EB645;
	Fri, 28 Jun 2024 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719585109; cv=none; b=igBodQ38fYTlxemps/Ane5E3zwakmnfY0YnF7dOnVmEvrxy/4qVZu+BkaLoJdT4dzjjnyjgk2iA8zV03L1T7Aix6p+OLd8V/A8LIWdZ9W9aisNHWE2861gZduwFxA96+8ELHSfaObf4l9iJt/wWpzaVXWajVG6LaBYFkL2rUCVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719585109; c=relaxed/simple;
	bh=Mn07VvKw7mIUWBJQd1Z/D4eKm3Eed4gC7mHD2nA7nZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqk/lJBF/lHJgDQFMcyAzNPBK6P/hPxXxFqY1i0NWUAyZ7Ek4Mgai+1Macp+1pAeFIIGGGylArMsGR8c06LrSowUQCvsZew1UmSKTpHRsCKsza2PM0JetR5KKJkEpHHOPKeIzxVujY6BQhe4hjoi2XSBsJjiDILlfFTEr7GGsVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYw4G9Hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYw4G9Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED4CC116B1;
	Fri, 28 Jun 2024 14:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719585108;
	bh=Mn07VvKw7mIUWBJQd1Z/D4eKm3Eed4gC7mHD2nA7nZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uYw4G9Hc3xl4Vbt5ovsjvHdfoWUMxAGwl/Zzp0n2pPdqpH8YO5F6EWeTv41FRhZ2D
	 5vD7GRu20BwWsvfZBCUuFngSUpRC5lBulPDRO1LoFjE7MQjA6SkqtF0GhCltcp9773
	 tlPPV/G1DC/LOqOYrL508bdEsxVfHV2ljqpz3yyE=
Date: Fri, 28 Jun 2024 16:31:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <kees@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-serial@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
Message-ID: <2024062800-doodle-pelvis-4798@gregkh>
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
 <202406271009.4E90DF8@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202406271009.4E90DF8@keescook>

On Thu, Jun 27, 2024 at 10:14:05AM -0700, Kees Cook wrote:
> On Wed, May 29, 2024 at 02:29:42PM -0700, Nathan Chancellor wrote:
> > Work for __counted_by on generic pointers in structures (not just
> > flexible array members) has started landing in Clang 19 (current tip of
> > tree). During the development of this feature, a restriction was added
> > to __counted_by to prevent the flexible array member's element type from
> > including a flexible array member itself such as:
> > 
> >   struct foo {
> >     int count;
> >     char buf[];
> >   };
> > 
> >   struct bar {
> >     int count;
> >     struct foo data[] __counted_by(count);
> >   };
> > 
> > because the size of data cannot be calculated with the standard array
> > size formula:
> > 
> >   sizeof(struct foo) * count
> > 
> > This restriction was downgraded to a warning but due to CONFIG_WERROR,
> > it can still break the build. The application of __counted_by on the
> > ports member of 'struct mxser_board' triggers this restriction,
> > resulting in:
> > 
> >   drivers/tty/mxser.c:291:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct mxser_port' is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
> >     291 |         struct mxser_port ports[] __counted_by(nports);
> >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >   1 error generated.
> > 
> > Remove this use of __counted_by to fix the warning/error. However,
> > rather than remove it altogether, leave it commented, as it may be
> > possible to support this in future compiler releases.
> > 
> > Cc: stable@vger.kernel.org
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/2026
> > Fixes: f34907ecca71 ("mxser: Annotate struct mxser_board with __counted_by")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Since this fixes a build issue under Clang, can we please land this so
> v6.7 and later will build again? Gustavo is still working on the more
> complete fix (which was already on his radar, so it won't be lost).
> 
> If it's easier/helpful, I can land this via the hardening tree? I was
> the one who sent the bad patch originally. :)
> 

I don't see this in my queue anywhere, sorry, can you resend it?  Or
feel free to take it through your trees, no objection from me there.

thanks,

greg k-h
