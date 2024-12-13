Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39EA1AAC9;
	Fri, 13 Dec 2024 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100463; cv=none; b=M34qcp+2oGEowEjIwQcqELXnSt+0X+AZfflQ4bnY+hjK4TnZFy2sqlutLnjFAOYDEnXou1eF0xugULLUb9JV50fbG5GkLG3QsfEPCGG3EKxI7OVn9QDtwfZmIppxiY4+gMd12som+CHqgnqmB2ybtPFcsavsOion8wMUc6Zd1MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100463; c=relaxed/simple;
	bh=wHBHWbN8T1dB7vyMnQIgEIpw4tUeOJJZ+ixlT+uAaX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxxMRfksDySwZ/YJi4ezWzbUM87tFxr1vxE8b30QEoxiM3cILn3p2Tf2BCdJk9zrg7lbyTBj/rbgEnTZhhybawOZMIyjNKHeIQEPk0MjRCjzhs91vgQqf0f9fFylFgak0FVt73PPFSaalgxIkbN98wnH4nTK8ay9v0sjZz9LiFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuaAGz83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuaAGz83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3457C4CED2;
	Fri, 13 Dec 2024 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734100462;
	bh=wHBHWbN8T1dB7vyMnQIgEIpw4tUeOJJZ+ixlT+uAaX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XuaAGz83aBmtU6jNbgdz7rRtuy/2IWP5vzD+SKjot+6aZL9bKyiJ033UzCHfqUs6q
	 dKLPPanAoPMiIfUBpikU/F3BeDuU9Okp7r946E0tyc8XM/CPJ2PwB/Ma/d4myK2CKz
	 3x7bhuKZcyl2PjCmCOkpuhEoZqp0N6rO8NLXPOBQ=
Date: Fri, 13 Dec 2024 15:34:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>, Austin Zheng <Austin.Zheng@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 437/466] drm/amd/display: Update Interface to Check
 UCLK DPM
Message-ID: <2024121304-reversing-suing-3c51@gregkh>
References: <20241212144306.641051666@linuxfoundation.org>
 <20241212144324.128679509@linuxfoundation.org>
 <6e25f099-1ba2-4bef-9477-888288270f5d@kernel.org>
 <2024121349-tacky-obstacle-a41b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024121349-tacky-obstacle-a41b@gregkh>

On Fri, Dec 13, 2024 at 03:28:20PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 12, 2024 at 06:45:07PM +0100, Jiri Slaby wrote:
> > On 12. 12. 24, 16:00, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Austin Zheng <Austin.Zheng@amd.com>
> > > 
> > > [ Upstream commit b8d046985c2dc41a0e264a391da4606099f8d44f ]
> > > 
> > > [Why]
> > > Videos using YUV420 format may result in high power being used.
> > > Disabling MPO may result in lower power usage.
> > > Update interface that can be used to check power profile of a dc_state.
> > > 
> > > [How]
> > > Allow pstate switching in VBlank as last entry in strategy candidates.
> > > Add helper functions that can be used to determine power level:
> > > -get power profile after a dc_state has undergone full validation
> > 
> > FWIW this was reverted in the Linus' tree:
> > 
> > commit 0e93b76cf92f229409e8da85c2a143868835fec3
> > Author: Austin Zheng <Austin.Zheng@amd.com>
> > Date:   Mon Sep 23 10:07:32 2024 -0400
> > 
> >     drm/amd/display: Revert commit Update Interface to Check UCLK DPM
> > 
> >     This reverts commit b8d046985c2dc41a0e264a391da4606099f8d44f.
> > 
> >     Reverting as regression discovered on certain systems and golden values
> >     need to updated.
> > 
> > 
> > 
> > Possibly, there are other fixes queued for 6.12, so the revert is not needed
> > anymore?
> 
> No, you are right, I need this one.  For some reason I thought I had
> applied it but it failed to apply cleanly and so it was dropped.  I'll
> go fix it up by hand now...

Nevermind, I just dropped this commit entirely, that was easier overall.

thanks for the review!

greg k-h
