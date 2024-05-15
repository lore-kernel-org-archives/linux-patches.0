Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C42B41C73;
	Wed, 15 May 2024 07:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715759502; cv=none; b=h0O9P339b5Elj1Tq3CDjVvAt9u1QaL1s51HM3o4F2NyFi5D3UeU75N6ET0DkmUlBzIv6+iYgbUPZJZfezgjVhPfhYYgfRXfAntf6sVb/ly+GvwYUV7JVxIsDR7rJnN/On4gRjKaKxDmaWmqtH1JXLavxcyPQ7Xzp8vY9PvXbAHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715759502; c=relaxed/simple;
	bh=1vDdTLpjyTmHDqyYX9ahZF7XLwKvShRk1KIxzZTG66A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1vrryq8iD+Mk8/TYhrEdPhUGhw2jph4oZw8Jc3S9HfhF5KgNT6VhPALEWfjQG/vn193Zhxh05wQ7uWfJXEIDsdYq3cB+gfkoQ4t1IikW1HQQGFFwKZ1QlHc0109pzOh5thMpOPlBgvKZ5uJe2VPoHRw+NWS35xWFUs7guXOgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5HSjC5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5HSjC5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46283C32782;
	Wed, 15 May 2024 07:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715759501;
	bh=1vDdTLpjyTmHDqyYX9ahZF7XLwKvShRk1KIxzZTG66A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V5HSjC5YL/+WApLuY3zyAfPRso+ZAgu3NdqgB1ocHbjG5WdkDUArRRQjcIKioZRuR
	 HiMAP6StzvfQU9VpDbNpCCwtkT4tFglwmsOqGGcAWR0kZyNYbEuvKsG3rPWOzdkL4T
	 +JwUOi8r8Zu1u/To7G13iHMnQnWpTU5FqfmYkk2A=
Date: Wed, 15 May 2024 09:51:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jerome Brunet <jbrunet@baylibre.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dmitry Shmidt <dimitrysh@google.com>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 100/168] ASoC: meson: axg-card: Fix nonatomic links
Message-ID: <2024051548-worsening-thrift-c427@gregkh>
References: <20240514101006.678521560@linuxfoundation.org>
 <20240514101010.464612719@linuxfoundation.org>
 <1j34qkzh7w.fsf@starbuckisacylon.baylibre.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1j34qkzh7w.fsf@starbuckisacylon.baylibre.com>

On Tue, May 14, 2024 at 02:26:02PM +0200, Jerome Brunet wrote:
> 
> On Tue 14 May 2024 at 12:19, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> >
> 
> Patch #100 and #101 should not be applied on v5.15.
> 
> A bit of history:
> * 3y ago patches #44 and #45 have been applied to fix a problem in AML
>   audio, but it caused a regression.
> * No solution was found at the time, so the patches were reverted by
>   change #100 and #101
> * Recently I came up with change #43 which fixes the regression from 3y
>   ago, so the fixes for original problem could be applied again (with a
>   different sha1 of course)
> 
> The situation was detailed in the cover letter of the related series:
> https://lore.kernel.org/linux-amlogic/20240426152946.3078805-1-jbrunet@baylibre.com
> 
> >From what I can see the backport is fine on 6.8, 6.6 and 6.1.
> Things starts to be problematic on 5.15.
> 
> In general, if upstream commit b11d26660dff is backported, it is fine to
> apply upstream commits:
>  * dcba52ace7d4 ("ASoC: meson: axg-card: make links nonatomic")
>  * f949ed458ad1 ("ASoC: meson: axg-tdm-interface: manage formatters in trigger")
> And the following commits (which are reverts for the 2 above) should not be applied:
>  * 0c9b152c72e5 ("ASoC: meson: axg-card: Fix nonatomic links")
>  * c26830b6c5c5 ("ASoC: meson: axg-tdm-interface: Fix formatters in trigger"")
> 
> If b11d26660dff is not backported, the 2 first change should be
> backported, or reverted if they have already been.
> 
> * v5.15: just dropping change #100 and #101 should be fine

I have now dropped these.

> * v5.10: I suppose this is where the backport starts to be problematic
>          Best would be to drop #31, #32, #73 and #74 for now

All now dropped.

> * v5.4: Same drop #26, #27, #60 and #61

All now dropped.

> * v4.19: drop #17 and #44

Dropped!

thanks for letting me know.

greg k-h
