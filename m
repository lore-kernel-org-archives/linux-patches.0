Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E050628D8CD;
	Wed, 16 Jul 2025 08:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752652813; cv=none; b=PYM+TFhMmXrATlDX9LQLO8AA1F7ukZIb1XFdVr1FUBCk2IC6l5ftPNg0Tm+UKqzpHw0jJTmm2NyepR+Y7BGRN9sf0B4ZP3O+o/1IpYm4zoN1C4ZhaPC9i6DhqIY6v6/QthXlMg/PU5GIuHYjpfHpN868vbxxzc4e2yiuPh1roOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752652813; c=relaxed/simple;
	bh=8ezUyebd/+zk1M3qi3OCn5hHE2PAlIsXeL4mPMikVcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3c26XL4QZJjpAqXSKP3p9VK8CH6+tkgtdxdzlsvZpdpAzWQxPlI7RE25MJegDN9HAkbSdK5w8kV+StKCbqDBNaSeoQ2nVjNwjwHBf3ldjEaPkn/7KkdT7wstRFluOGdBQ1rtzAKFOWQYAcdML0wq8ecxSVbK61jE1D9A2NZTGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNiKB5aT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNiKB5aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1996FC4CEF0;
	Wed, 16 Jul 2025 08:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752652812;
	bh=8ezUyebd/+zk1M3qi3OCn5hHE2PAlIsXeL4mPMikVcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WNiKB5aTgXzKdw+PMKZx1ARZ3GAbmFhcS5FaAxL/Z06vrDiQ+qS+RQ3Y1BFq43gNe
	 4KedC8w12Kk/qoZmcnB3yUqCOgR8rRz4GG9ZkU9hvBUZd/NTzm1EZLSRGzVhqc19I1
	 eujLaQCZizKkEi/h/0UTApnet6WALWb9FwmNVDgk=
Date: Wed, 16 Jul 2025 10:00:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] usb: atm: cxacru: Zero initialize bp in
 cxacru_heavy_init()
Message-ID: <2025071616-flap-mundane-7627@gregkh>
References: <20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org>
 <2025071618-jester-outing-7fed@gregkh>
 <20250716052450.GA1892301@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716052450.GA1892301@ax162>

On Tue, Jul 15, 2025 at 10:24:50PM -0700, Nathan Chancellor wrote:
> On Wed, Jul 16, 2025 at 07:06:50AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jul 15, 2025 at 01:33:32PM -0700, Nathan Chancellor wrote:
> > > After a recent change in clang to expose uninitialized warnings from
> > > const variables [1], there is a warning in cxacru_heavy_init():
> > > 
> > >   drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> > >    1104 |         if (instance->modem_type->boot_rom_patch) {
> > >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   drivers/usb/atm/cxacru.c:1113:39: note: uninitialized use occurs here
> > >    1113 |         cxacru_upload_firmware(instance, fw, bp);
> > >         |                                              ^~
> > >   drivers/usb/atm/cxacru.c:1104:2: note: remove the 'if' if its condition is always true
> > >    1104 |         if (instance->modem_type->boot_rom_patch) {
> > >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   drivers/usb/atm/cxacru.c:1095:32: note: initialize the variable 'bp' to silence this warning
> > >    1095 |         const struct firmware *fw, *bp;
> > >         |                                       ^
> > >         |                                        = NULL
> > > 
> > > This warning occurs in clang's frontend before inlining occurs, so it
> > > cannot notice that bp is only used within cxacru_upload_firmware() under
> > > the same condition that initializes it in cxacru_heavy_init(). Just
> > > initialize bp to NULL to silence the warning without functionally
> > > changing the code, which is what happens with modern compilers when they
> > > support '-ftrivial-auto-var-init=zero' (CONFIG_INIT_STACK_ALL_ZERO=y).
> > 
> > We generally do not want to paper over compiler bugs, when our code is
> > correct, so why should we do that here?  Why not fix clang instead?
> 
> I would not really call this a compiler bug. It IS passed uninitialized
> to this function and while the uninitialized value is not actually used,
> clang has no way of knowing that at this point in its pipeline, so I
> don't think warning in this case is unreasonable.

No, I take it back, it is unreasonable :)

At runtime, there never is a uninitialized use of this pointer, the
first time it is used, it is intended to be filled in if this is a "boot
rom patch":
	ret = cxacru_find_firmware(instance, "bp", &bp);

Then if that call fails, the function exits, great.

Then later on, this is called:
	cxacru_upload_firmware(instance, fw, bp);
so either bp IS valid, or it's still uninitialized, fair enough.

But then cxacru_upload_firmware() does the same check for "is this a
boot rom patch" and only then does it reference the variable.

And when it references it, it does NOT check if it is valid or not, so
even if you do pre-initialize this to NULL, surely some other static
checker is going to come along and say "Hey, you just dereferenced a
NULL pointer, this needs to be fixed!" when that too is just not true at
all.

So the logic here is all "safe" for now, and if you set this to NULL,
you are just papering over the fact that it is right, AND setting us up
to get another patch that actually does nothing, while feeling like the
submitter just fixed a security bug, demanding a CVE for an impossible
code path :)

So let's leave this for now because:

> This type of warning
> is off for GCC because of how unreliable it was when it is done in the
> middle end with optimizations. Furthermore, it is my understanding based
> on [1] that just the passing of an uninitialized variable in this manner
> is UB.
> 
> [1]: https://lore.kernel.org/20220614214039.GA25951@gate.crashing.org/

As gcc can't handle this either, it seems that clang also can't handle
it.  So turning this on for the kernel surely is going to trip it up in
other places than just this one driver.

If you _really_ want to fix this, refactor the code to be more sane and
obvious from a C parsing standpoint, but really, it isn't that complex
for a human to read and understand, and I see why it was written this
way.

As for the UB argument, bah, I don't care, sane compilers will do the
right thing, i.e. pass in the uninitialized value, or if we turned on
the 0-fill stack option, will be NULL anyway, otherwise why do we have
that option if not to "solve" the UB issue?).

thanks,

greg k-h
