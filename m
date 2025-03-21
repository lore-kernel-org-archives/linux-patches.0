Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832F122D4F1;
	Fri, 21 Mar 2025 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580066; cv=none; b=Ut7kx1VoDWZHGzzppHocw5E2vlWae9i7oVD7qfibHLjwcRLydHjkV16D8LSH7PAcS/hZIhn6skcHMNakfxYdifqaJTnkcbuCQENaYLFle/AohQ5YDwC1kubxAft59B2V1yTn++YuH1XtCWdQI8ei0CRKOdakgOd/B2smoFxhu1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580066; c=relaxed/simple;
	bh=OdedBUJebUY+DIv9ejGevH7g4mP7Thb1eFCY8YTv6/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkZ+ZoPFA9GxP+5uyoVfyX7wQMX92ezbxhDLw5BAbfd2CCDqPsxYtpW20uA223awMJxqN1VRFMYqGYx0SwdwZWMSqjdcXinDwT4sWkSdXKBAmyz929MoCF9HIlNSb9j7JtyZ0XN3Eb2okuh4hYMDTvQg1aAblJDyoLITYqkk6dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pb63h9bG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pb63h9bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D789C4CEE3;
	Fri, 21 Mar 2025 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742580065;
	bh=OdedBUJebUY+DIv9ejGevH7g4mP7Thb1eFCY8YTv6/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pb63h9bGaRLvgC9uGPn80vdueBXDC5kVg3BAPqnv1IYBLjbH6ooSFzvgAXeAIfBax
	 cIy47Usl7c3ptZvKfKDlqNo4+WtIhyTPT/X8CUxreWsOTHeUEXY1CSOkZqRJWgSHSP
	 caR8RxuObQJR4veDS7odAyRxS8QCXXpZL5hJ3mSLNuxoE0MMbHDyjyjieoE7EIr4RM
	 0IWWJKJTVcUhkHENIEOxQm/4jBcmPqOIC366OO/Q/oskmXGWEj3F2XMwID7UKRICLk
	 lrIncgDwVZG+Q2EyytMcAZ0EHLXdxvXlax5pJFF7lDlWwmCqp34s/HlxQd2G0Uv1aa
	 Wl38iVJTdQIhA==
Date: Fri, 21 Mar 2025 18:01:01 +0000
From: Simon Horman <horms@kernel.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	michal.swiatkowski@linux.intel.com
Subject: Re: [RFC PATCH 6.1.y] net/sched: act_mirred: don't override retval
 if we already lost the skb
Message-ID: <20250321180101.GP892515@horms.kernel.org>
References: <20250319012225.821278-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319012225.821278-1-jianqi.ren.cn@windriver.com>

On Wed, Mar 19, 2025 at 09:22:25AM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 ]
> 
> If we're redirecting the skb, and haven't called tcf_mirred_forward(),
> yet, we need to tell the core to drop the skb by setting the retcode
> to SHOT. If we have called tcf_mirred_forward(), however, the skb
> is out of our hands and returning SHOT will lead to UaF.
> 
> Move the retval override to the error path which actually need it.
> 
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
> Verified the build test

Sorry if it is obvious, but I'm confused by the intention of posting
an RFC for stable. Are you asking for buy-in regarding backporting
this patch to 6.1.y because for some reason it hasn't already propagated
there?

