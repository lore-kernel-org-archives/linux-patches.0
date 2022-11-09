Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FD610786
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 19:07:13 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso4296301pjn.0
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 11:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NDep2xTzg7wJbNApQgTgABbwuzhQVUJykl8RQQiftq8=;
        b=BQurSsH56mFh2n1DAucFH0nGFBvGEABBjFzDpVdbF0OUEZHWDAvOsP/G7pxv4eNCWV
         4ajW80cdG/w53j8mTfQm4FDh0XZbRCoYls82xs7G06Or27jBFk5MFV0DRFcT7S/BCshB
         BZ1LMHiue+xtdCc1aftQEQ0M+T9Xseto7C6zs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDep2xTzg7wJbNApQgTgABbwuzhQVUJykl8RQQiftq8=;
        b=t0XknV2cU9caj6gkyHhRfs+tjZNOpQVr80/I3meWbSESgtH6stLK/XPiiQgCDNcW3J
         S4PTU0jtuthdFzOND/qY5WaKmF0F/aGNTFG3xX11Ge60BLxswIDZoRWBXHXZ8OqePpYZ
         CkPzWpp23ogqEDfH6iZJDiz1p1wPLMNu2V8k4Rimh0K6mLNt9Uwm9Eq+7p5NR5pNeY9U
         5v0MBSGmjdKaKKnjkA6tfyo9t3Jnnb4dC1Pe1CEaSYxkE1m6XzpzBllyczla0HDaKZ9b
         4OZ9xpBlwyxwVlqqnWFJGw9xnCiQw4zrpsWoAKXP+IM/uxI4CTXSY/garR0OGe+3bgNz
         3IXg==
X-Gm-Message-State: ACrzQf2KQTorl3knLYEr5mCvDuYtuT9ebgFWPejNUKpKO054ElTSKE5c
	ef1SkfFkx+zs8kQE2TUUk1WYgA==
X-Google-Smtp-Source: AMsMyM5Qi9RKSjqi1EKSmHYh0kIPGrBEi36sEsIueAMb3yZymjHoIKLfM6YnRCyWT4Bfo5AfhQSrPw==
X-Received: by 2002:a17:90b:3d8e:b0:213:c01:b8bb with SMTP id pq14-20020a17090b3d8e00b002130c01b8bbmr63663963pjb.68.1668020833460;
        Wed, 09 Nov 2022 11:07:13 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w11-20020a17090a8a0b00b001faf7a88138sm1546027pjn.42.2022.11.09.11.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 11:07:12 -0800 (PST)
Date: Wed, 9 Nov 2022 11:07:12 -0800
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Nathan Huckleberry <nhuck@google.com>,
	Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH v2] drm: xlnx: Fix return type of
 zynqmp_dp_bridge_mode_valid
Message-ID: <202211091107.718BF1BE89@keescook>
References: <20221109001424.1422495-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109001424.1422495-1-nathan@kernel.org>

On Tue, Nov 08, 2022 at 05:14:25PM -0700, Nathan Chancellor wrote:
> From: Nathan Huckleberry <nhuck@google.com>
> 
> The mode_valid field in drm_bridge_helper_funcs is expected to be of
> type
> enum drm_mode_status (* mode_valid) (struct drm_bridge *bridge,
>                                      struct drm_display_mode *mode);
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition. A new
> warning in clang will catch this at compile time:
> 
>   drivers/gpu/drm/xlnx/zynqmp_dp.c:1573:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' with an expression of type 'int (struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .mode_valid = zynqmp_dp_bridge_mode_valid,
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> The return type of zynqmp_dp_bridge_mode_valid should be changed from
> int to enum drm_mode_status.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
