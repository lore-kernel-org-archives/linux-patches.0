Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A4092E410
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 20:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.14.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712002609; cv=none; b=LSZpVdLrLxqR2lQ7UhjgPjtjHA0toJ0Re9wKfOoqT+nMAYd5e7dxbUi8jM3dtruOODoIRCh+RgMxDQks3v3phX+X9XpU2GZnxbZHC5SKLBkfhNNq6qxzH+1dcEIrBoONenjUV8E3digiNUP+NkOSMQETVJxDji1WKMX/xVo5Jgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712002609; c=relaxed/simple;
	bh=SORi5A3PaecGgNK/AQh3YL3QC0/UJQp0Sf4kc1jG+XI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7fvPGrofKyZWXYUh5SsTeJZE9PEH+YB82DgjGQ6ULCnxWD6wqPDSpRjyib6y3xy5Pfscmf4HG+Wo7m8uh0umJYkm/gx0A6O5njlCpQlFa7ad1tMBCg3MBcOvqKSXBP1kNMJYS+AqLDtdXTIHS3zZenmggmXvFnrwdlrMhunNAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de; spf=pass smtp.mailfrom=c--e.de; arc=none smtp.client-ip=217.10.14.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=c--e.de
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id D5E061403C9; Mon,  1 Apr 2024 22:16:45 +0200 (CEST)
Date: Mon, 1 Apr 2024 22:16:45 +0200
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.1 251/272] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <ZgsWLUHW8nqUv7pi@cae.in-ulm.de>
References: <20240401152530.237785232@linuxfoundation.org>
 <20240401152538.859016197@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401152538.859016197@linuxfoundation.org>


Hi Greg,

On Mon, Apr 01, 2024 at 05:47:21PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Christian A. Ehrhardt <lk@c--e.de>
> 
> commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 upstream.
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
> 
> Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
> Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

This change has an out of bounds memory access. Please drop it from
the stable trees until a fix is available.

Sorry for the inconvenience!

> 
> --- a/drivers/usb/typec/ucsi/ucsi.c
> +++ b/drivers/usb/typec/ucsi/ucsi.c
> @@ -851,7 +851,7 @@ void ucsi_connector_change(struct ucsi *
>  	struct ucsi_connector *con = &ucsi->connector[num - 1];
>  
>  	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
> -		dev_dbg(ucsi->dev, "Bogus connector change event\n");
> +		dev_dbg(ucsi->dev, "Early connector change event\n");
>  		return;
>  	}
>  
> @@ -1210,6 +1210,7 @@ static int ucsi_init(struct ucsi *ucsi)
>  {
>  	struct ucsi_connector *con, *connector;
>  	u64 command, ntfy;
> +	u32 cci;
>  	int ret;
>  	int i;
>  
> @@ -1262,6 +1263,13 @@ static int ucsi_init(struct ucsi *ucsi)
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

Best regards
Christian

