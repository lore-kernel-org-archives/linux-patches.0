Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4A55228;
	Wed, 21 Feb 2024 10:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708511592; cv=none; b=rmV8ngeqXZXx0H2gUHTrrQjR8O4mHt4D94/FjTsdWu0n/gHadNtr3qwNN/HCNkjrUj2e8sFUm8vNrDGQ4XYwpN8oUb7Vmo1pUDi0tcOdbF09Q5Ibkgf07XPP/+z10KtRjPeQoGxL6PYdwKuPjaJb5nGk31sPJJOr5Dsz6zoh/Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708511592; c=relaxed/simple;
	bh=wBmpAvypePMGkIr64sby2PVZroYKG6tZ/uT/sRxVsCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+RZRFa2xAUSXkuRUk4KbEpo1T7LNkOvQ520yhw80swF4fax44wGsJqI1DLCrRQTpQv1Iqel1Li2hZhl672t423xLbHO9lDMNRiBrckMeThzm7r1OvSkTGiQdDIFMuMg0+6GRkLdG5zdQdlcJw45LV4UeBArC/rKG0v+Ol1m48w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSZpk8tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSZpk8tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1E5C433F1;
	Wed, 21 Feb 2024 10:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708511592;
	bh=wBmpAvypePMGkIr64sby2PVZroYKG6tZ/uT/sRxVsCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tSZpk8tri2tl/8IMrs+lD1pVMj3Bf4dQXWUMZzYf7PdI4pCeNODVpgKdVS4KG9CRa
	 vDleH5viYPTSufxHeZpKmIro4z9N3zOM+xjnnZ8W6dqqrKqDiaudLW7rnrXgx8Zh0k
	 rJSsMcdQfhbjVAYriBiu3HKEYFGLqvtDN6E6x2Zc=
Date: Wed, 21 Feb 2024 11:33:08 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>, Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 174/197] wifi: mwifiex: Support SD8978 chipset
Message-ID: <2024022145-abnormal-evasive-c978@gregkh>
References: <20240220204841.073267068@linuxfoundation.org>
 <20240220204846.279064097@linuxfoundation.org>
 <20240221080353.GB5131@francesco-nb>
 <2024022106-speculate-scallion-67a7@gregkh>
 <20240221083904.GA5872@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221083904.GA5872@francesco-nb>

On Wed, Feb 21, 2024 at 09:39:04AM +0100, Francesco Dolcini wrote:
> On Wed, Feb 21, 2024 at 09:12:23AM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Feb 21, 2024 at 09:03:53AM +0100, Francesco Dolcini wrote:
> > > On Tue, Feb 20, 2024 at 09:52:13PM +0100, Greg Kroah-Hartman wrote:
> > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Lukas Wunner <lukas@wunner.de>
> > > > 
> > > > [ Upstream commit bba047f15851c8b053221f1b276eb7682d59f755 ]
> > > > 
> > > > The Marvell SD8978 (aka NXP IW416) uses identical registers as SD8987,
> > > > so reuse the existing mwifiex_reg_sd8987 definition.
> > > > 
> > > > Note that mwifiex_reg_sd8977 and mwifiex_reg_sd8997 are likewise
> > > > identical, save for the fw_dump_ctrl register:  They define it as 0xf0
> > > > whereas mwifiex_reg_sd8987 defines it as 0xf9.  I've verified that
> > > > 0xf9 is the correct value on SD8978.  NXP's out-of-tree driver uses
> > > > 0xf9 for all of them, so there's a chance that 0xf0 is not correct
> > > > in the mwifiex_reg_sd8977 and mwifiex_reg_sd8997 definitions.  I cannot
> > > > test that for lack of hardware, hence am leaving it as is.
> > > > 
> > > > NXP has only released a firmware which runs Bluetooth over UART.
> > > > Perhaps Bluetooth over SDIO is unsupported by this chipset.
> > > > Consequently, only an "sdiouart" firmware image is referenced, not an
> > > > alternative "sdsd" image.
> > > > 
> > > > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > > > Signed-off-by: Kalle Valo <kvalo@kernel.org>
> > > > Link: https://lore.kernel.org/r/536b4f17a72ca460ad1b07045757043fb0778988.1674827105.git.lukas@wunner.de
> > > > Stable-dep-of: 1c5d463c0770 ("wifi: mwifiex: add extra delay for firmware ready")
> > > 
> > > I would drop this and 1c5d463c0770.
> > 
> > Why?  Commit 1c5d463c0770 was explicitly tagged for stable inclusion,
> > what changed?
> 
> 1c5d463c0770 is a fix for bba047f15851c8b053221f1b276eb7682d59f755.
> 
> So there is no bug, unless bba047f15851c8b053221f1b276eb7682d59f755 is
> there.

It is.

> The mistake that we did at that time is that it should have been
> 
> Cc: stable@vger.kernel.org
> Fixes: bba047f15851 ("wifi: mwifiex: Support SD8978 chipset")

Great, that commit is currently in:
	6.3 queue-5.10 queue-5.15 queue-6.1
so all is good.

thanks,

greg k-h
