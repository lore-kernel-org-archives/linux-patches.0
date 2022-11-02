Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA046ADD
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 15:42:55 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so2247612pjl.3
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 08:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gbHhHvdRSfNW3M6lKiiBiHsy/aZHIegD8in6WLhhzSY=;
        b=grx0sX1vyt4doXabEeN05DzVGZaktvYdcCfg6WGKYn2Um48Zgp2UMnzv9yxRjGlvDs
         s02OzcMqRXmY81P844mFxCquKl032+JyuX8aVk9fGB0kVUT/d3ioGHRtH7AHRaujNbdw
         65vnLvXCz2xWmb3ZUvb4RYrBdcrT6g2PSeo3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbHhHvdRSfNW3M6lKiiBiHsy/aZHIegD8in6WLhhzSY=;
        b=jKqtUzLHWOPq7S7flBdqvOChx+sugg60I98nB8rAKkF7K8xq4xqZzeLYFZUnK0PmI+
         ez7IUVjyje43dsKcKODbOX+Xny/Z64gmuvGjTlBcVqwlsW5Lq7AeG/HiXofF98/JCQfR
         M4DLkGQkTzmpxF7tSBo8fzJW1UmIMhDJBaM4HowL+8g5aUAgoa3sG02XPFuq+V3LhgS6
         RssA9+1gRVp3X376m3r5iyX8ByC6e5ak884sCIKXedbvTebivyeUgT+agOiCNM4eW7U8
         HcZV3ZVGcIoN5cfYgjjB33RIwLj+5dRk0xt3eFQB2cPvJHbw9ADLlQ6+uSMt2umS+HBz
         4LIQ==
X-Gm-Message-State: ACrzQf1gTdqmyTbV/AOvGMxc5lcxj99nw44TtzIAkDNY+o5ntt7HxWSv
	CgmEJPVJWEBj0xtUxERERwJ4wg==
X-Google-Smtp-Source: AMsMyM5riCGdRLVGt8cheeiKjHf8n8+rR3sMc60dvYFpdMSefduVp5ovnjO/E9dJecAFytPwR3myDw==
X-Received: by 2002:a17:902:720c:b0:186:fb90:573e with SMTP id ba12-20020a170902720c00b00186fb90573emr25604727plb.160.1667403775155;
        Wed, 02 Nov 2022 08:42:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902710f00b001885041d7b8sm47015pll.293.2022.11.02.08.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 08:42:54 -0700 (PDT)
Date: Wed, 2 Nov 2022 08:42:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/2] drm/amdgpu: Fix type of second parameter in
 trans_msg() callback
Message-ID: <202211020842.8F3ECD397@keescook>
References: <20221102152540.2389891-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102152540.2389891-1-nathan@kernel.org>

On Wed, Nov 02, 2022 at 08:25:39AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c:412:15: error: incompatible function pointer types initializing 'void (*)(struct amdgpu_device *, u32, u32, u32, u32)' (aka 'void (*)(struct amdgpu_device *, unsigned int, unsigned int, unsigned int, unsigned int)') with an expression of type 'void (struct amdgpu_device *, enum idh_request, u32, u32, u32)' (aka 'void (struct amdgpu_device *, enum idh_request, unsigned int, unsigned int, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>           .trans_msg = xgpu_ai_mailbox_trans_msg,
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
>   drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c:435:15: error: incompatible function pointer types initializing 'void (*)(struct amdgpu_device *, u32, u32, u32, u32)' (aka 'void (*)(struct amdgpu_device *, unsigned int, unsigned int, unsigned int, unsigned int)') with an expression of type 'void (struct amdgpu_device *, enum idh_request, u32, u32, u32)' (aka 'void (struct amdgpu_device *, enum idh_request, unsigned int, unsigned int, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>           .trans_msg = xgpu_nv_mailbox_trans_msg,
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> The type of the second parameter in the prototype should be 'enum
> idh_request' instead of 'u32'. Update it to clear up the warnings.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
