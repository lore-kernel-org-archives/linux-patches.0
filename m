Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592DC37EFE7;
	Thu, 23 Apr 2026 12:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947891; cv=none; b=tR9PVxZc3+MhKkBCJRzdGLodVlvR1GH4R6Ij/2f/M4mLI5NBMJkz1EQPedzJXV96ftIevHbefC3WZ4MRy6m4jBhTgj3i7JJeVkdeiVbTgqnC/QD0f5i7Ah/95cWAiQa9cTt6wEAFPyZ3TVP5/dXfxGg8ftGQ2PE/pxqJpxjGdzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947891; c=relaxed/simple;
	bh=0wF3XFc/Pzrua0msqoMlUyluVfOy/Wgtpj3qqMErnHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eaK5djAX5LMBRRhQ5FIZdUP/7EnI4fWaO3WF9Ycj/mi9Q8R4eqMMo7tekuz9C27sDSEzJ3vrHEw7sLKcYr/BuPHdXjEvcr4f/pe9AxKTppIe4CnrVKUMIqobY4FXcOcZcg8fyOeraL7wIZZib1vKTw9haTW6ksy/XH+qolbiZfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUWwZdYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUWwZdYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21C8C2BCAF;
	Thu, 23 Apr 2026 12:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776947891;
	bh=0wF3XFc/Pzrua0msqoMlUyluVfOy/Wgtpj3qqMErnHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fUWwZdYJXOIeMfmgWW+637SajL/ymLGfyE3FpK96J/cnmS+TKEk4iCJxtbZPj56qZ
	 TGAYk2YzXLUQFa0/xhNPAUhNQiy3vitPOlr0gVGS6BFoD2gaGt9pvC33KbWvmvRC/U
	 l3OK+YDqQKj0lQozNQSQ+XYq53rWFVTc+Dyq85e8=
Date: Thu, 23 Apr 2026 14:38:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
Message-ID: <2026042354-doorstep-stray-0fe0@gregkh>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155837.438151458@linuxfoundation.org>
 <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
 <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>
 <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>

On Tue, Apr 21, 2026 at 04:58:52PM -0600, Jens Axboe wrote:
> On 4/21/26 4:18 PM, Jens Axboe wrote:
> >>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
> >>>  		if (req->poll_update.update_user_data)
> >>>  			preq->user_data = req->poll_update.new_user_data;
> >>>  
> >>> -		ret2 = io_poll_add(preq, issue_flags);
> >>> +		ret2 = __io_poll_add(preq, issue_flags);
> >>>  		/* successfully updated, don't complete poll request */
> >>>  		if (!ret2)
> >>>  			goto out;
> >>> +		preq->result = ret2;
> >>> +
> >>>  	}
> >>> -	req_set_fail(preq);
> >>> -	io_req_complete(preq, -ECANCELED);
> >>> +	if (preq->result < 0)
> >>> +		req_set_fail(preq);
> >>> +	io_req_complete(preq, preq->result);
> >>
> >> If __io_poll_add() returned an events mask then it completed preq, but
> >> then we also complete preq here.  Is that really correct?
> > 
> > Let me take a closer look, I do agree with you that the final result
> > does not look entirely correct.
> 
> As far as I can tell, these two should be applied to 5.10 and 5.15
> stable. The first one fixes an old backporting issue that I didn't
> notice until doing some targeted testing just now. The second one should
> take care of the issues that Ben spotted in the current backport.

Now applied.

> Will be nice when 5.x is finally taken out behind the barn :-)

Totally agree...

greg k-h
