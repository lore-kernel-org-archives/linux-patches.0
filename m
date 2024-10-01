Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC5F1A08C6;
	Tue,  1 Oct 2024 18:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727809131; cv=none; b=Q4Ojsku/pnly+5BDiPsoSbgmc6oyCNAuFPgWDF9bsxvmSaweETkvMe2d94WoBqFBAZGWg5JTKxk9remEMyxR1r0zqNM0/KxPXwgEww7AU6CBWseO2MKXaBXaeGzr6OhnBXIjTSedaenIMfdLS8lOugg1/hBkKo35QYjfwihBE+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727809131; c=relaxed/simple;
	bh=MgLAiG2FTe76Kq6uFJegebqptOBYXYBE90tIaZBkibA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPus3fPIit3D9gnYJSJV1y//9VyY+gGhLdljO6OlmfgcvW1hFB7uXnkJ1PinVAmHFh56fTeuhRh2zz63o9QAWszqaWl+F/SVCVUsnJewz+5EPsTvAM0JW88W+soiakWC7QLSOIPPJ6mMJiZ1Fmy24pPkmGH89kSt8QuGmRiyw1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NObTHi3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NObTHi3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631B0C4CEC6;
	Tue,  1 Oct 2024 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727809130;
	bh=MgLAiG2FTe76Kq6uFJegebqptOBYXYBE90tIaZBkibA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NObTHi3SzDG6/owbW92YIoJJLjYYXbt1JMU/mQNdfbRlTtLZS97J1YATqsqcvgsKZ
	 K6/Bn2FqVApkhg3VMbwX1M9Ixac/KmVNeXTu7a3qNgwdGgP2jrgwnUOQG2vLb9gg4Y
	 6SDXmdM2FxJo1VueaFkT5r/aib2UFJGw5vTbd5TP+5Yr0GwtfqrQJDYYmv9ScT41VQ
	 1STZe9LaUNW2PBj/7FX68ELGsTmlGzLTyQgRLjhyDuBn51sEAier0RTaMeOFqxi/so
	 ndeXqkadKv0Af/P6ck+7Q4j+gkHY+Nya38J5B+ACPVAauDJBbCia7BkGqf3QHUsPEi
	 IhcNNaxCVGvJw==
Date: Tue, 1 Oct 2024 11:58:48 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Brian Cain <bcain@quicinc.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-hexagon@vger.kernel.org, patches@lists.linux.dev,
	llvm@lists.linux.dev
Subject: Re: [PATCH] hexagon: Disable constant extender optimization for LLVM
 prior to 19.1.0
Message-ID: <20241001185848.GA562711@thelio-3990X>
References: <20240819-hexagon-disable-constant-expander-pass-v1-1-36a734e9527d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819-hexagon-disable-constant-expander-pass-v1-1-36a734e9527d@kernel.org>

Ping? This hang is now happening in 6.12-rc1 in our CI.

On Mon, Aug 19, 2024 at 11:16:10AM -0700, Nathan Chancellor wrote:
> The Hexagon-specific constant extender optimization in LLVM may crash on
> Linux kernel code [1] (such as with a bcachefs change in -next):
> 
>   clang: llvm/lib/Target/Hexagon/HexagonConstExtenders.cpp:745: bool (anonymous namespace)::HexagonConstExtenders::ExtRoot::operator<(const HCE::ExtRoot &) const: Assertion `ThisB->getParent() == OtherB->getParent()' failed.
>   Stack dump:
>   0.      Program arguments: clang --target=hexagon-linux-musl ... fs/bcachefs/btree_io.c
>   1.      <eof> parser at end of file
>   2.      Code generation
>   3.      Running pass 'Function Pass Manager' on module 'fs/bcachefs/btree_io.c'.
>   4.      Running pass 'Hexagon constant-extender optimization' on function '@__btree_node_lock_nopath'
> 
> Without assertions enabled, there is just a hang during compilation.
> 
> This has been resolved in LLVM main (20.0.0) [2] and backported to LLVM
> 19.1.0 but the kernel supports LLVM 13.0.1 and newer, so disable the
> constant expander optimization using the '-mllvm' option when using a
> toolchain that is not fixed.
> 
> Link: https://github.com/llvm/llvm-project/issues/99714 [1]
> Link: https://github.com/llvm/llvm-project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
> Link: https://github.com/llvm/llvm-project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/hexagon/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
> index 92d005958dfb..ff172cbe5881 100644
> --- a/arch/hexagon/Makefile
> +++ b/arch/hexagon/Makefile
> @@ -32,3 +32,9 @@ KBUILD_LDFLAGS += $(ldflags-y)
>  TIR_NAME := r19
>  KBUILD_CFLAGS += -ffixed-$(TIR_NAME) -DTHREADINFO_REG=$(TIR_NAME) -D__linux__
>  KBUILD_AFLAGS += -DTHREADINFO_REG=$(TIR_NAME)
> +
> +# Disable HexagonConstExtenders pass for LLVM versions prior to 19.1.0
> +# https://github.com/llvm/llvm-project/issues/99714
> +ifneq ($(call clang-min-version, 190100),y)
> +KBUILD_CFLAGS += -mllvm -hexagon-cext=false
> +endif
> 
> ---
> base-commit: 47ac09b91befbb6a235ab620c32af719f8208399
> change-id: 20240802-hexagon-disable-constant-expander-pass-8b6b61db6afc
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
