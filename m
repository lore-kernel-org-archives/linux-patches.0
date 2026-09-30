Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5534E4CDDE6;
	Wed, 30 Sep 2026 12:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769812; cv=none; b=VYtKELaXPnMexSGggMCclOTobwDHA2BWlpHpwaHCGN12Bpq02xEjoHDEGWyFdjH6YbnTdcRqF3ScpGJ2Amfi3eXdgSzohiZ5NDSbvG01KBScI4ukU+QpxTGKO4gJQGdMS4/I74w/LJ/W4QIo2n/nzzTZW4+l9wsRTMZCvtRdK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769812; c=relaxed/simple;
	bh=6lbuV7NQgZFjl1ILQWUN4EDNHopI2RUwMC9WbbikSqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDDmLpypQnZ1P3I88hOmIQAgdMbEyafKslALZAv1djYoN0xjKm/lSWW3ugYDDQZ5Zw86G4+5ZGmXMSxuzOKbC34rtqybJmP0+xwDMViVYdBc3fChYObBiZcGVqluvmvrF2y6Z28N2WgEwnh95npQrsNQvWkZzep+Hyn2jvZf7cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ph9oPahs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ph9oPahs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634501F000FF;
	Wed, 30 Sep 2026 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790769810;
	bh=BhAyzd9uTMpVYzVpHh6/1OjAKRboCVsQXnv3jAa2oYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ph9oPahs4mfWZLa5gj+KoJ5Jo1gusei4vZ7+UW9pV5zt0CSy4LGiINv/z/EG2Sp6x
	 J1TSqjebbNW/6v5i1+fkBFROUUrZGq8pvhRHaCmtAQO4HrgwZ4sud8K1KmEcVPHN0m
	 7o+0gQFwEN4xVPByd5bEY+1sucP3iI9a4X790hdk=
Date: Wed, 30 Sep 2026 14:03:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Salmun <salmundani@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	=?iso-8859-1?Q?Rapha=EBl?= Larocque <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 6.18 303/398] Input: synaptics - disable InterTouch on
 ThinkPad T440p (board id 2722)
Message-ID: <2026093008-ricotta-dealer-ad24@gregkh>
References: <20260923140643.441954610@linuxfoundation.org>
 <20260923140651.274430576@linuxfoundation.org>
 <5ed0ee13-9502-42f1-94b7-a99607ca2bea@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ed0ee13-9502-42f1-94b7-a99607ca2bea@gmail.com>

On Sat, Sep 26, 2026 at 08:19:55PM -0300, Daniel Salmun wrote:
> On 9/23/26 11:06, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let
> > me know.
> > 
> > ------------------
> > 
> > From: Raphaël Larocque <rlarocque@disroot.org>
> > 
> > commit 26eb3d92c7a4d7adb1ae1740ca6e8e100b11d1ec upstream.
> > 
> > The Lenovo ThinkPad T440p (PNP ID LEN0036, board id 2722) has a
> > Synaptics touchpad whose SMBus companion is not ready at boot and
> > takes roughly 200 seconds to appear.
> [...]
> > Disable SMBus InterTouch for board id 2722 so the touchpad and
> > TrackPoint work immediately via PS/2 from boot.
> 
> I have a concern about this one. Board id 2722 isn't specific to the
> T440p. My ThinkPad L440 has the same Synaptics board id, and this patch
> would move it from SMBus/RMI4 to PS/2. I have never hit the issue this
> commit fixes, and I haven't seen it reported on other potentially
> affected models either.
> 
> I sent a patch [1] that limits the quirk to the T440p. Previous
> attempts to move these touchpads to PS/2 were rejected [2], as
> explained in that patch's commit message.
> 
> Could this be dropped from the stable queue until it's sorted out
> upstream?
> 
> [1] https://lore.kernel.org/all/20260925230039.236786-1-
> salmundani@gmail.com/
> [2] https://lore.kernel.org/linux-
> input/65C23A49-5A55-4CF4-9AFD-2DA504DAABF5@duggan.us/
> 

Let's just queue up whatever gets commited in Linus's tree to resolve
this.

thanks,

greg k-h
