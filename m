Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FA638F94C;
	Wed, 13 May 2026 11:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778673523; cv=none; b=FgT3FTZzZMMK5RE/mbW98pitEZYIABd5s+G90DKB5mRykWiXqIAdJSb+H7/5u8nz5mqNJKMbEwgSqPmwP9pApH1I+2Cdhx7OxRHie6olf8kSmt3x0KGMCQ8l+L+VsRoMicaNnKklZwSjU3sEMuiHBDp+y67xR/1mulQlkObc/Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778673523; c=relaxed/simple;
	bh=In8fYXQWtJzf6WlIE9aIJm782/mBwpstRnkGghUmsao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ca831lY8uoPKTPGteFp5In1wt2XEZ92nNkQ4k7QOibLJCjoLyiVmh2De95P9MPI/6lq7qu4YsjI4EuvIlcmpBEgDjn8xWUf2aJ3Cz2JGEqL2C++LDVcSJbdTfMyHYspfQVRyyY2QMN5+QdpX59GTC3GeC2FoQTrMPTO77AaIEB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3AXs98m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3AXs98m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9210FC2BCB7;
	Wed, 13 May 2026 11:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778673522;
	bh=In8fYXQWtJzf6WlIE9aIJm782/mBwpstRnkGghUmsao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A3AXs98mDEJhZuCL50H299avQ3XDiJhoyP4As9cF8NIx8giLyLX+CaR+1vXkjjvlo
	 KjLQlzP8q7zf7EGtBKnJjlXspL+WSo3ZpD03/KKVq8vlRm+RDmhWeHOM1BK+RqAVvn
	 Z1w53IyzhogIQA7uWa1cpFdHmXr7hHuh7+2HN92A=
Date: Wed, 13 May 2026 13:58:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chris Mason <clm@meta.com>, Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: Re: [PATCH 7.0 247/307] sched_ext: Skip tasks with stale task_rq in
 bypass_lb_cpu()
Message-ID: <2026051301-tusk-parcel-15ee@gregkh>
References: <20260512173940.117428952@linuxfoundation.org>
 <20260512173945.338221208@linuxfoundation.org>
 <2f509cbf-f14f-4dfc-8ba9-d53dc10e0aad@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f509cbf-f14f-4dfc-8ba9-d53dc10e0aad@kernel.org>

On Wed, May 13, 2026 at 06:59:56AM +0200, Jiri Slaby wrote:
> On 12. 05. 26, 19:40, Greg Kroah-Hartman wrote:
> > 7.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit da2d81b4118a74e65d2335e221a38d665902a98c upstream.
> > 
> > bypass_lb_cpu() transfers tasks between per-CPU bypass DSQs without
> > migrating them - task_cpu() only updates when the donee later consumes the
> > task via move_remote_task_to_local_dsq(). If the LB timer fires again before
> > consumption and the new DSQ becomes a donor, @p is still on the previous CPU
> > and task_rq(@p) != donor_rq. @p can't be moved without its own rq locked.
> > 
> > Skip such tasks.
> > 
> > Fixes: 95d1df610cdc ("sched_ext: Implement load balancer for bypass mode")
> > Cc: stable@vger.kernel.org # v6.19+
> > Reported-by: Chris Mason <clm@meta.com>
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reviewed-by: Andrea Righi <arighi@nvidia.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   kernel/sched/ext.c |    9 +++++++++
> >   1 file changed, 9 insertions(+)
> > 
> > --- a/kernel/sched/ext.c
> > +++ b/kernel/sched/ext.c
> > @@ -4008,6 +4008,15 @@ resume:
> >   		if (cpumask_empty(donee_mask))
> >   			break;
> > +		/*
> > +		 * If an earlier pass placed @p on @donor_dsq from a different
> > +		 * CPU and the donee hasn't consumed it yet, @p is still on the
> > +		 * previous CPU and task_rq(@p) != @donor_rq. @p can't be moved
> > +		 * without its rq locked. Skip.
> > +		 */
> > +		if (task_rq(p) != donor_rq)
> > +			continue;
> 
> As others pointed out already:
> [   75s] In file included from ../kernel/sched/build_policy.c:62:
> [   75s] ../kernel/sched/ext.c: In function ‘bypass_lb_cpu’:
> [   75s] ../kernel/sched/ext.c:4019:35: error: ‘donor_rq’ undeclared (first
> use in this function); did you mean ‘donee_rq’?
> [   75s]  4019 |                 if (task_rq(p) != donor_rq)
> [   75s]       |                                   ^~~~~~~~
> [   75s]       |                                   donee_rq
> 
> Donor and donor_rq were introduced in:
> commit ff06f727a9412b3c9f2f13f1441a5a0d2a31366b
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Mar 6 07:58:03 2026 -1000
> 
>     sched_ext: Move bypass_dsq into scx_sched_pcpu

This is odd that it doesn't show up in my test builds/runs.  I'll go
drop this now, and push out a -rc2, thanks!

greg k-h
