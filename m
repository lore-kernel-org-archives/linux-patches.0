Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD331865
	for <patches@lists.linux.dev>; Mon, 11 Apr 2022 18:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043C7C385A3;
	Mon, 11 Apr 2022 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1649700947;
	bh=SmPn3X5cDheOoHZUwKpL4wLNjM+9ri/u/69IOXPFMxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lLLugj9E7TrArwkSQ8iGhRwb5kxa0xtV9rerl4JaCG73VuUqZBxyht9oFMMEywgVg
	 HiQRyJ5EqXcZ8bGMRL22t9lyR+ctU/MXul7pp8N2scHt0KWj4pvx2BvhmeAFpn3L3J
	 S5KKUooIPSrU2ei98GlCmVP6O9vShLoOs0dfbdWWRtR61JWVq5MJFHqjuNDFaXNhzF
	 q1h1r6sQL1E3NAWRhoSxo70WUvfu9zRm6AMUU3DFDig4M/Og1cEC3OrtG8WUAfNaa2
	 LUod5k1PbEZUugl6qTfs+vpRL4aqrIqCRzTokgJ9RROn2XVSiFie+c3efya9JHvKx0
	 TJGuGozMPOJFA==
Date: Mon, 11 Apr 2022 11:15:45 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/msm/gpu: Avoid -Wunused-function with
 !CONFIG_PM_SLEEP
Message-ID: <YlRwUb3ZXyWItt+W@dev-arch.thelio-3990X>
References: <20220330180541.62250-1-nathan@kernel.org>
 <4deb0930-b244-677a-9f97-3730686eff5a@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4deb0930-b244-677a-9f97-3730686eff5a@linaro.org>

On Mon, Apr 11, 2022 at 03:53:01AM +0300, Dmitry Baryshkov wrote:
> On 30/03/2022 21:05, Nathan Chancellor wrote:
> > When building with CONFIG_PM=y and CONFIG_PM_SLEEP=n (such as ARCH=riscv
> > allmodconfig), the following warnings/errors occur:
> > 
> >    drivers/gpu/drm/msm/adreno/adreno_device.c:679:12: error: 'adreno_system_resume' defined but not used [-Werror=unused-function]
> >      679 | static int adreno_system_resume(struct device *dev)
> >          |            ^~~~~~~~~~~~~~~~~~~~
> >    drivers/gpu/drm/msm/adreno/adreno_device.c:655:12: error: 'adreno_system_suspend' defined but not used [-Werror=unused-function]
> >      655 | static int adreno_system_suspend(struct device *dev)
> >          |            ^~~~~~~~~~~~~~~~~~~~~
> >    cc1: all warnings being treated as errors
> > 
> > These functions are only used in SET_SYSTEM_SLEEP_PM_OPS(), which
> > evaluates to empty when CONFIG_PM_SLEEP is not set, making these
> > functions unused.
> > 
> > Traditionally, these functions are marked as __maybe_unused but in this
> > case, there is already an '#ifdef CONFIG_PM' in the code, so just do the
> > same thing with CONFIG_PM_SLEEP to resolve the warning.
> > 
> > Fixes: 7e4167c9e021 ("drm/msm/gpu: Park scheduler threads for system suspend")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> I'd suggest using __maybe_unused instead (and maybe even sending the
> followup patch changing the #ifdef CONFIG_PM to __maybe_unused too):
> 
> If the code is included into the compilation, it means it's more widely
> compile tested. Which tends to reveal obscure bugs, dependencies, etc.

Thanks, I looked into it and there was a recent rework of the PM macros
that allows us to eliminate the existing #ifdef. I have sent v2:

https://lore.kernel.org/20220411181249.2758344-1-nathan@kernel.org/

Cheers,
Nathan

> > ---
> >   drivers/gpu/drm/msm/adreno/adreno_device.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
> > index 661dfa7681fb..b25915230bab 100644
> > --- a/drivers/gpu/drm/msm/adreno/adreno_device.c
> > +++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
> > @@ -621,6 +621,7 @@ static int adreno_runtime_suspend(struct device *dev)
> >   	return gpu->funcs->pm_suspend(gpu);
> >   }
> > +#ifdef CONFIG_PM_SLEEP
> >   static void suspend_scheduler(struct msm_gpu *gpu)
> >   {
> >   	int i;
> > @@ -681,8 +682,8 @@ static int adreno_system_resume(struct device *dev)
> >   	resume_scheduler(dev_to_gpu(dev));
> >   	return pm_runtime_force_resume(dev);
> >   }
> > -
> > -#endif
> > +#endif /* CONFIG_PM_SLEEP */
> > +#endif /* CONFIG_PM */
> >   static const struct dev_pm_ops adreno_pm_ops = {
> >   	SET_SYSTEM_SLEEP_PM_OPS(adreno_system_suspend, adreno_system_resume)
> > 
> > base-commit: 05241de1f69eb7f56b0a5e0bec96a7752fad1b2f
> 
> 
> -- 
> With best wishes
> Dmitry
