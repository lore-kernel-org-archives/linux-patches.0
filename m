Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A61530DD3F;
	Thu, 11 Sep 2025 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601777; cv=none; b=Y6SFkTLCVRtiR3JQVHgnrEEWSp73qQHT1fgGA3TZdqpHMR2lzzaWPnX9kYlXRq4XK9xRohUWCi9wSHR3b3NgLZPk2+2fmvdsrNG8Yl6cAfYQQ5Okin93A4xBlgov6lA7mcuE7tJI9IoWvZzLoUUsPgNeUnFVVOL8m1FCZYE7Yyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601777; c=relaxed/simple;
	bh=02AVT6CAPbGP5VMxs27iRmrgwy+I8yTvzBgVHYALK9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iIXLliBvlCsaoIKcY9/RSeOedhiEOkbyAV9IYp4fDfseXz6z5801s63BhzNlnIcfR0fUSQFrDzE3QK1ymBAw59/UcQGPvg+pDB6OLSMsYDAEBDRoLOcq8gbwlrHCk60v8Svse9kyGPVdL53v+mUoQn9cL1ebLSZVMsjK3keY+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBT8hQwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBT8hQwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE93C4CEF0;
	Thu, 11 Sep 2025 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757601777;
	bh=02AVT6CAPbGP5VMxs27iRmrgwy+I8yTvzBgVHYALK9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UBT8hQwqmPMmGijDyv13CmGH0TKwLENZXm3vXdnIZ8t2u612evrEN83gntQUHpkco
	 3Q/zxXQolg74wj8nP0nLQtYjLyPRpCXovypVd1q/Ex0bLRrUnOkfxHjbQQp8B/7+tM
	 ZWGN1D3eiHKEwBLZqExGYXQqzlv3diVB/G+1vL70=
Date: Thu, 11 Sep 2025 16:42:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jun Eeo <jeeo@janestreet.com>
Cc: hch@lst.de, martin.petersen@oracle.com, patches@lists.linux.dev,
	riel@surriel.com, sashal@kernel.org, stable@vger.kernel.org,
	tsi@tuyoix.net
Subject: Re: [PATCH 6.1 035/198] scsi: core: Use GFP_NOIO to avoid circular
 locking dependency
Message-ID: <2025091136-aside-tissue-59a7@gregkh>
References: <20250325122157.561309561@linuxfoundation.org>
 <20250911143517.525874-1-jeeo@janestreet.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911143517.525874-1-jeeo@janestreet.com>

On Thu, Sep 11, 2025 at 03:35:17PM +0100, Jun Eeo wrote:
> Hi -
> 
> With this patch, we've been seeing a small number of machines in our
> fleet boot up but are not able to register a SCSI device:
> 
> [    6.290992] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> 
> It usually goes away upon another reboot. I don't have a reliable
> reproducer except for rebooting some servers repeatedly on 6.1.132.
> 
> I added a couple of printks around the various cases where scsi_alloc_sdev
> fails, as there are 3 allocation sites, and also pulled in f7d77dfc91
> ("mm/percpu.c: print error message too if atomic alloc failed"),
> and isolated it to a failed percpcu allocation:
> 
> [    5.431189] percpu: allocation failed, size=4 align=4 atomic=1, atomic alloc failed, no space left
> [    5.440383] sbitmap_init_node: init_alloc_hint failed.
> [    5.440383] scsi_realloc_sdev_budget_map: sbitmap_init_node failed with -12
> 
> Which kind of makes sense, as __alloc_percpu_gfp says:
> 
> > If @gfp doesn't contain %GFP_KERNEL, the allocation doesn't block
> > and can be called from any context but is a lot more likely to fail.
> 
> Reverting this patch in our environment made the initial SCSI scan
> reliably work, and we no longer see issues with the SCSI drive
> disappearing.
> 

Is this also a problem for you in newer kernels, like 6.16.y?

thanks,

greg k-h
