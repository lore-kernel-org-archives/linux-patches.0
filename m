Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10117A30F;
	Thu, 19 Jun 2025 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750344801; cv=none; b=P5OmC1X8rzWJH0psOv23IIU90mYwxZyWW7qRFxIakbrw+UOCy4ZInzNc0gyhbFnOT/nPZTYlhXEExx1FtMF8hstwh6C5mj18OtHlF08zB5iCMnBG2MyMjBzN89SKmZJR5+xALez+h+PlW1x4dC91bKLRFFsdAnYtIVzUw/5dxcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750344801; c=relaxed/simple;
	bh=jh+7x4yapH2tjx4d+2JN+Y/IIz5HqAcmcqnjs7BE7DI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8jmmNQJkGxAxKpCL/Wt5Jv1S75jU6sjVWFa6i5ukmGJYY5Hqrl8q6pwypmE1hfFNzjfNA7eKkChMiUnrrB+Ww6oFMKOLJhMh7Qhrw/MXB1k/zu94wSWNe6n+6ssjuBBNr513q6gXRMPoPh3nd+7gS1poCf9EDoIID8Aairdr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QboF5c/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QboF5c/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BCDC4CEEA;
	Thu, 19 Jun 2025 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750344800;
	bh=jh+7x4yapH2tjx4d+2JN+Y/IIz5HqAcmcqnjs7BE7DI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QboF5c/L/OR6qTMDFS7Y60BhLcuIjjY9miw/gFn5o0CHBTP9FX7yNEM5ncKJ8eOaH
	 bSc8QZ+0B/NB/BKifOwJmRyfjMwsfGu7wVHrMRGCMZDokQeMxTpI0WvMr/pqrJNHiM
	 nIYdwZ85U/fNUl6LvupXyWWxHUeJ9WCITRXcjZ/o=
Date: Thu, 19 Jun 2025 16:53:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Casey Connolly <casey.connolly@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 296/356] ath10k: snoc: fix unbalanced IRQ enable in
 crash recovery
Message-ID: <2025061946-squiggle-cheer-27c8@gregkh>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152350.087643471@linuxfoundation.org>
 <a91ca229-0603-4385-9f9e-01f3c3ede855@linaro.org>
 <2025061953-alarm-oxidize-1967@gregkh>
 <2ac47529-d72b-4de0-873e-247cce7c3c1c@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ac47529-d72b-4de0-873e-247cce7c3c1c@linaro.org>

On Thu, Jun 19, 2025 at 04:09:00PM +0200, Casey Connolly wrote:
> 
> 
> On 6/19/25 06:21, Greg Kroah-Hartman wrote:
> > On Wed, Jun 18, 2025 at 08:06:45PM +0200, Casey Connolly wrote:
> > > 
> > > 
> > > On 6/17/25 17:26, Greg Kroah-Hartman wrote:
> > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Caleb Connolly <caleb.connolly@linaro.org>
> > > > 
> > > > [ Upstream commit 1650d32b92b01db03a1a95d69ee74fcbc34d4b00 ]
> > > > 
> > > > In ath10k_snoc_hif_stop() we skip disabling the IRQs in the crash
> > > > recovery flow, but we still unconditionally call enable again in
> > > > ath10k_snoc_hif_start().
> > > > 
> > > > We can't check the ATH10K_FLAG_CRASH_FLUSH bit since it is cleared
> > > > before hif_start() is called, so instead check the
> > > > ATH10K_SNOC_FLAG_RECOVERY flag and skip enabling the IRQs during crash
> > > > recovery.
> > > > 
> > > > This fixes unbalanced IRQ enable splats that happen after recovering from
> > > > a crash.
> > > > 
> > > > Fixes: 0e622f67e041 ("ath10k: add support for WCN3990 firmware crash recovery")
> > > > Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> > > 
> > > If fixing my name is acceptable, that would be appreciated...
> > 
> > I can, to what?  This was a cherry-pick from what is in Linus's tree
> > right now, and what was sent to the mailing list, was that incorrect?
> 
> s/Caleb/Casey/ I sent this patch before updating my name.

Ah, sorry, I already did the release.  I would recommend sending in a
.mailmap update for the kernel so this gets caught going forward.

thanks,

greg k-h
