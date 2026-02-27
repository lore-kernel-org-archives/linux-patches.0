Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1AD372B51;
	Fri, 27 Feb 2026 23:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772234271; cv=none; b=i8OlYoyTBwXig4Cr8keRHACMGFWcU8usjIGcjrtLFVsFtYmL4kNFlC80sQbYTAW4UWeffbraYrIwvXnoXD9mnag4iHQz0svO3+qzgG+5BYEuLetr8TrLH1O9Pk2vFBeZbFDxBd8q0AcSeepdxaSF9gIHTxzLTn4HSjJIOmRXJhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772234271; c=relaxed/simple;
	bh=7uid9+rIYavideL2E1AJTnMG5FA/SHY6EUj9iPxChYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rnWFGM462EZvrIN4/uLFYlsVoXdXqlKuN3Ws0+L/HKIKSJRg/77EQgm/+7M1ppKvyp04VvIyelyNShjNvz/wejtQrIqmI+UOotUIxfhU+tSUYuuWAXtnpayck4jN7q8Ga3bzhC7HontEI8JY4yfxjCxUcyoI4lmMdkxjnXV+54Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uH2W4qb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uH2W4qb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A627C116C6;
	Fri, 27 Feb 2026 23:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772234270;
	bh=7uid9+rIYavideL2E1AJTnMG5FA/SHY6EUj9iPxChYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uH2W4qb8cnD3GcVObmF7wMykRODxu8Mn9s+bBaL67vPpNmFMNkPcT3PEuWVLsXQ9L
	 jvhtQUwrxCgvOPj6lx6Yoe7WTUkVJK0kdE+jWuceb+GZgRIsT9OMuGujaCvgw/UHJP
	 cJ6V/+g3OCvbrs/7VuIfMYys6q97iyZ0bELDPwN8jtsRmbq4vhdEDBpB9aRFjCXRyx
	 b196a4wuwOHCjtD6nrWDl00n+m8qP0ohsgiCMRvC/mhuwV5RxXBbnJDLrOPj944h5V
	 yCbK69lgn+SGSHu4ZnA22SuYUkwUbD+kUkeXI7FdeckjjAMrBkhauc6Uux/gF4Sajr
	 PNHbH24adYxyA==
Date: Fri, 27 Feb 2026 16:17:46 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.19 215/781] ALSA: pcm: Relax __free() variable
 declarations
Message-ID: <20260227231746.GA1772942@ax162>
References: <20260225012359.695468795@linuxfoundation.org>
 <20260225012404.989195256@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225012404.989195256@linuxfoundation.org>

On Tue, Feb 24, 2026 at 05:15:24PM -0800, Greg Kroah-Hartman wrote:
> 6.19-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Takashi Iwai <tiwai@suse.de>
> 
> [ Upstream commit f3d233daf011abbad2f6ebd0e545b42d2f378a4f ]
> 
> We used to have a variable declaration with __free() initialized with
> NULL.  This was to keep the old coding style rule, but recently it's
> relaxed and rather recommends to follow the new rule to declare in
> place of use for __free() -- which avoids potential deadlocks or UAFs
> with nested cleanups.
> 
> Although the current code has no bug, per se, let's follow the new
> standard and move the declaration to the place of assignment (or
> directly assign the allocated result) instead of NULL initializations.
> 
> Fixes: ae9213984864 ("ALSA: pcm: Use automatic cleanup of kfree()")
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Link: https://patch.msgid.link/20251216140634.171890-4-tiwai@suse.de
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please apply commit 0585c53b2154 ("ALSA: pcm: Revert bufs move in
snd_pcm_xfern_frames_ioctl()") to all branches that took this change to
fix the build with older supported versions of clang.

  https://storage.tuxsuite.com/public/clangbuiltlinux/nathan/builds/3AEpAuS5jtheTnTL9iDLNAiYTw3/build.log

Cheers,
Nathan
