Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583DF13B284;
	Sat, 12 Jul 2025 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752343494; cv=none; b=l729u1KskcLwSMC6MKhg4Fa1MVGrjgxbMvccF89QxWEOan3XCgbA1Gf/kDvt6CfQAhS6cecJ9pSyHIzbtNa4b7Xl4KZNdb3f1FQ54tCSVP76ZXvgjGGBM2UWA7/leLbjJPABNBq/mIDipDjxlwXCMtkPD4I0CLSm2oUE0/tYklw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752343494; c=relaxed/simple;
	bh=qhXkoyHjTIqBuIjJ4a9EJ6EqyerxsPahaWb2KYK8qyk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=V2pJqH9N3KYzLcFi2hXtVtHc6U5Gmnszn/RpDE8/oEhaWTFBvBeoBGrQswhyHD17ZBR6UWe2qdOIEAlAajXgC36hkFfDXmXfWw4So9KnDadUpx7NFrrQ3R6Ou2OdRKyNVuWarNXSpQw8K16UIOrP7dFusssY9tnKnXBV3LLi2HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4encWvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4encWvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51CAC4CEEF;
	Sat, 12 Jul 2025 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752343493;
	bh=qhXkoyHjTIqBuIjJ4a9EJ6EqyerxsPahaWb2KYK8qyk=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=q4encWvoHB9ISf+RUY702PzOWs79L6eapmZckWNCyrDCcIVBG4daLk+o6gHCZ7cjB
	 Eht5RZYBNLmRhu15wE1dw4Ek0xNr1E8equ2Fi+L9VnlQsz5aP+K06Sgq9u872vVblB
	 O1MoSu3pG2/a3v6kw8td2AclawscpLtukdtQeYw+OTZV3yt7khVs+yUsGrqjMrIbWT
	 rV/kYrz/GOYfrL+gQrPWyRVhOi1sFsqv99sRXn8L+vaqktrkyXSVPncz8MFaIuFrK4
	 MW+oVkmURdTm8ctD9Oj1RixYm9uHULf13qC9zWfedKFtkh/0NA1a87xkxcApBqXFbM
	 pH1CNCfn/1hUA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 12 Jul 2025 20:04:48 +0200
Message-Id: <DBA9X9FU5M9A.14RBXD887DKB1@kernel.org>
Cc: <stable@vger.kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <benno.lossin@proton.me>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl"
 <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 6.12.y] rust: init: allow `dead_code` warnings for Rust
 >= 1.89.0
From: "Benno Lossin" <lossin@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Sasha Levin" <sashal@kernel.org>, "Alex
 Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.20.1
References: <20250712171038.1287789-1-ojeda@kernel.org>
In-Reply-To: <20250712171038.1287789-1-ojeda@kernel.org>

On Sat Jul 12, 2025 at 7:10 PM CEST, Miguel Ojeda wrote:
> Starting with Rust 1.89.0 (expected 2025-08-07), the Rust compiler
> may warn:
>
>     error: trait `MustNotImplDrop` is never used
>        --> rust/kernel/init/macros.rs:927:15
>         |
>     927 |         trait MustNotImplDrop {}
>         |               ^^^^^^^^^^^^^^^
>         |
>        ::: rust/kernel/sync/arc.rs:133:1
>         |
>     133 | #[pin_data]
>         | ----------- in this procedural macro expansion
>         |
>         =3D note: `-D dead-code` implied by `-D warnings`
>         =3D help: to override `-D warnings` add `#[allow(dead_code)]`
>         =3D note: this error originates in the macro `$crate::__pin_data`
>                 which comes from the expansion of the attribute macro
>                 `pin_data` (in Nightly builds, run with
>                 -Z macro-backtrace for more info)
>
> Thus `allow` it to clean it up.

This is a bit strange, I can't directly reproduce the issue... I already
get this warning in 1.88:

    https://play.rust-lang.org/?version=3Dstable&mode=3Ddebug&edition=3D202=
4&gist=3D465f71a848e77ac3f7a96a0af6bc9e2a

> This does not happen in mainline nor 6.15.y, because there the macro was
> moved out of the `kernel` crate, and `dead_code` warnings are not
> emitted if the macro is foreign to the crate. Thus this patch is
> directly sent to stable and intended for 6.12.y only.
>
> Similarly, it is not needed in previous LTSs, because there the Rust
> version is pinned.
>
> Cc: Benno Lossin <lossin@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Anyways the patch itself looks fine, nobody should care about the
dead-code warning (since it is in fact used to prevent `Drop` being
implemented).

Acked-by: Benno Lossin <lossin@kernel.org>

---
Cheers,
Benno

> ---
> Greg, Sasha: please note that an equivalent patch is _not_ in mainline.
>
> We could put these `allow`s in mainline (they wouldn't hurt), but it
> isn't a good idea to add things in mainline for the only reason of
> backporting them, thus I am sending this directly to stable.
>
> The patch is pretty safe -- there is no actual code change.
>
>  rust/kernel/init/macros.rs | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
> index b7213962a6a5..e530028bb9ed 100644
> --- a/rust/kernel/init/macros.rs
> +++ b/rust/kernel/init/macros.rs
> @@ -924,6 +924,7 @@ impl<'__pin, $($impl_generics)*> ::core::marker::Unpi=
n for $name<$($ty_generics)
>          // We prevent this by creating a trait that will be implemented =
for all types implementing
>          // `Drop`. Additionally we will implement this trait for the str=
uct leading to a conflict,
>          // if it also implements `Drop`
> +        #[allow(dead_code)]
>          trait MustNotImplDrop {}
>          #[expect(drop_bounds)]
>          impl<T: ::core::ops::Drop> MustNotImplDrop for T {}
> @@ -932,6 +933,7 @@ impl<$($impl_generics)*> MustNotImplDrop for $name<$(=
$ty_generics)*>
>          // We also take care to prevent users from writing a useless `Pi=
nnedDrop` implementation.
>          // They might implement `PinnedDrop` correctly for the struct, b=
ut forget to give
>          // `PinnedDrop` as the parameter to `#[pin_data]`.
> +        #[allow(dead_code)]
>          #[expect(non_camel_case_types)]
>          trait UselessPinnedDropImpl_you_need_to_specify_PinnedDrop {}
>          impl<T: $crate::init::PinnedDrop>
>
> base-commit: fbad404f04d758c52bae79ca20d0e7fe5fef91d3
> --
> 2.50.1

