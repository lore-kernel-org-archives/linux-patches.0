Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C5F197A76;
	Fri, 25 Apr 2025 06:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745563266; cv=none; b=XTEs6wlZsnEP2Wu0haBZcZFIlbd1g6XVwOkFvVzUC/fVCmKHYPoRHQzEnCUGt+nmPSz2cLSWfUMHoE4+fDGP9cKqzooWX23dYnCnLdZcyKnEiBy2fCx26h0hIInxWTu2ud3o7kDofOkqCXAmNOmLiMEKfZwii8UEIMJ/bGPINEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745563266; c=relaxed/simple;
	bh=LT2DGtZYPKsuF0uZdJr3v8Z/KrDWPxbrdFW7vwHATuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emx3U2Zgs/BUCALBc75wdOT2gxwTW4d5LZoz3giMiBQUexfPuWNL9Kq5SnOD61f8m4+/402asoqfYOHG79zUPB6dm6J5QjNdJpKY5iJXRMZZceHL0UT/PDjsqp3+rH77VYXhvnxCR252/WQfsc++Wxt6KtvFeD3vUQkW5clnEjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfDVon5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfDVon5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A181C4CEE4;
	Fri, 25 Apr 2025 06:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745563265;
	bh=LT2DGtZYPKsuF0uZdJr3v8Z/KrDWPxbrdFW7vwHATuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PfDVon5mDeZ1Sn/w6ixeXRDGPcwTOSW5nul1MOHUs78hvfauTvvy6Lg3M9OEdHiKw
	 Ws4+paee+HMf8473lu2DhaTT+4LncAxaZG2lunoTgScsbXRiUd+VSH/+x51cb6e02k
	 lxEeaDF920M8Pn2NJUzWHFlR4qqbyfGPVlSCSYEU=
Date: Fri, 25 Apr 2025 08:41:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephan Gerhold <stephan.gerhold@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 6.14 130/241] cpufreq: Avoid using inconsistent
 policy->min and policy->max
Message-ID: <2025042552-lukewarm-sixties-cc61@gregkh>
References: <20250423142620.525425242@linuxfoundation.org>
 <20250423142625.881627603@linuxfoundation.org>
 <aApnCaypsl1VWIfo@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aApnCaypsl1VWIfo@linaro.org>

On Thu, Apr 24, 2025 at 06:30:01PM +0200, Stephan Gerhold wrote:
> Hi Greg,
> 
> On Wed, Apr 23, 2025 at 04:43:14PM +0200, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > commit 7491cdf46b5cbdf123fc84fbe0a07e9e3d7b7620 upstream.
> > 
> > Since cpufreq_driver_resolve_freq() can run in parallel with
> > cpufreq_set_policy() and there is no synchronization between them,
> > the former may access policy->min and policy->max while the latter
> > is updating them and it may see intermediate values of them due
> > to the way the update is carried out.  Also the compiler is free
> > to apply any optimizations it wants both to the stores in
> > cpufreq_set_policy() and to the loads in cpufreq_driver_resolve_freq()
> > which may result in additional inconsistencies.
> > 
> > To address this, use WRITE_ONCE() when updating policy->min and
> > policy->max in cpufreq_set_policy() and use READ_ONCE() for reading
> > them in cpufreq_driver_resolve_freq().  Moreover, rearrange the update
> > in cpufreq_set_policy() to avoid storing intermediate values in
> > policy->min and policy->max with the help of the observation that
> > their new values are expected to be properly ordered upfront.
> > 
> > Also modify cpufreq_driver_resolve_freq() to take the possible reverse
> > ordering of policy->min and policy->max, which may happen depending on
> > the ordering of operations when this function and cpufreq_set_policy()
> > run concurrently, into account by always honoring the max when it
> > turns out to be less than the min (in case it comes from thermal
> > throttling or similar).
> > 
> > Fixes: 151717690694 ("cpufreq: Make policy min/max hard requirements")
> > Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Christian Loehle <christian.loehle@arm.com>
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Link: https://patch.msgid.link/5907080.DvuYhMxLoT@rjwysocki.net
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Please drop this patch from all stable queues for now. It is causing the
> CPU frequency to be stuck at minimum after temperature throttling.
> I reported this with more detail as reply to the original patch [1].

Ok, now dropped from all queues, thanks for letting us know.

greg k-h
