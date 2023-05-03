Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81677E;
	Wed,  3 May 2023 01:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FEBC433D2;
	Wed,  3 May 2023 01:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683077086;
	bh=lsGfYqTxN6CmiGa/UF1TSjYTtWD5KKntZWexa6A8WXs=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=Ru8i90ept9ajVjdFjT2NFgsj3JUOqo7Fonh3eyJBsRlZgJLKMsKiiCoF6tWWDMUN/
	 CI/xxaszWoAA/ZEOOQxJ+1P9cVL7YHFeP2WkzV1JIAloS5zUBNHyi4EcNWeReqWQEN
	 Jz5+BUaUJsWh8p1yokbZX1k7DJwvftuIL+tmlDdz9rG+6N25T4ygxK4m+DLhNuylva
	 HmDnF3YBLIeRgN8Jqk4j05RuczGuacdpgyqzzF0UC4vdDGG0p5HLvDIOlQ0PhUExCY
	 qOFt8yDmPvxXLI6OudGUIUvWp+wPrg+Dwmh7WObWDPypmzuIzlT62daTNfUNZPDq/W
	 P2Sfb+/pbkxEQ==
Message-ID: <eca3f8fe42189a019536a27058f3d162.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230501-sp7021-field_prep-warning-v1-1-5b36d71feefe@kernel.org>
References: <20230501-sp7021-field_prep-warning-v1-1-5b36d71feefe@kernel.org>
Subject: Re: [PATCH] clk: sp7021: Adjust width of _m in HWM_FIELD_PREP()
From: Stephen Boyd <sboyd@kernel.org>
Cc: ndesaulniers@google.com, trix@redhat.com, linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>, mturquette@baylibre.com, qinjian@cqplus1.com
Date: Tue, 02 May 2023 18:24:44 -0700
User-Agent: alot/0.10

Quoting Nathan Chancellor (2023-05-01 14:34:47)
> When building with clang + W=3D1, there is a warning around an internal
> comparison check within the FIELD_PREP() macro, due to a 32-bit variable
> comparison against ~0ull:
>=20
>   drivers/clk/clk-sp7021.c:316:8: error: result of comparison of constant=
 18446744073709551615 with expression of type 'typeof (_Generic((_m), ...' =
(aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-o=
f-range-compare]
>           r0 |=3D HWM_FIELD_PREP(MASK_SEL_FRA, clk->p[SEL_FRA]);
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/clk/clk-sp7021.c:45:15: note: expanded from macro 'HWM_FIELD_PR=
EP'
>           (_m << 16) | FIELD_PREP(_m, value);     \
>                        ^~~~~~~~~~~~~~~~~~~~~
>   include/linux/bitfield.h:114:3: note: expanded from macro 'FIELD_PREP'
>                   __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");   =
 \
>                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/bitfield.h:71:53: note: expanded from macro '__BF_FIELD_C=
HECK'
>                   BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >    =
 \
>                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~=
~~
>   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=
=3D0 to see all)
>   include/linux/compiler_types.h:397:22: note: expanded from macro 'compi=
letime_assert'
>           _compiletime_assert(condition, msg, __compiletime_assert_, __CO=
UNTER__)
>           ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~
>   include/linux/compiler_types.h:385:23: note: expanded from macro '_comp=
iletime_assert'
>           __compiletime_assert(condition, msg, prefix, suffix)
>           ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/compiler_types.h:377:9: note: expanded from macro '__comp=
iletime_assert'
>                   if (!(condition))                                      =
 \
>                         ^~~~~~~~~
>=20
> This is expected given the tyoes of the input. Increase the size of the
> temporary variable in HWM_FIELD_PREP() to eliminate the warning, which
> follows the logic of commit cfd6fb45cfaf ("crypto: ccree - avoid
> out-of-range warnings from clang") for the same reasons.
>=20
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Applied to clk-next
