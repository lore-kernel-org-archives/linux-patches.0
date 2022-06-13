Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BDE1360;
	Mon, 13 Jun 2022 10:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655116066; x=1686652066;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cJw4UTUEc+RWc+ehCramYX9/m6K3edEpj+3lirTKgJs=;
  b=guBBIGxRXWq/FcAfgeac7E86SeYRDSqmImK0+578fV5QctRzNMMV+Abq
   VzToExGKSoC7pwS50nYEqGig0vBiazINisfuZq6AVx1xQzEhM/Vw5uYnC
   4x9DntNimnUiAMPikF4dp5tfBFalUaVcgnDVCZYojlp2Dk4W7RAdxHaAm
   beQ9i8QgW1blNZhruf/eHVLPRcMgLW7eMw0Kb6j4xA1wju8pyMCCfs4IB
   E74Lsq4oygtQq9JdxgDK9LdnRlpDelZfNIjYL3of5URXSHsMSXwEI5o/s
   SNKlCH1StG/jDZD12DkfXmeKxFarrYla9h7j8ZG5QRN6Ii9Mlu8zevuij
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="339910619"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="339910619"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:27:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="639662230"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.58.193])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:27:38 -0700
Message-ID: <40b8507e-1da3-7ab8-cd11-e0d692e08352@intel.com>
Date: Mon, 13 Jun 2022 13:27:36 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH] mmc: sdhci-brcmstb: Initialize base_clk to NULL in
 sdhci_brcmstb_probe()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, Al Cooper <alcooperx@gmail.com>,
 Ulf Hansson <ulf.hansson@linaro.org>, Kamal Dasu <kdasu.kdev@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>
Cc: bcm-kernel-feedback-list@broadcom.com,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 Justin Stitt <jstitt007@gmail.com>, Dan Carpenter
 <dan.carpenter@oracle.com>, linux-mmc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>
References: <20220608152757.82529-1-nathan@kernel.org>
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220608152757.82529-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/06/22 18:27, Nathan Chancellor wrote:
> Clang warns a few times along the lines of:
> 
>   drivers/mmc/host/sdhci-brcmstb.c:302:6: warning: variable 'base_clk' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>           if (res)
>               ^~~
>   drivers/mmc/host/sdhci-brcmstb.c:376:24: note: uninitialized use occurs here
>           clk_disable_unprepare(base_clk);
>                                 ^~~~~~~~
> 
> base_clk is used in the error path before it is initialized. Initialize
> it to NULL, as clk_disable_unprepare() calls clk_disable() and
> clk_unprepare(), which both handle NULL pointers gracefully.
> 
> Fixes: 2cecaac1b21c ("mmc: sdhci-brcmstb: Add ability to increase max clock rate for 72116b0")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1650
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/sdhci-brcmstb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
> index f8dff8537920..28e9cf995c41 100644
> --- a/drivers/mmc/host/sdhci-brcmstb.c
> +++ b/drivers/mmc/host/sdhci-brcmstb.c
> @@ -256,7 +256,7 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
>  	struct sdhci_host *host;
>  	struct resource *iomem;
>  	struct clk *clk;
> -	struct clk *base_clk;
> +	struct clk *base_clk = NULL;
>  	int res;
>  
>  	match = of_match_node(sdhci_brcm_of_match, pdev->dev.of_node);
> 
> base-commit: 10980053142d8a3e86eb4d3014574424b42b7a45

