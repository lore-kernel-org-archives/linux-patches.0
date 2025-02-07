Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130AD238D52;
	Fri,  7 Feb 2025 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738940615; cv=none; b=BDFcjoqKJyLvWJz3XJuZdxvDgIMnQfWAPR+/gJGI7wqclhlDSO3yPYq93bbH2EeUi+zQ5/T9E/eqMWQAPQa+MYEovqZe5/Jdfr+O0Jju/XJjzTnljWhdI6GtJ8FCl50ZEhOz2BzKgDRy8WL8RcW2Kw48eXgpSkxTDMOWETqd6BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738940615; c=relaxed/simple;
	bh=pfd0o9gha1P3u4srzrnDS6Wo7ak7hJLBWBfV8RQdcp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbOMmp2yr4x2OGZncupB8nEgDQuGh0SifkNdUHBLlaS+cZR1maHkW0YauWeRRtxM6JfKST8OX1wp9PozI6vFzY+1tIYBT6ECJ0sxkiJPXEfhx19iiEdxo/HLsb2wcZG0Q9hjZdSBcQ9iuH46zCoBCDZJ8YtHC+pBnLV6gd0VzLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuOmBviW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuOmBviW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E122C4CEDF;
	Fri,  7 Feb 2025 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738940614;
	bh=pfd0o9gha1P3u4srzrnDS6Wo7ak7hJLBWBfV8RQdcp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tuOmBviWAIVGAmnuaFZO+uW3izoawwmv36d+3eOU2gRiiWfbcJo3PbGSFTsKE3q7A
	 ZGT3N8F0Z/bkoJPQwp2S7itBrAg/AfZoeJ5TWRt4bnFrQpbQwvYuNiqWeubgVy49Qa
	 UxSXEhYkex4L6RhEUusAeurW1Xb2vBiXfVzVV7jk=
Date: Fri, 7 Feb 2025 16:03:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 541/623] PM: sleep: core: Synchronize runtime PM
 status of parents and children
Message-ID: <2025020710-antiquely-gone-caa7@gregkh>
References: <20250205134456.221272033@linuxfoundation.org>
 <20250205134516.919594202@linuxfoundation.org>
 <Z6YQpnfhXRh5oHRi@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6YQpnfhXRh5oHRi@hovoldconsulting.com>

On Fri, Feb 07, 2025 at 02:54:46PM +0100, Johan Hovold wrote:
> On Wed, Feb 05, 2025 at 02:44:43PM +0100, Greg Kroah-Hartman wrote:
> > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > [ Upstream commit 3775fc538f535a7c5adaf11990c7932a0bd1f9eb ]
> > 
> > Commit 6e176bf8d461 ("PM: sleep: core: Do not skip callbacks in the
> > resume phase") overlooked the case in which the parent of a device with
> > DPM_FLAG_SMART_SUSPEND set did not use that flag and could be runtime-
> > suspended before a transition into a system-wide sleep state.  In that
> > case, if the child is resumed during the subsequent transition from
> > that state into the working state, its runtime PM status will be set to
> > RPM_ACTIVE, but the runtime PM status of the parent will not be updated
> > accordingly, even though the parent will be resumed too, because of the
> > dev_pm_skip_suspend() check in device_resume_noirq().
> > 
> > Address this problem by tracking the need to set the runtime PM status
> > to RPM_ACTIVE during system-wide resume transitions for devices with
> > DPM_FLAG_SMART_SUSPEND set and all of the devices depended on by them.
> > 
> > Fixes: 6e176bf8d461 ("PM: sleep: core: Do not skip callbacks in the resume phase")
> > Closes: https://lore.kernel.org/linux-pm/Z30p2Etwf3F2AUvD@hovoldconsulting.com/
> > Reported-by: Johan Hovold <johan@kernel.org>
> > Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
> > Tested-by: Johan Hovold <johan+linaro@kernel.org>
> > Link: https://patch.msgid.link/12619233.O9o76ZdvQC@rjwysocki.net
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This patch appears to be causing trouble and should not be backported,
> at least not until this has been resolved:
> 
> 	https://lore.kernel.org/all/1c2433d4-7e0f-4395-b841-b8eac7c25651@nvidia.com/
> 
> Please drop from all stable queues.

Already done, and -rc2 releases were sent out yesterday with it removed.

thanks,

greg k-h
