Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B531AC422;
	Thu, 15 Aug 2024 14:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733079; cv=none; b=TMJ1ZWUP54oKOwh/cuUQyadK0bUjV5wtadWkF9c4+Y+LWHpwrXLkA7Ok8mjnJm7R6f2WHdb+i4OaFPdpp3tiiVTG+2kMkXUMs/FF23c2gXpojTajQNYs9M/l5Q2zVOYwTtxwyA3GXWTkvX6mRd9jol3XWMEG0xvIKwOd9L2O9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733079; c=relaxed/simple;
	bh=wa4y0ZyDZJZFFkHt7HSpkcdmU5KC+Tz1YKXyWvZY320=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BW56wiruiH014Q3WP3L17HtjGvTTVYJ3MU2b5+h584FOlpx5oC14q8nG9rGC5LwsZFo4AtlZYjOzNIzgdcaGgnGvQo0ZiPmsrjo+x1tCd6KC5qnJQq/ESLbydIVpf7h4Yy/mP+HGeX7YSGfeZwSMsdM9wMAtdLBCj+hFZzl8alo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSsJtI0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSsJtI0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E923C4AF0E;
	Thu, 15 Aug 2024 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733079;
	bh=wa4y0ZyDZJZFFkHt7HSpkcdmU5KC+Tz1YKXyWvZY320=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NSsJtI0NlPRlqWuDSWB0l51RCYOY0BpnRwls9j7ZUBMIhPGZrv498vdyl599ul7vc
	 bPQKKUnCsxJ3tRzsPM7nYL+A+sXkZhBrHroM8WUZea41vze6zFRlNeFOjJ9GRJLJeZ
	 AFP9gROSVPm7mJOXrM5CYPofcLr3y5SpOvh+ZKPY=
Date: Thu, 15 Aug 2024 16:20:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 085/484] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <2024081526-amusement-saddlebag-c622@gregkh>
References: <20240815131941.255804951@linuxfoundation.org>
 <20240815131944.570292721@linuxfoundation.org>
 <Zr4MX0elvdkuHZ8j@gofer.mess.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr4MX0elvdkuHZ8j@gofer.mess.org>

On Thu, Aug 15, 2024 at 03:10:39PM +0100, Sean Young wrote:
> On Thu, Aug 15, 2024 at 03:19:03PM +0200, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
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
> 
> This commit causes problems and has been reverted upstream.
> 
> https://git.linuxtv.org/media_stage.git/commit/?h=fixes&id=0c84bde4f37ba27d50e4c70ecacd33fe4a57030d
> 
> Please don't apply.

When will that land in Linus's tree?  Currently this commit is already
in released 6.1, 6.6, and 6.10 kernels :(

thanks,

greg k-h
