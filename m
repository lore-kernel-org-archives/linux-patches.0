Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BD822081
	for <patches@lists.linux.dev>; Sun,  4 Aug 2024 10:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.97.38.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722765610; cv=none; b=d9epoMsLrjx3NzgzqnZS8/l43x5Xch7XC5IgTvXd+EiJtTLfunio6uxk5l6sdF+o0dFHP7FTSaCI4/ijuzhNPx1EUXXjNhPxskXbNfEyB7o9J7hA9tY9jRCoyFHNQDTrTcfyWwl1IkPJw3AixYBZ3IvlZslLhDcAhtnPMqy2hDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722765610; c=relaxed/simple;
	bh=0AttI12sKCmifb/7pHMqUOGd42+V7EHR24QYtJmAOXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qns3iO77dVxAhiVU7MxqfcHIAG6GIMW2VYLbP+mtRdJIq3uES2g60vZjqpVICryXZTdtlm8RI54I84+3u81boRghEOhkixIHtfLiDAzdGIgv7fCVRPee3uMSXcQQcu1OY4jZPL4vg8pMQxggiot1AiDL8Cym99XnaIkDqqAcoRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org; spf=pass smtp.mailfrom=mess.org; dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b=sOKuQREX; arc=none smtp.client-ip=88.97.38.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mess.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b="sOKuQREX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
	t=1722765606; bh=0AttI12sKCmifb/7pHMqUOGd42+V7EHR24QYtJmAOXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sOKuQREXElg3gOLJyYKw6zGfeGiHpUsMMVpOw9OOD2BhjEGSek3d8VPgUA1gam151
	 +sCoe5cEAquJuGskLc26eys2MqaE/P81bJ+21uClWxgkcNOP6G6O8K3U+ZNTueaD/w
	 nNHy7yD5mP+PerPR65ofs501J15ppbFgoG2y6PYtwdB09CLrel/NtzKmfbx0TEco7U
	 /YcNELFx+m2Fijtv3WbumqrBiZLMAu1XrbmW9qVR1/A/5e/uAcs7x46Q/moY17EHpT
	 1WGh2+TVOJsufGjjEAV9DIRPUGH5iUuMJEoNpqm6WesJtM1NT9GEVNdDn0t9bIyM5E
	 eqj8JiXgoJdbA==
Received: by gofer.mess.org (Postfix, from userid 1000)
	id 09F5E1000C2; Sun,  4 Aug 2024 11:00:06 +0100 (BST)
Date: Sun, 4 Aug 2024 11:00:05 +0100
From: Sean Young <sean@mess.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <Zq9RJWcUyPU9JZs9@gofer.mess.org>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151735.968317438@linuxfoundation.org>
 <20240801165146.38991f60@mir>
 <Zq5KcGd8g4t2d11x@gofer.mess.org>
 <20240803180852.6eb5f0cb@mir>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240803180852.6eb5f0cb@mir>

On Sat, Aug 03, 2024 at 06:08:52PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2024-08-03, Sean Young wrote:
> > On Thu, Aug 01, 2024 at 04:51:46PM +0200, Stefan Lippers-Hollmann wrote:
> > > Hi
> > >
> > > On 2024-07-30, Greg Kroah-Hartman wrote:
> > > > 6.10-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Zheng Yejian <zhengyejian1@huawei.com>
> > > >
> > > > [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> > > >
> > > > Infinite log printing occurs during fuzz test:
> > > >
> > > >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> > > >   ...
> > > >   dvb-usb: schedule remote query interval to 100 msecs.
> > > >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
> > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > >   ...
> > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > >
> > > > Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
> > > > that is in rc_core_dvb_usb_remote_init() create a work that will call
> > > > dvb_usb_read_remote_control(), and this work will reschedule itself at
> > > > 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
> > > > see following code snippet:
> > > [...]
> > >
> > > This patch, as part of v6.10.3-rc3 breaks my TeVii s480 dual DVB-S2
> > > card, reverting just this patch from v6.10-rc3 fixes the situation
> > > again (a co-installed Microsoft Xbox One Digital TV DVB-T2 Tuner
> > > keeps working).
> >
> > Thanks for reporting this ...
> >
> > So looking at the commit, it must be that one of the usb endpoints is
> > neither a send/receiver bulk endpoint. Would you mind sending a lusb -v
> > of the device, I think something like:
> >
> > 	lsusb -v -d 9022:d482
> >
> > Should do it, or -d 9022::d481
> 
> It doesn't show up as 9022:d482 or 9022:d481, but as two 9022:d660.
> 
> system 1, raptor-lake:
> 
> # lsusb -v -d 9022:d660
> 
> Bus 001 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660

-snip-

>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0002  1x 2 bytes
>         bInterval               0

For this device, we do both a bulk snd/rcv to endpoint 1, but the descriptor
says it's an IN endpoint only. So, commit 
2052138b7da52ad5ccaf74f736d00f39a1c9198c rejects the device as being invalid.

At the moment, I'm not sure why this works without the patch, surely a bulk
send to endpoint 1 should fail; there is no out entry.

I'm poking around in the usb code, in the mean time if anyone has any ideas,
that would be appreciated.


Sean
