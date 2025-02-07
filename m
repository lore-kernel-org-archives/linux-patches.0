Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358131F4169;
	Fri,  7 Feb 2025 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738936478; cv=none; b=Xtub31XEto/0RNKbNZ9dpEF4mozbkojnBLfWrNnDuPjNxhAjYXgG4bL68+Ub83ybjVH+yyGMGDnVRJLrnf0G1vR9wWhn4mnxCKXjcWNpXHE+zN/OSslq+WQf4tPzMAPlOcEZN9g9RleVNjv6Ni2YeVXCVGRY7zhtyiZ4+wcR24A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738936478; c=relaxed/simple;
	bh=+9Nb79PCPONjK0IJAJ2FUvhPtmIH7tDDtA5yLL15zl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOC3Pc3jZheo16+62+gUIptjAcjiego13XM7PIk9Z8Ny0mjHcj0FsWKsycm99PaRu7TOKxtadoWA3BH7uIVxPeQVKzu7g0cZOCxalt+2Ot0o01mvQHsOFeOE2ve8bpomZmZ7JyXw5UGDPxkkamS+NynIkBNfzWfCGcV3MqTWksA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fps0HS3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fps0HS3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9931AC4CED1;
	Fri,  7 Feb 2025 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738936477;
	bh=+9Nb79PCPONjK0IJAJ2FUvhPtmIH7tDDtA5yLL15zl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fps0HS3H3smOOEy4Rw3xJJtjVN2H8E4lOAFm5MkZ+uvtRH+j/o/Z5b8gAnyKtJjrr
	 PI1Yv04krMwYEEQoBTZ9xOzAsGwySwoEOtzPzLc6/J3FDvfOAGxpC3dhL4v6Tfu6CN
	 m+IjViywq6yXy9qp9NyPYocTJHFv6PIzZh8eLsy3nYEtHKbMxlUishWduTXzOVwag6
	 EkwUQYycrO0NgJLMh3BsQ45FnfI2NkvsjsrvNJm4YTiM1jRWRAMftpcVSY1r527QE9
	 8XAI+YAvPw5iLaS5jngnet43gEwpy3/hvvdylZ0ybHnC1ICNm7nWlvleOKLBiB4+OC
	 ItkZaGUbIkjkA==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan@kernel.org>)
	id 1tgOog-000000003Wa-2HYR;
	Fri, 07 Feb 2025 14:54:46 +0100
Date: Fri, 7 Feb 2025 14:54:46 +0100
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 541/623] PM: sleep: core: Synchronize runtime PM
 status of parents and children
Message-ID: <Z6YQpnfhXRh5oHRi@hovoldconsulting.com>
References: <20250205134456.221272033@linuxfoundation.org>
 <20250205134516.919594202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205134516.919594202@linuxfoundation.org>

On Wed, Feb 05, 2025 at 02:44:43PM +0100, Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> [ Upstream commit 3775fc538f535a7c5adaf11990c7932a0bd1f9eb ]
> 
> Commit 6e176bf8d461 ("PM: sleep: core: Do not skip callbacks in the
> resume phase") overlooked the case in which the parent of a device with
> DPM_FLAG_SMART_SUSPEND set did not use that flag and could be runtime-
> suspended before a transition into a system-wide sleep state.  In that
> case, if the child is resumed during the subsequent transition from
> that state into the working state, its runtime PM status will be set to
> RPM_ACTIVE, but the runtime PM status of the parent will not be updated
> accordingly, even though the parent will be resumed too, because of the
> dev_pm_skip_suspend() check in device_resume_noirq().
> 
> Address this problem by tracking the need to set the runtime PM status
> to RPM_ACTIVE during system-wide resume transitions for devices with
> DPM_FLAG_SMART_SUSPEND set and all of the devices depended on by them.
> 
> Fixes: 6e176bf8d461 ("PM: sleep: core: Do not skip callbacks in the resume phase")
> Closes: https://lore.kernel.org/linux-pm/Z30p2Etwf3F2AUvD@hovoldconsulting.com/
> Reported-by: Johan Hovold <johan@kernel.org>
> Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
> Tested-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://patch.msgid.link/12619233.O9o76ZdvQC@rjwysocki.net
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch appears to be causing trouble and should not be backported,
at least not until this has been resolved:

	https://lore.kernel.org/all/1c2433d4-7e0f-4395-b841-b8eac7c25651@nvidia.com/

Please drop from all stable queues.

Johan
