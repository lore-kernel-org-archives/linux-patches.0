Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176174A2C
	for <patches@lists.linux.dev>; Tue,  6 Aug 2024 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.97.38.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722958857; cv=none; b=lWyVpfu97MbkyojiCvliKWXGsXasF4yp5g+nLG4TyiqNk76FJ+npLvAwUDlf+AXHXZ7uBmcogmyUT11596iNag2/gygIdc1UImOgBy1zsZECtRq7pIVp8PhNKV59eVBZ1mRrDgz7UKGxXtTNZSyUf72wT4jRRBA/y1WSJbQxZLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722958857; c=relaxed/simple;
	bh=3R5nENrMqucToN9VMkfPIcQLIExcpkUqFk9JgMH0+0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpwvAYh517Cq4nxMuDhUOlty2OtJ7wP+4BFI5UXDf3mECfzQsw6czRb0mvwYSUHJ2uyMVWMJ5oVjjw9PjYqpv3j54hQi3enjIzhLQ65CAw00BofyJZg1AP7AT1AZbUVRw08w2JRtNF8gsDrezGr/XLECedeElap1zPMGfEaCLBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org; spf=pass smtp.mailfrom=mess.org; dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b=IopLPqgP; arc=none smtp.client-ip=88.97.38.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mess.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b="IopLPqgP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
	t=1722958846; bh=3R5nENrMqucToN9VMkfPIcQLIExcpkUqFk9JgMH0+0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IopLPqgPE2Spa5odI/o7d5R0cPUef13nl33YxeqlQhaJ32UF7h8g2XoMvn7DrxDPQ
	 G+s/WOshC9be7+xVkgPFHsoIfeFxbElxR7552lb6sbzAu4KGGL8yxLXZl3bsrLlmhC
	 FVRcWB910sk/d+RKE1OYFnpx1oIHGEyh7L7DSpM6+82QrASlU49Qyr47pgit/b3pI/
	 OxenlPxH9h7hFKNDErZq4xdt9ZBLYdo4Qcna1zEYBIDs0vwaZimCtUSgdciBdVCm4L
	 jenefLOo+UKj+D6iBxhfrjLZBfZbiPiyhcSKf7XR2a2HDxI5UgVblegiKMKAgWLYmw
	 HBhNrMvcamjeQ==
Received: by gofer.mess.org (Postfix, from userid 1000)
	id 4F49F1000C2; Tue,  6 Aug 2024 16:40:46 +0100 (BST)
Date: Tue, 6 Aug 2024 16:40:46 +0100
From: Sean Young <sean@mess.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <ZrJD_gHZCsphqT-U@gofer.mess.org>
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

Hi Stefan,

On Sat, Aug 03, 2024 at 06:08:52PM +0200, Stefan Lippers-Hollmann wrote:
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

I don't think this drivers uses the bulk endpoint, and it is missing the
corresponding out bulk endpoint.

Please could you test the patch below please - that would be very helpful in
narrowing down this issue.

Thank you!

Sean

From adda4b83a6b800d4b35bbd12b9a198fb6a085f58 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Tue, 6 Aug 2024 16:31:02 +0100
Subject: [PATCH] media: dw2102: TeVii DVB-S2 S660 does not have bulk endpoint

Since commit 2052138b7da5 ("media: dvb-usb: Fix unexpected infinite loop
in dvb_usb_read_remote_control()"), we check that the bulk endpoints exist.
This device does have them and then errors out during initialization.

Fixes: 2052138b7da5 ("media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()")
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/usb/dvb-usb/dw2102.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 79e2ccf974c9..440991764942 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -2250,7 +2250,6 @@ static struct dvb_usb_device_properties s660_properties = {
 		.rc_query = dw2102_rc_query,
 	},
 
-	.generic_bulk_ctrl_endpoint = 0x81,
 	.num_adapters = 1,
 	.download_firmware = dw2102_load_firmware,
 	.read_mac_address = s6x0_read_mac_address,
-- 
2.45.2

