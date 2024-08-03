Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BF023CB;
	Sat,  3 Aug 2024 06:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722668272; cv=none; b=PUNaPzfC4+Uw62GrkJvHSzs4gABlCt9nzSG33jJ1+Ajzz7Y5E2Nta9SqNkyo0g3T4bN84zyswMivEakNB4J/0zD4a0VrNfCA31C9P1VnUGuSOH/UoV0KR84hNeB08VNLDzzsaZQ7Losg7Y/Rk66cRIOzcQmd+GEekTUjP8rvr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722668272; c=relaxed/simple;
	bh=sCikdkkJz6xD1boaxWR3KexueBqsy/KNN/E4Ryjrm0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDXbkpA7GdvX3X0l1DlrIkwgwCqowJsirUXd/7sfVGp67mmlC7TZO6apbvIzlDOnjwqrJCp20YwVU70Lsq9kW0BxO16TD16YO7UlwSK10SVVgfmbea9dx9kp30ySg5M1yahRUO5UcGLbD29gtuPF4Eu92IfWm9M06MH0YDJ2tL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NW0Y5CL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NW0Y5CL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8D7C116B1;
	Sat,  3 Aug 2024 06:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722668272;
	bh=sCikdkkJz6xD1boaxWR3KexueBqsy/KNN/E4Ryjrm0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NW0Y5CL+gNgdtOcASaHcbnoi1yTk3TXp1rZTQr0wjUaOAr+qUTggfNXvMfblsX0Pm
	 iQakz2jnMBdU1aM6pdA7QGDC+PYjIOlBhpo6M2ACK7c/rgoklnHBu2XBGn7UhrSESL
	 N1CNFEvhmyVTW6L5KB8Cs2MQPZg7Je62UwrQHtL0=
Date: Sat, 3 Aug 2024 08:57:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>,
	"Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <2024080325-blaming-lid-5f0d@gregkh>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151735.968317438@linuxfoundation.org>
 <20240801165146.38991f60@mir>
 <20240801172755.63c53206@mir>
 <20240801192125.300b2bd9@mir>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801192125.300b2bd9@mir>

On Thu, Aug 01, 2024 at 07:21:25PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2024-08-01, Stefan Lippers-Hollmann wrote:
> > On 2024-08-01, Stefan Lippers-Hollmann wrote:
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
> > [...]
> >
> > Btw. I can also reproduce this (both breakage and 'fix' by reverting
> > this patch) on a another x86_64 system that only has a single TeVii
> > s480 dual DVB-S2 card (and no further v4l devices) installed. So I'm
> > seeing this on both sandy-bridge and raptor-lake x86_64 systems.
> 
> This issue is also present in current linux HEAD (as of this moment,
> v6.11-rc1-63-g21b136cc63d2).
> 
> A clean revert of this commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c
> "media: dvb-usb: Fix unexpected infinite loop in
> dvb_usb_read_remote_control()" avoids the problem for v6.11~ as well.

As this issue is in Linus's tree, please work to get it resolved there
first and then we will gladly take the changes here.

thanks,

greg k-h
