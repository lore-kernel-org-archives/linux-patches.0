Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A9D2F35
	for <patches@lists.linux.dev>; Tue,  8 Mar 2022 22:47:47 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id r20so672880ljj.1
        for <patches@lists.linux.dev>; Tue, 08 Mar 2022 14:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TcDMQ6nS/X1H1j7aeyleDEMXXGffGCszydA5VcjYqgg=;
        b=mcIi5/LNOJSSSJDRimjIysrZdWErNM2fT0Mn788ztDzYtBr1Eq9gMtW0aFWEdbgizR
         b6HjS6DSva7ctaBWgtPwYFxoZGo2OohKiNKldxcxKIP007B23tOFG3hDQgElt8QzAg4d
         Bw/eNhTiphc4MnYNs+J5FyUu59cJmkR85gUmQhkYoQyybdgiT1LjR8igBzbrc13xqlRr
         P2jgpaIxbhnYxn67onVUUux10T5Z2bJNtKXWsucAZCb3a6i8gNiRzpWZAXG+j/Ud3kIL
         UgzgXGoYTJ6HMQ+fl2L93ws9j7gJoxkVWCo7gLm4BnwVRLokNwEJqylIyNxa3pF2J9w2
         T77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TcDMQ6nS/X1H1j7aeyleDEMXXGffGCszydA5VcjYqgg=;
        b=YpSnnMnnL+U2zAJEfSNaiKjWhrQ4IbacEv8p7KSejbvhhqA2q06848ToiCeS4FD4bq
         482sH3gyvxm9BxBb4ECl7PFTYyxK/NQIDL9gMEqw+vnzwChVIBjdjfwj733wrsyTLb3K
         IFyQqxR2aJ/a93xA6NKaG18ToIs3xktdcishXVGKyrIAePioASURMZRlLoNvRgCH9Z2Y
         ou9AkF0dt8MSX5tTWErx5LH1/uozQwqVRq+azlg7VjnaiTOAEhOgiWivcHwXdg8QG4nG
         x2KnBC/FFfq9kuu3T+8QS0j1H3Zn0mBzxjcmi43RkUEvmf9cTvNbiBn8cp5YbMERb3IH
         ld3Q==
X-Gm-Message-State: AOAM532ACoDFLI+qtzQYfvm4ybNQvKPzFt2XymvH1uixqUvd8sgSWEUq
	f5VcbZxIbmdFq9WSjbCI0e0KCJHGBviVgijFhmL1HA==
X-Google-Smtp-Source: ABdhPJzlxzIurB5HwPVFvPKrN6sox392JtzvHKNiMG1iJ5m52KHtMlH5aTxsK0urYbyIhWlEJGxod+fGDgevjQEk784=
X-Received: by 2002:a2e:8942:0:b0:246:4536:cf22 with SMTP id
 b2-20020a2e8942000000b002464536cf22mr12164694ljk.235.1646779665519; Tue, 08
 Mar 2022 14:47:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302235909.784935-1-nathan@kernel.org>
In-Reply-To: <20220302235909.784935-1-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 8 Mar 2022 14:47:34 -0800
Message-ID: <CAKwvOdkT1Lz8RqKmR0efPzpHxFgp98bwepwHURTUckEFYe5zYg@mail.gmail.com>
Subject: Re: [PATCH] drm/selftest: plane_helper: Put test structures in static storage
To: Nathan Chancellor <nathan@kernel.org>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Claudio Suarez <cssk@net-c.es>, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 2, 2022 at 4:00 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns on certain 32-bit architectures:
>
>   drivers/gpu/drm/selftests/test-drm_plane_helper.c:76:5: warning: stack frame size (1064) exceeds limit (1024) in 'igt_check_plane_state' [-Wframe-larger-than]
>   int igt_check_plane_state(void *ignored)
>       ^
>   1 warning generated.
>
> The structures in igt_check_plane_state() total 1008 bytes, so any small
> amount of inlining will cause the stack frame to exceed the 32-bit limit
> of 1024, triggering the warning.
>
> Move these structures to static storage, which dramatically reduces the
> amount of stack space in igt_check_plane_state(). There is no testing
> impact, as igt_check_plane_state() is only called once in the driver.
>
> Fixes: 943e6a8beeac ("mock a drm_plane in igt_check_plane_state to make the test more robust")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1600
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/gpu/drm/selftests/test-drm_plane_helper.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/selftests/test-drm_plane_helper.c b/drivers/gpu/drm/selftests/test-drm_plane_helper.c
> index ceebeede55ea..b61273e9c403 100644
> --- a/drivers/gpu/drm/selftests/test-drm_plane_helper.c
> +++ b/drivers/gpu/drm/selftests/test-drm_plane_helper.c
> @@ -77,7 +77,7 @@ int igt_check_plane_state(void *ignored)
>  {
>         int ret;
>
> -       const struct drm_crtc_state crtc_state = {
> +       static const struct drm_crtc_state crtc_state = {
>                 .crtc = ZERO_SIZE_PTR,
>                 .enable = true,
>                 .active = true,
> @@ -87,14 +87,14 @@ int igt_check_plane_state(void *ignored)
>                                 DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC)
>                 },
>         };
> -       struct drm_plane plane = {
> +       static struct drm_plane plane = {
>                 .dev = NULL
>         };
> -       struct drm_framebuffer fb = {
> +       static struct drm_framebuffer fb = {
>                 .width = 2048,
>                 .height = 2048
>         };
> -       struct drm_plane_state plane_state = {
> +       static struct drm_plane_state plane_state = {
>                 .plane = &plane,
>                 .crtc = ZERO_SIZE_PTR,
>                 .fb = &fb,
>
> base-commit: 9ae2ac4d31a85ce59cc560d514a31b95f4ace154
> --
> 2.35.1
>


-- 
Thanks,
~Nick Desaulniers
