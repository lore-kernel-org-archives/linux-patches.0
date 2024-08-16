Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B48CA957;
	Fri, 16 Aug 2024 06:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723791559; cv=none; b=LVxW7jM01oYTyVuAVml7yfAiHlUXMODhF3TgA9ccSPBEKd5tXDtUxzGBRMHoOQt0oMH3K25HwxYcIhf/I4U2M2YJUvWuft1aR85iMgt9I/uqECw45L1lLQef36wJfEV4Xjt3gJ1THpy3sTVsUXulKE5XXiAt49RN6oR2D7L9ZKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723791559; c=relaxed/simple;
	bh=LcIaxyPtrIg1O9JSLvHRZDGuueVXtwZD3+fWFiec1xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QJcEeHFQinMR9DWMmOiZR43hW0ANBVQ8nPRNB1m36aLO3J6N/Vi1brX8E64M4wGqoTcj9MEm0624JKySbUzQA2ydEtBcrLMDn8QTsvfoXPT6LtqthBlr5925cG7EBYFCL68jb0oYkurXf/Y7ndOPm6tDJjh858ENHmetgo/dxss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M09ztrJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M09ztrJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0905FC32782;
	Fri, 16 Aug 2024 06:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723791558;
	bh=LcIaxyPtrIg1O9JSLvHRZDGuueVXtwZD3+fWFiec1xk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M09ztrJL9XQLpXtbq4oTyP52kRJphtRZzYbPdjBp7DkiEXbSBpZAAJikJatp9PnoE
	 v6yS4PwtpDzT6P3useE7voxf5zG5A1nsqQDaz5dnpT53r0lsnmTbTkh4d4sAuTA0lm
	 UUR070iVoxuFR2rrUo8MDlA3pt+b3SSup20i5QRI=
Date: Fri, 16 Aug 2024 08:59:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 085/484] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <2024081604-backlands-outskirts-81ec@gregkh>
References: <20240815131941.255804951@linuxfoundation.org>
 <20240815131944.570292721@linuxfoundation.org>
 <Zr4MX0elvdkuHZ8j@gofer.mess.org>
 <2024081526-amusement-saddlebag-c622@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024081526-amusement-saddlebag-c622@gregkh>

On Thu, Aug 15, 2024 at 04:20:53PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 15, 2024 at 03:10:39PM +0100, Sean Young wrote:
> > On Thu, Aug 15, 2024 at 03:19:03PM +0200, Greg Kroah-Hartman wrote:
> > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Zheng Yejian <zhengyejian1@huawei.com>
> > > 
> > > [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> > > 
> > > Infinite log printing occurs during fuzz test:
> > > 
> > >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> > >   ...
> > >   dvb-usb: schedule remote query interval to 100 msecs.
> > >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   ...
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > > 
> > > Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
> > > that is in rc_core_dvb_usb_remote_init() create a work that will call
> > > dvb_usb_read_remote_control(), and this work will reschedule itself at
> > > 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
> > > see following code snippet:
> > 
> > This commit causes problems and has been reverted upstream.
> > 
> > https://git.linuxtv.org/media_stage.git/commit/?h=fixes&id=0c84bde4f37ba27d50e4c70ecacd33fe4a57030d
> > 
> > Please don't apply.
> 
> When will that land in Linus's tree?  Currently this commit is already
> in released 6.1, 6.6, and 6.10 kernels :(

I've queued up the revert everywhere now, thanks!

greg k-h
