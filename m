Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B727337D10A
	for <patches@lists.linux.dev>; Fri,  1 May 2026 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777626563; cv=none; b=XjZ+yP00gQw6FS0ksgSONE+4UmICz19V1XN2kDIMixjuVv7EWUlZqEmApZCIxXaOcHTCneSFZYNo5D4WpreS78jAEpgphpfK+dZSTbYO25/wLGk/dQhZEPx0SjxiFaCmDeWhNiZODKiFuJ0+9ozHjRMNlWaVCUKsz7lgBGCoMlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777626563; c=relaxed/simple;
	bh=xdtE/DCkochWviPR4LA8Fpn5j454tT/ivRr7H1oKanI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=BNLsyRFFso6D/gPmyOqOlNlZRAgzpoYQoxRMA27L/uFGyJPU008O4+hwaUQ2U/wm7ohKjPb73nRVJtUrnhx2oBIGfbPeufmh4xJF3fOjVW3fgKktdAyKrm85LqzWkMh7m/nrdh/KuwdfpMB1mG7IK22w5mKdj5GYjRshf+hI4uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=Hc9LBJ2Z; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Hc9LBJ2Z"
Received: from localhost (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id BD60640ACE03;
	Fri,  1 May 2026 08:54:18 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru BD60640ACE03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1777625658;
	bh=NwIekQkMHoKLiqQPg0K6ummhL2Oz3biAx42coufr5V4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Hc9LBJ2Za3CK5zQv9X3SQBx56j6b0/vUIsyCG2/K/r+PcYcvTz6hA10sw9R1dWa//
	 EG9eg29FyeBC4DxTj3TRnztG6Hk+EZ58NeRFeFt0u6aghGQrV1EYf51Eo1OFPi3J25
	 jMYmqz8n6AUSKnoAPJKqhDfWj5BvRvffdNPh7a8w=
Date: Fri, 1 May 2026 11:54:18 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com, lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
Message-ID: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>

Hi Jens,

the patch has some issues even after "[PATCH 2/2] io_uring/poll: fix
backport of io_poll_add() changes" has been applied.  Please see below.

Jens Axboe wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> Commit 84230ad2d2afbf0c44c32967e525c0ad92e26b4e upstream.
> 
> When the core of io_uring was updated to handle completions
> consistently and with fixed return codes, the POLL_REMOVE opcode
> with updates got slightly broken. If a POLL_ADD is pending and
> then POLL_REMOVE is used to update the events of that request, if that
> update causes the POLL_ADD to now trigger, then that completion is lost
> and a CQE is never posted.
> 
> Additionally, ensure that if an update does cause an existing POLL_ADD
> to complete, that the completion value isn't always overwritten with
> -ECANCELED. For that case, whatever io_poll_add() set the value to
> should just be retained.
> 
> Cc: stable@vger.kernel.org
> Fixes: 97b388d70b53 ("io_uring: handle completions in the core")

This commit is not present in 5.10/5.15 in any form, to my mind.  That
is, io_uring changes were imported in big chunks there without preserving
upstream git history in some places but still I can't find whether the
changes of the mentioned Fixes-commit are present in those old kernels.

So either the Fixes tag is not completely correct or this patch can just
be reverted from 5.10/5.15 stables.

> Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
> Tested-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  io_uring/io_uring.c |   26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -5980,7 +5980,7 @@ static int io_poll_add_prep(struct io_ki
>  	return 0;
>  }
>  
> -static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
> +static int __io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_poll_iocb *poll = &req->poll;
>  	struct io_poll_table ipt;
> @@ -5992,11 +5992,21 @@ static int io_poll_add(struct io_kiocb *
>  	if (!ret && ipt.error)
>  		req_set_fail(req);
>  	ret = ret ?: ipt.error;
> -	if (ret)
> +	if (ret > 0) {
>  		__io_req_complete(req, issue_flags, ret, 0);
> +		return ret;
> +	}
>  	return 0;
>  }
>  
> +static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	int ret;
> +
> +	ret = __io_poll_add(req, issue_flags);
> +	return ret < 0 ? ret : 0;
> +}
> +
>  static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> @@ -6012,6 +6022,7 @@ static int io_poll_update(struct io_kioc
>  		ret = preq ? -EALREADY : -ENOENT;
>  		goto out;
>  	}
> +	preq->result = -ECANCELED;
>  	spin_unlock(&ctx->completion_lock);
>  
>  	if (req->poll_update.update_events || req->poll_update.update_user_data) {
> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
>  		if (req->poll_update.update_user_data)
>  			preq->user_data = req->poll_update.new_user_data;
>  
> -		ret2 = io_poll_add(preq, issue_flags);
> +		ret2 = __io_poll_add(preq, issue_flags);
>  		/* successfully updated, don't complete poll request */
>  		if (!ret2)
>  			goto out;
> +		preq->result = ret2;
> +
>  	}
> -	req_set_fail(preq);
> -	io_req_complete(preq, -ECANCELED);
> +	if (preq->result < 0)
> +		req_set_fail(preq);
> +	io_req_complete(preq, preq->result);

preq->result is of unsigned type in 5.10/5.15 kernels so the check for
negative values is a no-op here.  Also as Ben pointed out in the initial
report, __io_poll_add() already does complete a request if it returns
non-zero result.  Not sure if completing it twice is good.  The extra
patch from this thread doesn't address these issues.

I wonder whether these lines may be moved in the else-branch here like

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8b0dfea96ee0..1e3835bdaa9f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -6036,10 +6036,10 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
                        goto out;
                preq->result = ret2;
 
-       }
-       if (preq->result < 0)
+       } else {
                req_set_fail(preq);
-       io_req_complete(preq, preq->result);
+               io_req_complete(preq, preq->result);
+       }
 out:
        /* complete update request, we're done with it */
        io_req_complete(req, ret);


but, again, then the __io_poll_add() surrounding logic doesn't become
clear enough:

	ret2 = __io_poll_add(preq, issue_flags);
	/* successfully updated, don't complete poll request */
	if (!ret2)
		goto out;
	preq->result = ret2;


Thus currently I'm for reverting this patch if there is no bug it might
fix in 5.10/5.15.


Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

--
Thanks,
Fedor
