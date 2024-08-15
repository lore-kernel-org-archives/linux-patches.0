Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E71B17BEC0
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 14:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.97.38.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731801; cv=none; b=W0erhntnfPh6SygEGD5f4EmM/NpVVX8zFzF+7j2HrXhNocjadZANGqyPJrO4xQbdc4ZXGHa42v6o1jH+AmfAhDISv4CzqMEU2U79DnqZ2fQG/qDX0xogBqEZvgWICtHUHv51WceblCBHyAOYN1o+9wRM5Ryz0wBu7ExoXRB7osA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731801; c=relaxed/simple;
	bh=LuZ1cvKWvQWmMaRBKeH8V7mIySryyd8gcvDoGNk22yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ex579BCeAL4iCgq8mKB7cD6EBIWJlWqxSiIcI3G0KQGU6jSFHvnuoLOwUd9a0vIAIFLiAWWahFEhp/oWE1VYS6hxHD8WIramg5leunRHZJRlaR3qD2w/OpRFn06/2eSa3/DVZzLDAn4KmvPI+L6EKblLdSAlKMgaMZhnqchWbKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org; spf=pass smtp.mailfrom=mess.org; dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b=eqA/yTLY; arc=none smtp.client-ip=88.97.38.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mess.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b="eqA/yTLY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
	t=1723731797; bh=LuZ1cvKWvQWmMaRBKeH8V7mIySryyd8gcvDoGNk22yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eqA/yTLY/WVo0fXWV7NoMxRYxCFySMm9jENZ0u2D5zoC+zZwxFfcoEkauPxW4GUjA
	 XAieA9/XvMMtFzEMx9yMb9pByJqhMGlANFr8ofp2j3D6XXk1ZEugS8FvdgEwWqFV1h
	 MEY5HxA9MYzZJnvmwStyak0IgWODy3o51Kn51YpPVVCMX+OZHc1va3hYk4bVQzZA9m
	 /nNURiWv1hEdA66u9C7XNIRD2u4DO02MBy293tWRmiR8SdE+PnEwP6LZNMCF104ZVr
	 DVqkTEBMJqAz5AvZlHT1mNO6x1t9xUvA8cxzEPru1FuZ081b1eyoYgTctKwpQirqo5
	 J2wvBbV61Ltfg==
Received: by gofer.mess.org (Postfix, from userid 1000)
	id 7E5FD100104; Thu, 15 Aug 2024 15:23:17 +0100 (BST)
Date: Thu, 15 Aug 2024 15:23:17 +0100
From: Sean Young <sean@mess.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 051/259] media: dvb-usb: Fix unexpected infinite loop
 in dvb_usb_read_remote_control()
Message-ID: <Zr4PVWBCBcUoXO0s@gofer.mess.org>
References: <20240815131902.779125794@linuxfoundation.org>
 <20240815131904.776800293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815131904.776800293@linuxfoundation.org>

On Thu, Aug 15, 2024 at 03:23:04PM +0200, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Zheng Yejian <zhengyejian1@huawei.com>
> 
> [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> 
> Infinite log printing occurs during fuzz test:
> 
>   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
>   ...
>   dvb-usb: schedule remote query interval to 100 msecs.
>   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
>   dvb-usb: bulk message failed: -22 (1/0)
>   dvb-usb: bulk message failed: -22 (1/0)
>   dvb-usb: bulk message failed: -22 (1/0)
>   ...
>   dvb-usb: bulk message failed: -22 (1/0)
> 
> Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
> that is in rc_core_dvb_usb_remote_init() create a work that will call
> dvb_usb_read_remote_control(), and this work will reschedule itself at
> 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
> see following code snippet:

This commit causes problems and has been reverted upstream.

https://git.linuxtv.org/media_stage.git/commit/?h=fixes&id=0c84bde4f37ba27d50e4c70ecacd33fe4a57030d

Please don't apply.

Thanks,

Sean
