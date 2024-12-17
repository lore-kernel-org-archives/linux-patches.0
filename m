Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C191F6661;
	Tue, 17 Dec 2024 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734457470; cv=none; b=BQKBxPmIhTSiJoMkMLtdvIBvrDWLeP4z0U0HEufjkfyLT0+l74MRnf+L5Dc7epUKoMvjvw0e/KzjaEYx/DoWCDf54RmS29vJztsFwhiBaDRtIiBKtmD6XDC70mBLhnHIOHHJQZir0mNDm8dAYMKJHYaQInNONJBVu753lAYPXm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734457470; c=relaxed/simple;
	bh=A//ntDLX7F+p0RzFZ+kiCywBs6TL0gT3ab+v5nn1KMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwzTouMvj1pIORH2qa7aY8VceoDGFmGoR4At14yH6RHDI8pQyHl6UHBmLXZCgUrUfArwjqF43qdETKuPIWpT9taijSrpC0UoUEjhdVLcY4s4bqGeID6XwAB1bE7qvZFVcniVAMBbVU4sm2hgc7vjtRPsP63lP8E9Ta6W8DUpK0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqMJESDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqMJESDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF898C4CED3;
	Tue, 17 Dec 2024 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734457469;
	bh=A//ntDLX7F+p0RzFZ+kiCywBs6TL0gT3ab+v5nn1KMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dqMJESDao7s4xO+yyxENPv5PaqsyBl95GTytZ+4JBnTNP1F7HZG6aW3elyaFAufTA
	 ImJxMW8Vm3v7cHZ4f02tq4bJwCmWkOkkRAD8mgSQGhwQaND8Gq42BQl9x3yuE+R6oP
	 lwdjXmVtuoyAr+18nYJEUGwwdyN7aKwN+Zv1hnObb98V6S/aP5fCER1XbXT8A+9eQH
	 JTRYv6BUzDDOKmZc/2CKioyMEcSAjFoHDQZhDb8MZS+spUpwiTMKqkyGlSY7wGBXX7
	 RE94Y9FQST5qsz5eiPcK55QFjFgUq+KUw0Me1DuGTrMGJrwAeNZ0wBzRTnawGGDXT6
	 FnAClSWSpErvg==
Date: Tue, 17 Dec 2024 10:44:25 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Brian Cain <bcain@quicinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-hexagon@vger.kernel.org, patches@lists.linux.dev,
	llvm@lists.linux.dev, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hexagon: Disable constant extender optimization for
 LLVM prior to 19.1.0
Message-ID: <20241217174425.GA2651946@ax162>
References: <20241121-hexagon-disable-constant-expander-pass-v2-1-1a92e9afb0f4@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121-hexagon-disable-constant-expander-pass-v2-1-1a92e9afb0f4@kernel.org>

Hi Linus,

Could you apply this change [1] directly? Brian has reviewed it and I have
sent this patch twice plus another ping for application [2]. I would
like to stop applying this in our CI and some other people have hit it
as well.

[1]: https://lore.kernel.org/all/20241121-hexagon-disable-constant-expander-pass-v2-1-1a92e9afb0f4@kernel.org/
[2]: https://lore.kernel.org/all/20241001185848.GA562711@thelio-3990X/

Cheers,
Nathan

On Thu, Nov 21, 2024 at 11:22:18AM -0700, Nathan Chancellor wrote:
> The Hexagon-specific constant extender optimization in LLVM may crash on
> Linux kernel code [1], such as fs/bcache/btree_io.c after
> commit 32ed4a620c54 ("bcachefs: Btree path tracepoints") in 6.12:
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
> Cc: stable@vger.kernel.org
> Link: https://github.com/llvm/llvm-project/issues/99714 [1]
> Link: https://github.com/llvm/llvm-project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
> Link: https://github.com/llvm/llvm-project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
> Reviewed-by: Brian Cain <bcain@quicinc.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Andrew, can you please take this for 6.13? Our CI continues to hit this.
> 
> Changes in v2:
> - Rebase on 6.12 to make sure it is still applicable
> - Name exact bcachefs commit that introduces crash now that it is
>   merged
> - Add 'Cc: stable' as this is now visible in a stable release
> - Carry forward Brian's reviewed-by
> - Link to v1: https://lore.kernel.org/r/20240819-hexagon-disable-constant-expander-pass-v1-1-36a734e9527d@kernel.org
> ---
>  arch/hexagon/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
> index 92d005958dfb232d48a4ca843b46262a84a08eb4..ff172cbe5881a074f9d9430c37071992a4c8beac 100644
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
> base-commit: adc218676eef25575469234709c2d87185ca223a
> change-id: 20240802-hexagon-disable-constant-expander-pass-8b6b61db6afc
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
