Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16ED17D2;
	Wed, 16 Jul 2025 07:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651951; cv=none; b=cBSLv0o00A1M+4sa8xF8oJZw6dPdraV5S762YVpfUhh8eQvEid9cV/wq/vzh/HVAJ7ovGa31dny9Q1/IKgAO2VA/tsd4rUTNNbZid15mXYsoFNrqldu27tdNlVYS3p2mGTj6O6dt6xXD700L9ro3DmzMj6rw1a1kH9CsPk+XCY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651951; c=relaxed/simple;
	bh=tgb9bkAyOBE58G0OSthVzllzAxenikv1W1kmlRHDq9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUJQWev0NkImGFzbw5oTCYQcExmx4l2lEGVljSs+LxOXcrlLdJvkOmOCZQCBicJe3ibbwvz5yHSvJh6Cg064LzrpEeA72HN9wrMziZdpNCuXuydMGFWNA1FnhvA8e1O2OWJPXQGc6mZ1MAhQqi0BVYGqK+c+PtfV0LMYATe6pKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYSkubu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYSkubu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABECC4CEF0;
	Wed, 16 Jul 2025 07:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752651950;
	bh=tgb9bkAyOBE58G0OSthVzllzAxenikv1W1kmlRHDq9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TYSkubu8WZQCqjYCz1FEAgpnsXGTfnqVlAoa6mAqTX9EEdNI9IWcJX8UGosHtrc6g
	 +WJ/XQJjap0nkgBFF3Van68mKHBCHUoR2mHUSJxGG/eRexyi90aHBw09yQ16x4T1Pt
	 0jXO1RriFSDAofDRXIgnEEq3LKXrzv8Q66PbqjXA=
Date: Wed, 16 Jul 2025 09:45:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] usb: atm: cxacru: Zero initialize bp in
 cxacru_heavy_init()
Message-ID: <2025071632-giggling-hatbox-22e4@gregkh>
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
> don't think warning in this case is unreasonable. This type of warning
> is off for GCC because of how unreliable it was when it is done in the
> middle end with optimizations. Furthermore, it is my understanding based
> on [1] that just the passing of an uninitialized variable in this manner
> is UB.
> 
> [1]: https://lore.kernel.org/20220614214039.GA25951@gate.crashing.org/

Ah, I see now what you are referring to, sorry.  I'll go queue this up
now, thanks.

greg k-h
