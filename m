Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3283348C55;
	Wed, 20 May 2026 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301275; cv=none; b=XI/0QWa6Gdhizj2bfmJ7fY/VEE2023W+FTrKaPqJ3IChLNyRr2B8PKr/SRjjG+ZcZbPjMQ6yhuw9PpKWnFG/EHMkq25HqtiopiKEqVRtE+qyUa9aJF8a+gE/puBY69W6IJ6GTGFa8ENyJ5jWGqkmFvAe6FU/j5LE04bPXvY58O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301275; c=relaxed/simple;
	bh=T0F3yG+11uxj+1P/vNrg+2C71fzu0Z8eZceliFJ+oPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRQslLxFzFCEtiEj76jFt2mQp7Z/orKxSOq7iHlHzF78DuakQXN2hb7sVS/26/cFBUXzz94oOkgSlpL7utPQ6pcP52LboLbEvYyxbyq+c/fqMj0ZvqRIXtTqyxAtz41RQ8Q88u51tYDebTcRW73+bI81+9Ksd02DO52p1tdzhLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gg60MDAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gg60MDAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42441F000E9;
	Wed, 20 May 2026 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779301273;
	bh=hAeACngJkQf4FLu5lKLPnlHaL+G/6grH03HBIB/iFa4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gg60MDAY17O3tqaRfXL2LGk5E5o677rsnNPrFGwmTR0bML5XJVB55IjGXFPM3jOTY
	 GM1tDAist0BE6tYr6QOo4PVCfNUvMpuUFtTY6zqOa1qrtP1Ja8o6MEJOEexSuZDMvI
	 SzliCPjYTWJVVdOIb4/wqcdc8bX5yvqAtLcT9CseAsl5E10gmtoLPQx1fFeyd0DSLT
	 a+9sHy+m3J9siZXj7pqTuyVEahOjEC0RooN4hWrwfS5h1rrg9T96+oVVKxQJK7dlUZ
	 3Kw7gitn6O1rUtABO1DURE+HvspgvaOuD0r9s92WkKCqSV4VDXYNqHzjsOLSYwxW2w
	 tM0Ehr3xeb51w==
Date: Thu, 21 May 2026 02:21:09 +0800
From: Gao Xiang <xiang@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 011/666] erofs: verify metadata accesses for
 file-backed mounts
Message-ID: <ag37lbajmtyv9xBd@debian>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162111.476779194@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260520162111.476779194@linuxfoundation.org>

Hi Greg,

On Wed, May 20, 2026 at 06:13:42PM +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 

Could you please help drop this too, the same reason as:
https://lore.kernel.org/r/ag3qlMOcTYM2FBUQ@debian

I will address this backport manually later.

Thanks,
Gao Xiang

> ------------------
> 
> From: Gao Xiang <hsiangkao@linux.alibaba.com>
> 
> [ Upstream commit 307210c262a29f41d7177851295ea1703bd04175 ]
> 
> For file-backed mounts, metadata is fetched via the page cache of
> backing inodes to avoid double caching and redundant copy ops out
> of RO uptodate folios, which is used by Android APEXes, ComposeFS,
> containerd.  However, rw_verify_area() was missing prior to
> metadata accesses.
> 
> Similar to vfs_iocb_iter_read(), fix this by:
>  - Enabling fanotify pre-content hooks on metadata accesses;
>  - security_file_permission() for security modules.
> 
> Verified that fanotify pre-content hooks now works correctly.
> 
> Fixes: fb176750266a ("erofs: add file-backed mount support")
> Acked-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/erofs/data.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 91182d5e3a66c..192c7ed885acd 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -30,6 +30,20 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset,
>  {
>  	pgoff_t index = offset >> PAGE_SHIFT;
>  	struct folio *folio = NULL;
> +	loff_t fpos;
> +	int err;
> +
> +	/*
> +	 * Metadata access for file-backed mounts reuses page cache of backing
> +	 * fs inodes (only folio data will be needed) to prevent double caching.
> +	 * However, the data access range must be verified here in advance.
> +	 */
> +	if (buf->file) {
> +		fpos = index << PAGE_SHIFT;
> +		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
> +		if (err < 0)
> +			return ERR_PTR(err);
> +	}
>  
>  	if (buf->page) {
>  		folio = page_folio(buf->page);
> -- 
> 2.53.0
> 
> 
> 
