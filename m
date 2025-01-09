Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B78B215180;
	Thu,  9 Jan 2025 11:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736422418; cv=none; b=YjVIGuQn1Q1dqa3PuvtAQp7jHcKqnIUrfsFW54Kz0oB3j85ze5qzWR+m5j2/snEYHZDbb3olTwxcXSiElKWv7h9tZt05ILeS7myTHRCcQIfsYZnhDxlGe11szx+Ae6jSDXiHHv7Rjvc6tymHCN7C208kr1xFXI2tL001HSpn8jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736422418; c=relaxed/simple;
	bh=cu8UvUGQO5GwJrCll44bXafOwGTC/lMBXYU0FivN47A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gasYUO1nIvnlunnPUYJ5OY9etsdT2/shCceShp7GjK9DhoXICcGgbuYN9oDUbztPBRnw4wOxJ/JAZFwchBwS4s1oYFYfMPSk7ecQRg9EBJg3pwEV+RfhCOvPSoPaFWIsVp9q3uihAamYTyKWbRVElOu6IUIYCBsOI8iBCuJ8ZOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6tEwtls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6tEwtls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41296C4CED2;
	Thu,  9 Jan 2025 11:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736422417;
	bh=cu8UvUGQO5GwJrCll44bXafOwGTC/lMBXYU0FivN47A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6tEwtlsjaFRnkJX39Z85UnDFpHbK95gmg/FJCXaVpOwXAu4Q3t3HOoZXukBZdPif
	 Va6W51JjKKSpBrHFFR0ornGg77siSyBLN+wpOUtAg3Ty73ixztVWhfzI/Vx7hiCI9C
	 MVywT1ERG4MXn7zrQ9lQB7Gy8+F4cutd9B3MazF4=
Date: Thu, 9 Jan 2025 12:33:34 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 014/222] drm/radeon: Delay Connector detecting when
 HPD singals is unstable
Message-ID: <2025010922-handler-grudging-fea3@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151151.141567133@linuxfoundation.org>
 <BL1PR12MB51447A9FC852D0E8DDCD6C4DF7122@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51447A9FC852D0E8DDCD6C4DF7122@BL1PR12MB5144.namprd12.prod.outlook.com>

On Wed, Jan 08, 2025 at 12:00:40AM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, January 6, 2025 10:14 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.dev;
> > Shixiong Ou <oushixiong@kylinos.cn>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.6 014/222] drm/radeon: Delay Connector detecting when HPD
> > singals is unstable
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Shixiong Ou <oushixiong@kylinos.cn>
> >
> > [ Upstream commit 949658cb9b69ab9d22a42a662b2fdc7085689ed8 ]
> >
> > In some causes, HPD signals will jitter when plugging in or unplugging HDMI.
> >
> > Rescheduling the hotplug work for a second when EDID may still be readable but
> > HDP is disconnected, and fixes this issue.
> >
> > Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Stable-dep-of: 979bfe291b5b ("Revert "drm/radeon: Delay Connector detecting
> > when HPD singals is unstable"")
> 
> Please drop both of these patches.  There is no need to pull back a patch just so that you can apply the revert.

Good point, both now dropped, thanks.

greg k-h
