Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A457938B;
	Mon, 18 Nov 2024 00:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731890021; cv=none; b=emug/i3rIZOxt2emEjlP++zoR8LXxxPU30sQvGGaaeD7VG7YmrQj5TlMgiecK6ifEmZ+g69wX25fU218cO0DtUSISozE7F4krLaJ8fWAFaSL3gpsQ/SEcvjmi9doRm+a3fSUKIcICc6ZoZDAnhkm5J0YRd6dj1ehVoEct21Lwq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731890021; c=relaxed/simple;
	bh=4o7AaiKx3ZvS0Vwau9DJqN/91vmE5tPtIoRZxRbu9Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbCq86PeDNh9+uOKtllpmyEzXdo8FwajrCxrbAjHtjrZLfPVmtwi4dR21BddNboNOk0bYJd7j2ivvoxlwSAJ04XNjJbUUQAW4KOjM0Wh1YsRERssfuFF3YKaVCUWIH4Wygzetg9LDIXDiW+Mr/IDCgPyrtwzSnBDvVsM3DvE1TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHdzRbNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHdzRbNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF3AC4CECD;
	Mon, 18 Nov 2024 00:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731890020;
	bh=4o7AaiKx3ZvS0Vwau9DJqN/91vmE5tPtIoRZxRbu9Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHdzRbNqrXQu/c3AiO/chH8UsOMlUjdeF1OKv66qK7Zefl24vZAOa9s2IJgGFOUJX
	 8/AZJElqcEsW1RkNigkB0yoZxuzWivEwEYLZsyB6jCI7qQ37R3Mt+Pd31ExlEnbn3n
	 qLbx+ycE2B2k1NXIPFLzaI79pcy59N5tYhshYt5lNzNAMlW7ieNHjL9fd+E2ROPjbx
	 gmJjcvXebjniIx0CU0u8iED6O4fZS1dIhutAIGRaNZzGJNzIF6Sk6RBe1B0IvxNZYj
	 GjL+uRXS7s3nmgxKmzAtprndpkEX1N7DLNTSuRHh/jbHrE1kncbw4xTiUHIyPpSNwq
	 XC6WzH+Kgw7+w==
Date: Sun, 17 Nov 2024 17:33:38 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	llvm@lists.linux.dev
Subject: Re: [PATCH 6.11 066/184] media: dvbdev: prevent the risk of out of
 memory access
Message-ID: <20241118003338.GA3311143@thelio-3990X>
References: <20241112101900.865487674@linuxfoundation.org>
 <20241112101903.395286793@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112101903.395286793@linuxfoundation.org>

On Tue, Nov 12, 2024 at 11:20:24AM +0100, Greg Kroah-Hartman wrote:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> 
> [ Upstream commit 972e63e895abbe8aa1ccbdbb4e6362abda7cd457 ]
> 
> The dvbdev contains a static variable used to store dvb minors.
> 
> The behavior of it depends if CONFIG_DVB_DYNAMIC_MINORS is set
> or not. When not set, dvb_register_device() won't check for
> boundaries, as it will rely that a previous call to
> dvb_register_adapter() would already be enforcing it.
> 
> On a similar way, dvb_device_open() uses the assumption
> that the register functions already did the needed checks.
> 
> This can be fragile if some device ends using different
> calls. This also generate warnings on static check analysers
> like Coverity.
> 
> So, add explicit guards to prevent potential risk of OOM issues.
> 
> Fixes: 5dd3f3071070 ("V4L/DVB (9361): Dynamic DVB minor allocation")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/media/dvb-core/dvbdev.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index b43695bc51e75..14f323fbada71 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -86,10 +86,15 @@ static DECLARE_RWSEM(minor_rwsem);
>  static int dvb_device_open(struct inode *inode, struct file *file)
>  {
>  	struct dvb_device *dvbdev;
> +	unsigned int minor = iminor(inode);
> +
> +	if (minor >= MAX_DVB_MINORS)
> +		return -ENODEV;
>  
>  	mutex_lock(&dvbdev_mutex);
>  	down_read(&minor_rwsem);
> -	dvbdev = dvb_minors[iminor(inode)];
> +
> +	dvbdev = dvb_minors[minor];
>  
>  	if (dvbdev && dvbdev->fops) {
>  		int err = 0;
> @@ -525,7 +530,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
>  	for (minor = 0; minor < MAX_DVB_MINORS; minor++)
>  		if (!dvb_minors[minor])
>  			break;
> -	if (minor == MAX_DVB_MINORS) {
> +	if (minor >= MAX_DVB_MINORS) {
>  		if (new_node) {
>  			list_del(&new_node->list_head);
>  			kfree(dvbdevfops);
> @@ -540,6 +545,14 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
>  	}
>  #else
>  	minor = nums2minor(adap->num, type, id);
> +	if (minor >= MAX_DVB_MINORS) {
> +		dvb_media_device_free(dvbdev);
> +		list_del(&dvbdev->list_head);
> +		kfree(dvbdev);
> +		*pdvbdev = NULL;
> +		mutex_unlock(&dvbdev_register_lock);
> +		return ret;

This needs commit a4aebaf6e6ef ("media: dvbdev: fix the logic when
DVB_DYNAMIC_MINORS is not set"), otherwise there is a warning with
certain configurations when building with clang:

  drivers/media/dvb-core/dvbdev.c:554:10: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
    554 |                 return ret;
        |                        ^~~
  drivers/media/dvb-core/dvbdev.c:463:13: note: initialize the variable 'ret' to silence this warning
    463 |         int id, ret;
        |                    ^
        |                     = 0
  1 warning generated.

I was somewhat surprised when this warning showed up in my stable
builds, until I realized that change does not have a Fixes tag like it
really should have...

Cheers,
Nathan

> +	}
>  #endif

>  	dvbdev->minor = minor;
>  	dvb_minors[minor] = dvb_device_get(dvbdev);
> -- 
> 2.43.0
> 
> 
> 
