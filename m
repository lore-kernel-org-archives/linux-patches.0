Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4773BB20;
	Wed, 21 Feb 2024 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708503147; cv=none; b=T0U9+0NOE2ZH9hxve2iNpvOIPoKtCsEkhBEgUry08qulDKSZBvEaeXm3TlWfqOBf19yTJZYgCrOq3Hlz3mrbquMWd3RESJw9d6wVb+AzD/vU0Tzb4UWWqJ8iPLqPZrj+XgLBmgRe7jryvk3OtHB6/LVgtgWOQV4dWhfHcimQ2+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708503147; c=relaxed/simple;
	bh=tF9us0osjA8UAzi6uxg3WrpUIErIZ2KZwm0EljYWe74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FU9iLGNdKWfwJg4GsLnye/afhnhHprEmqbALIg5kN43queTInKHcKd9Yz8O76/NbJ+0cvJtb2h5J+VCOSHZWNAw+a69Gp7qel3/YeLb98pNDfpuOua/1I7Ca9c3E8TS++3LrDXJsXkcnsl6mJ6MIaDSuTiT4NZ/m/0WY4c2haxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAG/Kaed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAG/Kaed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6962EC433C7;
	Wed, 21 Feb 2024 08:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708503147;
	bh=tF9us0osjA8UAzi6uxg3WrpUIErIZ2KZwm0EljYWe74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iAG/Kaedrs9CHnmzxV5wN/sdwSFL5kUayYB7fOj8tibQeJ8lVxDwOCcvZ5e1HDUt6
	 Eyw9bYD/Vc3XQ6ewNzogljwTx5dHsG/B8zeRg4++a07dNrAscNEIyB5OK1WoFTE4y1
	 lgyMZ5ogGwAn912cRhZhZtZ9HOOABpXu/uizL450=
Date: Wed, 21 Feb 2024 09:12:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>, Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 174/197] wifi: mwifiex: Support SD8978 chipset
Message-ID: <2024022106-speculate-scallion-67a7@gregkh>
References: <20240220204841.073267068@linuxfoundation.org>
 <20240220204846.279064097@linuxfoundation.org>
 <20240221080353.GB5131@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221080353.GB5131@francesco-nb>

On Wed, Feb 21, 2024 at 09:03:53AM +0100, Francesco Dolcini wrote:
> On Tue, Feb 20, 2024 at 09:52:13PM +0100, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Lukas Wunner <lukas@wunner.de>
> > 
> > [ Upstream commit bba047f15851c8b053221f1b276eb7682d59f755 ]
> > 
> > The Marvell SD8978 (aka NXP IW416) uses identical registers as SD8987,
> > so reuse the existing mwifiex_reg_sd8987 definition.
> > 
> > Note that mwifiex_reg_sd8977 and mwifiex_reg_sd8997 are likewise
> > identical, save for the fw_dump_ctrl register:  They define it as 0xf0
> > whereas mwifiex_reg_sd8987 defines it as 0xf9.  I've verified that
> > 0xf9 is the correct value on SD8978.  NXP's out-of-tree driver uses
> > 0xf9 for all of them, so there's a chance that 0xf0 is not correct
> > in the mwifiex_reg_sd8977 and mwifiex_reg_sd8997 definitions.  I cannot
> > test that for lack of hardware, hence am leaving it as is.
> > 
> > NXP has only released a firmware which runs Bluetooth over UART.
> > Perhaps Bluetooth over SDIO is unsupported by this chipset.
> > Consequently, only an "sdiouart" firmware image is referenced, not an
> > alternative "sdsd" image.
> > 
> > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > Signed-off-by: Kalle Valo <kvalo@kernel.org>
> > Link: https://lore.kernel.org/r/536b4f17a72ca460ad1b07045757043fb0778988.1674827105.git.lukas@wunner.de
> > Stable-dep-of: 1c5d463c0770 ("wifi: mwifiex: add extra delay for firmware ready")
> 
> I would drop this and 1c5d463c0770.

Why?  Commit 1c5d463c0770 was explicitly tagged for stable inclusion,
what changed?

thanks,

greg k-h
