Received: from gimli.kloenk.dev (gimli.kloenk.dev [195.39.247.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F86820F8
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 09:50:55 +0000 (UTC)
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1668160252; bh=k/lbX2lCWCPhAd8PfCnpbmF965t2ayUlczN62ucvq74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E93lyMGGH+YBdWFgAEPVyeQz5gFoksKISCRhPIAqTcZlcE6vIrpThQFNU8bkWVQzo
	 lMklOWgoyPrf50+FShaUhBbUj+l9K2K4fusfc7Ae7G+LS/T0z3A27GE1znZvbyHFEQ
	 3r4y26RIJIec02R5f0BOGs8klEsCURiiqHwokgS8=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Adam Bratschi-Kaye <ark.email@gmail.com>,
 =?utf-8?b?TsOhbmRvciBJc3R2w6FuIEtyw6Fjc2Vy?= <bonifaido@gmail.com>
Subject: Re: [PATCH v1 10/28] rust: error: add `From` implementations for
 `Error`
Date: Fri, 11 Nov 2022 10:50:51 +0100
Message-ID: <0FFA9049-1F58-4C8C-9EAD-8ABD4B0489A2@kloenk.dev>
In-Reply-To: <20221110164152.26136-11-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-11-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10 Nov 2022, at 17:41, Miguel Ojeda wrote:

> From: Wedson Almeida Filho <wedsonaf@gmail.com>
>
> Add a set of `From` implementations for the `Error` kernel type.
>
> These implementations allow to easily convert from standard Rust
> error types to the usual kernel errors based on one of the `E*`
> integer codes.
>
> On top of that, the question mark Rust operator (`?`) implicitly
> performs a conversion on the error value using the `From` trait
> when propagating. Thus it is extra convenient to use.
>
> For instance, a kernel function that needs to convert a `i64` into
> a `i32` and to bubble up the error as a kernel error may write:
>
>     fn f(x: i64) -> Result<...> {
>         ...
>         let y =3D i32::try_from(x)?;
>         ...
>     }
>
> which will transform the `TryFromIntError` into an `Err(EINVAL)`.
>
> Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Co-developed-by: N=C3=A1ndor Istv=C3=A1n Kr=C3=A1cser <bonifaido@gmail.=
com>
> Signed-off-by: N=C3=A1ndor Istv=C3=A1n Kr=C3=A1cser <bonifaido@gmail.co=
m>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> [Reworded, adapted for upstream and applied latest changes]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Finn Behrens <me@kloenk.dev>

Regards,
Finn
> ---
>  rust/kernel/error.rs | 45 +++++++++++++++++++++++++++++++++++++++++++-=

>  rust/kernel/lib.rs   |  1 +
>  2 files changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
> index 861746f2422d..5b9751d7ff1d 100644
> --- a/rust/kernel/error.rs
> +++ b/rust/kernel/error.rs
> @@ -4,7 +4,14 @@
>  //!
>  //! C header: [`include/uapi/asm-generic/errno-base.h`](../../../inclu=
de/uapi/asm-generic/errno-base.h)
>
> -use alloc::collections::TryReserveError;
> +use alloc::{
> +    alloc::{AllocError, LayoutError},
> +    collections::TryReserveError,
> +};
> +
> +use core::convert::From;
> +use core::num::TryFromIntError;
> +use core::str::Utf8Error;
>
>  /// Contains the C-compatible error codes.
>  pub mod code {
> @@ -71,12 +78,48 @@ impl Error {
>      }
>  }
>
> +impl From<AllocError> for Error {
> +    fn from(_: AllocError) -> Error {
> +        code::ENOMEM
> +    }
> +}
> +
> +impl From<TryFromIntError> for Error {
> +    fn from(_: TryFromIntError) -> Error {
> +        code::EINVAL
> +    }
> +}
> +
> +impl From<Utf8Error> for Error {
> +    fn from(_: Utf8Error) -> Error {
> +        code::EINVAL
> +    }
> +}
> +
>  impl From<TryReserveError> for Error {
>      fn from(_: TryReserveError) -> Error {
>          code::ENOMEM
>      }
>  }
>
> +impl From<LayoutError> for Error {
> +    fn from(_: LayoutError) -> Error {
> +        code::ENOMEM
> +    }
> +}
> +
> +impl From<core::fmt::Error> for Error {
> +    fn from(_: core::fmt::Error) -> Error {
> +        code::EINVAL
> +    }
> +}
> +
> +impl From<core::convert::Infallible> for Error {
> +    fn from(e: core::convert::Infallible) -> Error {
> +        match e {}
> +    }
> +}
> +
>  /// A [`Result`] with an [`Error`] error type.
>  ///
>  /// To be used as the return type for functions that may fail.
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index abd46261d385..ffc6626a6d29 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -12,6 +12,7 @@
>  //! do so first instead of bypassing this crate.
>
>  #![no_std]
> +#![feature(allocator_api)]
>  #![feature(core_ffi_c)]
>
>  // Ensure conditional compilation based on the kernel configuration wo=
rks;
> -- =

> 2.38.1
