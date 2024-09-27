Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E8913C914
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727456767; cv=none; b=Tqa8dKIekJo/n4Lh+Hh8vlHghmb1Fi7uGchT631dczW91c7Es0orjqFgeTGOfFCaY+BvLvpSihIAi/347aGsj1vjedCLRPN1paXrp0JTRyuz1ye5ftbCxAlPifhpr0pH2Y2s+A3VGVRIqmvvUEm8p3jwh1ycZ74qmeOHKrqrVRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727456767; c=relaxed/simple;
	bh=QT1nNXMyixzzO8cPczmurI3i3MOYrB/E95IPOWS8qGY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oCCyqKmt+7QSTTt2Iiv48LzcYbLx/vQzrqYSxV50n53oG0aOGptlbjJ+M257Nt1RW8U5Smj4oCwCgYp17hDCHkcky4VzHz2DTQDz8TlvxwKZPd7huoaiiLcdcmv+7N54MAGSdm16CdRqa6jF8gPATB7Osr7Kn2o87Mb76yuxp94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=b1EDYwbp; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="b1EDYwbp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1727456762; x=1727715962;
	bh=XEdNrIs+/Qoav2bIQvstvBaoiXxweTWIFB4AckNgCJo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=b1EDYwbpFNqVEYVLVlo17b3oQTIL5K+i5+RLJxqzaQ1F/5zS2V8yAc4WHId9T1UHp
	 +ejRYsS72iOYm7Gjs5ER8cOtfQGQN51Jgtv/4W2df1s9r3+XQ3whxeiIBFYapf0fxD
	 jUrOclQP/agZVQYdVjfRGGJKMTb1udjmMmWICjtYTF9sw+1ceuUn2sZ1ZLc59NFwUB
	 WVUFgGZhsriC7n9AcgJWWbyo7X0Kpc7cfKPbD4Hk7qLxdMjIZB2FwiX6clh5vbl23m
	 k4KjXv0wjDW7E+DhEYTKrpt1i6zjJEmfmMEOw8rAcRVa1TPUXLyPWA6rQRSG8J2lhR
	 iaBQUpXIZ4cPA==
Date: Fri, 27 Sep 2024 17:05:56 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: kunit: use C-string literals to clean warning
Message-ID: <d8d610d0-5cea-40de-868e-8c80954daa27@proton.me>
In-Reply-To: <20240927164414.560906-1-ojeda@kernel.org>
References: <20240927164414.560906-1-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: 806e01527716f02c2c9c501e9538cc350e2343f9
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 27.09.24 18:44, Miguel Ojeda wrote:
> Starting with upstream Rust commit a5e3a3f9b6bd ("move
> `manual_c_str_literals` to complexity"), to be released in Rust 1.83.0
> [1], Clippy now warns on `manual_c_str_literals` by default, e.g.:
>=20
>     error: manually constructing a nul-terminated string
>       --> rust/kernel/kunit.rs:21:13
>        |
>     21 |             b"\x013%pA\0".as_ptr() as _,
>        |             ^^^^^^^^^^^^^ help: use a `c""` literal: `c"\x013%pA=
"`
>        |
>        =3D help: for further information visit https://rust-lang.github.i=
o/rust-clippy/master/index.html#manual_c_str_literals
>        =3D note: `-D clippy::manual-c-str-literals` implied by `-D warnin=
gs`
>        =3D help: to override `-D warnings` add `#[allow(clippy::manual_c_=
str_literals)]`
>=20
> Apply the suggestion to clean up the warnings.
>=20
> Link: https://github.com/rust-lang/rust-clippy/pull/13263 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

> ---
> The cast could also be cleaned up, but that is already done in Gary's
> FFI series, so I didn't include another patch.
>=20
> C-string literals are available since Rust 1.77.0, which is higher than

I thought our minimal version is 1.78.0, or am I misunderstanding the
wording here (I interpret higher as "1.77 > min-version").

---
Cheers,
Benno

> our minimum version, but LTS kernels do not have Rust 1.77.0. But
> perhaps for these is not a big deal, and we could also enable
> `feature(c_str_literals)` instead.
>=20
>  rust/kernel/kunit.rs | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
> index 0ba77276ae7e..824da0e9738a 100644
> --- a/rust/kernel/kunit.rs
> +++ b/rust/kernel/kunit.rs
> @@ -18,7 +18,7 @@ pub fn err(args: fmt::Arguments<'_>) {
>      #[cfg(CONFIG_PRINTK)]
>      unsafe {
>          bindings::_printk(
> -            b"\x013%pA\0".as_ptr() as _,
> +            c"\x013%pA".as_ptr() as _,
>              &args as *const _ as *const c_void,
>          );
>      }
> @@ -34,7 +34,7 @@ pub fn info(args: fmt::Arguments<'_>) {
>      #[cfg(CONFIG_PRINTK)]
>      unsafe {
>          bindings::_printk(
> -            b"\x016%pA\0".as_ptr() as _,
> +            c"\x016%pA".as_ptr() as _,
>              &args as *const _ as *const c_void,
>          );
>      }
>=20
> base-commit: 570172569238c66a482ec3eb5d766cc9cf255f69
> --
> 2.46.2

