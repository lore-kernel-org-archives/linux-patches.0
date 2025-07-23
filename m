Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8D12E36E7;
	Wed, 23 Jul 2025 06:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753252969; cv=none; b=J0IeXEKq/AvjuBh0aWKwoEubPLGikHvPHxRVbZlLwOXSkZ08Df4eIgGdaeMqRrOo77jlaCHqZY+biTux+u/fvqWgKNZuu3qYyH59ZZXb02rmgGQEOw4EOALyyRQYJFPLSxTtr7Ixz0qKk05dv+SfUpy3eRQiufqfnKRKgXFC2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753252969; c=relaxed/simple;
	bh=J+S3eW18Zh9zN2pLJpGnqhlMJsPNAU9Sx9yiBRNsfSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=datzGQvKUvi5TGeG4rSIY8J2lDrRhjBUIiTtDCiOGewOvoJ2Lp5dv/fiUebfAdGR+e75nr+igieIF0B1w+rU85fupSwtPv3IVbvA2cNPcHlWNJleXCe3QsBrT2TaKWVH6slJsnd9amyPx10mc9tz4WmPhRpHTGVOyguLADRweDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9Jo7wZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9Jo7wZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201F4C4CEE7;
	Wed, 23 Jul 2025 06:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753252968;
	bh=J+S3eW18Zh9zN2pLJpGnqhlMJsPNAU9Sx9yiBRNsfSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s9Jo7wZ/xVu7Pj5PyqLLeSIPlTZwSYLpzFvCKDh4j4VqaItnPIPc4d5NxqGynNZBp
	 K2+sfFoQjzHw5zF0FtbfcmkGQ7rVj57Jg+cOdKLFm+Q7WT9pp7f7gwm5Z5qzzdZbOT
	 uio2IfljhyKdXfBgSG45m/X54PgYamlRqQbHzNTg=
Date: Wed, 23 Jul 2025 08:42:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naman Jain <namjain@linux.microsoft.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Long Li <longli@microsoft.com>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 6.12 020/158] tools/hv: fcopy: Fix irregularities with
 size of ring buffer
Message-ID: <2025072316-mop-manhood-b63e@gregkh>
References: <20250722134340.596340262@linuxfoundation.org>
 <20250722134341.490321531@linuxfoundation.org>
 <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>

On Tue, Jul 22, 2025 at 08:29:07PM +0530, Naman Jain wrote:
> 
> 
> On 7/22/2025 7:13 PM, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Naman Jain <namjain@linux.microsoft.com>
> > 
> > commit a4131a50d072b369bfed0b41e741c41fd8048641 upstream.
> > 
> > Size of ring buffer, as defined in uio_hv_generic driver, is no longer
> > fixed to 16 KB. This creates a problem in fcopy, since this size was
> > hardcoded. With the change in place to make ring sysfs node actually
> > reflect the size of underlying ring buffer, it is safe to get the size
> > of ring sysfs file and use it for ring buffer size in fcopy daemon.
> > Fix the issue of disparity in ring buffer size, by making it dynamic
> > in fcopy uio daemon.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
> > Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
> > Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
> > Reviewed-by: Long Li <longli@microsoft.com>
> > Link: https://lore.kernel.org/r/20250711060846.9168-1-namjain@linux.microsoft.com
> > Signed-off-by: Wei Liu <wei.liu@kernel.org>
> > Message-ID: <20250711060846.9168-1-namjain@linux.microsoft.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> 
> 
> Hello Greg,
> Please don't pick this change yet. I have shared the reason in the other
> thread:
> "Re: Patch "tools/hv: fcopy: Fix irregularities with size of ring buffer"
> has been added to the 6.12-stable tree"

Ok, I have dropped this from the 6.12.y tree now.

thanks,

greg k-h
