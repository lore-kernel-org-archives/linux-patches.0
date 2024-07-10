Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA08120F;
	Wed, 10 Jul 2024 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646226; cv=none; b=RZhov+Lr3/fGY2ciYBKhHPPJLxuXoozmbv1Kr6MQGDXp3182NfG5kbDH5nqvVTDU2PxCdkahkicSgRkkNOGsbHvIuutsrp1aEIH62Q+kN5zgR40EkiW35E6OpN1eZ3kNQaai4u0/Jr2bAHARgN0aPYJPWMzA3NknsgN0zvi4SJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646226; c=relaxed/simple;
	bh=d9NIoNvAmXJAYWmjVWiD/n/PtWG7Ev/HfH7ECteYYgc=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=V6Sgfn100y8T+SpHZTLRpUeJMDoM3j2LQdPLYcHHZg+r8rZdv/XJp/tIMdz0h7K5sSOnK6rW92jYedEUQnAWrazBIqSyxOe10T9lx6bTAUEQsXjx9WnfPhjj8snntB3Oc3lmoLJIgKF1sEDX/s1nmPWAygvcDICk4o+x9f7G2bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFnwj8fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFnwj8fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5108CC4AF07;
	Wed, 10 Jul 2024 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720646226;
	bh=d9NIoNvAmXJAYWmjVWiD/n/PtWG7Ev/HfH7ECteYYgc=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=VFnwj8fr/kUfeYy6M2uXEDgC4wbdVbrCGBf24UiA0AGu753EMuQNsjOOWV0u9uUSD
	 KM6i1JILZFnF+cxLKS2b60M31Eh1+S7VYuZyCfUfwYCzTbY075tcHDKRZ7Dbrx2byX
	 GqXM/IivdRXA2+wJraUTI5lcxDudsB+VaFaGZGBDv51AATzCBEJ15MRpPri/Af/9KR
	 LXNO+GeFZvEf3mxuUH2I4SWjcVyk+Q2fBNBh3uiedtny/R0IZLxQ5n33xSqNpCpmso
	 7w/qCvgx5N4n8MT0MQxaDjFj90/M2lQ9Qx+QJ62TXotUrypIgHHYa6pdq47zBRIt1D
	 CCfeY1TDuhR3A==
Message-ID: <c9fe1a32e0e362a8b7732ea554625c55.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240710-clk-sg2042-fix-sometimes-uninitialized-pll_set_rate-v1-1-538fa82dd539@kernel.org>
References: <20240710-clk-sg2042-fix-sometimes-uninitialized-pll_set_rate-v1-1-538fa82dd539@kernel.org>
Subject: Re: [PATCH] clk: sophgo: Avoid -Wsometimes-uninitialized in sg2042_clk_pll_set_rate()
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
To: Chen Wang <unicorn_wang@outlook.com>, Inochi Amaoto <inochiama@outlook.com>, Michael Turquette <mturquette@baylibre.com>, Nathan Chancellor <nathan@kernel.org>
Date: Wed, 10 Jul 2024 14:17:04 -0700
User-Agent: alot/0.10

Quoting Nathan Chancellor (2024-07-10 10:07:52)
> Clang warns (or errors with CONFIG_WERROR=3Dy):
>=20
>   drivers/clk/sophgo/clk-sg2042-pll.c:396:6: error: variable 'ret' is use=
d uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninit=
ialized]
>     396 |         if (sg2042_pll_enable(pll, 0)) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/clk/sophgo/clk-sg2042-pll.c:418:9: note: uninitialized use occu=
rs here
>     418 |         return ret;
>         |                ^~~
>   drivers/clk/sophgo/clk-sg2042-pll.c:396:2: note: remove the 'if' if its=
 condition is always false
>     396 |         if (sg2042_pll_enable(pll, 0)) {
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     397 |                 pr_warn("Can't disable pll(%s), status error\n"=
, pll->hw.init->name);
>         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~~
>     398 |                 goto out;
>         |                 ~~~~~~~~~
>     399 |         }
>         |         ~
>   drivers/clk/sophgo/clk-sg2042-pll.c:393:9: note: initialize the variabl=
e 'ret' to silence this warning
>     393 |         int ret;
>         |                ^
>         |                 =3D 0
>   1 error generated.
>=20
> sg2042_pll_enable() only ever returns zero, so this situation cannot
> happen, but clang does not perform interprocedural analysis, so it
> cannot know this to avoid the warning. Make it clearer to the compiler
> by making sg2042_pll_enable() void and eliminate the error handling in
> sg2042_clk_pll_set_rate(), which clears up the warning, as ret will
> always be initialized.
>=20
> Fixes: 48cf7e01386e ("clk: sophgo: Add SG2042 clock driver")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Applied to clk-next
