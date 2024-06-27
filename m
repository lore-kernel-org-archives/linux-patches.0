Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462619A2A8;
	Thu, 27 Jun 2024 17:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719508446; cv=none; b=UIIrXUe2OLQUoT2oT6dUsEltAUEFQTfjcE8O91HBc5eWmOEUHp5EcpzlPm+Sbdhtfd9gGXgvqPRfLnYBYYgzWHI9FNIvX28HGmU4L2mg76AKyRKSxgMj3Uqs1iO85wgzsQjFy/qw5D6GMB4sp/qngGH30Kw5k/PpqPQCSSll5NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719508446; c=relaxed/simple;
	bh=tNR6ArIGiHkLTpGQkaqhID9T8qBWrrtgctZsjePiA8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ec4NOu1vEK7HIOu30BjmyTMUJJmT+at+IyEv9FEE/5mcm3ajRNiZjCpXeeL8JD+Nnw4yIYoaC+Kb82MTwXJkWKEyPSvd+2+zmobukfLIkQjpo6qpg/HrGMDUCInYXkGFLyWQdbuO1lYCKizgf1C4dStWHhdzTiM13sQ8PuRyaac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtAcu1FG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtAcu1FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DF5C2BD10;
	Thu, 27 Jun 2024 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719508446;
	bh=tNR6ArIGiHkLTpGQkaqhID9T8qBWrrtgctZsjePiA8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RtAcu1FGJ6P2bbf/X4dsur5Hnf5L/FVULlmeohzDRYKuz6ePZ+uKKYm74H3EdgNmo
	 XlWBAZeCr43+0xZjyJrKO78GGKQ785KXaJGxLHBbA+7vLgm8dj5LPhJLEdRfFSeXwr
	 FzJSivkdhNDkiLgaKBQA001ga1cAY/Tp37wpV9noXkqcWyZ4fBhv6RIsjNPqYLiIbx
	 R/u4GNIbrvU1JRSvc2fyK2KxRnnepks0MHIywrbegr/DKmu06qiHTZnd/A5lsnwNny
	 j6JSGuPX7j0jJww7j2jrCZvvQKOucgU4nDRiE3PYJCL0T8PFOfIc4lDIGr76Iam4Dn
	 AvxHsaRMYypIw==
Date: Thu, 27 Jun 2024 10:14:05 -0700
From: Kees Cook <kees@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-serial@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
Message-ID: <202406271009.4E90DF8@keescook>
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>

On Wed, May 29, 2024 at 02:29:42PM -0700, Nathan Chancellor wrote:
> Work for __counted_by on generic pointers in structures (not just
> flexible array members) has started landing in Clang 19 (current tip of
> tree). During the development of this feature, a restriction was added
> to __counted_by to prevent the flexible array member's element type from
> including a flexible array member itself such as:
> 
>   struct foo {
>     int count;
>     char buf[];
>   };
> 
>   struct bar {
>     int count;
>     struct foo data[] __counted_by(count);
>   };
> 
> because the size of data cannot be calculated with the standard array
> size formula:
> 
>   sizeof(struct foo) * count
> 
> This restriction was downgraded to a warning but due to CONFIG_WERROR,
> it can still break the build. The application of __counted_by on the
> ports member of 'struct mxser_board' triggers this restriction,
> resulting in:
> 
>   drivers/tty/mxser.c:291:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct mxser_port' is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
>     291 |         struct mxser_port ports[] __counted_by(nports);
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> Remove this use of __counted_by to fix the warning/error. However,
> rather than remove it altogether, leave it commented, as it may be
> possible to support this in future compiler releases.
> 
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2026
> Fixes: f34907ecca71 ("mxser: Annotate struct mxser_board with __counted_by")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Since this fixes a build issue under Clang, can we please land this so
v6.7 and later will build again? Gustavo is still working on the more
complete fix (which was already on his radar, so it won't be lost).

If it's easier/helpful, I can land this via the hardening tree? I was
the one who sent the bad patch originally. :)

Thanks!

-Kees

-- 
Kees Cook
