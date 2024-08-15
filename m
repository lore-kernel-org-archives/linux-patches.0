Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06911BBBF7
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.97.38.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731049; cv=none; b=AtyXWzCQAjyrB3tfFSGhaLCh/OhQvOaflU6rlnQNNDux3Ql7Hiv8J00VsEw/sLTRLVw/YG7fyiyIhSkctliMYj043OxAsurwJOoSZx1ceqQQXJl0XH/GmRcj0m/dFFu1RMRyhBGY592B0HW8oslAL0luKDXqOsOLkIbSHs0/PpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731049; c=relaxed/simple;
	bh=c9rLTRtglaVuS3Ipal/B8WabNxkKLKF4gwi/pCbigB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdEyHn0ZBtmH9Bz8G7BnuNftYcxz7ySnYGBg8NG8ushXmsN91z0NWziIi86RirREnWxqwKkWFRB6B6V4i8YU44mtf6kV52UY/vOhFAcytS4HyymH2idopnMXmwpcnnSz6BfJBwin8EgBm6IKon47UZCzABfcomH8FyokpCLlkC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org; spf=pass smtp.mailfrom=mess.org; dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b=HzpXQ7zT; arc=none smtp.client-ip=88.97.38.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mess.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b="HzpXQ7zT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
	t=1723731039; bh=c9rLTRtglaVuS3Ipal/B8WabNxkKLKF4gwi/pCbigB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HzpXQ7zTS/uOCQxv0OVn0CAOrhwWozF+AvKRYertDV4QfMKZotKdFimSz9YgzA+H3
	 Y652A7ZEHS6wEnCcvKFXTfo5rjwoU5ZV/RHjQZiZ26/KUmz1aq4LpOg9mfHilRK/R0
	 9oBIrF4m1M/j28GcnDiluMj9cDJPq8lzfGX100Pn9+cuKBLe/xN9f6EJ3kKn7xrkoO
	 D9NgP60+4UzEnyT4en2WCQ7eoxIwPgqb2KkXJUj42+GfryYzzi8sxl0NTa1ZmWoHdd
	 /jPd14slV+8svTSYZ55j2N1fLXRf26vraArQbrDM6TAMBk3L8PN5NkcMjWRAWOug8X
	 Zi6km8dDf1xug==
Received: by gofer.mess.org (Postfix, from userid 1000)
	id B5974100104; Thu, 15 Aug 2024 15:10:39 +0100 (BST)
Date: Thu, 15 Aug 2024 15:10:39 +0100
From: Sean Young <sean@mess.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 085/484] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <Zr4MX0elvdkuHZ8j@gofer.mess.org>
References: <20240815131941.255804951@linuxfoundation.org>
 <20240815131944.570292721@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815131944.570292721@linuxfoundation.org>

On Thu, Aug 15, 2024 at 03:19:03PM +0200, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
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
