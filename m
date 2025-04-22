Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CE82638A9;
	Tue, 22 Apr 2025 08:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745311491; cv=none; b=O8+VOCt1vLk+FuMlTw+lVgI1W53sGm5WAJRHzxWkxBt1ogvfJhiOLEocHpGCibL7zozTuCoD/yJzvqqHKEGyyuI4ieZ3B/nzLk6A29gW54YjMBbqjLEgVbodtlsOhwjK7jgS/Ai63uDrOoyjZ++MegSrysLaXuhiWlsDLDz5EHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745311491; c=relaxed/simple;
	bh=YfYBYPoaL0jjj0LpzBYwTuA5lcq4ryN+A1gm/3RclHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLaO+yB8YfN3s6SzI6Kk5fhrT+2k1i5REmwr1xkBTBUeCcGnGGzZ113wR5/sNDXiyMo4p7cHLQyciq7NBVyyJu6G6odukF4Cjzm4oS6s9wp8zYPr1HJ6yoSnn8MlVitpzWbZak982o4wdOTLdFsV6fL/fxZVkOvlygraS4qbEDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=den9oPcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="den9oPcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C538AC4CEEA;
	Tue, 22 Apr 2025 08:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745311490;
	bh=YfYBYPoaL0jjj0LpzBYwTuA5lcq4ryN+A1gm/3RclHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=den9oPccglKzGh9MsHBbJtdXIjE0OcF2hpyRWv/A924Y0iMwxhgfTs7G+ULXs3lTU
	 CeUnQuDHNUNeNB2pa0xxUD+7J0kyZ3I9UFlH32B6WvVUaiBE/2WkdHiybHMtjQIHDy
	 wB5/KSpS5pn++yvBh95sei5cFwyGQxGT9bZfcy08=
Date: Tue, 22 Apr 2025 10:44:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jan Beulich <jbeulich@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 051/198] Xen/swiotlb: mark xen_swiotlb_fixup() __init
Message-ID: <2025042235-disown-gopher-01a1@gregkh>
References: <20250325122156.633329074@linuxfoundation.org>
 <20250325122157.975417185@linuxfoundation.org>
 <20250407181218.GA737271@ax162>
 <59eb2546-98c8-47e6-95e3-c7b4825cd86a@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59eb2546-98c8-47e6-95e3-c7b4825cd86a@suse.com>

On Tue, Apr 15, 2025 at 08:38:14AM +0200, Jürgen Groß wrote:
> On 07.04.25 20:12, Nathan Chancellor wrote:
> > Hi Greg,
> > 
> > On Tue, Mar 25, 2025 at 08:20:13AM -0400, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Jan Beulich <jbeulich@suse.com>
> > > 
> > > [ Upstream commit 75ad02318af2e4ae669e26a79f001bd5e1f97472 ]
> > > 
> > > It's sole user (pci_xen_swiotlb_init()) is __init, too.
> > 
> > This is not true in 6.1 though... which results in:
> > 
> >    WARNING: modpost: vmlinux.o: section mismatch in reference: pci_xen_swiotlb_init_late (section: .text) -> xen_swiotlb_fixup (section: .init.text)
> > 
> > Perhaps commit f9a38ea5172a ("x86: always initialize xen-swiotlb when
> > xen-pcifront is enabling") and its dependency 358cd9afd069 ("xen/pci:
> > add flag for PCI passthrough being possible") should be added (I did not
> > test if they applied cleanly though) but it seems like a revert would be
> > more appropriate. I don't see this change as a dependency of another one
> > and the reason it exists upstream does not apply in this tree so why
> > should it be here?
> 
> Right.
> 
> Greg, could you please remove this patch from the stable trees again?

Ick.  Now reverted, sorry about that.

greg k-h
