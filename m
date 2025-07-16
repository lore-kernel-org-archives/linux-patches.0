Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5389A1C3C1F;
	Wed, 16 Jul 2025 05:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752642415; cv=none; b=aCkZaOsFhmG+pcefa89hjD6iTaXeiAawNjH9ZG9d5eAG70pFHS6qul9gei4HFIpgR0JT3pVdbMhdncywbG0l1riGewi7YivJt26bmx78iRw6tu/EXgVk2KI2fE6tETjvLY4Z33TScARcP1n95FPO+pKqbhxJ57MQ92RnEbGiEqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752642415; c=relaxed/simple;
	bh=Ea4L8w4MaFN+VhyUzWP/6yVlPGnAInuffksIbykGIDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAO19dWsKPu5NNpRB5oYWjNzH5ABmN+GlnpneH35VwaYifsw1pDb3oMKDtSwGuWrCQpdMl8UjcgdzhsT5UnZAkSyXMX3s15yZNC3FZdIjDzJwMkKuwr8JOSeCbHCnPAKYgFmpC6SR4eu9RMCDPvHK8zFdagIXL9/KG89BIT2ifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3hqsNTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3hqsNTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C4CC4CEF0;
	Wed, 16 Jul 2025 05:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752642414;
	bh=Ea4L8w4MaFN+VhyUzWP/6yVlPGnAInuffksIbykGIDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3hqsNTATelcoA/OgL6YuTFrudWBTmaiw+rsocPLPK+TWSB2JFiRLE0NpaSPoIk1D
	 ShZO4Qc14RieIN3LT65ctqLYdZqSoG/+mgj9h16w4y+q7/7PfpWK3CPxRbIByI/xco
	 unO2QcWKc6tjGQYJ21/KPkqU2VzCCfP4kw5O2kzA=
Date: Wed, 16 Jul 2025 07:06:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] usb: atm: cxacru: Zero initialize bp in
 cxacru_heavy_init()
Message-ID: <2025071618-jester-outing-7fed@gregkh>
References: <20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org>

On Tue, Jul 15, 2025 at 01:33:32PM -0700, Nathan Chancellor wrote:
> After a recent change in clang to expose uninitialized warnings from
> const variables [1], there is a warning in cxacru_heavy_init():
> 
>   drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>    1104 |         if (instance->modem_type->boot_rom_patch) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/usb/atm/cxacru.c:1113:39: note: uninitialized use occurs here
>    1113 |         cxacru_upload_firmware(instance, fw, bp);
>         |                                              ^~
>   drivers/usb/atm/cxacru.c:1104:2: note: remove the 'if' if its condition is always true
>    1104 |         if (instance->modem_type->boot_rom_patch) {
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/usb/atm/cxacru.c:1095:32: note: initialize the variable 'bp' to silence this warning
>    1095 |         const struct firmware *fw, *bp;
>         |                                       ^
>         |                                        = NULL
> 
> This warning occurs in clang's frontend before inlining occurs, so it
> cannot notice that bp is only used within cxacru_upload_firmware() under
> the same condition that initializes it in cxacru_heavy_init(). Just
> initialize bp to NULL to silence the warning without functionally
> changing the code, which is what happens with modern compilers when they
> support '-ftrivial-auto-var-init=zero' (CONFIG_INIT_STACK_ALL_ZERO=y).

We generally do not want to paper over compiler bugs, when our code is
correct, so why should we do that here?  Why not fix clang instead?

thanks,

greg k-h
