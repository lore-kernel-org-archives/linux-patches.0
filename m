Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A71E1A33;
	Fri, 13 Dec 2024 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100105; cv=none; b=Oh5H+Ib0wRPBGYviYmsHQgbYzOv0FPh7sKqHurTrv6bKzjd3gOyFN+SPyI34OWOemltGZfU+02cvMiALPAE919IKlKEILOFE2Lbxd9TNJx7ZyGOaZjlzUPeebid/dRdBokjAqufbGIHy5w8i/DOrDI/YLHYjmA7jlMSSpX9sCFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100105; c=relaxed/simple;
	bh=ZbcKMdctPQCdyQzTtpcvziUCKjV2K9y/jKn3RlluK7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhlXXKzt3s55b0NOs9lsVkhk3I7x7ZbuH/A09x2hbSAs9n42a2FiHhm+VRx2vFrzVgY8CwTTR0IX33QaJ1J9ykWTYzMjsxzwHAwY5qfY65LBZ/Rp0XzLHGkqhyLXxIZbU0ZqyORhWTHm+TmDzwADtAHrmm2pwJbVcCtvSb7cPzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKv36EGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKv36EGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EB5C4CED0;
	Fri, 13 Dec 2024 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734100104;
	bh=ZbcKMdctPQCdyQzTtpcvziUCKjV2K9y/jKn3RlluK7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kKv36EGsqrYpRJYKhhZl8mk7wccb8onloMKKJwstbdADawiEWLN7zWt+9F9Nq9qa1
	 KYokXlrtluKzuU/g14Wue0BGxwlKuA//fuc6a/mYzguxSFCIIopgOpG0H4pgS+BLi0
	 TyAzsKAjEK1J8uifNGJ6X2ujGG7NRaQOcySMmBZ0=
Date: Fri, 13 Dec 2024 15:28:20 +0100
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
Message-ID: <2024121349-tacky-obstacle-a41b@gregkh>
References: <20241212144306.641051666@linuxfoundation.org>
 <20241212144324.128679509@linuxfoundation.org>
 <6e25f099-1ba2-4bef-9477-888288270f5d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e25f099-1ba2-4bef-9477-888288270f5d@kernel.org>

On Thu, Dec 12, 2024 at 06:45:07PM +0100, Jiri Slaby wrote:
> On 12. 12. 24, 16:00, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Austin Zheng <Austin.Zheng@amd.com>
> > 
> > [ Upstream commit b8d046985c2dc41a0e264a391da4606099f8d44f ]
> > 
> > [Why]
> > Videos using YUV420 format may result in high power being used.
> > Disabling MPO may result in lower power usage.
> > Update interface that can be used to check power profile of a dc_state.
> > 
> > [How]
> > Allow pstate switching in VBlank as last entry in strategy candidates.
> > Add helper functions that can be used to determine power level:
> > -get power profile after a dc_state has undergone full validation
> 
> FWIW this was reverted in the Linus' tree:
> 
> commit 0e93b76cf92f229409e8da85c2a143868835fec3
> Author: Austin Zheng <Austin.Zheng@amd.com>
> Date:   Mon Sep 23 10:07:32 2024 -0400
> 
>     drm/amd/display: Revert commit Update Interface to Check UCLK DPM
> 
>     This reverts commit b8d046985c2dc41a0e264a391da4606099f8d44f.
> 
>     Reverting as regression discovered on certain systems and golden values
>     need to updated.
> 
> 
> 
> Possibly, there are other fixes queued for 6.12, so the revert is not needed
> anymore?

No, you are right, I need this one.  For some reason I thought I had
applied it but it failed to apply cleanly and so it was dropped.  I'll
go fix it up by hand now...

thanks,

greg k-h
