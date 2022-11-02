Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C336D19
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 15:43:01 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id m6so16786609pfb.0
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 08:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CbzfHUK/OIe01GljM+tYcwS2aLG1wlQhszOS90aIPbk=;
        b=TnvBNqsScJgJGa9F6e4NUp0WnQSFcyWRX8Px7ptg6cO6ctt1BRBZcdYb69cwPtIwyN
         QoHb48pAlpwFaQk7ewUS76qc4+cdspn2SEn24wD7ztEg1qPECfbSrnmQfKNybPMUuQua
         osc2GMsfESHWanbfjNZictRM04i534QWu1ZfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbzfHUK/OIe01GljM+tYcwS2aLG1wlQhszOS90aIPbk=;
        b=vXKkyqUI47+jRHwwY8AaawraZOw0U4a26wQAvkhvL+cDQY58oOzPAhIECxlTrtmNU9
         NA8X3+MQPliF0w8dlzy1DGayizyS0m5ZJPUnvd2+x3MgUpi1bO12gzA/4jZRW+E936Sl
         RzZGOCvypssEHlsnB42PWtyM3e65NsQh2oTMIO3arqHAB9zQTdEXn5FphVpHAAL3IqDe
         lM4Zxgtc5fQif4uDsbx1AC/tTXgj9ONHsBWfFQljMqS4Mi4DAsncA8YPQXkNRRe6648b
         B2DZY4oPuid7ogN0Gh21MKSL18Khi2IwvKGCDXr6Ijfn9qDYlGVTforspl0lybqeLOEo
         tTiA==
X-Gm-Message-State: ACrzQf15PbcdWC6f04ywJ0IQeuV4iieEw8BVrR0uQgG0KE2ZCDU6S54S
	lsZMbo9iJH+F7kSSbEXUlBb72g==
X-Google-Smtp-Source: AMsMyM7zf3RSyPAO0SeThAybZk/yt9Nw3pqPZ2/rk3+peKB5InTdiurM9tAyqpCR0+JSZHkWzA3xrw==
X-Received: by 2002:a65:6b81:0:b0:461:4049:7df7 with SMTP id d1-20020a656b81000000b0046140497df7mr22347812pgw.593.1667403780934;
        Wed, 02 Nov 2022 08:43:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902650500b00186afd756edsm8431471plk.283.2022.11.02.08.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 08:43:00 -0700 (PDT)
Date: Wed, 2 Nov 2022 08:42:59 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] drm/amdgpu: Fix type of second parameter in
 odn_edit_dpm_table() callback
Message-ID: <202211020842.8B8E29F8@keescook>
References: <20221102152540.2389891-1-nathan@kernel.org>
 <20221102152540.2389891-2-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102152540.2389891-2-nathan@kernel.org>

On Wed, Nov 02, 2022 at 08:25:40AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/gpu/drm/amd/amdgpu/../pm/swsmu/amdgpu_smu.c:3008:29: error: incompatible function pointer types initializing 'int (*)(void *, uint32_t, long *, uint32_t)' (aka 'int (*)(void *, unsigned int, long *, unsigned int)') with an expression of type 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, long *, uint32_t)' (aka 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, long *, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>           .odn_edit_dpm_table      = smu_od_edit_dpm_table,
>                                      ^~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> There are only two implementations of ->odn_edit_dpm_table() in 'struct
> amd_pm_funcs': smu_od_edit_dpm_table() and pp_odn_edit_dpm_table(). One
> has a second parameter type of 'enum PP_OD_DPM_TABLE_COMMAND' and the
> other uses 'u32'. Ultimately, smu_od_edit_dpm_table() calls
> ->od_edit_dpm_table() from 'struct pptable_funcs' and
> pp_odn_edit_dpm_table() calls ->odn_edit_dpm_table() from 'struct
> pp_hwmgr_func', which both have a second parameter type of 'enum
> PP_OD_DPM_TABLE_COMMAND'.
> 
> Update the type parameter in both the prototype in 'struct amd_pm_funcs'
> and pp_odn_edit_dpm_table() to 'enum PP_OD_DPM_TABLE_COMMAND', which
> cleans up the warning.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
