Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5502D278;
	Fri, 17 Nov 2023 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JPmtshJI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700200686; x=1731736686;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=764IZoVQhx16LgTa6GgD/tKF6hSla9ceQN/OG1Ayc6I=;
  b=JPmtshJIQp5cFuh3ldnQUJuWgxKQpcksrRIl919urOBE17I92AoXOhXn
   FZYv9RikWPa/sEPh6Cxcm3Z2Z9MS7ausHDrAx40PQetvaKB0mcqjKaeon
   5feGaSzAHHKCynsJ1sZzynyCiVqnnADmarFmZlarceY9kMNKIRdlraoIX
   fLvsN38XioMln/TpyZWsPYOpHZPJjdjwqDie6PnMCpmeqaNkWUrzt6E9x
   ySiSRp+pe+mnFc23u1YZE0VbR02FjvKdowOriWbvs7obDqTbc6Ojs4/VL
   oX7F2JVJffo8O4h7wzgB0A7Mxuott1Zw6erhz6rsGimD6BMlfjJWo6DYF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="376290965"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="376290965"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 21:58:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="883015200"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883015200"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.39.65])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 21:58:04 -0800
Message-ID: <aa9039ca-69a5-4dca-8205-0b17782c7319@intel.com>
Date: Fri, 17 Nov 2023 07:58:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mmc: sdhci-of-dwcmshc: Use logical OR instead of bitwise
 OR in dwcmshc_probe()
To: Nathan Chancellor <nathan@kernel.org>, ulf.hansson@linaro.org
Cc: dfustini@baylibre.com, linux-mmc@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-v1-1-7e1a7f4ccaab@kernel.org>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-v1-1-7e1a7f4ccaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/11/23 03:46, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>     873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
>         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                                        ||
>     875 |                     (device_property_read_bool(dev, "mmc-hs400-1_8v")))
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>     873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
>         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                                      ||
>     874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
>   2 errors generated.
> 
> There is little reason for this if statement to use bitwise ORs, as the
> short circuiting of logical OR does not need to be avoided in this
> context; it would be wasteful to call device_property_read_bool() three
> times if the first two calls returned true. Switch to logical OR to fix
> the warning.
> 
> While in the area, the parentheses around the calls to
> device_property_read_bool() are not necessary and make the if statement
> harder to read, so remove them.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1960
> Fixes: aff35fbc7830 ("mmc: sdhci-of-dwcmshc: Add support for T-Head TH1520")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/sdhci-of-dwcmshc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
> index 0eb72544c09e..a1f57af6acfb 100644
> --- a/drivers/mmc/host/sdhci-of-dwcmshc.c
> +++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
> @@ -870,9 +870,9 @@ static int dwcmshc_probe(struct platform_device *pdev)
>  	if (pltfm_data == &sdhci_dwcmshc_th1520_pdata) {
>  		priv->delay_line = PHY_SDCLKDL_DC_DEFAULT;
>  
> -		if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
> -		    (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
> -		    (device_property_read_bool(dev, "mmc-hs400-1_8v")))
> +		if (device_property_read_bool(dev, "mmc-ddr-1_8v") ||
> +		    device_property_read_bool(dev, "mmc-hs200-1_8v") ||
> +		    device_property_read_bool(dev, "mmc-hs400-1_8v"))
>  			priv->flags |= FLAG_IO_FIXED_1V8;
>  		else
>  			priv->flags &= ~FLAG_IO_FIXED_1V8;
> 
> ---
> base-commit: 3f00051234f02d0d9d1f63b9a334d0fd4c65b6ca
> change-id: 20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-bf8fed73b5bb
> 
> Best regards,

