Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E72284B25;
	Mon, 16 Feb 2026 09:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771235457; cv=none; b=djJvZOoh7r++nM73uPBdKhWYLLHXTeN5gfyYSkO/Pel5PaxnASUmWQ9uiOoPYV6U6Dp2tgHtMdOGxCHkjWei2VqnxcqE6toD89o+7wp5yVjRQACvqZ9nfMtzu1TYzk4jAvIRcXPwCnkJ7FfIP2/OIL/mF9JO/L84SKyimGnhLuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771235457; c=relaxed/simple;
	bh=q7TzLaa/piaOpPIVMFMsYxtCESxuUToaDky0/qu0Ti0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdzUXYA1D/H6fMcdyJpXnnPJaBKPzZYC4UE0ARJd8uRGo7tI4P3ef3CELZ0qIe0rfFudxRL33Ptqyy3fq0raImQK1SomPAhIIZzBn9h6C/cLgLbz4FbQYd9H9B12tIzIJwRVDQpK6ynNjpjF+pc+fsX/cdNo/cx9WP+8uiJn158=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEovIU9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEovIU9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEC1C116C6;
	Mon, 16 Feb 2026 09:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771235457;
	bh=q7TzLaa/piaOpPIVMFMsYxtCESxuUToaDky0/qu0Ti0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hEovIU9/yWxgaM1GHReUuwhJ90pCnY/6dN8KOXUWo92a25XE+BourB0aCgBbWSfib
	 KfW6gMZaV5zolgJPk/9EA78x9+pVXegsrgv7wr1Dr2p6y0a67SuWxqGoTFfVx1/SuZ
	 al7KuJ3IQNa8jQDk5P54b5atN35iYYrK67fSDaeY=
Date: Mon, 16 Feb 2026 10:50:54 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Shida Zhang <zhangshida@kylinos.cn>, Coly Li <colyli@fnnas.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 30/87] bcache: fix I/O accounting leak in
 detached_dev_do_request
Message-ID: <2026021640-slingshot-yard-26e6@gregkh>
References: <20260204143846.906385641@linuxfoundation.org>
 <20260204143847.995871393@linuxfoundation.org>
 <df94d6c8-f236-46a7-9053-40b00a3a1a5b@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df94d6c8-f236-46a7-9053-40b00a3a1a5b@roeck-us.net>

On Thu, Feb 12, 2026 at 04:16:32PM -0800, Guenter Roeck wrote:
> Hi,
> 
> On Wed, Feb 04, 2026 at 03:40:28PM +0100, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Shida Zhang <zhangshida@kylinos.cn>
> > 
> > [ Upstream commit 4da7c5c3ec34d839bba6e035c3d05c447a2f9d4f ]
> > 
> > When a bcache device is detached, discard requests are completed
> > immediately. However, the I/O accounting started in
> > cached_dev_make_request() is not ended, leading to 100% disk
> > utilization reports in iostat. Add the missing bio_end_io_acct() call.
> > 
> > Fixes: cafe56359144 ("bcache: A block layer cache")
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > Acked-by: Coly Li <colyli@fnnas.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/md/bcache/request.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index a02aecac05cdf..6cba1180be8aa 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
> > @@ -1107,6 +1107,7 @@ static void detached_dev_do_request(struct bcache_device *d,
> >  
> >  	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
> >  	    !bdev_max_discard_sectors(dc->bdev)) {
> > +		bio_end_io_acct(orig_bio, start_time);
> >  		bio_endio(orig_bio);
> >  		return;
> >  	}
> 
> In 6.12.y and v6.18.y, the code continues:
> 
>         clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
>                                     &d->bio_detached);
>         if (!clone_bio) {
>                 orig_bio->bi_status = BLK_STS_RESOURCE;
>                 bio_endio(orig_bio);
>                 return;
>         }
> 
> The NULL check has been removed in the upstream kernel, so the error path
> does not exist there.
> 
> It seems that the above code is still having an accounting leak if
> bio_alloc_clone() returns NULL. Is this indeed the case, or am I
> missing something ?

Look at commit 6ea84d7a92cb ("bcache: remove dead code in
detached_dev_do_request") which changes 6.19 to not check the result of
bio_alloc_clone() as it can not fail here.

> If I am not missing something, is it necessary to add a call to
> bio_end_io_acct() into the error handling, or is the problem theoretic
> and can be addressed by backporting commit 6ea84d7a92cb ("bcache:
> remove dead code in detached_dev_do_request") to v6.12.y and v6.18.y ?

We could apply that commit, but in the end, it's probably not an issue
as this is impossible to hit.  But hey, if someone wants to backport
that commit and submit it for us to take, I'll not refuse :)

thanks,

greg k-h
