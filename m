Received: from hs01.dakr.org (hs01.dakr.org [173.249.23.66])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F08757EB
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.249.23.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723747227; cv=none; b=Cb7SUmCvFF1571UdlLXA727/iaHD86aK3MAHllu+z3nutoAGDL6gMyU4EMx4/c9bIY96pk3/VhIINk/MmfMlTwAPuvJmLX6/XsmJvIK8HA0GsPDBgYOp45I55PGfwdMpOGoVPju6CR/uxfWe94c4tDQmQXoc8LIOxzyF+vgliB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723747227; c=relaxed/simple;
	bh=DqvoXi4F3Pc40CMrzlKdtaZnQEiVxRYmQ3FlnDvE2gg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZX1bjSTNdvVeKx57KFwmIsPUWTq3ihuuvaHpAirDboXu5J0ySwdZuyCXI/zULiTL5+ZIUUoS+Ws3AHtomM3twaNxqjCXLWc9hzvf+a9DSif6FU4xhdp9ghVkRBQu2MBy3ULjBZaF8MOfLVdTL8CoD2gd/e0V7rQDX9uZAhWaUL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dakr.org; spf=pass smtp.mailfrom=dakr.org; arc=none smtp.client-ip=173.249.23.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dakr.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dakr.org
Message-ID: <204d94fb-14af-4132-831a-73aab2ef9d36@dakr.org>
Date: Thu, 15 Aug 2024 20:33:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] rust: enable bindgen's
 `--enable-function-attribute-detection` flag
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240814163722.1550064-1-ojeda@kernel.org>
From: Danilo Krummrich <me@dakr.org>
Content-Language: en-US
In-Reply-To: <20240814163722.1550064-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/24 6:37 PM, Miguel Ojeda wrote:
> `bindgen` is able to detect certain function attributes and annotate
> functions correspondingly in its output for the Rust side, when the
> `--enable-function-attribute-detection` is passed.
> 
> In particular, it is currently able to use `__must_check` in C
> (`#[must_use]` in Rust), which give us a bunch of annotations that are
> nice to have to prevent possible issues in Rust abstractions, e.g.:
> 
>       extern "C" {
>      +    #[must_use]
>           pub fn kobject_add(
>               kobj: *mut kobject,
>               parent: *mut kobject,
>               fmt: *const core::ffi::c_char,
>               ...
>           ) -> core::ffi::c_int;
>       }
> 
> Apparently, there are edge cases where this can make generation very slow,
> which is why it is behind a flag [1], but it does not seem to affect us
> in any major way at the moment.
> 
> Link: https://github.com/rust-lang/rust-bindgen/issues/1465 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72=u5Nrz_NW3U3_VqywJkD8pECA07q2pFDd1wjtXOWdkAQ@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks for looking into this,

Acked-by: Danilo Krummrich <dakr@kernel.org>

> ---
> If someone notices a major performance difference, please let me know!
> 
>   rust/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rust/Makefile b/rust/Makefile
> index 1f10f92737f2..c28b81e2a5fa 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -270,7 +270,7 @@ quiet_cmd_bindgen = BINDGEN $@
>         cmd_bindgen = \
>   	$(BINDGEN) $< $(bindgen_target_flags) \
>   		--use-core --with-derive-default --ctypes-prefix core::ffi --no-layout-tests \
> -		--no-debug '.*' \
> +		--no-debug '.*' --enable-function-attribute-detection \
>   		-o $@ -- $(bindgen_c_flags_final) -DMODULE \
>   		$(bindgen_target_cflags) $(bindgen_target_extra)
> 
> 
> base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
> --
> 2.46.0
> 
