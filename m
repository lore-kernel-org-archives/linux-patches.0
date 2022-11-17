Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9959BA469
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 23:19:25 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id v28so3225327pfi.12
        for <patches@lists.linux.dev>; Thu, 17 Nov 2022 15:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SBG7oyaijsCs+AkyB480R7surFEt7JkA2k2VbS/kZYQ=;
        b=JchDDL5/DOlP6j9lUMlspTqgaFV4s9nwIJAsn96fhlHO8vmv5OjKer7ndNaH2Cz7xY
         angRwTwMUaQhTZSFCg5SSReYBynCN5+lVd/BZbbmZmTbg32Qo/D4UYmdS5qJQ4EuCLtb
         LRcO4Rhcd6sxfjWlyGEHMkaxsvRbTcjQPJJxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBG7oyaijsCs+AkyB480R7surFEt7JkA2k2VbS/kZYQ=;
        b=T2YC4ulR65KfGTqvx4BgtBYW50sPXjZJ7QUaiMsEpdh3C37FpGCJpkF9Jd7PsEjYKA
         X9iIvwPRJs00D18cJbaKqJy+8Y0uQZu9D4AWYSpMl2bYBVBIWAR1Q6+2g+wVZDrNeEzi
         XxUBbAWaB95H9LKgOPA7w6t+V6zS3GyjB2LNSJCV7fbNUc32RirVP7+rK5ahQ9v50a/e
         Uz26W7OaQdM5T9JmzdrfSyxEyd48+78C2ms+NTCp+5Vhyj2tAchbtS1xi/A8qqde+gv8
         bqRs6UKYOJUhVDxJTl0yA+Iopa6mKsIoYW6/LVOuNj0U/+4ejsaJfqLQDhkRl7Q1rL94
         oC6Q==
X-Gm-Message-State: ANoB5pmcN8YSGCsvjc+E1xbdb89KXoRdU6iHphGcIMLQnuF1VNunyxMm
	eCQNZNapih+n/fH/G2wEgjCzcQ==
X-Google-Smtp-Source: AA0mqf5gYHTV4d1cJmSvcoc5/KxPzeS1y0Zb1fIaJiX9fjzOdUIlsRe1Bo/bjk0EkMpAHBf2HyMu/w==
X-Received: by 2002:a65:4c88:0:b0:477:55c:3ff4 with SMTP id m8-20020a654c88000000b00477055c3ff4mr4055311pgt.442.1668727164990;
        Thu, 17 Nov 2022 15:19:24 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 135-20020a62178d000000b0056ba6952e40sm1684386pfx.181.2022.11.17.15.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 15:19:24 -0800 (PST)
Date: Thu, 17 Nov 2022 15:19:23 -0800
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Stefan Agner <stefan@agner.ch>, Alison Wang <alison.wang@nxp.com>,
	dri-devel@lists.freedesktop.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/fsl-dcu: Fix return type of
 fsl_dcu_drm_connector_mode_valid()
Message-ID: <202211171518.88D58BBE@keescook>
References: <20221102154215.78059-1-nathan@kernel.org>
 <Y3K7GbHAMZPdY243@distrobox-ZFeO0pwFho.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3K7GbHAMZPdY243@distrobox-ZFeO0pwFho.thelio-3990X>

On Mon, Nov 14, 2022 at 03:03:05PM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> On Wed, Nov 02, 2022 at 08:42:15AM -0700, Nathan Chancellor wrote:
> > With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> > indirect call targets are validated against the expected function
> > pointer prototype to make sure the call target is valid to help mitigate
> > ROP attacks. If they are not identical, there is a failure at run time,
> > which manifests as either a kernel panic or thread getting killed. A
> > proposed warning in clang aims to catch these at compile time, which
> > reveals:
> > 
> >   drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c:74:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
> >           .mode_valid = fsl_dcu_drm_connector_mode_valid,
> >                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   1 error generated.
> > 
> > ->mode_valid() in 'struct drm_connector_helper_funcs' expects a return
> > type of 'enum drm_mode_status', not 'int'. Adjust the return type of
> > fsl_dcu_drm_connector_mode_valid() to match the prototype's to resolve
> > the warning and CFI failure.
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> > Reported-by: Sami Tolvanen <samitolvanen@google.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
> > index 4d4a715b429d..2c2b92324a2e 100644
> > --- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
> > +++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
> > @@ -60,8 +60,9 @@ static int fsl_dcu_drm_connector_get_modes(struct drm_connector *connector)
> >  	return drm_panel_get_modes(fsl_connector->panel, connector);
> >  }
> >  
> > -static int fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
> > -					    struct drm_display_mode *mode)
> > +static enum drm_mode_status
> > +fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
> > +				 struct drm_display_mode *mode)
> >  {
> >  	if (mode->hdisplay & 0xf)
> >  		return MODE_ERROR;
> > 
> > base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
> > -- 
> > 2.38.1
> > 
> > 
> 
> Could someone please pick this up so that it makes 6.2? We would like
> to try and get this warning turned on so that it can catch more
> potential run time issues at compile time but that can only happen when
> all the warnings are fixed.

I'll pick this up tomorrow if no one else snags it. :)

-- 
Kees Cook
