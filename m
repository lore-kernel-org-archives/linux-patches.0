Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5466514A8F
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 07:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMOcYjHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E548C433C8;
	Tue, 24 Oct 2023 07:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698133724;
	bh=WnmC6H7ZmmJ51nYNdcmp3NTy1FXn+2ppOtiZX2acN/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zMOcYjHEzCvJckkZnC64iyUNu7KQqgvKspnrEoD1BBAFfOyBo4PqAjJEIySBMt+QM
	 sQAXFTfaHYtND7scx810M2OP8hLN0wNnpoCoVlmg7Pa5Ts28rrfh8dczusJ/3bbxQ9
	 QDFrqQBkNU7SlZ0V1eTF6Sk+DyQ20QC8rYuKyC38=
Date: Tue, 24 Oct 2023 09:48:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Doug Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Anton Bambura <jenneron@postmarketos.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 219/241] drm/panel: Move AUX B116XW03 out of
 panel-edp back to panel-simple
Message-ID: <2023102433-sabbath-clarinet-2b6f@gregkh>
References: <20231023104833.832874523@linuxfoundation.org>
 <20231023104839.191685463@linuxfoundation.org>
 <CAD=FV=XV9csGb273q8eam8bAPFR91a9p8DULCZ_Mm6bW0pBQ0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=XV9csGb273q8eam8bAPFR91a9p8DULCZ_Mm6bW0pBQ0w@mail.gmail.com>

On Mon, Oct 23, 2023 at 07:35:36AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Mon, Oct 23, 2023 at 4:12 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.5-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Douglas Anderson <dianders@chromium.org>
> >
> > [ Upstream commit ad3e33fe071dffea07279f96dab4f3773c430fe2 ]
> >
> > In commit 5f04e7ce392d ("drm/panel-edp: Split eDP panels out of
> > panel-simple") I moved a pile of panels out of panel-simple driver
> > into the newly created panel-edp driver. One of those panels, however,
> > shouldn't have been moved.
> >
> > As is clear from commit e35e305eff0f ("drm/panel: simple: Add AUO
> > B116XW03 panel support"), AUX B116XW03 is an LVDS panel. It's used in
> > exynos5250-snow and exynos5420-peach-pit where it's clear that the
> > panel is hooked up with LVDS. Furthermore, searching for datasheets I
> > found one that makes it clear that this panel is LVDS.
> >
> > As far as I can tell, I got confused because in commit 88d3457ceb82
> > ("drm/panel: auo,b116xw03: fix flash backlight when power on") Jitao
> > Shi added "DRM_MODE_CONNECTOR_eDP". That seems wrong. Looking at the
> > downstream ChromeOS trees, it seems like some Mediatek boards are
> > using a panel that they call "auo,b116xw03" that's an eDP panel. The
> > best I can guess is that they actually have a different panel that has
> > similar timing. If so then the proper panel should be used or they
> > should switch to the generic "edp-panel" compatible.
> >
> > When moving this back to panel-edp, I wasn't sure what to use for
> > .bus_flags and .bus_format and whether to add the extra "enable" delay
> > from commit 88d3457ceb82 ("drm/panel: auo,b116xw03: fix flash
> > backlight when power on"). I've added formats/flags/delays based on my
> > (inexpert) analysis of the datasheet. These are untested.
> >
> > NOTE: if/when this is backported to stable, we might run into some
> > trouble. Specifically, before 474c162878ba ("arm64: dts: mt8183:
> > jacuzzi: Move panel under aux-bus") this panel was used by
> > "mt8183-kukui-jacuzzi", which assumed it was an eDP panel. I don't
> > know what to suggest for that other than someone making up a bogus
> > panel for jacuzzi that's just for the stable channel.
> >
> > Fixes: 88d3457ceb82 ("drm/panel: auo,b116xw03: fix flash backlight when power on")
> > Fixes: 5f04e7ce392d ("drm/panel-edp: Split eDP panels out of panel-simple")
> > Tested-by: Anton Bambura <jenneron@postmarketos.org>
> > Acked-by: Hsin-Yi Wang <hsinyi@chromium.org>
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20230925150010.1.Iff672233861bcc4cf25a7ad0a81308adc3bda8a4@changeid
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpu/drm/panel/panel-edp.c    | 29 -----------------------
> >  drivers/gpu/drm/panel/panel-simple.c | 35 ++++++++++++++++++++++++++++
> >  2 files changed, 35 insertions(+), 29 deletions(-)
> 
> I responded to Sasha but managed to miss CCing stable@. My
> apologies... Copying what I wrote there:
> 
> ---
> 
> I feel that this should not be added to any stable trees. Please
> remove it from the 6.1 and 6.5 stable trees and, if possible, mark it
> so it won't get auto-selected in the future.
> 
> The issue here is that several mediatek boards ended up (incorrectly)
> claiming that they included this panel and this change has the
> possibility to break those boards. In the latest upstream kernel
> mediatek boards that were using it have switched to the generic
> "edp-panel" compatible string, but if this is backported someplace
> before that change it has the potential to break folks.
> 
> It should be noted that it was confirmed that the "snow" and
> "peach-pit" boards appeared to be working even without this patch, so
> there is no burning need (even for those boards) to get this patch
> backported.
> 
> For discussion on the topic, please see the link pointed to by the patch, AKA:
> 
> https://patchwork.freedesktop.org/patch/msgid/20230925150010.1.Iff672233861bcc4cf25a7ad0a81308adc3bda8a4@changeid
> 
> ---
> 
> Sasha has already said he'd remove it from the queue, but responding
> here just in case it's important. Thanks!

He's dropped them now, thanks!

greg k-h
