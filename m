Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EF71C75F;
	Mon, 12 Jun 2023 15:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E01C433EF;
	Mon, 12 Jun 2023 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686584376;
	bh=eTO6nV2KFJoFHZXkfRoArOeQJS3VieaqFmMwWQ7nFG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DwCvPig+2UdunEVNFvrjxGGOm4CBmeQWUFA4xn9f5so5tXTwNR5m3xxQgBCQO6KgF
	 vYMDPE3osITaH2duWQ4bvInWTct3JoWwHsV9krCMACKGovD2z8xwAJcrOk4yf7EWTt
	 XQoROZwdyLW080/0l1krZvbrWuD0MuAYoYCf46ePKZuGDintNQGwzIdU1Hl+/KVJkU
	 BczK3MVFHQRxYvgmKSE0bDJFqeMfNEmkwggrXZ+ZIcS/YBKBv9sVTYr073vU+jm5xV
	 w+xeuAY4C1pHJKjlbKBYvAQ6RDB0WktNuAZU2yh7vorG36lahM/G/uDr8+q1QDzWMw
	 t8MWrewg6GT5w==
Date: Mon, 12 Jun 2023 08:39:33 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
	amd-gfx@lists.freedesktop.org, trix@redhat.com,
	llvm@lists.linux.dev, ndesaulniers@google.com,
	patches@lists.linux.dev, dri-devel@lists.freedesktop.org,
	hamza.mahfooz@amd.com, Kenny.Ho@amd.com
Subject: Re: [PATCH] drm/amdgpu: Wrap -Wunused-but-set-variable in cc-option
Message-ID: <20230612153933.GA3521@dev-arch.thelio-3990X>
References: <20230608-amdgpu-wrap-wunused-but-set-variable-in-cc-option-v1-1-48ca005f2247@kernel.org>
 <87ttvfpz5u.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttvfpz5u.fsf@intel.com>

On Sat, Jun 10, 2023 at 10:14:05AM +0300, Jani Nikula wrote:
> On Thu, 08 Jun 2023, Nathan Chancellor <nathan@kernel.org> wrote:
> > -Wunused-but-set-variable was only supported in clang starting with
> > 13.0.0, so earlier versions will emit a warning, which is turned into a
> > hard error for the kernel to mirror GCC:
> >
> >   error: unknown warning option '-Wunused-but-set-variable'; did you mean '-Wunused-const-variable'? [-Werror,-Wunknown-warning-option]
> >
> > The minimum supported version of clang for building the kernel is
> > 11.0.0, so match the rest of the kernel and wrap
> > -Wunused-but-set-variable in a cc-option call, so that it is only used
> > when supported by the compiler.
> 
> I wonder if there's a table somewhere listing all the warning options,
> which GCC and Clang versions support them, and which versions have them
> in -Wall and -Wextra. Would be really useful.

I don't think there is anything other than the official documentations for each listing
all the warning options. I know each version has its own documentation
for comparing warnings between releases but that is obviously tedious.

The clang -Wall question is easy enough to answer based on the test
case:

https://github.com/llvm/llvm-project/blob/llvmorg-16.0.0/clang/test/Misc/warning-wall.c
https://github.com/llvm/llvm-project/blob/llvmorg-15.0.0/clang/test/Misc/warning-wall.c
https://github.com/llvm/llvm-project/blob/llvmorg-14.0.0/clang/test/Misc/warning-wall.c
https://github.com/llvm/llvm-project/blob/llvmorg-13.0.0/clang/test/Misc/warning-wall.c
https://github.com/llvm/llvm-project/blob/llvmorg-12.0.0/clang/test/Misc/warning-wall.c
https://github.com/llvm/llvm-project/blob/llvmorg-11.0.0/clang/test/Misc/warning-wall.c

Clang has a tool, diagtool, that can print information about -Wextra,
but I do not ship it with the kernel.org LLVM releases, nor does Debian
it seems. On a recent clang-17 (the colors don't matter for this
exercise):

$ diagtool tree -Wextra

GREEN = enabled by default
YELLOW = disabled by default
RED = unimplemented (accepted for GCC compatibility)

-Wextra
  -Wdeprecated-copy
    -Wdeprecated-copy-with-user-provided-copy
  -Wmissing-field-initializers
  -Wignored-qualifiers
    -Wignored-reference-qualifiers
  -Winitializer-overrides
  -Wsemicolon-before-method-body
  -Wmissing-method-return-type
  -Wsign-compare
  -Wunused-parameter
  -Wunused-but-set-parameter
  -Wnull-pointer-arithmetic
    -Wgnu-null-pointer-arithmetic
  -Wnull-pointer-subtraction
  -Wempty-init-stmt
  -Wstring-concatenation
  -Wfuse-ld-path

Maybe some of that can be useful for future travelers.

> If there isn't one, it would be really helpful. *wink*.

Heh, that does sound like an interesting project but I am not sure I
have the bandwidth at the moment to do something like that, especially
since the number of warnings that are different between GCC and clang
are continuing to dwindle :)

Cheers,
Nathan

> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1869
> > Fixes: a0fd5a5f676c ("drm/amd/amdgpu: introduce DRM_AMDGPU_WERROR")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  drivers/gpu/drm/amd/amdgpu/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/amd/amdgpu/Makefile b/drivers/gpu/drm/amd/amdgpu/Makefile
> > index 7ee68b1bbfed..86b833085f19 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/Makefile
> > +++ b/drivers/gpu/drm/amd/amdgpu/Makefile
> > @@ -40,7 +40,7 @@ ccflags-y := -I$(FULL_AMD_PATH)/include/asic_reg \
> >  	-I$(FULL_AMD_PATH)/amdkfd
> >  
> >  subdir-ccflags-y := -Wextra
> > -subdir-ccflags-y += -Wunused-but-set-variable
> > +subdir-ccflags-y += $(call cc-option, -Wunused-but-set-variable)
> >  subdir-ccflags-y += -Wno-unused-parameter
> >  subdir-ccflags-y += -Wno-type-limits
> >  subdir-ccflags-y += -Wno-sign-compare
> >
> > ---
> > base-commit: 6bd4b01e8938779b0d959bdf33949a9aa258a363
> > change-id: 20230608-amdgpu-wrap-wunused-but-set-variable-in-cc-option-0be9528ac5c8
> >
> > Best regards,
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center
