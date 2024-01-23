Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6AF4BAA8;
	Tue, 23 Jan 2024 12:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706014083; cv=none; b=N9vK0DYdzlSYXY9nmknRsLWFHXJjW2AetSr9dsOwjrh122vkjkHRNuahXQ2HkunAqBGl8cYS0ku3f4pWTjMeoL0Ioo4ibsOOyfYjOpA6J2DQ55Rz9EeYBodeRowV1ArvvBFSZI1BYJ6hyD6x7YF6caguch4xLG4iyXiIUYfS7Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706014083; c=relaxed/simple;
	bh=9yjMihqjslLSUzRqb85FrH/1zaPJrFeWvhpOHFaepUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlIsQYBiYE8rPV0TBiGS3bXnfX7kJFd26CIqNS9+aKh9r0Fdqx8yt08iderdd6o2vjl8bWxZ001fWreYjyCCvdErPG65/HjEfF9tRNBhTlmwHkpD7/BF101GTq2UYBeNOH5ouPwU5GcajcJtP0xPAV/qGQolay1Q2G8cgdbnUzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpvyr3/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpvyr3/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D14C433C7;
	Tue, 23 Jan 2024 12:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706014083;
	bh=9yjMihqjslLSUzRqb85FrH/1zaPJrFeWvhpOHFaepUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jpvyr3/whmzGWJgeWKiIKTnU4YEZHuPFs31gUquNPBQP9JjamWl0oX2TvE3BfR4jt
	 GaSjLPs5dxPEoG4YP39DcbfdQy2cGZRBRbUGvJRgUKw0VjPVPJHEVtQbRi8zUc1fra
	 AR26y60Y2bjeF/QhY/83yTW84XOa7D/lyZf5LzPs=
Date: Tue, 23 Jan 2024 04:14:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 328/583] gpiolib: provide gpio_device_find()
Message-ID: <2024012314-distill-womanlike-77bb@gregkh>
References: <20240122235812.238724226@linuxfoundation.org>
 <20240122235822.085816226@linuxfoundation.org>
 <CACMJSevr71oSy-CjUKkyXa4ur=mQL3R+PBnJUWQB-Pw3yp+kgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMJSevr71oSy-CjUKkyXa4ur=mQL3R+PBnJUWQB-Pw3yp+kgA@mail.gmail.com>

On Tue, Jan 23, 2024 at 10:56:50AM +0100, Bartosz Golaszewski wrote:
> On Tue, 23 Jan 2024 at 03:03, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > [ Upstream commit cfe102f63308c8c8e01199a682868a64b83f653e ]
> >
> > gpiochip_find() is wrong and its kernel doc is misleading as the
> > function doesn't return a reference to the gpio_chip but just a raw
> > pointer. The chip itself is not guaranteed to stay alive, in fact it can
> > be deleted at any point. Also: other than GPIO drivers themselves,
> > nobody else has any business accessing gpio_chip structs.
> >
> > Provide a new gpio_device_find() function that returns a real reference
> > to the opaque gpio_device structure that is guaranteed to stay alive for
> > as long as there are active users of it.
> >
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Stable-dep-of: 48e1b4d369cf ("gpiolib: remove the GPIO device from the list when it's unregistered")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> Greg,
> 
> I think there's something not quite right with the system for picking
> up patches into stable lately. This is the third email where I'm
> stopping Sasha or you from picking up changes that are clearly new
> features and not fixes suitable for backporting.
> 
> Providing a new, improved function to replace an old interface should
> not be considered for stable branches IMO. Please drop it.

Even if it is required for a valid bugfix that affects users?  This is a
dependency of the commit 48e1b4d369cf ("gpiolib: remove the GPIO device
from the list when it's unregistered"), shouldn't that be backported to
all affected kernels properly?

thanks,

greg k-h
