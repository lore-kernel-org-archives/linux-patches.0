Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E7A16EB71
	for <patches@lists.linux.dev>; Mon,  1 Jul 2024 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719864342; cv=none; b=bxtwNpxjOzc1Ri85xg1QcMqaDKL5zpzlEy7aa6RbK5IcnHAi7BRQrugOysUf/rVEUqHdi1MC95bONFESYWpfunaMzXPKaUeT22LQdpc/EpG6SgloVKbXtXlduhwCdMt8V2Ln174H1FR7zlQFGQh307LVi3odO1uUCe3PYcMexCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719864342; c=relaxed/simple;
	bh=5VQTwTKEUExBX8o2nqjCSvPRM0RkgeWuM3RjMkLIS30=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0mEsBVFUAOyT3qWIT3oIJtb0XYJBctFwooF9b0IFghhAL0lROGjYkRSKmVouSwLmK5owmza9YhcZUj2RdyX7qOQalNx6IamUamv+JHL6sOZY4teN2gq9WhLcOyYN5anYfeyRXRYuufB6Hj28j+hmSFUhXXgfhQGDM2777sIpec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Q24Ag0Wn; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Q24Ag0Wn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1719864332; x=1720123532;
	bh=Fbqy3CjeIafymXMm5Clcbg+Jyu+ttWkp2c05/l/pUhI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Q24Ag0Wnv8EsHIeIaAkSaAtD3UkV6F9Jfu75lHZ4h9fCHFwPRyA9nWOojM9D+iNCz
	 L67a79N49OIlGnR+L2QdPGXU6usiBHYtMl6jU7bVX/CaAu5l+UDfMgZ08QHlSXNOiR
	 H2jm0wFJLBnpw/vJ5g4dDG6yQeGRBmEJaGKybpsfGm2oX1AVkItMp82DTaZayj8kRR
	 D4StTugOsA12KNVNX9hNTklfG34jD30hEmz/2tpRzmyIGPR0Y81yH5v8iOZNaY2CwU
	 UPTTV/KQiGPKZw6cXVstD9zzndqPaynKdPatxSEuvI4dJQM0nwp+7f1DsmZ96p6/8z
	 QKAwJNey8ltsw==
Date: Mon, 01 Jul 2024 20:05:26 +0000
To: Miguel Ojeda <ojeda@kernel.org>
From: =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 02/13] rust: init: simplify from `map_err` to `inspect_err`
Message-ID: <ap7u5hpgfdzYgTkobIleYc0uolBIsAVbq56CwMJG6k4x57wXeEtu4fpLpgSOvQtbJHvB6D0J1wlBaqDV-xt2owlVejhfABUv_ivILyJ2J9o=@protonmail.com>
In-Reply-To: <20240701183625.665574-3-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-3-ojeda@kernel.org>
Feedback-ID: 27884398:user:proton
X-Pm-Message-ID: cec92edeebf47f40201cfcea59a396169f8fab5a
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, July 1st, 2024 at 20:36, Miguel Ojeda <ojeda@kernel.org> wrote:

> A new complexity lint, `manual_inspect` [1], has been introduced in
> the upcoming Rust 1.81 (currently in nightly), which checks for uses of
> `map*` which return the original item:
>=20
>     error:
>     --> rust/kernel/init.rs:846:23
>         |
>     846 |         (self.1)(val).map_err(|e| {
>         |                       ^^^^^^^
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#manual_inspect
>         =3D note: `-D clippy::manual-inspect` implied by `-D warnings`
>         =3D help: to override `-D warnings` add `#[allow(clippy::manual_i=
nspect)]`
>     help: try
>         |
>     846 ~         (self.1)(val).inspect_err(|e| {
>     847 |             // SAFETY: `slot` was initialized above.
>     848 ~             unsafe { core::ptr::drop_in_place(slot) };
>         |
>=20
> Thus clean them up.
>=20
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/manual_i=
nspect [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/init.rs | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
> index 68605b633e73..07bacf134c19 100644
> --- a/rust/kernel/init.rs
> +++ b/rust/kernel/init.rs
> @@ -843,11 +843,9 @@ unsafe fn __pinned_init(self, slot: *mut T) -> Resul=
t<(), E> {
>          let val =3D unsafe { &mut *slot };
>          // SAFETY: `slot` is considered pinned.
>          let val =3D unsafe { Pin::new_unchecked(val) };
> -        (self.1)(val).map_err(|e| {
> +        (self.1)(val).inspect_err(|_|
>              // SAFETY: `slot` was initialized above.
> -            unsafe { core::ptr::drop_in_place(slot) };
> -            e
> -        })
> +            unsafe { core::ptr::drop_in_place(slot) })

The formatting here is a bit weird. I would have expected the ) ending the =
inspect_err call to be placed on a new line given that the unsafe block isn=
't placed on the same line as the start of the inspect_err call either. Thi=
s seems to be a case where rustfmt mostly gives up on formatting. If I dein=
dent the comment and unsafe block rustfmt will keep it that way and if I ad=
d a trailing space to the inspect_err line it will keep it and emit an erro=
r that it left behind trailing whitespace. Maybe add a block around the com=
ment and unsafe block to make rustfmt work again?

>      }
>  }
>=20
> @@ -941,11 +939,9 @@ unsafe fn __init(self, slot: *mut T) -> Result<(), E=
> {
>          // SAFETY: All requirements fulfilled since this function is `__=
init`.
>          unsafe { self.0.__pinned_init(slot)? };
>          // SAFETY: The above call initialized `slot` and we still have u=
nique access.
> -        (self.1)(unsafe { &mut *slot }).map_err(|e| {
> +        (self.1)(unsafe { &mut *slot }).inspect_err(|_|
>              // SAFETY: `slot` was initialized above.
> -            unsafe { core::ptr::drop_in_place(slot) };
> -            e
> -        })
> +            unsafe { core::ptr::drop_in_place(slot) })
>      }
>  }
>=20
> --
> 2.45.2
