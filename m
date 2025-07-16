Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0126F264F99;
	Wed, 16 Jul 2025 05:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752643495; cv=none; b=ak4YyBT5Wv9yFQvP/XYJ2E2y+EK+e0Jui/+VFSEGq5nFfmP9pWBdYENNgSBhWVkQEh9ceI249K8Xmx8RRThVvI6NjFwsgUBRpnkp0T9XlsljNMP2gCXfV7g1jLkJZhEWNf6mLQHTHl98WQ+/ZN9HcXVRhwazyKhQSmJUibiJVCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752643495; c=relaxed/simple;
	bh=NTc0dXa+1iv/hfoLA998fSRkxZiw3F2b1EA1EIKmOm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Af/8HMczcOaRee6E8lZJPiUCmjH7pcoLwpPPI9pjCm+aHaneemYnur6ZHGukBrYImEbE23KVcOonhrWAj4VrCkilgzM6mGmKTu/LYYWxv3442RQedE678lcms8CIPMAg+jlm3N6riKMXwDhc/mZqcjSF9wFjqLZ6BUUUR4HB31U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7arrX9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7arrX9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F4BC4CEF0;
	Wed, 16 Jul 2025 05:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752643494;
	bh=NTc0dXa+1iv/hfoLA998fSRkxZiw3F2b1EA1EIKmOm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C7arrX9vLDxpFqsweVgoKYk9ktWCFkxn1Gvs/3jX2RQG+2o/KvOtAeIYS8zvQtP3x
	 lAOj7WL6TOoaZko7OEEwCPmH99FH+o6ND5C7sFjozkITxb1h+NT2UexqRW7rcEr2Vb
	 lzGPpRTL/faZZjG0CGA0fGysaQFLVbKmpZRkKXB4Wi7n/X6Se9KhHA+nQYna6RF16d
	 WfPztJIpphKgZ9kFKjs2Beoahg/DvZ8L/aL+H2G0DqoDkHjvfasph+GGJinRS2hiUB
	 wFsOzWY4W6TXa8GOJRyvjTLDyx60Ulxq+DjuMqr6KNvljo8sAxB5gRAujKgPTdwWD8
	 AD6+kvTdZmZfw==
Date: Tue, 15 Jul 2025 22:24:50 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] usb: atm: cxacru: Zero initialize bp in
 cxacru_heavy_init()
Message-ID: <20250716052450.GA1892301@ax162>
References: <20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org>
 <2025071618-jester-outing-7fed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025071618-jester-outing-7fed@gregkh>

On Wed, Jul 16, 2025 at 07:06:50AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jul 15, 2025 at 01:33:32PM -0700, Nathan Chancellor wrote:
> > After a recent change in clang to expose uninitialized warnings from
> > const variables [1], there is a warning in cxacru_heavy_init():
> > 
> >   drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >    1104 |         if (instance->modem_type->boot_rom_patch) {
> >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   drivers/usb/atm/cxacru.c:1113:39: note: uninitialized use occurs here
> >    1113 |         cxacru_upload_firmware(instance, fw, bp);
> >         |                                              ^~
> >   drivers/usb/atm/cxacru.c:1104:2: note: remove the 'if' if its condition is always true
> >    1104 |         if (instance->modem_type->boot_rom_patch) {
> >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   drivers/usb/atm/cxacru.c:1095:32: note: initialize the variable 'bp' to silence this warning
> >    1095 |         const struct firmware *fw, *bp;
> >         |                                       ^
> >         |                                        = NULL
> > 
> > This warning occurs in clang's frontend before inlining occurs, so it
> > cannot notice that bp is only used within cxacru_upload_firmware() under
> > the same condition that initializes it in cxacru_heavy_init(). Just
> > initialize bp to NULL to silence the warning without functionally
> > changing the code, which is what happens with modern compilers when they
> > support '-ftrivial-auto-var-init=zero' (CONFIG_INIT_STACK_ALL_ZERO=y).
> 
> We generally do not want to paper over compiler bugs, when our code is
> correct, so why should we do that here?  Why not fix clang instead?

I would not really call this a compiler bug. It IS passed uninitialized
to this function and while the uninitialized value is not actually used,
clang has no way of knowing that at this point in its pipeline, so I
don't think warning in this case is unreasonable. This type of warning
is off for GCC because of how unreliable it was when it is done in the
middle end with optimizations. Furthermore, it is my understanding based
on [1] that just the passing of an uninitialized variable in this manner
is UB.

[1]: https://lore.kernel.org/20220614214039.GA25951@gate.crashing.org/

Cheers,
Nathan
