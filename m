Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A278270EC1;
	Mon, 18 Aug 2025 05:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755496381; cv=none; b=hoNvd/QqgKuKbBU2fJ1J076/mHFDsRRtzZacq9kzzME89SnF3BmVxXGbvQGkHsfYDBw4J5PzQz1405X/xTNGu5iNp4Q56qkGkPhJqxB3CTgyBAWQzjfJ/P63r1y2dU28vaaFLrf+1kTwYjsxOw1PSTqJZxgyKNShUiOWCnXF+eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755496381; c=relaxed/simple;
	bh=3rzCBglMM+tJqyl0fcLp3OCwEGz9JuyA8oQioE0rcgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tL2FZJL8gVAtekx72Yc1zR5DwxR5ClQq6p8oKdA5YeNHS7kRA2AW7aFVnk+65a9OoAuNTHXSiQ9PXnBzsVEnGe+DCUK09sBOf+uwNy+h0Nr8ENDh/xBENCqz+F7M50QlbPNERZUC3pLrZLcngVZU0y0BGiKvphfcLdK5sroFRmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKQdqvuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKQdqvuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050B0C4CEEB;
	Mon, 18 Aug 2025 05:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755496380;
	bh=3rzCBglMM+tJqyl0fcLp3OCwEGz9JuyA8oQioE0rcgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uKQdqvuwiUJCipE0tCOzTXyHaLKZmbhwerOaI3xodCGCZH8G77OQrOHiY9dhW1KiS
	 xR1EcycUqizEkn9cSsbEkItoTFFr/ABeyIhb0aJ86vwMHnt0ZV2WxMWptKHbACyf8v
	 3ccR5nylvuXQMIgn89mb09U+PqsCBywwE8dGAveQ=
Date: Mon, 18 Aug 2025 07:52:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naman Jain <namjain@linux.microsoft.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Long Li <longli@microsoft.com>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 6.12 020/158] tools/hv: fcopy: Fix irregularities with
 size of ring buffer
Message-ID: <2025081834-bullfrog-elixir-6a96@gregkh>
References: <20250722134340.596340262@linuxfoundation.org>
 <20250722134341.490321531@linuxfoundation.org>
 <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>
 <2025072316-mop-manhood-b63e@gregkh>
 <08158da3-82a0-4eb0-a805-87afe34e288a@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08158da3-82a0-4eb0-a805-87afe34e288a@linux.microsoft.com>

On Mon, Aug 18, 2025 at 10:54:10AM +0530, Naman Jain wrote:
> 
> 
> On 7/23/2025 12:12 PM, Greg Kroah-Hartman wrote:
> > On Tue, Jul 22, 2025 at 08:29:07PM +0530, Naman Jain wrote:
> > > 
> > > 
> > > On 7/22/2025 7:13 PM, Greg Kroah-Hartman wrote:
> > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Naman Jain <namjain@linux.microsoft.com>
> > > > 
> > > > commit a4131a50d072b369bfed0b41e741c41fd8048641 upstream.
> > > > 
> > > > Size of ring buffer, as defined in uio_hv_generic driver, is no longer
> > > > fixed to 16 KB. This creates a problem in fcopy, since this size was
> > > > hardcoded. With the change in place to make ring sysfs node actually
> > > > reflect the size of underlying ring buffer, it is safe to get the size
> > > > of ring sysfs file and use it for ring buffer size in fcopy daemon.
> > > > Fix the issue of disparity in ring buffer size, by making it dynamic
> > > > in fcopy uio daemon.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
> > > > Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
> > > > Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
> > > > Reviewed-by: Long Li <longli@microsoft.com>
> > > > Link: https://lore.kernel.org/r/20250711060846.9168-1-namjain@linux.microsoft.com
> > > > Signed-off-by: Wei Liu <wei.liu@kernel.org>
> > > > Message-ID: <20250711060846.9168-1-namjain@linux.microsoft.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > 
> > > 
> > > Hello Greg,
> > > Please don't pick this change yet. I have shared the reason in the other
> > > thread:
> > > "Re: Patch "tools/hv: fcopy: Fix irregularities with size of ring buffer"
> > > has been added to the 6.12-stable tree"
> > 
> > Ok, I have dropped this from the 6.12.y tree now.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hello Greg,
> Can you please consider picking this change for next release of 6.12 kernel.
> The dependent change [1] is now part of 6.12 kernel, so we need this change
> to fix fcopy in 6.12 kernel.
> 
> [1]: Drivers: hv: Make the sysfs node size for the ring buffer dynamic

What are the exact git commit ids you want to have applied here?  [1]
does not reference much to me :)

thanks,

greg k-h
