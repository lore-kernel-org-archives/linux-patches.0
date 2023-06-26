Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7D11FA3;
	Mon, 26 Jun 2023 09:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4526C433C8;
	Mon, 26 Jun 2023 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687770641;
	bh=bkEzN7NEeSuJMSS4LbC9r8tnxCY2Dyrv80RPlDqBdBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fFv7QpxevJNhOVyBMTQQSBPkWul0PqSqgUUbhkOVdWIZHUT60QMzZNJgmdo2QQ6mG
	 aG4RZTwp5uNPO/yk23DusKoabAVLqbKo8esdTECwzJUlOfoiuQcKJo7tiy5FjiDkiy
	 BUDCWQf7V3gdfj56oF2MW8t8/pEBSUau+6xt1wD9aMq+ky2w2Z1oIM7BgVLOaLySeU
	 wHYf1ujoP9aCvRO5XPeIcutZFK2nk4g7KQNH7Lc4jF0CaiCfs/n4PdRZEDDTcn3oqG
	 wbb7Vwxl0UgprK+0gEAbcH4pgV9TaXHsj7mEJEaYDOjS8m18z4OHIorpKzE2pWc94v
	 FWxWBpyxOLZdg==
Date: Mon, 26 Jun 2023 10:10:35 +0100
From: Lee Jones <lee@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: sean.wang@mediatek.com, pavel@ucw.cz, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com, ndesaulniers@google.com,
	trix@redhat.com, linux-leds@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] leds: leds-mt6323: Adjust return/parameter types in wled
 get/set callbacks
Message-ID: <20230626091035.GZ10378@google.com>
References: <20230622-mt6323-wled-wincompatible-function-pointer-types-strict-v1-1-6ad256f220e8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230622-mt6323-wled-wincompatible-function-pointer-types-strict-v1-1-6ad256f220e8@kernel.org>

On Thu, 22 Jun 2023, Nathan Chancellor wrote:

> Clang's kernel Control Flow Integrity (kCFI) is a compiler-based
> security mitigation that ensures the target of an indirect function call
> matches the expected type of the call and trapping if they do not match
> exactly. The warning -Wincompatible-function-pointer-types-strict aims
> to catch these issues at compile time, which reveals:
> 
>  drivers/leds/leds-mt6323.c:598:49: error: incompatible function pointer types assigning to 'int (*)(struct led_classdev *, enum led_brightness)' from 'int (struct led_classdev *, unsigned int)' [-Werror,-Wincompatible-function-pointer-types-strict]
>    598 |                         leds->led[reg]->cdev.brightness_set_blocking =
>        |                                                                      ^
>    599 |                                                 mt6323_wled_set_brightness;
>        |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
>  drivers/leds/leds-mt6323.c:600:40: error: incompatible function pointer types assigning to 'enum led_brightness (*)(struct led_classdev *)' from 'unsigned int (struct led_classdev *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>    600 |                         leds->led[reg]->cdev.brightness_get =
>        |                                                             ^
>    601 |                                                 mt6323_get_wled_brightness;
>        |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
>  2 errors generated.
> 
> While 'unsigned int' is ABI compatible with 'enum led_brightness' (hence
> no warning from -Wincompatible-function-pointer-types) and the callers
> of these callbacks use/pass the values as 'unsigned int', the mismatch
> between the prototype and the called function will trip kCFI at runtime.
> 
> Change the types in the implementations to match the prototypes, clearing
> up the warning and avoiding kCFI failures.
> 
> Fixes: 9bb0a9e0626c ("leds: leds-mt6323: Add support for WLEDs and MT6332")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/leds/leds-mt6323.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks

-- 
Lee Jones [李琼斯]
