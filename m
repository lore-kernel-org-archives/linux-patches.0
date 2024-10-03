Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AFE1C32;
	Thu,  3 Oct 2024 07:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727939570; cv=none; b=HSKCPyDiEPWA5qylXlNQzSmzUMEqNLGPRzDf9NYRHvQivYccnwhHkoX17F1zmVn/CxDAUb+ehPS4UdAXh2oWs6QOxSohannviXvoM9nqrwINz9k5tv+fCeu1JYub6v+fL/8r/xjFCjw0BfvSSlUs4ESpgN28qpbbjBkER6kGvm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727939570; c=relaxed/simple;
	bh=/OBKbg4VHuhDk5e0rqVa9fggJ33vISeIqk7oP+5ke7w=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtI8/OPMh524FpL1Fi6Mha68jgwYXbmabwL61rTQGGZ9u42OaYGnJBmCmYXyM5NXUmw5RziV62m4fNMIES9kp5CnaYuUmls94P0EHQmXGAL4kN86BjYp/wLvoDmyw09GX4U/Aj5TZtErrnxVtJ2GfZ70oWEBawr+l4+hjcm/1VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGmOriGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGmOriGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0CDC4CEC7;
	Thu,  3 Oct 2024 07:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727939569;
	bh=/OBKbg4VHuhDk5e0rqVa9fggJ33vISeIqk7oP+5ke7w=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=FGmOriGuLkFDCwJefpcSTZjUy78xHf80mwbYvbFd+1JztcR+erCQV3xGldjnaFmAf
	 rjA8mJPvHvGgaTyPDbYrnXJrWh7A+R7sfaOO0QKn2Sz/MXlzu6T4OHfwdao+KlKrMQ
	 vuJZR3ygOILNNxbyriPKIBb5+/leLnO8cTtODpLI=
Date: Thu, 3 Oct 2024 09:12:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org, patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 451/695] spi: atmel-quadspi: Avoid overwriting delay
 register settings
Message-ID: <2024100338-refueling-nearest-6ef6@gregkh>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125840.462311087@linuxfoundation.org>
 <20241002-alarm-freedom-16ab0ea3305f@thorsis.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002-alarm-freedom-16ab0ea3305f@thorsis.com>

On Wed, Oct 02, 2024 at 03:59:26PM +0200, Alexander Dahl wrote:
> Hello Greg,
> 
> Am Wed, Oct 02, 2024 at 02:57:29PM +0200 schrieb Greg Kroah-Hartman:
> > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Alexander Dahl <ada@thorsis.com>
> > 
> > [ Upstream commit 329ca3eed4a9a161515a8714be6ba182321385c7 ]
> > 
> > Previously the MR and SCR registers were just set with the supposedly
> > required values, from cached register values (cached reg content
> > initialized to zero).
> > 
> > All parts fixed here did not consider the current register (cache)
> > content, which would make future support of cs_setup, cs_hold, and
> > cs_inactive impossible.
> > 
> > Setting SCBR in atmel_qspi_setup() erases a possible DLYBS setting from
> > atmel_qspi_set_cs_timing().  The DLYBS setting is applied by ORing over
> > the current setting, without resetting the bits first.  All writes to MR
> > did not consider possible settings of DLYCS and DLYBCT.
> > 
> > Signed-off-by: Alexander Dahl <ada@thorsis.com>
> > Fixes: f732646d0ccd ("spi: atmel-quadspi: Add support for configuring CS timing")
> > Link: https://patch.msgid.link/20240918082744.379610-2-ada@thorsis.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/spi/atmel-quadspi.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
> > index 466c01b31123b..b557ce94da209 100644
> > --- a/drivers/spi/atmel-quadspi.c
> > +++ b/drivers/spi/atmel-quadspi.c
> > @@ -375,9 +375,9 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
> >  	 * If the QSPI controller is set in regular SPI mode, set it in
> >  	 * Serial Memory Mode (SMM).
> >  	 */
> > -	if (aq->mr != QSPI_MR_SMM) {
> > -		atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
> > -		aq->mr = QSPI_MR_SMM;
> > +	if (!(aq->mr & QSPI_MR_SMM)) {
> > +		aq->mr |= QSPI_MR_SMM;
> > +		atmel_qspi_write(aq->scr, aq, QSPI_MR);
> 
> This is a write to a wrong register, it was already fixed with
> <20240926090356.105789-1-ada@thorsis.com> [1] which was taken by Mark
> into the spi for-next tree.  If you take this patch, please also take
> the fixup!  Sorry for messing this up, that was my fault.
> 
> (Note: I'm AFK from tomorrow until October 13th.)
> 
> Thanks
> Alex
> 
> [1] https://lore.kernel.org/linux-spi/20240926090356.105789-1-ada@thorsis.com/T/#u

Now queued up, thanks!

greg k-h
