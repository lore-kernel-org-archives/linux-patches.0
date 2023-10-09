Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5FD347D0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9jCsMx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7BFC433C7;
	Mon,  9 Oct 2023 18:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696874799;
	bh=lCspL3UrUtDyA1LDGzHu/7/pVV250YgXZCnkR/UFNG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q9jCsMx3x8rOdHkcMMLrmhA+i4hTqOVusmanwf3i+EJDl0vtp9ZNpLtpyFshUBKrE
	 JsNxYB+abeEGJdcwh6d0/DSoGhsAKxBbQEsyz8cNtIZWNHGn3JNbPLJO8s/NHdtYN2
	 ij644K5jTvAE7F+vyHzHoy6RYvlMs7szDj8/BVOw=
Date: Mon, 9 Oct 2023 20:06:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
	kernel@pengutronix.de
Subject: Re: [PATCH 6.1 001/162] spi: zynqmp-gqspi: Convert to platform
 remove callback returning void
Message-ID: <2023100919-rehire-reflector-1bf3@gregkh>
References: <20231009130122.946357448@linuxfoundation.org>
 <20231009130122.990256512@linuxfoundation.org>
 <20231009154949.33tpn4fsbacllhme@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231009154949.33tpn4fsbacllhme@pengutronix.de>

On Mon, Oct 09, 2023 at 05:49:49PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Mon, Oct 09, 2023 at 02:59:42PM +0200, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > [ Upstream commit 3ffefa1d9c9eba60c7f8b4a9ce2df3e4c7f4a88e ]
> > 
> > The .remove() callback for a platform driver returns an int which makes
> > many driver authors wrongly assume it's possible to do error handling by
> > returning an error code. However the value returned is (mostly) ignored
> > and this typically results in resource leaks. To improve here there is a
> > quest to make the remove callback return void. In the first step of this
> > quest all drivers are converted to .remove_new() which already returns
> > void.
> > 
> > Trivially convert this driver from always returning zero in the remove
> > callback to the void returning variant.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Link: https://lore.kernel.org/r/20230303172041.2103336-88-u.kleine-koenig@pengutronix.de
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Stable-dep-of: 1527b076ae2c ("spi: zynqmp-gqspi: fix clock imbalance on probe failure")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> While I don't think this patch is dangerous to backport, the more
> conservative option of directly applying 1527b076ae2c would have been
> the one I'd chosen.
> 
> The simple(?) conflict resolution for picking 1527b076ae2c on top of
> v6.1.56 looks as follows:
> 
> diff --cc drivers/spi/spi-zynqmp-gqspi.c
> index c760aac070e5,c309dedfd602..000000000000
> --- a/drivers/spi/spi-zynqmp-gqspi.c
> +++ b/drivers/spi/spi-zynqmp-gqspi.c
> @@@ -1244,20 -1368,17 +1244,24 @@@ static int zynqmp_qspi_remove(struct pl
>   {
>   	struct zynqmp_qspi *xqspi = platform_get_drvdata(pdev);
>   
> + 	pm_runtime_get_sync(&pdev->dev);
> + 
>   	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
> + 
> + 	pm_runtime_disable(&pdev->dev);
> + 	pm_runtime_put_noidle(&pdev->dev);
> + 	pm_runtime_set_suspended(&pdev->dev);
>   	clk_disable_unprepare(xqspi->refclk);
>   	clk_disable_unprepare(xqspi->pclk);
> - 	pm_runtime_set_suspended(&pdev->dev);
> - 	pm_runtime_disable(&pdev->dev);
>  +
>  +	return 0;
>   }
>   
>  +static const struct of_device_id zynqmp_qspi_of_match[] = {
>  +	{ .compatible = "xlnx,zynqmp-qspi-1.0", },
>  +	{ /* End of table */ }
>  +};
>  +
>   MODULE_DEVICE_TABLE(of, zynqmp_qspi_of_match);
>   
>   static struct platform_driver zynqmp_qspi_driver = {
> 

Agreed, I've dropped the one patch and fixed this one up to look like
this, thanks.

greg k-h
