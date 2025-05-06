Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848BC1A76D0;
	Tue,  6 May 2025 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547940; cv=none; b=S7KkFtYzmXo3S5IrH4XLd/ZrX+vMiZ/TJjWPuU8FCu3AWWkTZGorlj3vvfTzsobnSQwgAc7T8K7eOYAx821DTUNw2MmtG0B0FuGNphqGP/vqcUvGPQp4EC1nSL+oE/Ds8HMApQVgCTI3OGgCHhCh76fIhW3BqY8rFO8mTo/DwTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547940; c=relaxed/simple;
	bh=Ja8R6PBJOP3kiBaQRzBM/QTYmWLJfq8Yv0MlEpMcSDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fivFLhiOFczAvxmDSJ8RpgyHlyGALtnXmR7r2WIuefPi4F9mupAIg7ZMZlS2uD35lY4KDYXZWwsIV6UDPMeqp9aMDllVCdXiGNCRvglW1OrDnAXPiyzGo1EaS+3Q5+zog+oQXkSpoJYwhj14dSev0DozQ7d40WpKq5Y00W3MNOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usNB21Kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usNB21Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48242C4CEE4;
	Tue,  6 May 2025 16:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746547938;
	bh=Ja8R6PBJOP3kiBaQRzBM/QTYmWLJfq8Yv0MlEpMcSDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=usNB21KzlaAT93voU8Gmgs63ZOm7Lti5kJB6ISZ4hOtvYWIji+eZfZCEQLuIOVxcj
	 H4ILlWe4jG+1gesv5mWakpP8JdB5UYXnu0fQs6n9PeG5uumNdcxC80K3xT1j3FpN38
	 G7vHQI7tGKNBakUKznhdGA31FXgfdDCmMEz1ajQY=
Date: Tue, 6 May 2025 18:12:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jared Holzman <jholzman@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling
 UBLK_U_IO_NEED_GET_DATA
Message-ID: <2025050646-glitch-carpentry-017e@gregkh>
References: <20250429161124.815951989@linuxfoundation.org>
 <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>
 <2025050455-reconvene-denial-e291@gregkh>
 <744b4d9b-24f3-487c-805f-5aa02eaa093b@nvidia.com>
 <2025050509-impending-uranium-ccba@gregkh>
 <c5022682-52e7-4340-995c-7d3d84bb77aa@nvidia.com>
 <2025050537-flaring-wolverine-c3fd@gregkh>
 <843866f8-059a-4e5d-8316-19c92ae25a82@nvidia.com>
 <2025050524-turmoil-garden-66b3@gregkh>
 <922ba351-2b17-4b92-94d2-8a1fef390cd5@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <922ba351-2b17-4b92-94d2-8a1fef390cd5@nvidia.com>

On Tue, May 06, 2025 at 05:31:50PM +0300, Jared Holzman wrote:
> On 05/05/2025 11:50, Greg Kroah-Hartman wrote:
> > On Mon, May 05, 2025 at 11:25:24AM +0300, Jared Holzman wrote:
> >> On 05/05/2025 10:54, Greg Kroah-Hartman wrote:
> >>> On Mon, May 05, 2025 at 10:47:03AM +0300, Jared Holzman wrote:
> >>>> On 05/05/2025 8:51, Greg Kroah-Hartman wrote:
> >>>>> On Sun, May 04, 2025 at 04:47:20PM +0300, Jared Holzman wrote:
> >>>>>> On 04/05/2025 15:39, Greg Kroah-Hartman wrote:
> >>>>>>> On Sun, May 04, 2025 at 02:55:00PM +0300, Jared Holzman wrote:
> >>>>>>>> On 29/04/2025 19:38, Greg Kroah-Hartman wrote:
> >>>>>>>>> 6.14-stable review patch.  If anyone has any objections, please let me know.
> >>>>>>>>>
> >>>>>>>>> ------------------
> >>>>>>>>>
> >>>>>>>>> From: Ming Lei <ming.lei@redhat.com>
> >>>>>>>>>
> >>>>>>>>> [ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]
> >>>>>>>>>
> >>>>>>>>> We call io_uring_cmd_complete_in_task() to schedule task_work for handling
> >>>>>>>>> UBLK_U_IO_NEED_GET_DATA.
> >>>>>>>>>
> >>>>>>>>> This way is really not necessary because the current context is exactly
> >>>>>>>>> the ublk queue context, so call ublk_dispatch_req() directly for handling
> >>>>>>>>> UBLK_U_IO_NEED_GET_DATA.
> >>>>>>>>>
> >>>>>>>>> Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
> >>>>>>>>> Tested-by: Jared Holzman <jholzman@nvidia.com>
> >>>>>>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >>>>>>>>> Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
> >>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>>>>>>>> ---
> >>>>>>>>>  drivers/block/ublk_drv.c | 14 +++-----------
> >>>>>>>>>  1 file changed, 3 insertions(+), 11 deletions(-)
> >>>>>>>>>
> >>>>>>>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> >>>>>>>>> index 437297022dcfa..c7761a5cfeec0 100644
> >>>>>>>>> --- a/drivers/block/ublk_drv.c
> >>>>>>>>> +++ b/drivers/block/ublk_drv.c
> >>>>>>>>> @@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
> >>>>>>>>>  	mutex_unlock(&ub->mutex);
> >>>>>>>>>  }
> >>>>>>>>>  
> >>>>>>>>> -static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
> >>>>>>>>> -		int tag)
> >>>>>>>>> -{
> >>>>>>>>> -	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
> >>>>>>>>> -	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
> >>>>>>>>> -
> >>>>>>>>> -	ublk_queue_cmd(ubq, req);
> >>>>>>>>> -}
> >>>>>>>>> -
> >>>>>>>>>  static inline int ublk_check_cmd_op(u32 cmd_op)
> >>>>>>>>>  {
> >>>>>>>>>  	u32 ioc_type = _IOC_TYPE(cmd_op);
> >>>>>>>>> @@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
> >>>>>>>>>  		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
> >>>>>>>>>  			goto out;
> >>>>>>>>>  		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
> >>>>>>>>> -		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
> >>>>>>>>> -		break;
> >>>>>>>>> +		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
> >>>>>>>>> +		ublk_dispatch_req(ubq, req, issue_flags);
> >>>>>>>>> +		return -EIOCBQUEUED;
> >>>>>>>>>  	default:
> >>>>>>>>>  		goto out;
> >>>>>>>>>  	}
> >>>>>>>>
> >>>>>>>> Hi Greg,
> >>>>>>>>
> >>>>>>>> Will you also be backporting "ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd" to 6.14-stable?
> >>>>>>>
> >>>>>>> What is the git commit id you are referring to?  And was it asked to be
> >>>>>>> included in a stable release?
> >>>>>>>
> >>>>>>> thanks,
> >>>>>>>
> >>>>>>> greg k-h
> >>>>>>
> >>>>>> Hi Greg,
> >>>>>>
> >>>>>> The commit is: f40139fde527
> >>>>>>
> >>>>>> It is Part 2 of the same patch series.
> >>>>>
> >>>>> It does not apply to the stable tree at all, so no, we will not be
> >>>>> adding it unless someone provides a working version of it.
> >>>>>
> >>>>> thanks,
> >>>>>
> >>>>> greg k-h
> >>>>
> >>>> Hi Greg,
> >>>>
> >>>> Happy to provide a version that will apply. I just need to know where to get your working branch to base it on.
> >>>
> >>> The latest stable release tree.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>
> >> Hi Greg,
> >>
> >> I tried branch linux-6.14.y of repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
> >>
> >> But I can't apply any of the previous patches in the series [PATCH 6.14 000/311] to get to the point
> >> where I can create my version of the patch.
> > 
> > All of those changes are already in that branch, right?  So no need to
> > apply them again :)
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> Thanks, I figured it out finally. Sorry for the noise.
> 
> I needed some help with the patch, so I consulted with the maintainer (Ming Lei).
> 
> He has provided me with a branch based stable/linux-6.14.y, containing several commits that are needed to get to the point where the patch can be applied.
> 
> I've tested it and it works and he has given me the go-ahead to send you a pull request.
> 
> I've never done that before so I'd prefer to just send a patch series to the mailing-list.
> 
> Let me know if that's okay.

Please do, we can not take pull request for stable patches as we require
them to be in individual patches for our tools to process.

thanks,

greg k-h
