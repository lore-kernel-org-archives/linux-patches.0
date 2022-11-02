Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33A77461
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:22:12 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d10so17278748pfh.6
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 12:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4EDI3vYbHaaiAQeZuuGzJ5Pv1WpOR32gAtsS0QDWLuw=;
        b=cf2nTr5YnckoTzWzbGWmtwmcSXrd8AamU45cN4BkmLr5woysN2W1kdbIKrPwII4PVI
         ce8I7YTY4uSDnL6ZPBTz94gxiF8GCs7pA974P296j4z8qCIMA1+np81HnE/zTRa6yv+M
         k3Z8gi82o4u4QsaXVn9ASZodldSA4+ubXIZL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4EDI3vYbHaaiAQeZuuGzJ5Pv1WpOR32gAtsS0QDWLuw=;
        b=LnOaSxYChws2YihKA0nmI7yEQaD1yi+jc9TKcksESHfIWB4IzohViRl0Ade8DmoEU5
         var/0EpCPloinnQfKljNSRauRv/47XzZpNjc05SeX+z5Sa0Zj334CVpM9OAEjoFN1LEs
         u12y8LDYPgu2xxPGmJHv8uPQYuuuydl91b0KUm+b57oaLl8b3mkIz3iI5AuKvnGISCub
         q8TlYVuNhJpljA1Dhmbg6TD972M0QMacMLw86FBY7trszfr2uROzZ5QnLgGz1nkIFIxL
         jiT0YeznqCO+85je0uwyHJvV+ismInNTWr3xcHw/tUa0NvvHKNOHMvTHp+FZl7XLAzo+
         /v6A==
X-Gm-Message-State: ACrzQf0JYrIiEPvg5vt7W6k7rawK1SgUXHZUgjXF64p6cFPRUsVLOGeE
	dcudPO4+eoqbOWF7rcFpUu3Jbw==
X-Google-Smtp-Source: AMsMyM6VtLTeGYSXsL6Ro3gC8gkszOK2+Cjl0KViNXychOWaLiDIqn26ITH/JYsmSRn3aX4X3qwIeQ==
X-Received: by 2002:a05:6a00:1391:b0:56d:2b6f:57b3 with SMTP id t17-20020a056a00139100b0056d2b6f57b3mr23293181pfg.56.1667416932256;
        Wed, 02 Nov 2022 12:22:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 85-20020a621658000000b005609d3d3008sm9054723pfw.171.2022.11.02.12.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:22:11 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:22:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/mediatek: Fix return type of
 mtk_hdmi_bridge_mode_valid()
Message-ID: <202211021222.1E8A8BCB43@keescook>
References: <20221102154712.540548-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102154712.540548-1-nathan@kernel.org>

On Wed, Nov 02, 2022 at 08:47:12AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/gpu/drm/mediatek/mtk_hdmi.c:1407:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' with an expression of type 'int (struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .mode_valid = mtk_hdmi_bridge_mode_valid,
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> ->mode_valid() in 'struct drm_bridge_funcs' expects a return type of
> 'enum drm_mode_status', not 'int'. Adjust the return type of
> mtk_hdmi_bridge_mode_valid() to match the prototype's to resolve the
> warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
