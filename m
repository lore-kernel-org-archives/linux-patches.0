Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ADA328617;
	Wed, 17 Dec 2025 09:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765964203; cv=none; b=SfLzlZJ1c6XyC/KDGMNxzNim8DPQLs/njq+5YVm3hM70N3jwlN/F6/Vx2iVKfq2K5NFcIuwCPIrPea/H+lRPYcBRyYxowjobBlLtuinwclnjLseAgieZEdFGiEVNgtwT3LVHA9udzuH0CnS3erSrL6iTtPxjNqZlLC9e1gLMPy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765964203; c=relaxed/simple;
	bh=Wyh7lCOHXtqEwjyPfQhU0ee7Yb5w1waZAnxgxQlNZrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDHOcxSTLSXpsGgUuykmiQ5H2dKwK/ddy3UCSm+V6eNB2T1J6JK/yBP69GmB/XOLg4Xe/qpXnfcPR5wZA62AypcKBXtu6FGQ+GTa5/Uly6RH4HoyJzdhUg/UNwaxWQPpN+xTRA3SFbovu6zXG54Xuv914/vTM96B2O2posiUgc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAAu6qoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAAu6qoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C1DC4CEF5;
	Wed, 17 Dec 2025 09:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765964202;
	bh=Wyh7lCOHXtqEwjyPfQhU0ee7Yb5w1waZAnxgxQlNZrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KAAu6qoOHLDeOltGzDvnDiWnu3cbtkEMVXt0DQm4MUDzVn3vL/Np6wqP6WLn43kgo
	 ypksFQgQbYF2Q8Ic2QPMPRcakOaMA1SAvA8Rt4WBJ4u+KBT7NE9nbUfmNZPfIAaNzB
	 tTrKD+j/Lxc0vY9CyCW48s4DfhmeopM5yS+dRT2I=
Date: Wed, 17 Dec 2025 10:36:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ronald Warsow <rwarsow@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Message-ID: <2025121708-chunk-sasquatch-284c@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>
 <2025121714-gory-cornhusk-eb87@gregkh>
 <b72d4821-d3e6-4b29-96c8-6acb1fc916a8@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b72d4821-d3e6-4b29-96c8-6acb1fc916a8@gmx.de>

On Wed, Dec 17, 2025 at 09:27:49AM +0100, Ronald Warsow wrote:
> On 17.12.25 06:47, Greg Kroah-Hartman wrote:
> > On Tue, Dec 16, 2025 at 05:06:56PM +0100, Ronald Warsow wrote:
> > > Hi
> > > 
> > > no regressions here on x86_64 (RKL, Intel 11th Gen. CPU), but *only* when
> > > running GPU driver i915.
> > > 
> > > with GPU driver xe I get here:
> > > 
> > > [   14.391631] rfkill: input handler disabled
> > > [   14.787149] ------------[ cut here ]------------
> > > [   14.787153] refcount_t: underflow; use-after-free.
> > > [   14.787167] WARNING: CPU: 10 PID: 2463 at lib/refcount.c:28
> 
> ....
> 
> > > ====
> > > 
> > > If I did the bisect correct, bisect-log:
> > > 
> > > # status: waiting for both good and bad commits
> > > # good: [25442251cbda7590d87d8203a8dc1ddf2c93de61] Linux 6.18.1
> > > git bisect good 25442251cbda7590d87d8203a8dc1ddf2c93de61
> > > # status: waiting for bad commit, 1 good commit known
> > > # bad: [103c79e44ce7c81882928abab98b96517a8bce88] Linux 6.18.2-rc1
> > > git bisect bad 103c79e44ce7c81882928abab98b96517a8bce88
> > > # bad: [d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd] drm/msm: Fix NULL pointer
> > > dereference in crashstate_get_vm_logs()
> > > git bisect bad d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd
> > 
> > Is this also an issue with 6.19-rc1?  Are we missing something here?
> > 
> 6.19-rc1 is okay here

Odd, as you aren't even running the driver that this commit points to,
right?  You shouldn't be building it, so why does this show up as the
"bad" commit id?

totally confused,

greg k-h
