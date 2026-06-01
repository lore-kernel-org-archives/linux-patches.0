Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D73DA5CE;
	Mon,  1 Jun 2026 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326767; cv=none; b=YIFu4OFe6jZ846ciuHDTuxphEjYSp7w96bI2wS7Co0pSYD1GRw1CR6dUE3laYwoxdevOQyHoUWXvCC69WN/9sM53mzRZsZMsVu4dJvRFljtAd9hdh1lN515EEaQp9u0zYicS6yueTOdEPIp38f7YIHC1qryFamZrD6lnavh7GYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326767; c=relaxed/simple;
	bh=qWMA9PncXlAoyab0260y8B0+Du9krratMRZK3VnXuxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mdZlN8pr83zb2ipBjGeZB8sG+nNxoZvKUFyzREo4aLfviqYNeZIIBjiO/bWakk052EFSGvNG3WoKFNUpzJN3/FSCC4P7s7+drbhyP93A7kUPvgYT977f1tKjUrGFj1LI/7HDbF2ohzdc+BOAFUtubjfLPuWobWTj+n13gXOFvC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xdc61XGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xdc61XGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B01F00893;
	Mon,  1 Jun 2026 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780326765;
	bh=ZlX9orUtgt30raHGN+qq6+45w2Xgtxs4uevFTgEUcxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xdc61XGnoyyWwb9/s/rJMLJHR8RXYZcLJfYswBFpAaLS54t6kQyXEvCkKVCzH2hRX
	 IsuiwcAxvZnU8VZWITvXL5D6KFYorrl9wIn6bsc62WJQl4+A/jma4gZ+Fg12CU/mbA
	 J83E3GyoY4hLLq2sKHuSM+uci8FRSdoAJrTuU2jg=
Date: Mon, 1 Jun 2026 17:11:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>, Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.10 210/589] spi: rockchip: fix controller deregistration
Message-ID: <2026060156-siesta-obscurity-1492@gregkh>
References: <20260530160224.570625122@linuxfoundation.org>
 <20260530160230.478262786@linuxfoundation.org>
 <211fb901ba2c644e6ebdffe46d9face7e317db70.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <211fb901ba2c644e6ebdffe46d9face7e317db70.camel@decadent.org.uk>

On Mon, Jun 01, 2026 at 01:16:06PM +0200, Ben Hutchings wrote:
> On Sat, 2026-05-30 at 18:01 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johan Hovold <johan@kernel.org>
> > 
> > commit 53e7a16070feb7d1d4d81a583eaac5e25048b9c3 upstream.
> > 
> > Make sure to deregister the controller before freeing underlying
> > resources like DMA channels during driver unbind.
> > 
> > Fixes: 64e36824b32b ("spi/rockchip: add driver for Rockchip RK3xxx SoCs integrated SPI")
> > Cc: stable@vger.kernel.org	# 3.17
> > Cc: addy ke <addy.ke@rock-chips.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Link: https://patch.msgid.link/20260324082326.901043-3-johan@kernel.org
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/spi/spi-rockchip.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > --- a/drivers/spi/spi-rockchip.c
> > +++ b/drivers/spi/spi-rockchip.c
> > @@ -792,7 +792,7 @@ static int rockchip_spi_probe(struct pla
> >  		ctlr->can_dma = rockchip_spi_can_dma;
> >  	}
> >  
> > -	ret = devm_spi_register_controller(&pdev->dev, ctlr);
> > +	ret = spi_register_controller(ctlr);
> >  	if (ret < 0) {
> >  		dev_err(&pdev->dev, "Failed to register controller\n");
> >  		goto err_free_dma_rx;
> > @@ -828,6 +828,8 @@ static int rockchip_spi_remove(struct pl
> >  	clk_disable_unprepare(rs->spiclk);
> >  	clk_disable_unprepare(rs->apb_pclk);
> >  
> > +	spi_unregister_controller(ctlr);
> 
> This needs to be inserted above the clk_disable_unprepare()s.

Ick, ok, let me drop this for now.
