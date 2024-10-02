Received: from mail.thorsis.com (mail.thorsis.com [217.92.40.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280961D1E6B
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.92.40.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877575; cv=none; b=ovEakOVjseU1LJUnlu8CmW5OA6Pcxxg2jPlFl0w14UCnViDoTU4Ceak8m9JOOZdu9ufJpljbUhIESxq0MsSPMYYLOtsJxPoYWlBxKH8AqB8a6ng84qVRouz6NgIkM+SMW206QhsU6fFvKkrbgvVPRwRb2HQ3tPBTJWNZ526jZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877575; c=relaxed/simple;
	bh=IaNMjnZJy0z1wxvhoru6iUhYjySK8Jt/5xB/5jNuul8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMNHMzdsv2mIHWYr6MjZ4Az9lVC45JkSlc1TqXLtIN9qzjqyuCGRsEsYf63uCteTY4/yu8+j5uxIM4TVWva3owGfa6ceYdgcYlCugJlyRBQzpKjJ22v3XsaM1EkzEepCxWzb+7VkTT9MfYJIJEIt5tI/uqF01aDyUDrskiasSo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorsis.com; spf=pass smtp.mailfrom=thorsis.com; dkim=pass (2048-bit key) header.d=thorsis.com header.i=@thorsis.com header.b=eZp4W4TY; arc=none smtp.client-ip=217.92.40.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorsis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorsis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorsis.com header.i=@thorsis.com header.b="eZp4W4TY"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 52A321483606;
	Wed,  2 Oct 2024 15:59:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thorsis.com; s=dkim;
	t=1727877569; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=+liSgV+9gvc3i9IzqEkP6EiXi0aKY8uKnmPTc1RyS4Q=;
	b=eZp4W4TYnSJotbI46XjT/VQg8nN0BskkGvTfxbvrOiWJ0fFInp4NqQ/j+rh8PZI1dpg24c
	PCpHhn8P3JUjh3ZF8vnXrjN0SAv/1GZimEQ9qUT1qhYyjhmPc+pq1iIxKZrjxWFdVu7V/f
	hz2Xa+YucDCvZ+17nFLbP/22gKtsO237gVtGybSUFCtjTyzp/OwcQa7Ho1iV12DQj9rqSO
	wllfrj/mWiwtG3Z3Z755DWHWnv1YEuiw8qnB8vE3tQ4ibvdeVI2raFWc/WIEaRib6z2oOj
	IBic+SHzMUud6IcxEiMIwnn+ivGJZhkjP2Uibo472gZPbNido+aVso/nScO5Dw==
Date: Wed, 2 Oct 2024 15:59:26 +0200
From: Alexander Dahl <ada@thorsis.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>, Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 451/695] spi: atmel-quadspi: Avoid overwriting delay
 register settings
Message-ID: <20241002-alarm-freedom-16ab0ea3305f@thorsis.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125840.462311087@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002125840.462311087@linuxfoundation.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Last-TLS-Session-Version: TLSv1.3

Hello Greg,

Am Wed, Oct 02, 2024 at 02:57:29PM +0200 schrieb Greg Kroah-Hartman:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alexander Dahl <ada@thorsis.com>
> 
> [ Upstream commit 329ca3eed4a9a161515a8714be6ba182321385c7 ]
> 
> Previously the MR and SCR registers were just set with the supposedly
> required values, from cached register values (cached reg content
> initialized to zero).
> 
> All parts fixed here did not consider the current register (cache)
> content, which would make future support of cs_setup, cs_hold, and
> cs_inactive impossible.
> 
> Setting SCBR in atmel_qspi_setup() erases a possible DLYBS setting from
> atmel_qspi_set_cs_timing().  The DLYBS setting is applied by ORing over
> the current setting, without resetting the bits first.  All writes to MR
> did not consider possible settings of DLYCS and DLYBCT.
> 
> Signed-off-by: Alexander Dahl <ada@thorsis.com>
> Fixes: f732646d0ccd ("spi: atmel-quadspi: Add support for configuring CS timing")
> Link: https://patch.msgid.link/20240918082744.379610-2-ada@thorsis.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/spi/atmel-quadspi.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
> index 466c01b31123b..b557ce94da209 100644
> --- a/drivers/spi/atmel-quadspi.c
> +++ b/drivers/spi/atmel-quadspi.c
> @@ -375,9 +375,9 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
>  	 * If the QSPI controller is set in regular SPI mode, set it in
>  	 * Serial Memory Mode (SMM).
>  	 */
> -	if (aq->mr != QSPI_MR_SMM) {
> -		atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
> -		aq->mr = QSPI_MR_SMM;
> +	if (!(aq->mr & QSPI_MR_SMM)) {
> +		aq->mr |= QSPI_MR_SMM;
> +		atmel_qspi_write(aq->scr, aq, QSPI_MR);

This is a write to a wrong register, it was already fixed with
<20240926090356.105789-1-ada@thorsis.com> [1] which was taken by Mark
into the spi for-next tree.  If you take this patch, please also take
the fixup!  Sorry for messing this up, that was my fault.

(Note: I'm AFK from tomorrow until October 13th.)

Thanks
Alex

[1] https://lore.kernel.org/linux-spi/20240926090356.105789-1-ada@thorsis.com/T/#u

>  	}
>  
>  	/* Clear pending interrupts */
> @@ -501,7 +501,8 @@ static int atmel_qspi_setup(struct spi_device *spi)
>  	if (ret < 0)
>  		return ret;
>  
> -	aq->scr = QSPI_SCR_SCBR(scbr);
> +	aq->scr &= ~QSPI_SCR_SCBR_MASK;
> +	aq->scr |= QSPI_SCR_SCBR(scbr);
>  	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
>  
>  	pm_runtime_mark_last_busy(ctrl->dev.parent);
> @@ -534,6 +535,7 @@ static int atmel_qspi_set_cs_timing(struct spi_device *spi)
>  	if (ret < 0)
>  		return ret;
>  
> +	aq->scr &= ~QSPI_SCR_DLYBS_MASK;
>  	aq->scr |= QSPI_SCR_DLYBS(cs_setup);
>  	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
>  
> @@ -549,8 +551,8 @@ static void atmel_qspi_init(struct atmel_qspi *aq)
>  	atmel_qspi_write(QSPI_CR_SWRST, aq, QSPI_CR);
>  
>  	/* Set the QSPI controller by default in Serial Memory Mode */
> -	atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
> -	aq->mr = QSPI_MR_SMM;
> +	aq->mr |= QSPI_MR_SMM;
> +	atmel_qspi_write(aq->mr, aq, QSPI_MR);
>  
>  	/* Enable the QSPI controller */
>  	atmel_qspi_write(QSPI_CR_QSPIEN, aq, QSPI_CR);
> -- 
> 2.43.0
> 
> 
> 
> 
