Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07163BE165;
	Wed, 20 May 2026 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297740; cv=none; b=tm8sglFEXHHvL9SDwKSwWmkUrL/xUZudqd9BXqMjoVxqWmIzTagPH8LHuwSuNATLzqiPR2RVZaju7Ra85EGRVoGwfeo4GtJr4d9TVJ3vxSwC5SiuXEFWkvUZTbkB1zA022bvBDOVIX50jn2FrCF+XxwXX1UNKKBe9sGQOYO/tvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297740; c=relaxed/simple;
	bh=NpQ1Jyg7vQ40tYZ953aeKX2p4s1lJ7cTxR+DCUnBrKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiIGXcyBIhjT5EgPwR+MsW72GAeMWdIxqonlKZhmaY4O8G+Y5CtI+2rSbuApmz47h/MGWGh3jVmYXN/4plYQuPZyvvAcY86iXu+6AUFZ/8AvjNVIX//Szr8vwkpQSQMv/zVOn/kimZMqeaND1KLtGiUCWJOjp0hy+NI434WTffw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXzhd3CI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXzhd3CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D511F000E9;
	Wed, 20 May 2026 17:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779297739;
	bh=8Qj1mjLbItHB2o4CA0jRbYV85vRMUukkoslRkxoKqcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aXzhd3CIl3n8mxw8zVQsYD/y/3w8pJd8lONm8C4SKcU4VfstAur+IXFFn4h7QXxbg
	 smsaLMNcovh3wfqTnIn5wXv6+h3zRv9or603vlaxnC0qqDfpsgTiOr34sYbvXZhgS2
	 G1ZXnDPL8KxQ7LAbgxzD4SOj5GanFeWeKouLDe9rHQPstxMRXLT0e6yOp+o+b3NNzu
	 G1/sh0lkBIYzAa0EqwMsAPqvN5Yd1LOMHjeQhiI8fRHI6+zKFueqa6uwyCL78VYHtN
	 q12q3g9Dfwk6z7vAt3VJSUsq9IcwQcgbL5OGa7hWKH27g9CdXU+v4kFUexI4niyv3T
	 OwaXn7PPkBQOw==
Date: Thu, 21 May 2026 01:22:14 +0800
From: Gao Xiang <xiang@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 010/957] erofs: verify metadata accesses for
 file-backed mounts
Message-ID: <ag3txj1lJNTGZQjp@debian>
References: <20260520162134.554764788@linuxfoundation.org>
 <20260520162134.785057461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260520162134.785057461@linuxfoundation.org>

Hi Greg,

On Wed, May 20, 2026 at 06:08:13PM +0200, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.
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
> index 8ca29962a3dde..58aea2b48580c 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -29,6 +29,20 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
>  {
>  	pgoff_t index = (buf->off + offset) >> PAGE_SHIFT;
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
