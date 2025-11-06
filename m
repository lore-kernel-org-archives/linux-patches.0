Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968F3245006;
	Thu,  6 Nov 2025 04:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762403249; cv=none; b=KwWnhn8Fey1tkroXoBRQkzLROZlkezJO3U6bCnW6oZ86q/z9Aedc5ymDCrB9HINHTEWqb83MfYSmu8z4lQqYFgql8FP6FOTq1f79v0amIZXM2PZde+ZWSOI+K6Mm8se5umYvPMHDPXX6bXL04VUHh+dpWOtg67w9OV04XwDMdzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762403249; c=relaxed/simple;
	bh=LjXjqLiIcTZEnOqRTQkglRGH4acf/bZ0o7BRdQk34q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J4jPBmnyzHFMtAEotAUfRiB0htZ7evsFd9Kck10g13mieZKiqEFZX5jLv1ctOaJ3cgGmVSI6FamUhKshJM4R8ysUZkSTAif4EjkSRMeT4Sf0a/rnQriA06KUqe93DUc/Z3yaUYGUHmVJ0ShCeD//mL4K+XOOUDj2QmOI/eIRkDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vA9F7BQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vA9F7BQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B514DC4CEF7;
	Thu,  6 Nov 2025 04:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762403249;
	bh=LjXjqLiIcTZEnOqRTQkglRGH4acf/bZ0o7BRdQk34q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vA9F7BQVRZYZmmk9SqDAXOxQ6pzMKyd+PdRqVIMxutAJytjul5dcdIAOXDvFQ9vgy
	 Msh4g8XLxH6YJrNdxi1oulgyY90RJCh9t+ZprC4Pf6aFIpbnH0nQGhLCIRzPb0i3ln
	 MxT+Le+ftf3G01A3CdPnFFfZr98TxAo+fprfsFJ0Zf0kDJq5zypKn7bLIGK/2FSwnV
	 fKxAMv2NaZGCS1DvVVis/+nyDtRDAE26gUeDJ9ddn/FDVVDotB2uspxQjUcveNnNf5
	 4ayVVTyqT6CGdJI1jTLH7kHjq0Zkw1Ul+hBYKl6WPplCguiiMiD+WBSW6XJXx20YAJ
	 AxiBxOyx/SPtw==
Date: Wed, 5 Nov 2025 21:27:25 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 239/332] fsdax: switch dax_iomap_rw to use iomap_iter
Message-ID: <20251106042725.GA826592@ax162>
References: <20251027183524.611456697@linuxfoundation.org>
 <20251027183531.141165261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027183531.141165261@linuxfoundation.org>

On Mon, Oct 27, 2025 at 07:34:52PM +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit ca289e0b95afa973d204c77a4ad5c37e06145fbf ]
> 
> Switch the dax_iomap_rw implementation to use iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Stable-dep-of: 154d1e7ad9e5 ("dax: skip read lock assertion for read-only filesystems")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/dax.c | 49 ++++++++++++++++++++++++-------------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 3e7e9a57fd28c..6619a71b57bbe 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1104,20 +1104,21 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>  	return size;
>  }
>  
> -static loff_t
> -dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> -		struct iomap *iomap, struct iomap *srcmap)
> +static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
> +		struct iov_iter *iter)
>  {
> +	const struct iomap *iomap = &iomi->iomap;

The constification of iomap in this change depends on commit
7e4f4b2d689d ("fsdax: mark the iomap argument to dax_iomap_sector as
const") from the upstream series to avoid compiler warnings, which may
be fatal in the case of clang since it is a subwarning of
-Wincompatible-pointer-types:

  fs/dax.c: In function 'dax_iomap_iter':
  fs/dax.c:1147:58: warning: passing argument 1 of 'dax_iomap_sector' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
   1147 |                 const sector_t sector = dax_iomap_sector(iomap, pos);
        |                                                          ^~~~~
  fs/dax.c:1009:48: note: expected 'struct iomap *' but argument is of type 'const struct iomap *'
   1009 | static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
        |                                  ~~~~~~~~~~~~~~^~~~~

  fs/dax.c:1147:44: error: passing 'const struct iomap *' to parameter of type 'struct iomap *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
   1147 |                 const sector_t sector = dax_iomap_sector(iomap, pos);
        |                                                          ^~~~~
  fs/dax.c:1009:48: note: passing argument to parameter 'iomap' here
   1009 | static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
        |                                                ^

Cheers,
Nathan
