Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BF12BD1C;
	Tue,  2 Apr 2024 07:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712044370; cv=none; b=RpIH4jn+FrL/Uwei+syUYY8e+/XpSu0Zy6mwoD/yn5GPMfWNjHdHz5JT4sG3dtGvdoUIT5Kjw/OgWzVN3jOq276sgT2YCEpvP4+SsAhY8aYm4LobBBG1sVqptIa9BdgeFhbIK9IDdItvt82ewakbLYxUhFpkM3+PVstGKnuVNAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712044370; c=relaxed/simple;
	bh=WwfqxIqdxxJob6FHg3dVuAgvuc55Xj+SyK/XAogMEHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPARHRNVTWJ5A+KJnihvHKQ4tyn1d25O6hWZ+OMR3jSaYvZyFMdO+H+84puDVq4qW/bc67+toJpNdymby6aYPUMTrpsOOKw5gGmc6b+l+m2fkv2YyCYJdb2hR3HBoVT170/V9Ei/uV5TSA5GfUtLnhWKu7+7R9CjtXWCcwcGJHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6kEQmLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6kEQmLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C33C433F1;
	Tue,  2 Apr 2024 07:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712044370;
	bh=WwfqxIqdxxJob6FHg3dVuAgvuc55Xj+SyK/XAogMEHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v6kEQmLhc3brqNY0Lezi1sV00zH7dvV/j3raEVauJdi4EHH8LnwKcRBJqy21rBJpg
	 i8tBURCcamZlZXMsCYf5ujeRyXZ5gobrcu50ooBgL1pWPYIjwRfSpvXHjpqsFUp9CA
	 1IFBJVihgEpuDzdbIoSPO8gn8nAlvR7v6vVEbYtM=
Date: Tue, 2 Apr 2024 09:52:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.1 251/272] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <2024040223-steerable-regretful-a9f9@gregkh>
References: <20240401152530.237785232@linuxfoundation.org>
 <20240401152538.859016197@linuxfoundation.org>
 <ZgsWLUHW8nqUv7pi@cae.in-ulm.de>
 <2024040216-cahoots-gizzard-4ffb@gregkh>
 <ZgugfCVW2j1Uwm4J@cae.in-ulm.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgugfCVW2j1Uwm4J@cae.in-ulm.de>

On Tue, Apr 02, 2024 at 08:06:52AM +0200, Christian A. Ehrhardt wrote:
> 
> Hi Greg,
> 
> On Tue, Apr 02, 2024 at 07:40:43AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Apr 01, 2024 at 10:16:45PM +0200, Christian A. Ehrhardt wrote:
> > > 
> > > Hi Greg,
> > > 
> > > On Mon, Apr 01, 2024 at 05:47:21PM +0200, Greg Kroah-Hartman wrote:
> > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Christian A. Ehrhardt <lk@c--e.de>
> > > > 
> > > > commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 upstream.
> > > > 
> > > > The completion notification for the final SET_NOTIFICATION_ENABLE
> > > > command during initialization can include a connector change
> > > > notification.  However, at the time this completion notification is
> > > > processed, the ucsi struct is not ready to handle this notification.
> > > > As a result the notification is ignored and the controller
> > > > never sends an interrupt again.
> > > > 
> > > > Re-check CCI for a pending connector state change after
> > > > initialization is complete. Adjust the corresponding debug
> > > > message accordingly.
> > > > 
> > > > Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> > > > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > > Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
> > > > Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
> > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > 
> > > This change has an out of bounds memory access. Please drop it from
> > > the stable trees until a fix is available.
> > 
> > Shouldn't we get a fix for Linus's tree too?  Have I missed that
> > somewhere?  Or should this just be reverted now?
> 
> I posted the fix a few hours after sending this mail. It is here:
>     https://lore.kernel.org/all/20240401210515.1902048-1-lk@c--e.de/
> 
> Either this should be fast tracked to Linus or the original change
> reverted, yes.

I've dropped the offending commit from the stable queues now.  Once this
fix gets into Linus's tree, let us know and I will add both in then.

thanks,

greg k-h
