Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4338490;
	Mon, 14 Nov 2022 22:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C72C433C1;
	Mon, 14 Nov 2022 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668463387;
	bh=xYf9S1SoJjidkD4jKsy+Wuq5ZNiGrhRfm8O+wo77syE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l3ePceobY6nyivcZMmUGudcVYrlsg/3EXws/XpBIS7a5XcMT0y67Oz/g56ed5U4NT
	 G2oJEToHGrx2JfaBNw9W8tDVmqDwtfmxQnG0Ym2milI+MV6nbJ70QyAe91hfzyJ5Ld
	 7ESuvU4Lov6wmRCR0mhTE56U88kCWA6B9SQdQorHfHV45tC9gw0YVwFPKd6E6uW61h
	 ZPptAdJt6sofngivPa2SPpg2hI/weJgfoDh2GZJnDxxDL3zwizU07C2IaqkIAhmP+d
	 YnXzWEzlIjI+TCDerTQNsDvSH7NCJU46bNzh/tBXu7HJQQIz+rqnp9Hit57yxEl3wc
	 /T2pVFrr6DrSw==
Date: Mon, 14 Nov 2022 15:03:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Stefan Agner <stefan@agner.ch>, Alison Wang <alison.wang@nxp.com>
Cc: dri-devel@lists.freedesktop.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] drm/fsl-dcu: Fix return type of
 fsl_dcu_drm_connector_mode_valid()
Message-ID: <Y3K7GbHAMZPdY243@distrobox-ZFeO0pwFho.thelio-3990X>
References: <20221102154215.78059-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102154215.78059-1-nathan@kernel.org>

Hi all,

On Wed, Nov 02, 2022 at 08:42:15AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c:74:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .mode_valid = fsl_dcu_drm_connector_mode_valid,
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> ->mode_valid() in 'struct drm_connector_helper_funcs' expects a return
> type of 'enum drm_mode_status', not 'int'. Adjust the return type of
> fsl_dcu_drm_connector_mode_valid() to match the prototype's to resolve
> the warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
> index 4d4a715b429d..2c2b92324a2e 100644
> --- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
> +++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
> @@ -60,8 +60,9 @@ static int fsl_dcu_drm_connector_get_modes(struct drm_connector *connector)
>  	return drm_panel_get_modes(fsl_connector->panel, connector);
>  }
>  
> -static int fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
> -					    struct drm_display_mode *mode)
> +static enum drm_mode_status
> +fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
> +				 struct drm_display_mode *mode)
>  {
>  	if (mode->hdisplay & 0xf)
>  		return MODE_ERROR;
> 
> base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
> -- 
> 2.38.1
> 
> 

Could someone please pick this up so that it makes 6.2? We would like
to try and get this warning turned on so that it can catch more
potential run time issues at compile time but that can only happen when
all the warnings are fixed.

Cheers,
Nathan
