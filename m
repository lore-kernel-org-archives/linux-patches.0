Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171DC24F47
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:06:36 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id 128so17073235pga.1
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YLJw50A1K+KhusFBEa675+xxaU3caL5GDgA+x/6AGwQ=;
        b=eanRVW/LBbSyQtTn8NWCZTTDAawhljklM58TSIe0LHlwW/gHbMD11JP3ckeaEe/msg
         vmppBy0RmvOGmkJW6vTqFKB6oG4y+0rkYyOuCChrP4Sy/x03U/caHHgMIFnNNWlXRSYQ
         MKBSw57TYyF6OcudfzZhtv+PDEccU/3X7mxRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLJw50A1K+KhusFBEa675+xxaU3caL5GDgA+x/6AGwQ=;
        b=UN9803uzTGwwpF91tGCw1FLU4rKCgvq0mh0ZsAww1RP9vx/tiDvP8arBjaihoN/CWH
         yD31VkXbjLvAUJZCFFdtE3U3VTvqMeFiK89rwjhuECWFSRw7rme9RhxYlW86bjTC2gAr
         knuDDRJJwwxxAkC+9VhLLiQvsFPXazqiyftFBQDO5EOXyCtorQVSfvwWjyoIoMM5Ay/U
         E780Lss9KS7zb2C6tk7TGchjWMtdulvoa6awSxn47zj0L2h1FpQnPYjm5bl0aNIjnfR/
         CaurNnNTX8KtycC0ePUkWgUSYH7f+wwyZUmvtxsWYc+mdKQHLZKyIUdfuQW0v0JygHH2
         WrJA==
X-Gm-Message-State: ACrzQf0XkUMOAXbHa+Hm6JkEwzHGwqY7nGw/R8Tm7pVOXVHWKX89+nLh
	CIOHk+qZ4nnvsLlTrMCIHx3Kyg==
X-Google-Smtp-Source: AMsMyM5nOP7TB+tQ3IHpynS+a4tGqv36tuqeuJEkR1BO6kWK8sdX+uSJsUdso0ZtKCVhfl6YA8bm0g==
X-Received: by 2002:a05:6a00:1688:b0:53b:4239:7c5c with SMTP id k8-20020a056a00168800b0053b42397c5cmr27219671pfc.81.1667415995509;
        Wed, 02 Nov 2022 12:06:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s17-20020a170902ea1100b00186727e5f5csm8710774plg.248.2022.11.02.12.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:06:35 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:06:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/meson: Fix return type of
 meson_encoder_cvbs_mode_valid()
Message-ID: <202211021206.F5C5954F66@keescook>
References: <20221102155242.1927166-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102155242.1927166-1-nathan@kernel.org>

On Wed, Nov 02, 2022 at 08:52:42AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/gpu/drm/meson/meson_encoder_cvbs.c:211:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' with an expression of type 'int (struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .mode_valid = meson_encoder_cvbs_mode_valid,
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> ->mode_valid() in 'struct drm_bridge_funcs' expects a return type of
> 'enum drm_mode_status', not 'int'. Adjust the return type of
> meson_encoder_cvbs_mode_valid() to match the prototype's to resolve the
> warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
