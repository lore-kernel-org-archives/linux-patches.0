Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6601494A7;
	Fri,  3 Jan 2025 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735914329; cv=none; b=dhmTD9/rsYuE6misPla+AXtI00kmEs04kI2HWcxqp1lq/UwT9WuOb6INEGksC+t+8powv6IkS3SS0gXurCuGM+DBKYu9sPBMLcUTfdrS8TAUvhDs+CtqfmEihG+ImdJp9LK7iVKo4Dl5d3f01/HXGuIVTEw8ePW93CBpvS4NpIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735914329; c=relaxed/simple;
	bh=9rkDFEkGJMZh9gqmxw60dXjoOQeA4ixOSDAGcEo3bgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtJIfzGJO8hD0jnFo9Mh71e3yRc4HuGvBh/aMDHNa+H2Ok1oJ2KQJ/uVrFreQs3H2k4t2H2cGXhKyOvQWncAAZ212VfbFr9RFQ3yDwBtZHG1ctj5M2dmYVr1isnAY/hMVV88l4IuDhoHei1j/ZdoawBJH+16H9/sbZEArbJDwlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kso0gLsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kso0gLsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5548FC4CECE;
	Fri,  3 Jan 2025 14:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735914328;
	bh=9rkDFEkGJMZh9gqmxw60dXjoOQeA4ixOSDAGcEo3bgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kso0gLsOnKVaCZXGRozJqP9zLznelBJwtMkW0qURcHulbiBFW3jYDy/Gy8SHF57Gy
	 6F8K4rXBmZXia78C9mG74cJC2xuucC6P+6b88ntInL8wfSMj7F1UoiIDj/1TW3OqfI
	 +E7XWDjrZehRDdI/upmAXA4ncIlSV4P1uhcC+IFE=
Date: Fri, 3 Jan 2025 15:25:26 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, kxwang23@m.fudan.edu.cn,
	alexandre.belloni@bootlin.com, patches@lists.linux.dev,
	pgaj@cadence.com, linux-i3c@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] i3c: master: cdns: Fix use after free
 vulnerability in cdns_i3c_master Driver Due to Race Condition
Message-ID: <2025010340-unearned-snare-fa78@gregkh>
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

Wait, why are you all submitting stable patches again?  I thought I
asked you to change how you all did this AND discuss it with me after
you came up with a plan on how to move forward.

What happened to all of that?  I'm dropping this, and the other
submission you sent as nothing seems to have changed :(

greg k-h
