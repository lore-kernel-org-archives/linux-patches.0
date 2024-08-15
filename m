Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF941A76B5;
	Thu, 15 Aug 2024 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734270; cv=none; b=NptZhDKfTl7vr1q5PTfLlttiEKRCMAOF2E0gl/UhkpZ7t5yUacWYc1p622fk87wqhtunUdfSePWjwEAiCl8AWvj4RhvWSPh8HbrWm4XaLdJLMWnIrhNU2RrefQIlcHuX024f66h9xNH7ugDEHXMzpLD0kqtPPcX0K7ZCecdPopk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734270; c=relaxed/simple;
	bh=HltTTI+e8zHa/qW9JNcDQXbYgPTmLUWskd9ijkI8SrM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1zXVo6k5gBpoXo6tfQspS2N2Ov56N6wnm3qskp7egTUsDKIngmUbU/Nso9RUancY/d4xzepScCtGX0mIhGfwShDEJuW5AS16gIJGXjKSFU0hBVebWoU9rxj3Y5TVkoKAEWSlRgeP3zhTH1ScEQ74JS2CYXT2ViiSxJXQ9gCQ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPlX7Bi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPlX7Bi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B8BC4AF0D;
	Thu, 15 Aug 2024 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723734269;
	bh=HltTTI+e8zHa/qW9JNcDQXbYgPTmLUWskd9ijkI8SrM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aPlX7Bi3/wmYB8ikaem8Ft3bALXzCVClw2xagxo0if8pH5nDRJQhBImwzJC0P2qE/
	 +8Cx21imJGYHMOdL4FlM+mYxIeUEoVjPrQ89Q2Iw/pbiPEqGCBAQiy8dzfPA6ZBfUU
	 Pa6bMxJvM3DUNoGgcVmX8WNZiJRPM8IP6fMWYKKs/HgVvOAJNQ//ME4lcWVURZ3TqG
	 Uqt0DghoDdAXaW4RN4AFDHMH0lc7PBm/rGzmkxmZCVGFwdZ4cguEd64O8j5pKo9+OI
	 3xKOnHoC4WcU7y/apxbYTaLCFtFzNh8G07w8yrueXUmFcNNsdKkdvK4wi4x6pqSwuw
	 hiTVukapcPpjg==
Date: Thu, 15 Aug 2024 17:04:25 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sean Young
 <sean@mess.org>, stable@vger.kernel.org, patches@lists.linux.dev, Zheng
 Yejian <zhengyejian1@huawei.com>, Sasha Levin <sashal@kernel.org>, Mauro
 Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 5.15 085/484] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <20240815170418.5dd187b1@foz.lan>
In-Reply-To: <ad064a06-2037-4289-8087-d5a525872c26@xs4all.nl>
References: <20240815131941.255804951@linuxfoundation.org>
	<20240815131944.570292721@linuxfoundation.org>
	<Zr4MX0elvdkuHZ8j@gofer.mess.org>
	<2024081526-amusement-saddlebag-c622@gregkh>
	<ad064a06-2037-4289-8087-d5a525872c26@xs4all.nl>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Thu, 15 Aug 2024 16:51:03 +0200
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> On 15/08/2024 16:20, Greg Kroah-Hartman wrote:
> > On Thu, Aug 15, 2024 at 03:10:39PM +0100, Sean Young wrote:  
> >> On Thu, Aug 15, 2024 at 03:19:03PM +0200, Greg Kroah-Hartman wrote:  
> >>> 5.15-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Zheng Yejian <zhengyejian1@huawei.com>
> >>>
> >>> [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> >>>
> >>> Infinite log printing occurs during fuzz test:
> >>>
> >>>   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> >>>   ...
> >>>   dvb-usb: schedule remote query interval to 100 msecs.
> >>>   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
> >>>   dvb-usb: bulk message failed: -22 (1/0)
> >>>   dvb-usb: bulk message failed: -22 (1/0)
> >>>   dvb-usb: bulk message failed: -22 (1/0)
> >>>   ...
> >>>   dvb-usb: bulk message failed: -22 (1/0)
> >>>
> >>> Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
> >>> that is in rc_core_dvb_usb_remote_init() create a work that will call
> >>> dvb_usb_read_remote_control(), and this work will reschedule itself at
> >>> 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
> >>> see following code snippet:  
> >>
> >> This commit causes problems and has been reverted upstream.
> >>
> >> https://git.linuxtv.org/media_stage.git/commit/?h=fixes&id=0c84bde4f37ba27d50e4c70ecacd33fe4a57030d
> >>
> >> Please don't apply.  
> > 
> > When will that land in Linus's tree?  Currently this commit is already
> > in released 6.1, 6.6, and 6.10 kernels :(  
> 
> I asked Mauro to make a PR asap. Hopefully for the next rc.

PR just sent:
	https://lore.kernel.org/linux-media/20240815170235.0ab77b44@foz.lan/T/#u

Regards,
Mauro


Thanks,
Mauro
