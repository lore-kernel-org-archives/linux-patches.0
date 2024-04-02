Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C596323D;
	Tue,  2 Apr 2024 05:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712037552; cv=none; b=av8JiA9p7KoprTij3cg6kTws88SQ7+wHcr11A4viEIyN8vbSPKJKSp6rDYI84d/Pp9bd8da0U+WztXKzAJyU7g8F3KgC+4w7jVKZaCpJLlppQVHQ3mVv9nIF83xEQkWvDa5Djs0f3Od5cn2YXSWcFNa9NLMOsdfZeL8INsmKtgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712037552; c=relaxed/simple;
	bh=wcK13Ddvs/cXCCw4diL8Bj8+MEOJemoyiyzBJ5GEaNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVKN5AwhKugso4WkcvkoekIomLn1MvmeXVrznCZ9xvvVG+WVoIQkl06preU7eBE1avkhYzewWVKiEIU9PTtUdvBwqTmY/wEg2mU0YXHg13KjTk3tpBqfMm7lY8u996f0PzObgCdNDg34ZC26zfPxOSMSg+Blo6YvQzCD+SB//80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPTzfPnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPTzfPnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AF3C433C7;
	Tue,  2 Apr 2024 05:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712037551;
	bh=wcK13Ddvs/cXCCw4diL8Bj8+MEOJemoyiyzBJ5GEaNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QPTzfPnloVCmjEFaipNNoMRpO/UO4vp4aMTcYTWRVT4QL5QO5DPTUM6Cuw1Eg8raV
	 jRkU8JAgyQJTI+7zO12WA9GWXmL4bTNsa+1LjjmQuKxC6+UInEcw0YTCetmU4OfYCL
	 A/7yrKa2MPcW3gl6p3llQ3IoebjZjCANirQ3ffzw=
Date: Tue, 2 Apr 2024 07:59:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.1 251/272] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <2024040255-pampers-scrutiny-6b75@gregkh>
References: <20240401152530.237785232@linuxfoundation.org>
 <20240401152538.859016197@linuxfoundation.org>
 <ZgsWLUHW8nqUv7pi@cae.in-ulm.de>
 <2024040216-cahoots-gizzard-4ffb@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024040216-cahoots-gizzard-4ffb@gregkh>

On Tue, Apr 02, 2024 at 07:40:43AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Apr 01, 2024 at 10:16:45PM +0200, Christian A. Ehrhardt wrote:
> > 
> > Hi Greg,
> > 
> > On Mon, Apr 01, 2024 at 05:47:21PM +0200, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Christian A. Ehrhardt <lk@c--e.de>
> > > 
> > > commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 upstream.
> > > 
> > > The completion notification for the final SET_NOTIFICATION_ENABLE
> > > command during initialization can include a connector change
> > > notification.  However, at the time this completion notification is
> > > processed, the ucsi struct is not ready to handle this notification.
> > > As a result the notification is ignored and the controller
> > > never sends an interrupt again.
> > > 
> > > Re-check CCI for a pending connector state change after
> > > initialization is complete. Adjust the corresponding debug
> > > message accordingly.
> > > 
> > > Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> > > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
> > > Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > This change has an out of bounds memory access. Please drop it from
> > the stable trees until a fix is available.
> 
> Shouldn't we get a fix for Linus's tree too?  Have I missed that
> somewhere?  Or should this just be reverted now?

Ah, I see the fix now, still catching up on email this morning...
