Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047443ED13E;
	Fri,  2 Oct 2026 06:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790922304; cv=none; b=aTvL+IlHR2gRrFHbE7IpwMFQu3DCJ/yN/3luSVoiSK4idBVbQrCV5lymFAGXGCXTF8aQKayeLVb07hMRLASM8B9Th5hbhBuftotFMf/NubMXnNNMfCT27LOhgHE54Lqf1D2WHmByQ15I6qR34+n2hBf+kQTgPFa9DvXlI4DEymc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790922304; c=relaxed/simple;
	bh=CKbVCKBZRcky9jGAHAJgeV9fKnJVp9gMbGPX8mUqnUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HzI3/x/+PA6n6FkcPP4bTVrCCxpCjpjlrgYOUWaKYGx58zRvNVSGYOkCcRNqEhf7xKjWBqIrfXhUW6a5T0oEhrtQwumgfNgU6yw9Tcx8DE6H/PlyNUK/8RyedKyLYPdNbatYInNkWHq+6RX64r+4r7+lpzzEv8J9Upu5iSJUkAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIT2uoxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIT2uoxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F601F000FF;
	Fri,  2 Oct 2026 06:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790922302;
	bh=hIdTw+hSajrIXH74CUiX1+GHGkzjkUgU/AkeeAwfVxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gIT2uoxWN83pZ+uzMsDCgJ48TUYSYWdoz1mz4zUF+02kIfDeYaHD1UbnNq2kH+7gg
	 bEeWGsYq/a4SBfZyRjF389oTDEKjU78qY2WP67nguoHPQCwiicnrc/7eIglvE9j1G3
	 I4AF3QD1e3dnt5BN/V3p6HNBmrTKsEzUo5e7OiJc=
Date: Fri, 2 Oct 2026 08:24:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 6.12 554/877] xfs: drop dquot flush lock when we cant
 find a buffer to flush
Message-ID: <2026100246-silk-headlamp-3e9f@gregkh>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152426.598291693@linuxfoundation.org>
 <4463bbc7-ee0e-4f92-a075-e2dd331adf30@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4463bbc7-ee0e-4f92-a075-e2dd331adf30@oracle.com>

On Fri, Oct 02, 2026 at 01:51:58AM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:54 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > commit ffb48dccce1960a9ea24463a2f3c21d124d6b672 upstream.
> > 
> > LOLLM noticed that xfs_qm_flush_one fails to drop the dquot flush lock
> > if it can't grab the buffer associated with the dquot.  Since there's no
> > buffer, nobody else is going to drop the dqflock, so we need to do it
> > ourselves.
> > 
> > Cc: stable@vger.kernel.org # v6.13
> > Fixes: ca378189fdfa89 ("xfs: convert quotacheck to attach dquot buffers")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Assisted-by: LOLLM # finding obvious bugs
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   fs/xfs/xfs_qm.c |   10 ++++++++--
> >   1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1317,16 +1317,22 @@ xfs_qm_flush_one(
> >   	error = xfs_dquot_use_attached_buf(dqp, &bp);
> >   	if (error)
> > -		goto out_unlock;
> > +		goto out_dqflock;
> >   	if (!bp) {
> >   		error = -EFSCORRUPTED;
> > -		goto out_unlock;
> > +		goto out_dqflock;
> >   	}
> >   	error = xfs_qm_dqflush(dqp, bp);
> >   	if (!error)
> >   		xfs_buf_delwri_queue(bp, buffer_list);
> >   	xfs_buf_relse(bp);
> > +	mutex_unlock(&dqp->q_qlock);
> > +	xfs_qm_dqrele(dqp);
> 
> 
> ^^
> 
> Hi Greg,
> 
> An AI assisted backport review flagged this, and I checked the upstream
> code against the 6.12.y tip f4ffa8dc360b.
> 
> Upstream ffb48dccce19 acquires a temporary dquot reference and balances
> it on the buffer-bearing return path:
> 
>     if (!lockref_get_not_dead(&dqp->q_lockref))
>         return 0;
> 
>     mutex_lock(&dqp->q_qlock);
>     /* ... intervening source omitted ... */
>     xfs_buf_relse(bp);
>     mutex_unlock(&dqp->q_qlock);
>     xfs_qm_dqrele(dqp);
>     return error;
> 
> 6.12.y starts with a mutex-only xfs_dqlock(), but copies the release:
> 
>     xfs_dqlock(dqp);
>     if (dqp->q_flags & XFS_DQFLAG_FREEING)
>         goto out_unlock;
>     if (!XFS_DQ_IS_DIRTY(dqp))
>         goto out_unlock;
>     /* ... intervening source omitted ... */
>     xfs_buf_relse(bp);
>     mutex_unlock(&dqp->q_qlock);
>     xfs_qm_dqrele(dqp);
>     return error;
> 
> Neither xfs_dqlock() nor the walker takes a reference. The new
> xfs_qm_dqrele() releases an unowned reference and can assert/underflow
> q_nrefs on dirty zero-reference dquots after quotacheck, potentially
> blocking purge/teardown.
> 
> Could we replace the new mutex_unlock()/xfs_qm_dqrele() pair with
> xfs_dqunlock(dqp), keeping the early return and out_dqflock cleanup?
> 
> or drop this fix for 6.12.y ?

Now dropped from the 6.12.y queue, thanks.

greg k-h
