Received: from m.b4.vu (m.b4.vu [203.16.231.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2EB388879
	for <patches@lists.linux.dev>; Sun, 31 May 2026 15:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.16.231.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780240411; cv=none; b=ukL+2JhBH9za5OP/TpshOby/0xV0DtW8YZj6LXv00mJTFygFFZCDqTzhlbMIY+0M7zi5W8bHNRN60DHUOtvjJlIe1DPBXchjVy8pxpLZA+mY4wVkz8TVONTVkDlq4fuPdJ0laU99389PlPinlKncYNOnhRby5wuehe2qcAsj//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780240411; c=relaxed/simple;
	bh=H2ExlMdIhxev/OHb0le93xGbNGsb+HE6C8eYWRhN4VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsUNzLoIxUtV9KZb4ulwXwb7x+o0L4jlr7A0sxSBNgFaTfNe0CmRRF0lt5+QDkzzJ82t7/nuuyhYIHvbcBSR5tvsPfKe0ZMoL679IYSXrHVtMFuaUUixQrOOr/2GEq+WTjd48BcsgTzDoXrna7YYJREb/FH7AlJmM7m9VFr6FUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=b4.vu; spf=pass smtp.mailfrom=b4.vu; dkim=pass (2048-bit key) header.d=b4.vu header.i=@b4.vu header.b=IFhxnrGB; arc=none smtp.client-ip=203.16.231.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=b4.vu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=b4.vu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=b4.vu header.i=@b4.vu header.b="IFhxnrGB"
Received: by m.b4.vu (Postfix, from userid 1000)
	id C2EEB67DC7DB; Mon,  1 Jun 2026 00:43:20 +0930 (ACST)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.b4.vu C2EEB67DC7DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=b4.vu; s=m1;
	t=1780240400; bh=fGPzGM6HsELRKDb0LPe7FpxAWXKREgEVrtYdnVrRNlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IFhxnrGB3R8Gy0pb5KDCtWuEbxYgZ+rB930ZW3ezUW3np6ez6BYVD9gB9gkZpJEp6
	 mnJ8DiiYp/3NIhZIPkjSBGNQ83FXfulvAVzG8N1zUBoHJSFZ570Jmqo2bHcKDU5xCH
	 oz8mMFl40OZDLi8zDxPhyociOuuUgaIt9UycXV0A+8EMp2pVOSel41U6qRV2TX4Pio
	 IbLdM8YhgHAOmKLiuYqtLTThyPGv+W0ZWrIWSxZLro86p6Sn4WboQC9C5s3XvX86OP
	 WCu51K7y0yflN+hwHX+AUxLxQvmtqQCtwNP13ltd0yotkgcJPBZSVix7LbZUAFurWB
	 7x8QJDU96V/dg==
Date: Mon, 1 Jun 2026 00:43:20 +0930
From: "Geoffrey D. Bennett" <g@b4.vu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 054/969] ALSA: usb-audio: Improve Focusrite sample
 rate filtering
Message-ID: <ahxQECPrGoTY10B3@m.b4.vu>
References: <20260530160300.485627683@linuxfoundation.org>
 <20260530160301.888290661@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530160301.888290661@linuxfoundation.org>

On Sat, May 30, 2026 at 05:52:58PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Geoffrey D. Bennett <g@b4.vu>
> 
> [ Upstream commit 24d2d3c5f94007a5a0554065ab7349bb69e28bcb ]
> 
> Replace the bLength == 10 max_rate check in
> focusrite_valid_sample_rate() with filtering that also examines the
> bmControls VAL_ALT_SETTINGS bit.
> 
> When VAL_ALT_SETTINGS is readable, the device uses strict
> per-altsetting rate filtering (only the highest rate pair for that
> altsetting is valid). When it is not readable, all rates up to
> max_rate are valid.
> 
> For devices without the bLength == 10 Format Type descriptor extension
> but with VAL_ALT_SETTINGS readable and multiple altsettings (only seen
> in Scarlett 18i8 3rd Gen playback), fall back to the Focusrite
> convention: alt 1 = 48kHz, alt 2 = 96kHz, alt 3 = 192kHz.
> 
> This produces correct rate tables for all tested Focusrite devices
> (all Scarlett 2nd, 3rd, and 4th Gen, Clarett+, and Vocaster) using
> only USB descriptors, allowing QUIRK_FLAG_VALIDATE_RATES to be removed
> for Focusrite in the next commit.
> 
> Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Link: https://patch.msgid.link/7e18c1f393a6ecb6fc75dd867a2c4dbe135e3e22.1771594828.git.g@b4.vu
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/usb/format.c | 86 +++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 74 insertions(+), 12 deletions(-)
> 
> diff --git a/sound/usb/format.c b/sound/usb/format.c
> index f33d25a4e4cc7..682adbdf7ee79 100644
[...]

Hi Greg,

Please drop these from 6.1 and 5.15. They're part of a 3-patch series
that needs all 3 to get the benefit (plus 5 more fixes on top for the
1st Gen Scarletts that the series regressed).

The series avoids leaving the device at 192kHz after probe (which
mutes the internal mixer and disables the Air/Safe modes until an
application opens the PCM). But the part that actually fixes that,
38c322068a26 ("Add QUIRK_FLAG_SKIP_IFACE_SETUP"), wasn't selected.
Without it, __snd_usb_parse_audio_interface() still calls
snd_usb_init_sample_rate(rate_max) at probe, so removing
VALIDATE_RATES on its own doesn't help.

Unfortunately 38c322068a26 is a regression for some 1st Gen Scarletts,
and those exclusions were found one model at a time, so I'm not 100%
confident every affected model is covered, although there have been no
further reports in nearly 8 weeks. I'm not sure for 6.1/5.15 if the
benefit outweighs the risk, but if you'd rather take it all, the full
set in order is:

24d2d3c5f940 ALSA: usb-audio: Improve Focusrite sample rate filtering
a8cc55bf81a4 ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
38c322068a26 ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP
8780f561f671 ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen from SKIP_IFACE_SETUP
990a8b0732cf ALSA: usb-audio: Exclude Scarlett 2i4 1st Gen from SKIP_IFACE_SETUP
f025ac8c698a ALSA: usb-audio: Exclude Scarlett Solo 1st Gen from SKIP_IFACE_SETUP
a0dafdbd1049 ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen (8016) from SKIP_IFACE_SETUP
a47306a74c31 ALSA: usb-audio: Exclude Scarlett 18i20 1st Gen from SKIP_IFACE_SETUP

Same issue applies to 6.6 and 6.12: they took the first two (filter +
VALIDATE_RATES removal) but not 38c322068a26, so the 192kHz behaviour
is unchanged there. They should probably get the same treatment.

Thanks,
Geoffrey
