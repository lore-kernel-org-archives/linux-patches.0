Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BB93FF1C1;
	Mon, 18 May 2026 12:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779106569; cv=none; b=ThIFnAHntDG81wk8CDHGF2/7CI7EWNnm/q4DPfOOBJomnOMCYk6+HwzHVc9TXqUdzh7UnLslXpQpU+KE+77fc3IJnnO1xT/t8m02t43kM5jmM14WfCNkIe+1p2nr56gjiSLDnte0QsFM0fgdThCDxNC2NjMzcRlwlA/1VzHLZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779106569; c=relaxed/simple;
	bh=XYsRtPYTFaKawM7nUzhJPb+P7s87NzrhXN2ierK/HFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBCfAo7ji24XWzM159gUkYloP7Q3xEo1+5r4VjZaac2O4uYpAeSFc7wRaCFF/9nQV+8eH0gLb2HVvSPlTZzZJIHdZ+4QF5tKBIs+JMazsdy000u9+6/rgfFAJHDgSxm+Puvy+eyFyDVHm77cqn+clWCv59IToQojqkRNiGl+FBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH9a70z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH9a70z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4A4C2BCC6;
	Mon, 18 May 2026 12:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1779106569;
	bh=XYsRtPYTFaKawM7nUzhJPb+P7s87NzrhXN2ierK/HFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CH9a70z25f5en7QJqQut1DAIFQEV+scVEzKMjihNBIMeiKtR5rICpW/oJRfl3DEeG
	 rX9O/02SWielbnrWCfZxSxbW6jCSlxdZh6u6qnd+J03ucf2te2Ltkz8t3IlSz0PAQN
	 4/HKqySN4Ql98DYb0YZb77wj1S10JlnExlLI+9os=
Date: Mon, 18 May 2026 14:16:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 130/144] io_uring/kbuf: support min length left for
 incremental buffers
Message-ID: <2026051801-trifocals-gummy-2be3@gregkh>
References: <20260515154653.469907118@linuxfoundation.org>
 <20260515154656.529062291@linuxfoundation.org>
 <876ac528-b2db-4d52-afff-2a44f13a6767@oracle.com>
 <bc8ede5a-ab28-4191-9153-7e66c28916ac@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc8ede5a-ab28-4191-9153-7e66c28916ac@kernel.dk>

On Sun, May 17, 2026 at 07:02:25PM -0600, Jens Axboe wrote:
> On 5/17/26 12:39 PM, Harshit Mogalapalli wrote:
> > Hi Greg and Jens,
> > 
> > On 15/05/26 21:19, Greg Kroah-Hartman wrote:
> >> 6.12-stable review patch.  If anyone has any objections, please let me know.
> >>
> >> ------------------
> >>
> >> From: Martin Michaelis <code@mgjm.de>
> >>
> >> commit 7deba791ad495ce1d7921683f4f7d1190fa210d1 upstream.
> >>
> >> Incrementally consumed buffer rings are generally fully consumed, but
> >> it's quite possible that the application has a minimum size it needs to
> >> meet to avoid truncation. Currently that minimum limit is 1 byte, but
> >> this should be a setting that is the hands of the application. For
> >> recvmsg multishot, a prime use case for incrementally consumed buffers,
> >> the application may get spurious -EFAULT returned at the end of an
> >> incrementally consumed buffer, as less space is available than the
> >> headers need.
> >>
> >> Grab a u32 field in struct io_uring_buf_reg, which the application can
> >> use to inform the kernel of the minimum size that should be available
> >> in an incrementally consumed buffer. If less than that is available,
> >> the current buffer is fully processed and the next one will be picked.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
> >> Link: https://github.com/axboe/liburing/issues/1433
> >> Signed-off-by: Martin Michaelis <code@mgjm.de>
> >> [axboe: write commit message, change io_buffer_list member name]
> >> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> ---
> >>   include/uapi/linux/io_uring.h |    3 ++-
> >>   io_uring/kbuf.c               |    8 +++++++-
> >>   io_uring/kbuf.h               |    7 +++++++
> >>   3 files changed, 16 insertions(+), 2 deletions(-)
> >>
> >> --- a/include/uapi/linux/io_uring.h
> >> +++ b/include/uapi/linux/io_uring.h
> >> @@ -758,7 +758,8 @@ struct io_uring_buf_reg {
> >>       __u32    ring_entries;
> >>       __u16    bgid;
> >>       __u16    flags;
> >> -    __u64    resv[3];
> >> +    __u32    min_left;
> >> +    __u32    resv[5];
> >>   };
> > 
> > ^^^ let us remember this. More comments below
> >>     /* argument for IORING_REGISTER_PBUF_STATUS */
> >> --- a/io_uring/kbuf.c
> >> +++ b/io_uring/kbuf.c
> >> @@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io
> >>           this_len = min_t(u32, len, buf_len);
> >>           buf_len -= this_len;
> >>           /* Stop looping for invalid buffer length of 0 */
> >> -        if (buf_len || !this_len) {
> >> +        if (buf_len > bl->min_left_sub_one || !this_len) {
> >>               WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
> >>               WRITE_ONCE(buf->len, buf_len);
> >>               return false;
> >> @@ -727,6 +727,10 @@ int io_register_pbuf_ring(struct io_ring
> >>       if (reg.ring_entries >= 65536)
> >>           return -EINVAL;
> >>   +    /* minimum left byte count is a property of incremental buffers */
> >> +    if (!(reg.flags & IOU_PBUF_RING_INC) && reg.min_left)
> >> +        return -EINVAL;
> >> +
> >>       bl = io_buffer_get_list(ctx, reg.bgid);
> >>       if (bl) {
> >>           /* if mapped buffer ring OR classic exists, don't allow */
> >> @@ -747,6 +751,8 @@ int io_register_pbuf_ring(struct io_ring
> >>       if (!ret) {
> >>           bl->nr_entries = reg.ring_entries;
> >>           bl->mask = reg.ring_entries - 1;
> >> +        if (reg.min_left)
> >> +            bl->min_left_sub_one = reg.min_left - 1;
> >>           if (reg.flags & IOU_PBUF_RING_INC)
> >>               bl->flags |= IOBL_INC;
> > 
> > 
> > I have run an AI assisted backport review and it spotted an issue: I
> > have taken a look and the issues goes like:
> > 
> > Backport updates struct io_uring_buf_reg to min_left + resv[5] but
> > keeps legacy validation that only checks reg.resv[0..2], so resv[3]
> > and resv[4] are silently accepted.
> > 
> > Upstream has something like this:
> > 
> > if (copy_from_user(&reg, arg, sizeof(reg)))
> >     return -EFAULT;
> > if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
> >     return -EINVAL;
> > if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
> >     return -EINVAL;
> > 
> > 6.12.y still has:
> > 
> > if (copy_from_user(&reg, arg, sizeof(reg)))
> >     return -EFAULT;
> > 
> > if (reg.resv[0] || reg.resv[1] || reg.resv[2])
> >     return -EINVAL;
> > if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
> >     return -EINVAL;
> > 
> > So we are not checking resv[3], resv[4],
> > 
> > This commit is needed commit: 172484907285 ("io_uring/kbuf: use
> > mem_is_zero()") to fix this. It is a clean cherry-pick, so I think the
> > best thing is to take it for next cycle. this commit is present in
> > 6.16-rc1+ so newer long-term stable kernel releases than 6.12.y don't
> > have this problem.
> > 
> > 
> > Jens, please correct me if the above understanding looks wrong.
> 
> Nope you are right. It's not an actual issue, it's just future proofing
> checking. So it's quite fine to just add that commit for the next stable
> release. I'll check the others too, as the mem_is_zero() commit landed
> in 6.16.

Thanks, now queued up.

greg k-h
