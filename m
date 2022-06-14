Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFBE1366;
	Tue, 14 Jun 2022 06:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6ECC3411B;
	Tue, 14 Jun 2022 06:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1655188247;
	bh=jjLucxVfYponZZbTy9aAXqu9kv3d9EqWhXxAmri77yk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDtlif+OOvJpKdA8CtAXUlFZEcek3+IzpLAW59f0C+maa77x2kY9RWblSlvKF3eNG
	 X5OaczZNlBxu+5paKOXWG6wCdoafksB8DEJR4piKi5ZLpGMW8NRi/mPlGlbs/n6iNl
	 BPA121LoYnfJq/ZaHLfLz5gEl3Un/O/1a/VhBQW8vHVBD2+lQaeOrePRF1E6P47PQF
	 EG7ix6IPAWP7hPVHHVFWkdi680312IUmjzR7+apH3Dv5LL223FlaFabuUcbPYTwW9R
	 xIE+isTWg9j07CrMXZnWr/6itBLdoL7hkjsV8lJpdRJXXju17OrriIB4J7l6KtB71L
	 KvgB7IGi+lNxg==
Date: Tue, 14 Jun 2022 06:30:44 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev, Evan Green <evgreen@chromium.org>,
	Rajat Jain <rajatja@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>
Subject: Re: [PATCH v2] platform/chrome: cros_ec: Always expose last resume
 result
Message-ID: <YqgrFORv5rMggcLs@google.com>
References: <20220611061825.4119270-1-swboyd@chromium.org>
 <Yqgc6sD7bEHLVYRg@google.com>
 <CAE-0n53aiXq+eUC0gq=J0kO+_zFpZGnL42AgyEBVM-_wtccnJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n53aiXq+eUC0gq=J0kO+_zFpZGnL42AgyEBVM-_wtccnJA@mail.gmail.com>

On Mon, Jun 13, 2022 at 11:17:50PM -0700, Stephen Boyd wrote:
> Quoting Tzung-Bi Shih (2022-06-13 22:30:18)
> > On Fri, Jun 10, 2022 at 11:18:25PM -0700, Stephen Boyd wrote:
> > > @@ -135,10 +135,10 @@ static int cros_ec_sleep_event(struct cros_ec_device *ec_dev, u8 sleep_event)
> > >       buf.msg.command = EC_CMD_HOST_SLEEP_EVENT;
> > >
> > >       ret = cros_ec_cmd_xfer_status(ec_dev, &buf.msg);
> > > -
> > > -     /* For now, report failure to transition to S0ix with a warning. */
> > > +     /* Report failure to transition to system wide suspend with a warning. */
> > >       if (ret >= 0 && ec_dev->host_sleep_v1 &&
> > > -         (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME)) {
> > > +         (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME ||
> > > +          sleep_event == HOST_SLEEP_EVENT_S3_RESUME)) {
> > >               ec_dev->last_resume_result =
> > >                       buf.u.resp1.resume_response.sleep_transitions;
> >
> > The warning in the if-block:
> > WARN_ONCE(buf.u.resp1.resume_response.sleep_transitions &
> >           EC_HOST_RESUME_SLEEP_TIMEOUT,
> >           "EC detected sleep transition timeout. Total slp_s0 transitions: %d",
> >           buf.u.resp1.resume_response.sleep_transitions &
> >           EC_HOST_RESUME_SLEEP_TRANSITIONS_MASK);
> >
> > Not sure and I wonder if the term "slp_s0" is still generic enough to the case.
> > And also [1].
> >
> > [1]: https://crrev.com/a311a7657ca0a488f507fa78fd9c2d825cbf083e/power_manager/powerd/system/suspend_configurator.cc#98
> 
> I don't know what "slp_s0" means. I guess it's some intelism? It could
> change to "sleep" and work for me.
> 
> >
> > At least we should fix [2] once the patch landed.
> >
> > [2]: https://crrev.com/a311a7657ca0a488f507fa78fd9c2d825cbf083e/power_manager/tools/suspend_stress_test#369
> 
> And by fix you mean change "S0iX" to "suspend"?

Yes.
