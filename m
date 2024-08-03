Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE99139590
	for <patches@lists.linux.dev>; Sat,  3 Aug 2024 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.97.38.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722698362; cv=none; b=IApqflJeSqRFpkQ/LT2+vueqHtZs67zcxvVAsQtFdG6OD5V16H5RQnoxCHCPc+bsrKMltE2Ew7uf2oLUmmUfo9oqZt5+/cw/VTutQtDsfJtrBptI1Jp1FZDx0MWtg1R0QSE7wZv8QL0v0Lr8Xccg7h0mWeMVilUkNU55G6h9WgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722698362; c=relaxed/simple;
	bh=1Y9alObW1YlZTi3NNY8kPhIISkBQPQKdyvj+60EnNG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJUsxpxNMQbGtGn+4Ba2C+ybgjfTK6jL7JEqMrKIA2xNzKfeyshP7oKp1t4NmXZi6q5G1Sqp/nNHRAas+oldp5gI/qVsubEgT4cmym+XXXfVkkxVKep7TaVywxh6pVc1zyofJkEKmwQBMZYwciOSOsFTfjZtBP/VGPSR0oj2F1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org; spf=pass smtp.mailfrom=mess.org; dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b=Ui/xvna4; arc=none smtp.client-ip=88.97.38.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mess.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b="Ui/xvna4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
	t=1722698352; bh=1Y9alObW1YlZTi3NNY8kPhIISkBQPQKdyvj+60EnNG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ui/xvna4cEZTwnmkFNgHoKwJxRVIg8aH/Xw9sS2W1GhYpErB0KYJW5iZo4JYr4DSK
	 hLRbzwndMuMfuTZchtSf+cML2k5j/3AGP5dxR0jg2S5wOxYeU9ta9Lu1qSzCPojHSl
	 XWfUiyPt+p8kQIR7NIFbHKCBOcBJZbyxeALY+wpYQ/7ifj125l+vJeublYXhindgy2
	 4izoXcBl0ryYTg/pD+Io+SrvaXDRBcJdVOLwudh0Di1vyuPIzXhUZ40xvyxbdUmEar
	 tEB2qc37kypKWghiPxMxY/IBcEC5huBb9eaQ8hbL8tIDhN1p+QT6kEBMHvz2kD71k8
	 5pNiKugJe4K4g==
Received: by gofer.mess.org (Postfix, from userid 1000)
	id 3261B100069; Sat,  3 Aug 2024 16:19:12 +0100 (BST)
Date: Sat, 3 Aug 2024 16:19:12 +0100
From: Sean Young <sean@mess.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <Zq5KcGd8g4t2d11x@gofer.mess.org>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151735.968317438@linuxfoundation.org>
 <20240801165146.38991f60@mir>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801165146.38991f60@mir>

On Thu, Aug 01, 2024 at 04:51:46PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2024-07-30, Greg Kroah-Hartman wrote:
> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Zheng Yejian <zhengyejian1@huawei.com>
> >
> > [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> >
> > Infinite log printing occurs during fuzz test:
> >
> >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> >   ...
> >   dvb-usb: schedule remote query interval to 100 msecs.
> >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
> >   dvb-usb: bulk message failed: -22 (1/0)
> >   dvb-usb: bulk message failed: -22 (1/0)
> >   dvb-usb: bulk message failed: -22 (1/0)
> >   ...
> >   dvb-usb: bulk message failed: -22 (1/0)
> >
> > Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
> > that is in rc_core_dvb_usb_remote_init() create a work that will call
> > dvb_usb_read_remote_control(), and this work will reschedule itself at
> > 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
> > see following code snippet:
> [...]
> 
> This patch, as part of v6.10.3-rc3 breaks my TeVii s480 dual DVB-S2
> card, reverting just this patch from v6.10-rc3 fixes the situation
> again (a co-installed Microsoft Xbox One Digital TV DVB-T2 Tuner
> keeps working).

Thanks for reporting this ...

So looking at the commit, it must be that one of the usb endpoints is
neither a send/receiver bulk endpoint. Would you mind sending a lusb -v
of the device, I think something like:

	lsusb -v -d 9022:d482

Should do it, or -d 9022::d481

Either we find a fix for this quickly or revert the entire commit.

Thanks,

Sean
