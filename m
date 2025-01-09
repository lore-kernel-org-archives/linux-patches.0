Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521CA1FCFF4;
	Thu,  9 Jan 2025 10:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736417488; cv=none; b=JrAPC9FIJYpuj3DOf6ZoPXU3lrXym5zOQ+2AWFeao9z3VKdYXWCefL33NoamXYOgJOT+yh9RBMu1daU2ASQu3EegqA9k3mXRMraIXzBZ5f3L9BpWja+BQoCtxd8SyXM/yEPB2Cy5T5FGFhavOhS9kMJQYNnwgxHDppBCu191qwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736417488; c=relaxed/simple;
	bh=UclOxUeegfd9H8l71oZtnGFp2jXRP6zSHxVUd5irahE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mThmuVn6kcPQ7jPPanVA4ieo5no/95GjKbLzEIZPE3bLb+ymPV55P/IBIlDhOAa+Vuf3By6SKDKvE6Y5xOdI13Xl9vHUfgGxHNQZcoxjMSxEPxMQX6wvd9VIeUj6i0kayDjE6v8nFt8R4DpW+6hejDHfH0rydf5Dir7XeAoZ910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi8fBlii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi8fBlii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A208C4CED2;
	Thu,  9 Jan 2025 10:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736417487;
	bh=UclOxUeegfd9H8l71oZtnGFp2jXRP6zSHxVUd5irahE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pi8fBliidLq4GO44JzeznRUtDoWPiVfxPnXlGfTuz5V1vbl+WdVq+R1p7HaMTiRYi
	 3zc9Oz1ZJ9zFN2IEfZYCnWOjZXUtGvJtGbhNS2mJUEn6F/p4qP9kHX+JvE9HF8DBz0
	 rBoofs2xKSpfUoAvC6HWdz++krSlQo4r+1IrAg90=
Date: Thu, 9 Jan 2025 11:11:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 116/168] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <2025010916-hardiness-dynamite-e8d3@gregkh>
References: <20250106151138.451846855@linuxfoundation.org>
 <20250106151142.833223628@linuxfoundation.org>
 <in5x6saane6o2yjo3qxrcs3fpssgsfg3dutksidtsjie2g3zeb@5wait6y3lrz4>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <in5x6saane6o2yjo3qxrcs3fpssgsfg3dutksidtsjie2g3zeb@5wait6y3lrz4>

On Wed, Jan 08, 2025 at 12:55:14PM +0900, Sergey Senozhatsky wrote:
> On (25/01/06 16:17), Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kairui Song <kasong@tencent.com>
> > 
> > [ Upstream commit 74363ec674cb172d8856de25776c8f3103f05e2f ]
> > 
> > Setting backing device is done before ZRAM initialization.  If we set the
> > backing device, then remove the ZRAM module without initializing the
> > device, the backing device reference will be leaked and the device will be
> > hold forever.
> > 
> > Fix this by always reset the ZRAM fully on rmmod or reset store.
> > 
> > Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
> > Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Reported-by: Desheng Wu <deshengwu@tencent.com>
> > Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Can we please drop this patch?
> 

Now dropped (also in 5.10.y)
