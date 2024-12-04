Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489C61AB6FF;
	Wed,  4 Dec 2024 09:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733305427; cv=none; b=GbeINpzuBwIXi0DtiLKLtTO5iTJb5KHtxbwSU70Uk1ZnQjuva1AuRSkfdWidWif/USWOTVK9XKQGgpbwWh3gboGEsoXzTbclRG5ujwG54Q0PtFFFRNbNR6WsUpeHdDQvcsW5grPqc25qMoftS1Z+mAlPgq/Rm+bOODCxcglCCdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733305427; c=relaxed/simple;
	bh=PWrHeDKw+oq+b09wbyG1pzc83XNPY1LPkCYQjhR8i/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEFkPYZDs6nWmM0xOtFhNQTG26DPh0O7zWQwTh34VGbQ8M/n3t4D1GD05yT6aJtMYcBWq8Tv5liTm22HXOco3HuP86XCnj5RCZ++yajJSFXKnZX29GIf/e5G5cRWUxoIU9/yD66JJmf/B07uGmJm3ZOJ7YkKXkH0YrFbDqNTSVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDaE2ndC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDaE2ndC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3549FC4CED1;
	Wed,  4 Dec 2024 09:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733305426;
	bh=PWrHeDKw+oq+b09wbyG1pzc83XNPY1LPkCYQjhR8i/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MDaE2ndCiRt/0GQJtUi/NV4K0n8xuHlEaBNN5BuVUDMPXWXi0bxCRgNhF86ISsIqt
	 aCAXE30DDeUXVKaWs9AiosQUu+uwy9G0+ySRmQ09eDxfn5yiAZSQA9l+DGH4T1+kif
	 7NZYPchIRTh/hA6soAVzB8VLVUCazmxsUgr4FkXg=
Date: Wed, 4 Dec 2024 10:43:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tomasz Figa <tfiga@google.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 207/817] media: venus: fix enc/dec destruction order
Message-ID: <2024120430-skillet-operator-4f78@gregkh>
References: <20241203143955.605130076@linuxfoundation.org>
 <20241203144003.826130114@linuxfoundation.org>
 <20241204031031.GF886051@google.com>
 <2024120433-paternal-state-098e@gregkh>
 <20241204071642.GH886051@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204071642.GH886051@google.com>

On Wed, Dec 04, 2024 at 04:16:42PM +0900, Sergey Senozhatsky wrote:
> On (24/12/04 08:10), Greg Kroah-Hartman wrote:
> > > > From: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > > 
> > > > [ Upstream commit 6c9934c5a00ae722a98d1a06ed44b673514407b5 ]
> > > > 
> > > > We destroy mutex-es too early as they are still taken in
> > > > v4l2_fh_exit()->v4l2_event_unsubscribe()->v4l2_ctrl_find().
> > > > 
> > > > We should destroy mutex-es right before kfree().  Also
> > > > do not vdec_ctrl_deinit() before v4l2_fh_exit().
> > > 
> > > Hi Greg, I just received a regression report which potentially
> > > might have been caused by these venus patches.  Please do not
> > > take
> > > 
> > > 	media: venus: sync with threaded IRQ during inst destruction
> > > 	media: venus: fix enc/dec destruction order
> > > 
> > > to any stable kernels yet.  I need to investigate first.
> > 
> > What are the git commit id of these that I should be dropping?
> 
> Upstream:
> 
> 	6c9934c5a00ae722a98d1a06ed44b673514407b5
> 	45b1a1b348ec178a599323f1ce7d7932aea8c6d4
> 
> as far as I can tell.

Looks right, thanks, I'll go drop these from all stable queues now.

greg k-h
