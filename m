Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E3537A481
	for <patches@lists.linux.dev>; Fri,  1 May 2026 22:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777674377; cv=none; b=Bmuwf7U7QKGD5y9kkQxEe7vEowVhmtfGVxcZbCBaEkDXbY1uK1HN7oxkwXNE5UU0Y+fbF1Af4KTZKF9upZny8jMaTm6ofOFLDV1Qxh/U1P+QmgFNr4WqrRnvmj7LZZOruo0lqPG8W4cT8A/xVa1Bfvjgk6+vqCdnymvOZUgUCk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777674377; c=relaxed/simple;
	bh=EKLMt3AmP0XqAlXm1PJDP+Unfv6n9jw1H8yuE5tgibk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vs2ksERfqT19DaP5JAhvCM1D2t47UCo2wRJEuaY0HQTQTILSo7HJ78MKVBu+EPXbm8ufoO5Ixib3zzpgOzX6URvXS2x8x6O4csuWOYzpEa39q34UuCsyLHF5PK8AxC8ksSalS0MhuzA6bIMYl+ssAzf7RFScfPCB5mkYU0gwZog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=pwscRpmn; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="pwscRpmn"
Received: from localhost (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id 7249945F798B;
	Fri,  1 May 2026 22:26:13 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7249945F798B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1777674373;
	bh=gqRzleIGhv9m+GK1nBa8FDeo3kK1lqfnBQn7Gl26vT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pwscRpmnWuWN1mmLHYnq0U4AZHA+hMOLCVLtIABMpXajyaA3TincKVCFcoQNvclPi
	 idkbOvFpCPi5hU97iatyE5BCdoFSO4gaBCYhpktKhBzVubqJdfDSi+tFgYwDUi2onT
	 C8ZhPEG0ZEN58I7OhtOgaOPPYMuK0E1rHf21jOA8=
Date: Sat, 2 May 2026 01:26:13 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com, lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
Message-ID: <20260502011444-849ff2d3f8fe48b07f48d496-pchelkin@ispras>
References: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <58103791-4c19-441c-9d4f-7ae5f9c6151a@kernel.dk>
 <20260502003658-e04f382bc8ed201a99b573e0-pchelkin@ispras>
 <20260502005417-671675fb5906578c85c3fb4f-pchelkin@ispras>
 <fb26a75a-cb2c-4ee6-92b9-4c488a2c7ba5@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fb26a75a-cb2c-4ee6-92b9-4c488a2c7ba5@kernel.dk>

On Fri, 01. May 16:07, Jens Axboe wrote:
> On 5/1/26 3:55 PM, Fedor Pchelkin wrote:
> >> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >> index 8b0dfea96ee0..b17a26b1b5e1 100644
> >> --- a/io_uring/io_uring.c
> >> +++ b/io_uring/io_uring.c
> >> @@ -6006,7 +6006,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
> >>  {
> >>         struct io_ring_ctx *ctx = req->ctx;
> >>         struct io_kiocb *preq;
> >> -       int ret2, ret = 0;
> >> +       int ret2 = -ECANCELED, ret = 0;
> >>  
> >>         io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
> >>  
> >> @@ -6037,7 +6037,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
> >>                 preq->result = ret2;
> >>  
> >>         }
> >> -       if (preq->result < 0)
> >> +       if (ret2 < 0)
> >>                 req_set_fail(preq);
> >>         io_req_complete(preq, preq->result);
> >>  out:
> >>
> >>
> >> The fixup patch may be updated with this if the changes look OK.
> >>
> > 
> > Or maybe this one which is less hassle:
> > 
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 8b0dfea96ee0..bb01eaa9761f 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -6037,7 +6037,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
> >                 preq->result = ret2;
> >  
> >         }
> > -       if (preq->result < 0)
> > +       if (preq->result)
> >                 req_set_fail(preq);
> >         io_req_complete(preq, preq->result);
> >  out:
> 
> That'd be fine. Note that both your patches are white space damaged. I

Argh, my fault.

> can send out updated fixup patches, the above does improve them. But at
> this point I don't even know what is queued up where. As far as I can
> tell neither 5.10-stable or 5.15-stable have the fixup queued up yet,
> even though I asked for it 10 days ago. Neither the fixup, nor the
> EPOLL_URING_WAKE patch.

They've been queued up to 5.10 and 5.15.  The queues are available at [1,2]
from the official kernel git web urls. 

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/

While being in queue, the patches may be fixed up by stable maintainers if
I'm correct.

> From 8f1a401b0fce5a46935153f8572b0681d5b9a00d Mon Sep 17 00:00:00 2001
> From: Jens Axboe <axboe@kernel.dk>
> Date: Tue, 21 Apr 2026 16:44:06 -0600
> Subject: [PATCH 2/2] io_uring/poll: fix backport of io_poll_add() changes

[...]

> @@ -6188,7 +6184,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>  		preq->result = ret2;
>  
>  	}
> -	if (preq->result < 0)
> +	if (ret2 < 0)
>  		req_set_fail(preq);
>  	io_req_complete(preq, preq->result);
>  out:

I'm really uncomfortable to raise this but - ret2 should be initialized in
beginning of the function io_poll_update().
