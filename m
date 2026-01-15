Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87303218AAF;
	Thu, 15 Jan 2026 01:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768438971; cv=none; b=QACGPfnDgJSXz6rCHUDfRZolEfdtbQqXuteEu17FX+m5D5/o9i3hQXvUmvLbVyH01VG+jEcTZ3mx5Anq3leJDMnGT5V6zTQxBfaijYkGyi1mSHySAt+xz9R9unioJeqjVHovJNPperol3DVwfKwvkJ67k2ollg1Rvv4kXs+HpuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768438971; c=relaxed/simple;
	bh=jVBqlcLqSYseOgAHYybbgxO53XS2Bsh6/8CM4GtShzE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gbrkM7xAUIIzlXuuQiDMtA5tbf5e2cMU7MeqrR0qbVj8t0aS8hth3wMynqcuePC3vEv931xrAM4jg4uRTtzWSi4Rj+Z6fHbT6WfCPHL2LESRjw+Iw30xRwfo+KgkENw0NdJM7FUvW+dsN0NM2draGvEysjrP+xo9Olt9wBRpUmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDvTK8d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDvTK8d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721FBC4CEF7;
	Thu, 15 Jan 2026 01:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768438971;
	bh=jVBqlcLqSYseOgAHYybbgxO53XS2Bsh6/8CM4GtShzE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=kDvTK8d4hpQPa0CO4skL5dFMNKYiupT4QYHsMg2RDLscHlG/jv8ca+2pzZIupkQDt
	 VNOFC9PANKfgV4+2yQc1IEHyC5+cROm2GPysCuPLvU300v3hfYgFiX0HuQ7J55ANk4
	 MYuDm8q17bwnl6Gsn71BtEVZLw+oA2R8KQDtOLNIwhY+AKdRJ+Fw9pLB34V87wDwQ0
	 K/mHwgGBAwBnucAXu35LMkTfcz1PvqeiLpYKFsj8LIFzDDVmn/733duDo73i4Uiuqe
	 70YXVSGcyDfuyY5lEOn5F0gCTmt88Tmu22M2Mfp3obPLLf0l2MauV84ADS0zZUYIKa
	 dvZTzciYsKkRA==
Date: Wed, 14 Jan 2026 18:02:46 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
cc: Paul Walmsley <pjw@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
    Palmer Dabbelt <palmer@dabbelt.com>, 
    Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
    Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
    Craig Topper <craig.topper@sifive.com>, linux-riscv@lists.infradead.org, 
    llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH RFC v2] riscv: Use 64-bit variable for output in
 __get_user_asm
In-Reply-To: <20260113-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v2-1-e04aba2e1f9f@kernel.org>
Message-ID: <7bc39d4d-6e2d-f0af-9787-5fd2c92bfd4e@kernel.org>
References: <20260113-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v2-1-e04aba2e1f9f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Nathan,

On Tue, 13 Jan 2026, Nathan Chancellor wrote:

> After commit f6bff7827a48 ("riscv: uaccess: use 'asm_goto_output' for
> get_user()"), which was the first commit that started using asm goto
> with outputs on RISC-V, builds of clang built with assertions enabled
> start crashing in certain files that use get_user() with:
> 
>   clang: llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.cpp:12743: Register FollowCopyChain(MachineRegisterInfo &, Register): Assertion `MI->getOpcode() == TargetOpcode::COPY && "start of copy chain MUST be COPY"' failed.
> 
> Internally, LLVM generates an addiw instruction when the output of the
> inline asm (which may be any scalar type) needs to be sign extended for
> ABI reasons, such as a later function call, so that basic block does not
> have to do it.
> 
> Use a temporary 64-bit variable as the output of the inline assembly in
> __get_user_asm() and explicitly cast it to truncate it if necessary,
> avoiding the addiw that triggers the assertion.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/2092
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v2:
> - Rebase on 6.19-rc5
> - Send to updated addresses
> - Link to v1: https://lore.kernel.org/r/20250811-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v1-1-7bb8c9cbb92b@kernel.org
> ---
> I did this unconditionally but I did not do much investigation into how
> the code generation changes, as I never have good luck with figuring out
> what is real vs. noise. If this is a worry, I can just duplicate this
> under a CONFIG_CC_IS_CLANG block. Alternatively, we could mark
> CONFIG_CC_HAS_ASM_GOTO_OUTPUT as broken with clang when targeting
> RISC-V.

I'm assuming this would be a temporary patch, and that we might be able to 
remove it at some point (years, I guess?)

Might be worth adding a comment in the code to explain why a temporary 
variable is needed.


thanks for the patch,

- Paul
