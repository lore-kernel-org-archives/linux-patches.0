Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5B7E107;
	Wed, 30 Apr 2025 12:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746014747; cv=none; b=mphUwny7jcp5pNhf+HzA4RsSB0rstCXJ2V3QUGNNWiz/nxQkonhr3CjLShP2h/7kiNGlDK5h/j3kWJqt/kbeN2G789bD1owmoYKXIBe5Owki+iEcMeJgxvzddeKAY6P07PHityyY3yC9eLZTRwfAM6u5uOsm0gNvjfN/ezLF2B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746014747; c=relaxed/simple;
	bh=nZo6aZZpdiBBHzLRsbGar147DbeG+1FEzKl7AA6QWPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAaWwODRRLijsMrdf0dREz/yBKmdDYvHgepliVDVu1WkOBd+NsuCgILOmCpZnLW6awt4WJA389OBu6sDRKY9u5xRGzuRdzOnXrPfZxy4aFgISH+SF0PQFKxga2LvBdCIvqfKwH8zu7yJgXijdSYCv4TIlNqNM9DZtFdhPUVQeus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8AoANsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8AoANsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA3BC4CEE9;
	Wed, 30 Apr 2025 12:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746014746;
	bh=nZo6aZZpdiBBHzLRsbGar147DbeG+1FEzKl7AA6QWPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8AoANshaZ+ynDzEt95pf+JZI5d9PzVsIdFuqQ+4Ny0bk72gdlVAczUHmr/V1R553
	 wIodNuyT/XqABnV6my6y3PWfDUnhO0rP0XKdVNUDokv8QoSdNPUrPvD92oIn8gcmZq
	 ZfbsR+xM2iczJzKORjaHHO8efLicMeswQclKNq3A=
Date: Wed, 30 Apr 2025 09:21:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 020/204] ASoC: qcom: lpass: Make
 asoc_qcom_lpass_cpu_platform_remove() return void
Message-ID: <2025043003-goon-retouch-debd@gregkh>
References: <20250429161059.396852607@linuxfoundation.org>
 <20250429161100.253501778@linuxfoundation.org>
 <npexot3y75j2lyvv2w33k6clvla24hpxls32giyyzh7swoyngs@p2qwspziwcwt>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <npexot3y75j2lyvv2w33k6clvla24hpxls32giyyzh7swoyngs@p2qwspziwcwt>

On Wed, Apr 30, 2025 at 08:54:30AM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Tue, Apr 29, 2025 at 06:41:48PM +0200, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > [ Upstream commit d0cc676c426d1958989fac2a0d45179fb9992f0a ]
> > 
> > The .remove() callback for a platform driver returns an int which makes
> > many driver authors wrongly assume it's possible to do error handling by
> > returning an error code.  However the value returned is (mostly) ignored
> > and this typically results in resource leaks. To improve here there is a
> > quest to make the remove callback return void. In the first step of this
> > quest all drivers are converted to .remove_new() which already returns
> > void.
> > 
> > asoc_qcom_lpass_cpu_platform_remove() returned zero unconditionally.
> > Make it return void instead and convert all users to struct
> > platform_device::remove_new().
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Link: https://lore.kernel.org/r/20231013221945.1489203-15-u.kleine-koenig@pengutronix.de
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Stable-dep-of: a93dad6f4e6a ("ASoC: q6apm-dai: make use of q6apm_get_hw_pointer")
> 
> I didn't try to actually apply the patches without this, but I guess the
> upside of this commit is only to prevent a trivial merge conflict in
> sound/soc/qcom/lpass.h.
> 
> Not sure this is justification enough to backport this patch to stable.
> (Totally fine if you think it is, just sharing my thoughts.)

merge conflicts are bad, adding additional patches to prevent that is
good :)

