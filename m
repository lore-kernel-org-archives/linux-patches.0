Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A861FA8D6;
	Fri,  3 Jan 2025 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735914267; cv=none; b=drJJJKL8Rn9k0TOwEXlAqh0N9AEJ5PtlJ3TA8tb9yagdueyqgeSmdfc7stzwm3bN6IFK+EIXgzHAWakh0ZmDHvN3tnt4Q1X4ParuwmE1Izp5kc75RfvY5jU4Az80jH0BVAdWmdCiRiF515X2RSU5AWZ/VihPqC7uyQrgRKgT8x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735914267; c=relaxed/simple;
	bh=cJhV01vvkdQGihtqL6AbdNDdrsAL+38nywAOHSb42Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9h87LsGySPxkPF8IAI2t9RlBRuzIi5MOZfsdXGjFaWTMMH/4SG1/Ev2uj/b/TMCymifYaEkczLOYBjB3yd+kiwXZrqS2lClolfFU/RbR/EDnPEa6BW7DZPFq4WS2gmvQ8Yl7rmPm1QvluX4SooXbJirb7UTd7x6lr280IJJhmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeaHo2+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeaHo2+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7FFC4CECE;
	Fri,  3 Jan 2025 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735914265;
	bh=cJhV01vvkdQGihtqL6AbdNDdrsAL+38nywAOHSb42Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GeaHo2+4csy0+w+o0Ull3FgBR4Qyg9X3dKM1Zw5j7ofd1tdY87IY4m2EL4UHD1aOm
	 10zkKMWUdi4kcDOArGPj7VnSGCBtMGKfxoePRA4yKSoZjT5isjacfrJkc5E2WrBFst
	 6/AeecW3BTVJXkQ9zDiXCkTKdE5vSRIQ3bRhqCYY=
Date: Fri, 3 Jan 2025 15:24:22 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, kxwang23@m.fudan.edu.cn,
	alexandre.belloni@bootlin.com, patches@lists.linux.dev,
	pgaj@cadence.com, linux-i3c@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] i3c: master: cdns: Fix use after free
 vulnerability in cdns_i3c_master Driver Due to Race Condition
Message-ID: <2025010316-natural-atlantic-f2d3@gregkh>
References: <20250103070420.64714-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250103070420.64714-1-jianqi.ren.cn@windriver.com>

On Fri, Jan 03, 2025 at 03:04:20PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Kaixin Wang <kxwang23@m.fudan.edu.cn>
> 
> [ Upstream commit 609366e7a06d035990df78f1562291c3bf0d4a12 ]
> 
> In the cdns_i3c_master_probe function, &master->hj_work is bound with
> cdns_i3c_master_hj. And cdns_i3c_master_interrupt can call
> cnds_i3c_master_demux_ibis function to start the work.
> 
> If we remove the module which will call cdns_i3c_master_remove to
> make cleanup, it will free master->base through i3c_master_unregister
> while the work mentioned above will be used. The sequence of operations
> that may lead to a UAF bug is as follows:
> 
> CPU0                                      CPU1
> 
>                                      | cdns_i3c_master_hj
> cdns_i3c_master_remove               |
> i3c_master_unregister(&master->base) |
> device_unregister(&master->dev)      |
> device_release                       |
> //free master->base                  |
>                                      | i3c_master_do_daa(&master->base)
>                                      | //use master->base
> 
> Fix it by ensuring that the work is canceled before proceeding with
> the cleanup in cdns_i3c_master_remove.
> 
> Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
> Link: https://lore.kernel.org/r/20240911153544.848398-1-kxwang23@m.fudan.edu.cn
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> ---
>  drivers/i3c/master/i3c-master-cdns.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/i3c/master/i3c-master-cdns.c b/drivers/i3c/master/i3c-master-cdns.c
> index b9cfda6ae9ae..4473c0b1ae2e 100644
> --- a/drivers/i3c/master/i3c-master-cdns.c
> +++ b/drivers/i3c/master/i3c-master-cdns.c
> @@ -1668,6 +1668,7 @@ static int cdns_i3c_master_remove(struct platform_device *pdev)
>  	struct cdns_i3c_master *master = platform_get_drvdata(pdev);
>  	int ret;
>  
> +	cancel_work_sync(&master->hj_work);
>  	ret = i3c_master_unregister(&master->base);
>  	if (ret)
>  		return ret;
> -- 
> 2.25.1
> 
> 

Does not apply to 6.1.y :(
