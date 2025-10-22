Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6D32512FF;
	Wed, 22 Oct 2025 06:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112885; cv=none; b=Wk8zudWgp2pWogi6a4tHg8yNBGt9wY4b/BvpeY/ITcLKjrOGPAYbAgMbAW5JolnE8IyfJtkPMwxFlh+psKbV3d7mTHtWj2oWjbPe6SHAG/KeO1ZUJ0FnFQyjqVTLY8QSZ/2kr6KIAD3ZJ8z/7yhqwpNvJw26pQwKQUO2e9LxBow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112885; c=relaxed/simple;
	bh=w/MZeU/86UdRDSiq11nPKaaA+8xdwNa7ZF3MOBzM6uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+hr+BabLaDYv7kTAIChmZ3yfRDm5Sbc+Kb+80UYOMjq17RgyWm7IKOmT1H7ukI7JAmPxoS900snOfN9jYQdd/SMeEB6vAsXioVIDsDrFq2h7GVodG1REFfWh9CIFMFvNzn1MS0gsj4QGxLrICpXyyDCn7bYIyZ/FzG886vqUkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQHsBELa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQHsBELa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09322C4CEE7;
	Wed, 22 Oct 2025 06:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761112883;
	bh=w/MZeU/86UdRDSiq11nPKaaA+8xdwNa7ZF3MOBzM6uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TQHsBELaK0dpIfSKG+QaOjtHGgcmIikYGHbTRH+LoHelxy//5W2iCI3T51g4Nk0Zv
	 bV17blgWjLd7/3ESDbrLrETMAyuWDmQAYVoHTgQ2KX82FLbUuR/S4LyIRgumbm+ez2
	 rza7uOEgJNeBjjEy8y84nwfEtbe1WDqMrK0Ae9ns=
Date: Wed, 22 Oct 2025 08:00:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
	Nick Bowler <nbowler@draconx.ca>,
	Douglas Anderson <dianders@chromium.org>,
	Dave Airlie <airlied@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.17 040/159] drm/ast: Blank with VGACR17 sync enable,
 always clear VGACRB6 sync off
Message-ID: <2025102243-vertebrae-dormitory-0717@gregkh>
References: <20251021195043.182511864@linuxfoundation.org>
 <20251021195044.163217433@linuxfoundation.org>
 <499eb508-5f24-4ef4-a2a3-f3d76d89db66@leemhuis.info>
 <2025102235-pediatric-sandlot-f2de@gregkh>
 <af5633f4-f339-49a5-9047-2b0682e50584@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af5633f4-f339-49a5-9047-2b0682e50584@googlemail.com>

On Wed, Oct 22, 2025 at 07:52:53AM +0200, Peter Schneider wrote:
> Hi Greg,
> 
> 
> Am 22.10.2025 um 07:28 schrieb Greg Kroah-Hartman:
> > On Wed, Oct 22, 2025 at 06:49:21AM +0200, Thorsten Leemhuis wrote:
> > > On 10/21/25 21:50, Greg Kroah-Hartman wrote:
> > > > 6.17-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Thomas Zimmermann <tzimmermann@suse.de>
> > > > 
> > > > commit 6f719373b943a955fee6fc2012aed207b65e2854 upstream.
> > > > 
> > > > Blank the display by disabling sync pulses with VGACR17<7>. Unblank
> > > > by reenabling them. This VGA setting should be supported by all Aspeed
> > > > hardware.
> > > 
> > > TWIMC, a regression report about 6.18-rc2 that was bisected to this
> > > commit just came in:
> > > 
> > > https://lore.kernel.org/all/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/
> > > 
> > > To quote:
> > > 
> > > """
> > > I have encountered a serious (for me) regression with 6.18-rc2 on my
> > > 2-socket Ivy Bridge Xeon E5-2697 v2 server. After
> > > booting, my console screen goes blank and stays blank. 6.18-rc1 was
> > > still fine.
> > > 
> > > [...]
> > > 
> > > When I revert this from 6.18-rc2, the issue goes away and my console
> > > screen works again.
> > > """
> > 
> > Thanks, I'll go drop this patch from the stable queues for now.
> > 
> > greg k-h
> 
> 
> So Thorsten (thanks!) was 20 minutes quicker ;-) But I just tested this with
> 6.12.55-rc1 and 6.17.5-rc1, too, and can confirm that this offending patch
> breaks VGA on my machine, and that reverting just this patch against either
> RC makes the issue go away.
> 
> I'll retest -rc2 too when it's out.

Should be out now, thanks!
