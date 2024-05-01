Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF4037E
	for <patches@lists.linux.dev>; Wed,  1 May 2024 19:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.14.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714590653; cv=none; b=lpzjDA77bcXwjf4BZYuER2icFcZieZRGNKxXx3phlmvsGSPmEPyMlXynomzNf8hYyw8XEKOy2QMCwmuYyaephjRHSLwFlDswcBcnUY+nAIZSpfxWSp41Hj06gb5pVg5IIfv5p5Cgb3Gmk5vGPm/vdPxbqeJm6Z7gkK5EaDsRtm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714590653; c=relaxed/simple;
	bh=xZcwA5ae7kJsF2KgtTHObgD2Q0PCsAhBUrTUOy0mWwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZ8qrRlp4RHp6DFxFhkVA1SL1zYVIMRQSlqAH6RT0EhWW3pdFHpKaL0SVb4MuJmrMRJmfXO1dxQ6SAJJcaeFHDjW3xPt+0O3/IPaJ0G02RmyZB6oJdlF1N2I5bMLYjfWJrrEaENWbFFHnmFVtsbXWWj5p+vzfCahN6dznUvwwt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de; spf=pass smtp.mailfrom=c--e.de; arc=none smtp.client-ip=217.10.14.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=c--e.de
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id 614121403D1; Wed,  1 May 2024 21:10:42 +0200 (CEST)
Date: Wed, 1 May 2024 21:10:42 +0200
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.1 251/272] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <ZjKTsuw2/ZyzVYtN@cae.in-ulm.de>
References: <20240401152530.237785232@linuxfoundation.org>
 <20240401152538.859016197@linuxfoundation.org>
 <ZgsWLUHW8nqUv7pi@cae.in-ulm.de>
 <2024040216-cahoots-gizzard-4ffb@gregkh>
 <ZgugfCVW2j1Uwm4J@cae.in-ulm.de>
 <2024040223-steerable-regretful-a9f9@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024040223-steerable-regretful-a9f9@gregkh>


Hi Greg,

On Tue, Apr 02, 2024 at 09:52:47AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 02, 2024 at 08:06:52AM +0200, Christian A. Ehrhardt wrote:
> > 
> > Hi Greg,
> > 
> > On Tue, Apr 02, 2024 at 07:40:43AM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Apr 01, 2024 at 10:16:45PM +0200, Christian A. Ehrhardt wrote:
> > > > 
> > > > Hi Greg,
> > > > 
> > > > On Mon, Apr 01, 2024 at 05:47:21PM +0200, Greg Kroah-Hartman wrote:
> > > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: Christian A. Ehrhardt <lk@c--e.de>
> > > > > 
> > > > > commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 upstream.
> > > > > 
> > > > > The completion notification for the final SET_NOTIFICATION_ENABLE
> > > > > command during initialization can include a connector change
> > > > > notification.  However, at the time this completion notification is
> > > > > processed, the ucsi struct is not ready to handle this notification.
> > > > > As a result the notification is ignored and the controller
> > > > > never sends an interrupt again.
> > > > > 
> > > > > Re-check CCI for a pending connector state change after
> > > > > initialization is complete. Adjust the corresponding debug
> > > > > message accordingly.
> > > > > 
> > > > > Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> > > > > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > > > Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
> > > > > Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > ---
> > > > >  drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
> > > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > 
> > > > This change has an out of bounds memory access. Please drop it from
> > > > the stable trees until a fix is available.
> > > 
> > > Shouldn't we get a fix for Linus's tree too?  Have I missed that
> > > somewhere?  Or should this just be reverted now?
> > 
> > I posted the fix a few hours after sending this mail. It is here:
> >     https://lore.kernel.org/all/20240401210515.1902048-1-lk@c--e.de/
> > 
> > Either this should be fast tracked to Linus or the original change
> > reverted, yes.
> 
> I've dropped the offending commit from the stable queues now.  Once this
> fix gets into Linus's tree, let us know and I will add both in then.

The fix for
    808a8b9e0b87 ("usb: typec: ucsi: Check for notifications after init")
has hit Linus's tree as 
    ce4c8d21054a ("usb: typec: ucsi: Fix connector check on init")

There is no urgency but this is to let you know that the original commit
is eligible for -stable again, provided that the follow up commit is
backported, too.

Best regards,
Christian
