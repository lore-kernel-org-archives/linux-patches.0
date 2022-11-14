Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB508490;
	Mon, 14 Nov 2022 22:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D094DC433D6;
	Mon, 14 Nov 2022 22:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668463429;
	bh=A/NcI7yjCPifobrfLgSLwoo0K6kjDNSD5cJqS0LmguA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZB1f/gO1gqKm3c27NAV+6hLCatqq4Cnm8Yzn4YSNHtN3YDzSmdb9zOHWrzznFXoVZ
	 mhSmQ8z0i/RGGvko7tMNFcJqCAQJeEVGIBNzWLI/bhyZ8pvOjxWjWV/QMBJfxozEPV
	 1STSnp1tgD9z4d8NC7zjNr/5Dh3LVuFBfcRfU4hTvDBhYKFrgFIjxAfBz3BXXYNxzf
	 kZ0Ll1TCqZRrNVi2cLZaAwt9z0iTJGwxGap3a6sH5W7BaQwbU1KWtM6QKqRI9QTCyK
	 JxphSETre+VB7vCD416M12wquPY65RHHPflNiYzN5Y9N5Q6/IU/OtAuIby3TkBfDSN
	 J9cZJCkfT/jFA==
Date: Mon, 14 Nov 2022 15:03:47 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alain Volmat <alain.volmat@foss.st.com>
Cc: dri-devel@lists.freedesktop.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] drm/sti: Fix return type of
 sti_{dvo,hda,hdmi}_connector_mode_valid()
Message-ID: <Y3K7QxuaXUm9C8pL@distrobox-ZFeO0pwFho.thelio-3990X>
References: <20221102155623.3042869-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102155623.3042869-1-nathan@kernel.org>

Hi all,

On Wed, Nov 02, 2022 at 08:56:23AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/gpu/drm/sti/sti_hda.c:637:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .mode_valid = sti_hda_connector_mode_valid,
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/gpu/drm/sti/sti_dvo.c:376:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .mode_valid = sti_dvo_connector_mode_valid,
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/gpu/drm/sti/sti_hdmi.c:1035:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .mode_valid = sti_hdmi_connector_mode_valid,
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> ->mode_valid() in 'struct drm_connector_helper_funcs' expects a return
> type of 'enum drm_mode_status', not 'int'. Adjust the return type of
> sti_{dvo,hda,hdmi}_connector_mode_valid() to match the prototype's to
> resolve the warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/sti/sti_dvo.c  | 5 +++--
>  drivers/gpu/drm/sti/sti_hda.c  | 5 +++--
>  drivers/gpu/drm/sti/sti_hdmi.c | 5 +++--
>  3 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/sti/sti_dvo.c b/drivers/gpu/drm/sti/sti_dvo.c
> index b6ee8a82e656..076d5f30a09c 100644
> --- a/drivers/gpu/drm/sti/sti_dvo.c
> +++ b/drivers/gpu/drm/sti/sti_dvo.c
> @@ -346,8 +346,9 @@ static int sti_dvo_connector_get_modes(struct drm_connector *connector)
>  
>  #define CLK_TOLERANCE_HZ 50
>  
> -static int sti_dvo_connector_mode_valid(struct drm_connector *connector,
> -					struct drm_display_mode *mode)
> +static enum drm_mode_status
> +sti_dvo_connector_mode_valid(struct drm_connector *connector,
> +			     struct drm_display_mode *mode)
>  {
>  	int target = mode->clock * 1000;
>  	int target_min = target - CLK_TOLERANCE_HZ;
> diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
> index 03cc401ed593..a53b5a15c2a9 100644
> --- a/drivers/gpu/drm/sti/sti_hda.c
> +++ b/drivers/gpu/drm/sti/sti_hda.c
> @@ -601,8 +601,9 @@ static int sti_hda_connector_get_modes(struct drm_connector *connector)
>  
>  #define CLK_TOLERANCE_HZ 50
>  
> -static int sti_hda_connector_mode_valid(struct drm_connector *connector,
> -					struct drm_display_mode *mode)
> +static enum drm_mode_status
> +sti_hda_connector_mode_valid(struct drm_connector *connector,
> +			     struct drm_display_mode *mode)
>  {
>  	int target = mode->clock * 1000;
>  	int target_min = target - CLK_TOLERANCE_HZ;
> diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
> index cb82622877d2..09e0cadb6368 100644
> --- a/drivers/gpu/drm/sti/sti_hdmi.c
> +++ b/drivers/gpu/drm/sti/sti_hdmi.c
> @@ -1004,8 +1004,9 @@ static int sti_hdmi_connector_get_modes(struct drm_connector *connector)
>  
>  #define CLK_TOLERANCE_HZ 50
>  
> -static int sti_hdmi_connector_mode_valid(struct drm_connector *connector,
> -					struct drm_display_mode *mode)
> +static enum drm_mode_status
> +sti_hdmi_connector_mode_valid(struct drm_connector *connector,
> +			      struct drm_display_mode *mode)
>  {
>  	int target = mode->clock * 1000;
>  	int target_min = target - CLK_TOLERANCE_HZ;
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
