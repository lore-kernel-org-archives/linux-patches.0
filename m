Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA1C24F47
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:06:51 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so2761306pjk.1
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=71cIGVUi+2jVEjXbTMLP+sHbufV3ZHGsKiLlY1xVyE4=;
        b=fjGGSl6TZGy6MhSeAlQ9V3XlMvK9/dKuFuRpy8Ew/54JsuPSu62uZ6R7xn5ia9d6mL
         xmWYa3LxJrXqfZL52eFl4W2S7p0zWy5w3mpFGbEqxRpS4Jz1o7xWa7Czjp+BMc/29Ion
         AObRStps16tXSHWBnfGNhb6ksTT8C1QPkW5mM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71cIGVUi+2jVEjXbTMLP+sHbufV3ZHGsKiLlY1xVyE4=;
        b=A/kghjIuRWtVdU9q+qLP7voHEzeqcp1t/2YelvGgeM7VP9cHiiTm1YlOyqWgFPHfT0
         KEPSBdAc8x7TvU8GKM1F8KLGNr61xMAFKBuKbAxTf6/Rg8cLi/FkQLOg/vLVY/IX1Q9W
         aDVOnby2T0letmzhol2bJ3qBMfk2lCW+/LcNzwWZ7HU2URBOOLn4cre6Ag8+sjGXKb/X
         LKwLsFsf5cwTMI9UQQjpwjUbyKIh8XfiqNgIBTQ5RqCcN9JPwQ1GLdbL4BVFiWhkgFim
         PDFstsorLcBnf6/j6TxgIYYj0FcJM+uH7lKeTdoeUwpHfsE+EM5TFRWqXLQ5r9lHJjFG
         QyPQ==
X-Gm-Message-State: ACrzQf3qfRuwpyNf39Sk4aO2Be3p5XsKxChpS1MVPe3B3X5OxHMddn18
	iQEk8aQCL0LkvdbjF+bLGIMQbg==
X-Google-Smtp-Source: AMsMyM7w0eDTA7/r8K67/N2jqI2Q9w/r0P434xSeZcahrG3KviKdGBv3lb4n7+RNP3OVrJqxGz8rXA==
X-Received: by 2002:a17:90a:bf82:b0:214:6fd:90ec with SMTP id d2-20020a17090abf8200b0021406fd90ecmr11317834pjs.61.1667416011472;
        Wed, 02 Nov 2022 12:06:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l12-20020a170903244c00b0017da2798025sm8710635pls.295.2022.11.02.12.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:06:50 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:06:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alain Volmat <alain.volmat@foss.st.com>,
	dri-devel@lists.freedesktop.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/sti: Fix return type of
 sti_{dvo,hda,hdmi}_connector_mode_valid()
Message-ID: <202211021206.1A488F29C@keescook>
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

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
