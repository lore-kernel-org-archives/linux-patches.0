Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E9F19C546;
	Sun,  4 May 2025 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746362366; cv=none; b=ozBag+fKx4eWWzv62YFbCA/B8832/p1/biLdsxt6u2b6t6IVBBuheHAMz8XWzQZdI9vOkGjTmu5yhipaWJ6C30blEixAoNg+BQ3RKWm5t4hCVfg0VzJeSpZAE692xEot2XSOvuMyUrh0cmRhus83qQMOBL2/BOkzIUKQW8QU4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746362366; c=relaxed/simple;
	bh=bY/WdD3xvXee4q5Ac3bKloMFka094fj04kq+mGgM29E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtXbjfmGoUMRrLvpbkstm4gpWzJgxon2rMMCcN2G5HBG7WFq95G68P+KbzoobnsJJ1SIEjaqnO5NafKM2B9emWxcHuy2NIR+h4X9Ioi8Rj2Inol3BaXgacQ31u3jIc8sDZBajfElRcL5aA5jzGSNp5T23V/15/vS6/FoYmTpBmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcZkcmfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcZkcmfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5417C4CEE7;
	Sun,  4 May 2025 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746362365;
	bh=bY/WdD3xvXee4q5Ac3bKloMFka094fj04kq+mGgM29E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WcZkcmfCenHJfjyLeTYvkYf8zKE5wtf2bYGF2RA2bAI0X92mrAm0465ojv20FFL2p
	 MQs+dja6q3k3DK+3kJGDM0HCd2YBn2QbOSwQjA1BdTVsWoy+plYZ07tpPgMm+luHIg
	 fA55p86MBCTTs+PAmY5R9CHaNvA0YAi7+6cgedJ0=
Date: Sun, 4 May 2025 14:39:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jared Holzman <jholzman@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling
 UBLK_U_IO_NEED_GET_DATA
Message-ID: <2025050455-reconvene-denial-e291@gregkh>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161124.815951989@linuxfoundation.org>
 <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>

On Sun, May 04, 2025 at 02:55:00PM +0300, Jared Holzman wrote:
> On 29/04/2025 19:38, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ming Lei <ming.lei@redhat.com>
> > 
> > [ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]
> > 
> > We call io_uring_cmd_complete_in_task() to schedule task_work for handling
> > UBLK_U_IO_NEED_GET_DATA.
> > 
> > This way is really not necessary because the current context is exactly
> > the ublk queue context, so call ublk_dispatch_req() directly for handling
> > UBLK_U_IO_NEED_GET_DATA.
> > 
> > Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
> > Tested-by: Jared Holzman <jholzman@nvidia.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/block/ublk_drv.c | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > index 437297022dcfa..c7761a5cfeec0 100644
> > --- a/drivers/block/ublk_drv.c
> > +++ b/drivers/block/ublk_drv.c
> > @@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
> >  	mutex_unlock(&ub->mutex);
> >  }
> >  
> > -static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
> > -		int tag)
> > -{
> > -	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
> > -	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
> > -
> > -	ublk_queue_cmd(ubq, req);
> > -}
> > -
> >  static inline int ublk_check_cmd_op(u32 cmd_op)
> >  {
> >  	u32 ioc_type = _IOC_TYPE(cmd_op);
> > @@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
> >  		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
> >  			goto out;
> >  		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
> > -		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
> > -		break;
> > +		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
> > +		ublk_dispatch_req(ubq, req, issue_flags);
> > +		return -EIOCBQUEUED;
> >  	default:
> >  		goto out;
> >  	}
> 
> Hi Greg,
> 
> Will you also be backporting "ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd" to 6.14-stable?

What is the git commit id you are referring to?  And was it asked to be
included in a stable release?

thanks,

greg k-h
