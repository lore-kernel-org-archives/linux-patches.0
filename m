Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2068914C5A3;
	Mon, 13 May 2024 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605351; cv=none; b=g4nPQ3imKFfYa79wvLH+E9MpNv7VWcJLo40OCM9VvDx7hNT4bS8MqOhzC/mAAqczO7zulJ5bgym3pMYoOaLe4dFRcakQeOp/WEAyqDTUzmN2nNCUPX5W5UVZOxlhaJL401sRf2AW+O1OLM/IWGxa/VRbIihEE4Lmd+79MHwfjiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605351; c=relaxed/simple;
	bh=unu2bcr+QOslnGcsSu84g6oQGRqK01Q/I7nKU+QPcwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0RJypUERFVVWnJ3PG9l4N1FZiNpnaN8mxXOTRwhzJu6eG4DhCw9/SWGrsxsl+FFF/VD7+6m2TAQE931kn6a5rSuoHEV3Au8A0Zele4tsXLs6mwYGUiOVcDYZVyP6uDHtodxXrXPCuHLDnpao881zZ9p0PKfGdzvCZXY8kELFW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRVplcMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRVplcMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFA0C113CC;
	Mon, 13 May 2024 13:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715605350;
	bh=unu2bcr+QOslnGcsSu84g6oQGRqK01Q/I7nKU+QPcwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eRVplcMc9Nq3hLquSHorT2/50e4+ttDNN8aenzyV2SCtqPDg2jHbUhwwumJ0dVh10
	 9rgwK9AtGn12pJAIhxAP+eqXWKDah3j0NkmDLGPAJl2l+oj4N3m0xwCNiD47LWzTAL
	 OptFyCHpXy0R7xPEabtkOJU4tfUQbdavBSMLN/fM=
Date: Mon, 13 May 2024 15:02:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.1 251/272] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <2024051320-expansive-acid-c651@gregkh>
References: <20240401152530.237785232@linuxfoundation.org>
 <20240401152538.859016197@linuxfoundation.org>
 <ZgsWLUHW8nqUv7pi@cae.in-ulm.de>
 <2024040216-cahoots-gizzard-4ffb@gregkh>
 <ZgugfCVW2j1Uwm4J@cae.in-ulm.de>
 <2024040223-steerable-regretful-a9f9@gregkh>
 <ZjKTsuw2/ZyzVYtN@cae.in-ulm.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjKTsuw2/ZyzVYtN@cae.in-ulm.de>

On Wed, May 01, 2024 at 09:10:42PM +0200, Christian A. Ehrhardt wrote:
> 
> Hi Greg,
> 
> On Tue, Apr 02, 2024 at 09:52:47AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Apr 02, 2024 at 08:06:52AM +0200, Christian A. Ehrhardt wrote:
> > > 
> > > Hi Greg,
> > > 
> > > On Tue, Apr 02, 2024 at 07:40:43AM +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, Apr 01, 2024 at 10:16:45PM +0200, Christian A. Ehrhardt wrote:
> > > > > 
> > > > > Hi Greg,
> > > > > 
> > > > > On Mon, Apr 01, 2024 at 05:47:21PM +0200, Greg Kroah-Hartman wrote:
> > > > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > > > > 
> > > > > > ------------------
> > > > > > 
> > > > > > From: Christian A. Ehrhardt <lk@c--e.de>
> > > > > > 
> > > > > > commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 upstream.
> > > > > > 
> > > > > > The completion notification for the final SET_NOTIFICATION_ENABLE
> > > > > > command during initialization can include a connector change
> > > > > > notification.  However, at the time this completion notification is
> > > > > > processed, the ucsi struct is not ready to handle this notification.
> > > > > > As a result the notification is ignored and the controller
> > > > > > never sends an interrupt again.
> > > > > > 
> > > > > > Re-check CCI for a pending connector state change after
> > > > > > initialization is complete. Adjust the corresponding debug
> > > > > > message accordingly.
> > > > > > 
> > > > > > Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> > > > > > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > > > > Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
> > > > > > Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
> > > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > ---
> > > > > >  drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
> > > > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > > 
> > > > > This change has an out of bounds memory access. Please drop it from
> > > > > the stable trees until a fix is available.
> > > > 
> > > > Shouldn't we get a fix for Linus's tree too?  Have I missed that
> > > > somewhere?  Or should this just be reverted now?
> > > 
> > > I posted the fix a few hours after sending this mail. It is here:
> > >     https://lore.kernel.org/all/20240401210515.1902048-1-lk@c--e.de/
> > > 
> > > Either this should be fast tracked to Linus or the original change
> > > reverted, yes.
> > 
> > I've dropped the offending commit from the stable queues now.  Once this
> > fix gets into Linus's tree, let us know and I will add both in then.
> 
> The fix for
>     808a8b9e0b87 ("usb: typec: ucsi: Check for notifications after init")
> has hit Linus's tree as 
>     ce4c8d21054a ("usb: typec: ucsi: Fix connector check on init")
> 
> There is no urgency but this is to let you know that the original commit
> is eligible for -stable again, provided that the follow up commit is
> backported, too.

Thanks, all now queued up.

greg k-h
