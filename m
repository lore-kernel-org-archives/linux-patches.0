Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6CF10F3
	for <patches@lists.linux.dev>; Fri,  1 Jul 2022 04:00:15 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id 72-20020a9d064e000000b00616c2a174bcso950337otn.8
        for <patches@lists.linux.dev>; Thu, 30 Jun 2022 21:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UIQbOmI3pL7SkABqDJH+080MonEhwBz+pt3xl6BVtfY=;
        b=VaIR2IHSPRPJ4kuxXmfzhrJ0wSULAztD2o7AVZAHEJ8Te02eO8QDQCGlIdZ5mYkpX6
         ylFuZoHqHx2+xfG4+1DRCC40gKFT8T8hvE+XDWCe7pWtdBWQ1lrrvtolJyrdefVkcN6F
         h9B9SR6lGywh1BjymSnUXOU83OnudKCp+hQGliBhjX+JaQkkzxpSsMT2Bgshljx+jPBS
         eO6ReqMUrYnvNXKzIdcRBmwzzIRdo9yQ+ETzjlew7HKujhn5mSfRy2+DZzNzFauNQMoB
         DpL3S+EZY0ZuLIUMNVCNc1ZEBxiA95yfKfFc5fuLxpCMw/8XaoiNOGaeUUBnMqTE69fY
         ft/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UIQbOmI3pL7SkABqDJH+080MonEhwBz+pt3xl6BVtfY=;
        b=oDgsrwmdYuL0i5Lj/tp6XOXB10aekOPWzCbZ8lT82BenFk7Yfsveti4r9EM7p9ZUHO
         +Xr/jFrBToWvPg3KgYtRHOBnXKrujNTiFLn26agMZ0ZuyQO9iU9tQx1fdt9R7Z3SIlpX
         8iETjpPrmKPASTPV4meCkPGZ5mLwyq1N6Jt98mHEZuJNBWzNvL1mqD0qO6+x2sQQYpQ+
         YK+ZXI9YMDc06sy3kWWflslJwadjvwxuZPWh0ffJ4KHKRNuKxGgHM3b4crgNrGk6UG/b
         H6ZtDgXgyqjAxNFkhuZccbxrFI7BEkhI5D1IwRYQiv68o26vXv1o9WNK8BmUxphMoR52
         BB1g==
X-Gm-Message-State: AJIora93yxUiYi+h4dCrX9luyraNVRD+u4R5wxMNtw8XajcA1rFAeYjv
	ErBG8DBLurKScuOJdh0ajqbwLQ==
X-Google-Smtp-Source: AGRyM1uXeVOAg5ZEY1ZkjTbui+MlAXJH0K22EzbbOpufiKUlHPpw/tLNbnYPCH5I6VHR2KWyRNHqAA==
X-Received: by 2002:a05:6830:12cb:b0:616:b36b:e50b with SMTP id a11-20020a05683012cb00b00616b36be50bmr5751122otq.1.1656648014778;
        Thu, 30 Jun 2022 21:00:14 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id s4-20020a056870ea8400b000f1bc45ba21sm15063247oap.14.2022.06.30.21.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 21:00:14 -0700 (PDT)
Date: Thu, 30 Jun 2022 23:00:11 -0500
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, Taniya Das <quic_tdas@quicinc.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>
Subject: Re: [PATCH/RFC] clk: qcom: rpmh: Block system suspend if XO is
 enabled
Message-ID: <Yr5xS/HCrBuNrn9N@builder.lan>
References: <20220628201340.3981860-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628201340.3981860-1-swboyd@chromium.org>

On Tue 28 Jun 15:13 CDT 2022, Stephen Boyd wrote:

> Tracking down what RPMh resource is blocking XO shutdown in suspend is
> hard. Largely because we need external debug tools to dump the RPMh
> internal state to figure out what resource is enabled. Instead of doing
> that, let's just block system wide suspend in the kernel if the RPMh XO
> resource is enabled by something in the kernel. This will help us narrow
> down XO shutdown failures to the XO clk, and not something else like an
> interconnect or regulator RPMh resource.
> 
> I'm sending this as an RFC because it breaks suspend for me on Trogdor
> boards. I found out that the XO resource is always enabled on these
> devices because the audio driver leaves an audio clk always on. This
> means that the XO resource must not be used to determine if XO shutdown
> is achievable, or we're leaving power savings on the table.
> 
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
> 
> Please don't apply. It will break suspend on Trogdor boards.
> 

This seems like a useful debug feature for people outside of Qualcomm,
so I assume you're saying that we shouldn't merge it until someone has
fixed the audio driver? Or did you post it just as a debug tool?

Regards,
Bjorn

>  drivers/clk/qcom/clk-rpmh.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
> index aed907982344..ba0e0e4b9cf2 100644
> --- a/drivers/clk/qcom/clk-rpmh.c
> +++ b/drivers/clk/qcom/clk-rpmh.c
> @@ -70,6 +70,14 @@ struct clk_rpmh_desc {
>  
>  static DEFINE_MUTEX(rpmh_clk_lock);
>  
> +/* XO shutdown will fail if XO is enabled across suspend */
> +static int clk_rpmh_suspend(struct device *dev)
> +{
> +	struct clk_rpmh *xo = dev_get_drvdata(dev);
> +
> +	return xo && xo->state ? -EBUSY : 0;
> +}
> +
>  #define __DEFINE_CLK_RPMH(_platform, _name, _name_active, _res_name,	\
>  			  _res_en_offset, _res_on, _div)		\
>  	static struct clk_rpmh _platform##_##_name_active;		\
> @@ -690,6 +698,10 @@ static int clk_rpmh_probe(struct platform_device *pdev)
>  			dev_err(&pdev->dev, "failed to register %s\n", name);
>  			return ret;
>  		}
> +
> +		/* Stash CXO clk for XO shutdown tracking */
> +		if (i == RPMH_CXO_CLK)
> +			platform_set_drvdata(pdev, rpmh_clk);
>  	}
>  
>  	/* typecast to silence compiler warning */
> @@ -722,9 +734,12 @@ static const struct of_device_id clk_rpmh_match_table[] = {
>  };
>  MODULE_DEVICE_TABLE(of, clk_rpmh_match_table);
>  
> +static SIMPLE_DEV_PM_OPS(clk_rpmh_pm_ops, clk_rpmh_suspend, NULL);
> +
>  static struct platform_driver clk_rpmh_driver = {
>  	.probe		= clk_rpmh_probe,
>  	.driver		= {
> +		.pm	= pm_ptr(&clk_rpmh_pm_ops),
>  		.name	= "clk-rpmh",
>  		.of_match_table = clk_rpmh_match_table,
>  	},
> 
> base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
> -- 
> https://chromeos.dev
> 
