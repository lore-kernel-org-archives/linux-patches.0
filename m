Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32F67E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F206C433C1;
	Wed,  2 Nov 2022 02:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667357370;
	bh=W4fAhnKbB727M/BBd7ZkvwyarygTC85F2EeJtyYUMec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvbtbU6E38Y8CQ1GJX/u7/GDZTJHDaRxGZPkNR8g/2SDCyeCVX2JhV/PzMO5LTcJa
	 rTDRkc0lPxIVjIGfpF38bwThUYCS4wiUpyE37ZHDX2IzapaZWA5dXmhiQWX3WzXbAI
	 kBKRIHR6Nz+qy4gjr/ZFmsu++QCrzvGVU6lT/uPNPrlBjrYnjhfTiMG4/faK0wSP3w
	 nyr4VXFUxqyirIXSv5uyfCOKJLluzF5a9pTbsaJaEIGG4+hS2qSrfSymwNfeHlcLtR
	 SyldkVAXhNW98BRCwZSZjBZDh3IhqnEUoEvxmWz6wkEsvb6X7xOTpx85uaRdELQffi
	 6RNvz62EWserA==
Date: Tue, 1 Nov 2022 21:49:27 -0500
From: Bjorn Andersson <andersson@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, patches@lists.linux.dev,
	Andy Gross <agross@kernel.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	linux-arm-msm@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Satya Priya <quic_c_skakit@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] clk: qcom: gdsc: Remove direct runtime PM calls
Message-ID: <20221102024927.n5mjyzyqyapveapa@builder.lan>
References: <20221101233421.997149-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101233421.997149-1-swboyd@chromium.org>

On Tue, Nov 01, 2022 at 04:34:21PM -0700, Stephen Boyd wrote:
> We shouldn't be calling runtime PM APIs from within the genpd
> enable/disable path for a couple reasons.
[..][
> Upon closer inspection, calling runtime PM APIs like this in the GDSC
> driver doesn't make sense. It was intended to make sure the GDSC for the
> clock controller providing other GDSCs was enabled, specifically the
> MMCX GDSC for the display clk controller on SM8250 (sm8250-dispcc), so
> that GDSC register accesses succeeded. That will already happen because
> we make the 'dev->pm_domain' a parent domain of each GDSC we register in
> gdsc_register() via pm_genpd_add_subdomain(). When any of these GDSCs
> are accessed, we'll enable the parent domain (in this specific case
> MMCX).
> 

It's correct that adding the GDSCs as subdomains for the device's
parent-domain will ensure that enabling a GDSC will propagate up and
turn on the (typically) rpmhpd resource.

But the purpose for the explicit calls was to ensure that the clock
controller itself is accessible. It's been a while since I looked at
this, but iirc letting MMCX to turn off would cause the register access
during dispcc probing to fail - similar to how
clk_pm_runtime_get()/put() ensures the clock registers are accessible.


Perhaps I misunderstood something in the process, or lost track of the
actual issues?

Regards,
Bjorn
