Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C79184A;
	Tue, 14 Jun 2022 05:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D609CC3411B;
	Tue, 14 Jun 2022 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1655184622;
	bh=9l+iMcSM/DmvozPd4ozkq1hDQFKRmGEPfuXGp/QM7hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arAqPKGls8bT2wjhixbzjcHeeK7f22+DW2dLL5iEYeMcFiUdNDJIR5V4J6S5mcUjr
	 Szr9a3oUa5Ihfpl0JJ3kFix+EvWwKK7+Pu57QNZ7WH6KoLV/i7F5gaiIrpu40h77VP
	 z+ZI8uOKRQUjCEuUl59SX2K9uLafb7/n91Mvg35qdjp8bxDFa2I6ggsB05FNDqno4v
	 rozoKEmTO2DwpAlg5DLuoWv95hZW6s2eKZg/UpJK6oC7USQKhXc8E8gyEQZYG0171R
	 pYX99+jMEHqoHXZ9BPZfvYnJUoVGPWcUGmOodVduWrTz9YcEr0TPgFPp5Gn5LNLXiX
	 NQDqRbHgkBvMQ==
Date: Tue, 14 Jun 2022 05:30:18 +0000
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
Message-ID: <Yqgc6sD7bEHLVYRg@google.com>
References: <20220611061825.4119270-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611061825.4119270-1-swboyd@chromium.org>

On Fri, Jun 10, 2022 at 11:18:25PM -0700, Stephen Boyd wrote:
> @@ -135,10 +135,10 @@ static int cros_ec_sleep_event(struct cros_ec_device *ec_dev, u8 sleep_event)
>  	buf.msg.command = EC_CMD_HOST_SLEEP_EVENT;
>  
>  	ret = cros_ec_cmd_xfer_status(ec_dev, &buf.msg);
> -
> -	/* For now, report failure to transition to S0ix with a warning. */
> +	/* Report failure to transition to system wide suspend with a warning. */
>  	if (ret >= 0 && ec_dev->host_sleep_v1 &&
> -	    (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME)) {
> +	    (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME ||
> +	     sleep_event == HOST_SLEEP_EVENT_S3_RESUME)) {
>  		ec_dev->last_resume_result =
>  			buf.u.resp1.resume_response.sleep_transitions;

The warning in the if-block:
WARN_ONCE(buf.u.resp1.resume_response.sleep_transitions &
          EC_HOST_RESUME_SLEEP_TIMEOUT,
          "EC detected sleep transition timeout. Total slp_s0 transitions: %d",
          buf.u.resp1.resume_response.sleep_transitions &
          EC_HOST_RESUME_SLEEP_TRANSITIONS_MASK);

Not sure and I wonder if the term "slp_s0" is still generic enough to the case.
And also [1].

[1]: https://crrev.com/a311a7657ca0a488f507fa78fd9c2d825cbf083e/power_manager/powerd/system/suspend_configurator.cc#98

At least we should fix [2] once the patch landed.

[2]: https://crrev.com/a311a7657ca0a488f507fa78fd9c2d825cbf083e/power_manager/tools/suspend_stress_test#369
