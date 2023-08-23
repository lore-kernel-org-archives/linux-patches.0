Received: from mail-41103.protonmail.ch (mail-41103.protonmail.ch [185.70.41.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF2FC8FD
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 16:27:28 +0000 (UTC)
Date: Wed, 23 Aug 2023 16:18:39 +0000
Authentication-Results: mail-41103.protonmail.ch;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="jg6sJdO+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1692807540; x=1693066740;
	bh=x+ih6c7WHhuGLWj+NKR9PNQotRoT6LuY26VzJlqilQI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=jg6sJdO+wYfiN0CZyNbSGsqjc0kJkj+61U/RuzVBMg2AxPn32enN0K6C+YdWLxyU3
	 GuTu6akhfV+GFprFWj/p15cJ1EVVWqdCY67mme62pA7MXtip9ZYHpIUPmWZo+OixiE
	 eA5/AzIntIRie646SvMAHroA3ozy7SKjsXF+N5l1eF63gv9Z5LogDPdihwFZNAnsxN
	 VFd5jRyqkoT8K02tGax+efa8Z0EzU5VGGUdGpLiWCru5tJLfzGJlYTC2kabgGpXA0Y
	 T2r4p5uEBNOJNYVEPXC6KaUnJnv1t7tRB7YSAOuW8gyCDPd1o0xKUBx3drtKKAM19x
	 0CFNA7ElsgUdw==
To: Miguel Ojeda <ojeda@kernel.org>
From: =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/2] rust: arc: add explicit `drop()` around `Box::from_raw()`
Message-ID: <pNr7-0EyO6weJkSEeU770VmDkk25LV2u1CAbyHuS2XwPdFpYPmgBxqWLjLZLjOCW9p1At09QxciCyE_e9QdfnXO0SikhaJVZAU6GPAjA8aU=@protonmail.com>
In-Reply-To: <20230823160244.188033-2-ojeda@kernel.org>
References: <20230823160244.188033-1-ojeda@kernel.org> <20230823160244.188033-2-ojeda@kernel.org>
Feedback-ID: 27884398:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wednesday, August 23rd, 2023 at 18:02, Miguel Ojeda <ojeda@kernel.org> w=
rote:

> `Box::from_raw()` is `#[must_use]`, which means the result cannot
> go unused.
>=20
> In Rust 1.71.0, this was not detected because the block expression
> swallows the diagnostic [1]:
>=20
>     unsafe { Box::from_raw(self.ptr.as_ptr()) };
>=20
> It would have been detected, however, if the line had been instead:
>=20
>     unsafe { Box::from_raw(self.ptr.as_ptr()); }
>=20
> i.e. the semicolon being inside the `unsafe` block, rather than
> outside.
>=20
> In Rust 1.72.0, the compiler started warning about this [2], so
> without this patch we will get:
>=20
>         error: unused return value of `alloc::boxed::Box::<T>::from_raw` =
that must be used
>         --> rust/kernel/sync/arc.rs:302:22
>         |
>     302 |             unsafe { Box::from_raw(self.ptr.as_ptr()) };
>         |                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>         |
>         =3D note: call `drop(Box::from_raw(ptr))` if you intend to drop t=
he `Box`
>         =3D note: `-D unused-must-use` implied by `-D warnings`
>     help: use `let _ =3D ...` to ignore the resulting value
>         |
>     302 |             unsafe { let _ =3D Box::from_raw(self.ptr.as_ptr())=
; };
>         |                      +++++++                                 +
>=20
> Thus add an add an explicit `drop()` as the `#[must_use]`'s
> annotation suggests (instead of the more general help line).
>=20
> Link: https://github.com/rust-lang/rust/issues/104253 [1]
> Link: https://github.com/rust-lang/rust/pull/112529 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>

> ---
>  rust/kernel/sync/arc.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index 172f563976a9..4c14d540a581 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -299,7 +299,7 @@ fn drop(&mut self) {
>              // The count reached zero, we must free the memory.
>              //
>              // SAFETY: The pointer was initialised from the result of `B=
ox::leak`.
> -            unsafe { Box::from_raw(self.ptr.as_ptr()) };
> +            unsafe { drop(Box::from_raw(self.ptr.as_ptr())) };
>          }
>      }
>  }
> --
> 2.42.0
