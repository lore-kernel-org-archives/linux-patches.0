Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B6221104;
	Tue, 23 Jan 2024 14:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706020322; cv=none; b=SeTpslYbFUJUJuVPfwMHAzKWPYr2T02rfVdC98tlh8UY7YOhjdWvDxzu5QrwvXys313LNpO4TksK5NcGKkwoCGUoGxRBlGkQxWAkSbEF99e5acJlw/EfsUD0KnqoYOKE/wHjzx8yb8x3GONxDo2sT1GsrQ4YnGtgvmcFdRTB7B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706020322; c=relaxed/simple;
	bh=GWhFxl7RzV7jgWEOFI3X6xruxWjs+R57LNgY1QhzLzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSvS7k9wfRgjcLXIsmid+qK8IwTzFVWR9/Abji9FcC//JXeE3HcDkY8CHeTukQqkqVg1pdPnSomtHmbgoCU8aQGAzCHAEufWIt271HlJi7T4xJHlaYSHIvH5YSbhkIs+IZgSr6btx4l3oGSZzY1adCUJQCEzvIJFuSw+HRcdGdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JChCCIdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JChCCIdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7634C433C7;
	Tue, 23 Jan 2024 14:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706020321;
	bh=GWhFxl7RzV7jgWEOFI3X6xruxWjs+R57LNgY1QhzLzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JChCCIdc4UHgL4LXPnIHsS/MBHUbS3x1BvnZ0lMooDY9bwBimjduW4DfKsngiSUms
	 qjiDXIzmSyMqG2HVLm0vGRRBvNlUMwkHoKt3OzSkWmpIKdIQqMib1r4+75Krp5XVjC
	 7dLafSoLvLfanm0jpNKq70ggShz08zjm3ueTttPo=
Date: Tue, 23 Jan 2024 06:32:00 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 328/583] gpiolib: provide gpio_device_find()
Message-ID: <2024012300-print-deceased-ea31@gregkh>
References: <20240122235812.238724226@linuxfoundation.org>
 <20240122235822.085816226@linuxfoundation.org>
 <CACMJSevr71oSy-CjUKkyXa4ur=mQL3R+PBnJUWQB-Pw3yp+kgA@mail.gmail.com>
 <2024012314-distill-womanlike-77bb@gregkh>
 <CACMJSevTCk+HkeBC4YbmiRrzViwBNi9r30wdDKrB8J92YBcu4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMJSevTCk+HkeBC4YbmiRrzViwBNi9r30wdDKrB8J92YBcu4A@mail.gmail.com>

On Tue, Jan 23, 2024 at 02:13:40PM +0100, Bartosz Golaszewski wrote:
> On Tue, 23 Jan 2024 at 13:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jan 23, 2024 at 10:56:50AM +0100, Bartosz Golaszewski wrote:
> > > On Tue, 23 Jan 2024 at 03:03, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > >
> > > > [ Upstream commit cfe102f63308c8c8e01199a682868a64b83f653e ]
> > > >
> > > > gpiochip_find() is wrong and its kernel doc is misleading as the
> > > > function doesn't return a reference to the gpio_chip but just a raw
> > > > pointer. The chip itself is not guaranteed to stay alive, in fact it can
> > > > be deleted at any point. Also: other than GPIO drivers themselves,
> > > > nobody else has any business accessing gpio_chip structs.
> > > >
> > > > Provide a new gpio_device_find() function that returns a real reference
> > > > to the opaque gpio_device structure that is guaranteed to stay alive for
> > > > as long as there are active users of it.
> > > >
> > > > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > > > Stable-dep-of: 48e1b4d369cf ("gpiolib: remove the GPIO device from the list when it's unregistered")
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > >
> > > Greg,
> > >
> > > I think there's something not quite right with the system for picking
> > > up patches into stable lately. This is the third email where I'm
> > > stopping Sasha or you from picking up changes that are clearly new
> > > features and not fixes suitable for backporting.
> > >
> > > Providing a new, improved function to replace an old interface should
> > > not be considered for stable branches IMO. Please drop it.
> >
> > Even if it is required for a valid bugfix that affects users?  This is a
> > dependency of the commit 48e1b4d369cf ("gpiolib: remove the GPIO device
> > from the list when it's unregistered"), shouldn't that be backported to
> > all affected kernels properly?
> >
> > thanks,
> >
> > greg k-h
> 
> Eh... It is technically a fix but also this has been like it since
> 2014 and nobody ever hit the bug (or bothered to report it). Ok do as
> you wish with this one.

You all marked the commit as a fix for an issue, so that's why we
backported all of this.  If something is NOT a fix, don't tag it as
such?  :)

Or, if you want, we can ignore all patches in the gpio subsystem that
are NOT explicitly tagged with a cc: stable@ tag, if you agree that you
will properly tag everything.  Some other subsytems do this, but that
increases the responsibility on the maintainers of the subsystem, which
is not something I would ever ask anyone to do.

Heck, for my subsystems, I miss tagging stable a lot, but the scripts
pick up those that get Fixes: tags, so it's a good back-stop to solve
problems.

Again, if you want us to ignore any portion of the tree that you are the
maintainer, just let me know the directory(ies) that you want and I can
add it to the "ignore list" or you can send a patch for this file:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list

thanks!

gre gk-h
