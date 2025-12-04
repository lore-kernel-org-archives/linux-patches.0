Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2588C2D7DEC;
	Thu,  4 Dec 2025 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865208; cv=none; b=cQI+rLSfJ6pvokMzE/pA5Ep2Rkdr6U/BNYQzTG+w3abwMBCwAOEK0ym2OuuQfy0PfdQzFpnsS1bipO7XpvKr68mpXRMl5jCzu04z539o2WRuQjkNpFy9coMoq8ikVyOn8pI2ej+xTZ6TcuupKUD10kr/5zd3yIxVMO6UAN7jEI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865208; c=relaxed/simple;
	bh=VopRiVpxFytYDs3Lndf/hTicJzDNf8FaZTKgMXkheV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYl3LKXGt99O8htp3sMyR5L5eWaEgVJns6tggZ/GfB7R6BgRPUIX0qTVgJ8B+QQTmLm1Xz62okdJYDoKWWW/zXS7wg+XKEBXdkUOsYmTiLYvVGNtFnx6O+sJBUcwx/Oza+wx+BhkC+6DRflyzrKYCPJeSIgcy+zDM1cbm6GR/yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9agkHjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9agkHjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B73C4CEFB;
	Thu,  4 Dec 2025 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764865206;
	bh=VopRiVpxFytYDs3Lndf/hTicJzDNf8FaZTKgMXkheV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=w9agkHjR+7t9IV23XDKM80WhOEyHnoKYPIDqInWHotqWalkgksZX0DqFTaKzbSXig
	 sJ6tylyp68fWFkh3z7xd5xLZxSDom312zC5ykdraF3LqhwVcDbMOYEiBLDowfoVJ0R
	 t2bYCNDJ1n9l5mRR0BR+Q9ARskVjIX7rny44Sbkw=
Date: Thu, 4 Dec 2025 17:20:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>
Subject: Re: [PATCH 5.15 276/392] ALSA: usb-audio: Fix potential overflow of
 PCM transfer buffer
Message-ID: <2025120454-smoky-unworldly-6057@gregkh>
References: <20251203152414.082328008@linuxfoundation.org>
 <20251203152424.319007924@linuxfoundation.org>
 <87ecpbsfbj.wl-tiwai@suse.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecpbsfbj.wl-tiwai@suse.de>

On Wed, Dec 03, 2025 at 05:25:20PM +0100, Takashi Iwai wrote:
> On Wed, 03 Dec 2025 16:27:06 +0100,
> Greg Kroah-Hartman wrote:
> > 
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Takashi Iwai <tiwai@suse.de>
> > 
> > commit 05a1fc5efdd8560f34a3af39c9cf1e1526cc3ddf upstream.
> > 
> > The PCM stream data in USB-audio driver is transferred over USB URB
> > packet buffers, and each packet size is determined dynamically.  The
> > packet sizes are limited by some factors such as wMaxPacketSize USB
> > descriptor.  OTOH, in the current code, the actually used packet sizes
> > are determined only by the rate and the PPS, which may be bigger than
> > the size limit above.  This results in a buffer overflow, as reported
> > by syzbot.
> > 
> > Basically when the limit is smaller than the calculated packet size,
> > it implies that something is wrong, most likely a weird USB
> > descriptor.  So the best option would be just to return an error at
> > the parameter setup time before doing any further operations.
> > 
> > This patch introduces such a sanity check, and returns -EINVAL when
> > the packet size is greater than maxpacksize.  The comparison with
> > ep->packsize[1] alone should suffice since it's always equal or
> > greater than ep->packsize[0].
> > 
> > Reported-by: syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=bfd77469c8966de076f7
> > Link: https://lore.kernel.org/690b6b46.050a0220.3d0d33.0054.GAE@google.com
> > Cc: Lizhi Xu <lizhi.xu@windriver.com>
> > Cc: <stable@vger.kernel.org>
> > Link: https://patch.msgid.link/20251109091211.12739-1-tiwai@suse.de
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  sound/usb/endpoint.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- a/sound/usb/endpoint.c
> > +++ b/sound/usb/endpoint.c
> > @@ -1374,6 +1374,11 @@ int snd_usb_endpoint_set_params(struct s
> >  	ep->sample_rem = ep->cur_rate % ep->pps;
> >  	ep->packsize[0] = ep->cur_rate / ep->pps;
> >  	ep->packsize[1] = (ep->cur_rate + (ep->pps - 1)) / ep->pps;
> > +	if (ep->packsize[1] > ep->maxpacksize) {
> > +		usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
> > +			      ep->maxpacksize, ep->cur_rate, ep->pps);
> > +		return -EINVAL;
> > +	}
> >  
> >  	/* calculate the frequency in 16.16 format */
> >  	ep->freqm = ep->freqn;
> 
> This backport requires a similar workaround done for 6.12.y for the
> unbalanced mutex lock, the downstream commit fdf0dc82eb60
>     ALSA: usb-audio: Fix missing unlock at error path of maxpacksize check
> 
> It seems that 5.10.y doesn't need the workaround as it has no mutex
> lock applied around it.

Thanks, now queued up for 6.1 and 5.15.

greg k-h
