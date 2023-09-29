Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996BB20F9
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 19:56:42 +0000 (UTC)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1qmJbL-00056x-Gl; Fri, 29 Sep 2023 21:56:39 +0200
Message-ID: <e85da95c-5451-31ea-cae9-76d697fb548f@pengutronix.de>
Date: Fri, 29 Sep 2023 21:56:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 329/406] clk: imx: pll14xx: dynamically configure PLL
 for 393216000/361267200Hz
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Marco Felsch <m.felsch@pengutronix.de>,
 Abel Vesa <abel.vesa@linaro.org>
References: <20230917191101.035638219@linuxfoundation.org>
 <20230917191109.976825265@linuxfoundation.org>
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20230917191109.976825265@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev

Hi,

On 17.09.23 21:13, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ahmad Fatoum <a.fatoum@pengutronix.de>
> 
> commit 72d00e560d10665e6139c9431956a87ded6e9880 upstream.
> 
> Since commit b09c68dc57c9 ("clk: imx: pll14xx: Support dynamic rates"),
> the driver has the ability to dynamically compute PLL parameters to
> approximate the requested rates. This is not always used, because the
> logic is as follows:
> 
>   - Check if the target rate is hardcoded in the frequency table
>   - Check if varying only kdiv is possible, so switch over is glitch free
>   - Compute rate dynamically by iterating over pdiv range
> 
> If we skip the frequency table for the 1443x PLL, we find that the
> computed values differ to the hardcoded ones. This can be valid if the
> hardcoded values guarantee for example an earlier lock-in or if the
> divisors are chosen, so that other important rates are more likely to
> be reached glitch-free.
> 
> For rates (393216000 and 361267200, this doesn't seem to be the case:
> They are only approximated by existing parameters (393215995 and
> 361267196 Hz, respectively) and they aren't reachable glitch-free from
> other hardcoded frequencies. Dropping them from the table allows us
> to lock-in to these frequencies exactly.
> 
> This is immediately noticeable because they are the assigned-clock-rates
> for IMX8MN_AUDIO_PLL1 and IMX8MN_AUDIO_PLL2, respectively and a look
> into clk_summary so far showed that they were a few Hz short of the target:
> 
> imx8mn-board:~# grep audio_pll[12]_out /sys/kernel/debug/clk/clk_summary
> audio_pll2_out           0        0        0   361267196 0     0  50000   N
> audio_pll1_out           1        1        0   393215995 0     0  50000   Y
> 
> and afterwards:
> 
> imx8mn-board:~# grep audio_pll[12]_out /sys/kernel/debug/clk/clk_summary
> audio_pll2_out           0        0        0   361267200 0     0  50000   N
> audio_pll1_out           1        1        0   393216000 0     0  50000   Y
> 
> This change is equivalent to adding following hardcoded values:
> 
>   /*               rate     mdiv  pdiv  sdiv   kdiv */
>   PLL_1443X_RATE(393216000, 655,    5,    3,  23593),
>   PLL_1443X_RATE(361267200, 497,   33,    0, -16882),
> 
> Fixes: 053a4ffe2988 ("clk: imx: imx8mm: fix audio pll setting")
> Cc: stable@vger.kernel.org # v5.18+

Patch is only correct for v5.18 onward. Please drop for v5.10.

Thanks,
Ahmad

> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> Link: https://lore.kernel.org/r/20230807084744.1184791-2-m.felsch@pengutronix.de
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/clk/imx/clk-pll14xx.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- a/drivers/clk/imx/clk-pll14xx.c
> +++ b/drivers/clk/imx/clk-pll14xx.c
> @@ -60,8 +60,6 @@ static const struct imx_pll14xx_rate_tab
>  	PLL_1443X_RATE(650000000U, 325, 3, 2, 0),
>  	PLL_1443X_RATE(594000000U, 198, 2, 2, 0),
>  	PLL_1443X_RATE(519750000U, 173, 2, 2, 16384),
> -	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
> -	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
>  };
>  
>  struct imx_pll14xx_clk imx_1443x_pll = {
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

