Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93F0143867
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.14.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712594174; cv=none; b=ZryP1wbg1V0rLPCzjEihg2lhZNEmyey2dtw9QbLFrv8LCjwaIH8wN9hZEw3I3tPGFdLTMwZeM5wAQqhNOS9wdKSSutw7yOew9ZaVdCkKug5pUMVLdItorwBuKlWVZFPMvwebyWd5Cpml9/lWBa57TRzbJSUHH/d6aC34OnJ2Gys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712594174; c=relaxed/simple;
	bh=CWWNwMNgAzKNmYdnyVzGseCF66ItLiQl0/7FAOyNL/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/WtDlmozqZ09toCRBP/dS9ZQJEOjqwR+ny+Ii23fo+Tw0K2IXZCf9LV4nZfxPu3tcnN08OmR1eW+H55DARLEms8Sl5v7+kPxe7hXTTvUyHWeOVKf9N+LC2fA19eVcDUMfCv5qEIXu017rOo2/1kqNEnjCjkCms34pn5lNW8dOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de; spf=pass smtp.mailfrom=c--e.de; arc=none smtp.client-ip=217.10.14.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=c--e.de
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id 8FDE814055D; Mon,  8 Apr 2024 18:36:08 +0200 (CEST)
Date: Mon, 8 Apr 2024 18:36:08 +0200
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.8 131/273] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <ZhQc+AoLGkrJB1to@cae.in-ulm.de>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125313.358936582@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408125313.358936582@linuxfoundation.org>


Hi Greg,

On Mon, Apr 08, 2024 at 02:56:46PM +0200, Greg Kroah-Hartman wrote:
> 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Christian A. Ehrhardt <lk@c--e.de>
> 
> [ Upstream commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 ]
> 
> The completion notification for the final SET_NOTIFICATION_ENABLE
> command during initialization can include a connector change
> notification.  However, at the time this completion notification is
> processed, the ucsi struct is not ready to handle this notification.
> As a result the notification is ignored and the controller
> never sends an interrupt again.
> 
> Re-check CCI for a pending connector state change after
> initialization is complete. Adjust the corresponding debug
> message accordingly.

As discussed previously, this one should not go into the stable
trees without the follow up fix that is in you usb-linus tree but
not yet in mainline. This applies to all stable branches. Let me
know if you want a separate mail for each branch.

Thanks
Christian

> Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
> Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/typec/ucsi/ucsi.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> index 0bfe5e906e543..96da828f556a9 100644
> --- a/drivers/usb/typec/ucsi/ucsi.c
> +++ b/drivers/usb/typec/ucsi/ucsi.c
> @@ -962,7 +962,7 @@ void ucsi_connector_change(struct ucsi *ucsi, u8 num)
>  	struct ucsi_connector *con = &ucsi->connector[num - 1];
>  
>  	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
> -		dev_dbg(ucsi->dev, "Bogus connector change event\n");
> +		dev_dbg(ucsi->dev, "Early connector change event\n");
>  		return;
>  	}
>  
> @@ -1393,6 +1393,7 @@ static int ucsi_init(struct ucsi *ucsi)
>  {
>  	struct ucsi_connector *con, *connector;
>  	u64 command, ntfy;
> +	u32 cci;
>  	int ret;
>  	int i;
>  
> @@ -1445,6 +1446,13 @@ static int ucsi_init(struct ucsi *ucsi)
>  
>  	ucsi->connector = connector;
>  	ucsi->ntfy = ntfy;
> +
> +	ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
> +	if (ret)
> +		return ret;
> +	if (UCSI_CCI_CONNECTOR(READ_ONCE(cci)))
> +		ucsi_connector_change(ucsi, cci);
> +
>  	return 0;
>  
>  err_unregister:
> -- 
> 2.43.0
> 
> 
> 
> 
