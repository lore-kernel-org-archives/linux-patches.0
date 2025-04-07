Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47220258CFD;
	Mon,  7 Apr 2025 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744049542; cv=none; b=A9JaVdabj6iLucAnVge/4mp/OLAFyFr7gpdAbIP/kv5cgRage+TK3YrVaYZIidCq7uO1onGMXweOtMvbLMKSAV0vCKKWTS1V9lGWfF1NIvSUN8hWpZlgR1CK7Yc7sOIzU+I110p6JXacb6btURIj432yrpl5tZY/mP8FhYnBFjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744049542; c=relaxed/simple;
	bh=ckzOI7nJaN7g69N2eDE8aCNzMRLv/2qrZ2SIJBhjrjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFrZMzQtRr8fwUovqwfSB9FQCyzf1WV/Y3Z2Kld1PUev1TpR4E9X3WdtCqQpjHg1VXY+wLCRd/vZhmQJAHkkeYTVdCWzuuDWdSXotrNrWOVldVOXVAmwa1O7TRBgDSZn+73PWzxpPxAOKzJ4LDvV3kyPkE+QbsYx/gf3eWkl+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFCadevX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFCadevX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5966C4CEDD;
	Mon,  7 Apr 2025 18:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744049542;
	bh=ckzOI7nJaN7g69N2eDE8aCNzMRLv/2qrZ2SIJBhjrjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gFCadevXmolJqSp+yC2kfDJXud/RE9YHWsnv2S49+HDvsBrRk6pPPIh9GhlUAaCKr
	 2Z4OlqhM/rYu6Uf6ye1OHK8ClfIssRIm4t/pI/hBzWOeA52Xag4s2rIcD0S3I4l2Zk
	 MujLsmDaRyqsEQ6Mx7DE0w14wg75juT2pEEe1bxcp7wssjSl211WRBIIZrhCiaAeZz
	 +PlFJsKDWHfjjwe9Dh/4on3CegDNptzUzHACmi2nz1usJsIpe4fXJoeq+YVo/TDGGt
	 GpE0bQQZ42/9d/fI7P/Xdi/nMWq12DJilcToKgV+uRVkNc+pDqOvdQ6jIBt5Ja8j39
	 wkpMRfvVI7LHg==
Date: Mon, 7 Apr 2025 11:12:18 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 051/198] Xen/swiotlb: mark xen_swiotlb_fixup() __init
Message-ID: <20250407181218.GA737271@ax162>
References: <20250325122156.633329074@linuxfoundation.org>
 <20250325122157.975417185@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325122157.975417185@linuxfoundation.org>

Hi Greg,

On Tue, Mar 25, 2025 at 08:20:13AM -0400, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jan Beulich <jbeulich@suse.com>
> 
> [ Upstream commit 75ad02318af2e4ae669e26a79f001bd5e1f97472 ]
> 
> It's sole user (pci_xen_swiotlb_init()) is __init, too.

This is not true in 6.1 though... which results in:

  WARNING: modpost: vmlinux.o: section mismatch in reference: pci_xen_swiotlb_init_late (section: .text) -> xen_swiotlb_fixup (section: .init.text)

Perhaps commit f9a38ea5172a ("x86: always initialize xen-swiotlb when
xen-pcifront is enabling") and its dependency 358cd9afd069 ("xen/pci:
add flag for PCI passthrough being possible") should be added (I did not
test if they applied cleanly though) but it seems like a revert would be
more appropriate. I don't see this change as a dependency of another one
and the reason it exists upstream does not apply in this tree so why
should it be here?

Cheers,
Nathan

> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
> 
> Message-ID: <e1198286-99ec-41c1-b5ad-e04e285836c9@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/xen/swiotlb-xen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 0893c1012de62..fe52c8cbf1364 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -112,7 +112,7 @@ static int is_xen_swiotlb_buffer(struct device *dev, dma_addr_t dma_addr)
>  }
>  
>  #ifdef CONFIG_X86
> -int xen_swiotlb_fixup(void *buf, unsigned long nslabs)
> +int __init xen_swiotlb_fixup(void *buf, unsigned long nslabs)
>  {
>  	int rc;
>  	unsigned int order = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT);
> -- 
> 2.39.5
> 
> 
> 
