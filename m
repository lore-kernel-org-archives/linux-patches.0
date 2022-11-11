Received: from gimli.kloenk.dev (gimli.kloenk.dev [195.39.247.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC8F81A
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 09:33:31 +0000 (UTC)
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1668158747; bh=IfxMhTyWpAJMoziSkCSvw30s8AApUw/YyM4ljR9ufhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pF/x7DY3tm82372JfEhfnwx+eXGThYB2AaKt9v/iuoHU1uSA7repQr+McvUbHOYjr
	 EfjHJhUyZV+X65t1ZVqhlsmx9dV9IBZcnhkWgkT8/VSr6YZ+SOVlGMw1ksLFb2rxbX
	 2nQNc17pLSu8Uep/KsPClt1Cxc/KxHmJC0e+oOGo=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v1 05/28] rust: macros: add `concat_idents!` proc macro
Date: Fri, 11 Nov 2022 10:25:45 +0100
Message-ID: <D530D97C-9155-47D0-8F50-923583E6AD29@kloenk.dev>
In-Reply-To: <20221110164152.26136-6-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-6-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10 Nov 2022, at 17:41, Miguel Ojeda wrote:

> From: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>
>
> This macro provides similar functionality to the unstable feature
> `concat_idents` without having to rely on it.
>
> For instance:
>
>     let x_1 =3D 42;
>     let x_2 =3D concat_idents!(x, _1);
>     assert!(x_1 =3D=3D x_2);
>
> It has different behavior with respect to macro hygiene. Unlike
> the unstable `concat_idents!` macro, it allows, for example,
> referring to local variables by taking the span of the second
> macro as span for the output identifier.
>
> Signed-off-by: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>
> [Reworded, adapted for upstream and applied latest changes]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Finn Behrens <me@kloenk.dev>

Regards,
Finn

> ---
>  rust/macros/concat_idents.rs | 23 +++++++++++++++++++
>  rust/macros/lib.rs           | 44 ++++++++++++++++++++++++++++++++++++=

>  2 files changed, 67 insertions(+)
>  create mode 100644 rust/macros/concat_idents.rs
>
> diff --git a/rust/macros/concat_idents.rs b/rust/macros/concat_idents.r=
s
> new file mode 100644
> index 000000000000..3b5a9dd70e8a
> --- /dev/null
> +++ b/rust/macros/concat_idents.rs
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +use proc_macro::{token_stream, Ident, TokenStream, TokenTree};
> +
> +use crate::helpers::expect_punct;
> +
> +fn expect_ident(it: &mut token_stream::IntoIter) -> Ident {
> +    if let Some(TokenTree::Ident(ident)) =3D it.next() {
> +        ident
> +    } else {
> +        panic!("Expected Ident")
> +    }
> +}
> +
> +pub(crate) fn concat_idents(ts: TokenStream) -> TokenStream {
> +    let mut it =3D ts.into_iter();
> +    let a =3D expect_ident(&mut it);
> +    assert_eq!(expect_punct(&mut it), ',');
> +    let b =3D expect_ident(&mut it);
> +    assert!(it.next().is_none(), "only two idents can be concatenated"=
);
> +    let res =3D Ident::new(&(a.to_string() + &b.to_string()), b.span()=
);
> +    TokenStream::from_iter([TokenTree::Ident(res)])
> +}
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index 91764bfb1f89..15555e7ff487 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -2,6 +2,7 @@
>
>  //! Crate for all kernel procedural macros.
>
> +mod concat_idents;
>  mod helpers;
>  mod module;
>
> @@ -70,3 +71,46 @@ use proc_macro::TokenStream;
>  pub fn module(ts: TokenStream) -> TokenStream {
>      module::module(ts)
>  }
> +
> +/// Concatenate two identifiers.
> +///
> +/// This is useful in macros that need to declare or reference items w=
ith names
> +/// starting with a fixed prefix and ending in a user specified name. =
The resulting
> +/// identifier has the span of the second argument.
> +///
> +/// # Examples
> +///
> +/// ```ignore
> +/// use kernel::macro::concat_idents;
> +///
> +/// macro_rules! pub_no_prefix {
> +///     ($prefix:ident, $($newname:ident),+) =3D> {
> +///         $(pub(crate) const $newname: u32 =3D kernel::macros::conca=
t_idents!($prefix, $newname);)+
> +///     };
> +/// }
> +///
> +/// pub_no_prefix!(
> +///     binder_driver_return_protocol_,
> +///     BR_OK,
> +///     BR_ERROR,
> +///     BR_TRANSACTION,
> +///     BR_REPLY,
> +///     BR_DEAD_REPLY,
> +///     BR_TRANSACTION_COMPLETE,
> +///     BR_INCREFS,
> +///     BR_ACQUIRE,
> +///     BR_RELEASE,
> +///     BR_DECREFS,
> +///     BR_NOOP,
> +///     BR_SPAWN_LOOPER,
> +///     BR_DEAD_BINDER,
> +///     BR_CLEAR_DEATH_NOTIFICATION_DONE,
> +///     BR_FAILED_REPLY
> +/// );
> +///
> +/// assert_eq!(BR_OK, binder_driver_return_protocol_BR_OK);
> +/// ```
> +#[proc_macro]
> +pub fn concat_idents(ts: TokenStream) -> TokenStream {
> +    concat_idents::concat_idents(ts)
> +}
> -- =

> 2.38.1
