Received: from mail-4324.protonmail.ch (mail-4324.protonmail.ch [185.70.43.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5267D5668
	for <patches@lists.linux.dev>; Sat, 24 Jun 2023 15:03:29 +0000 (UTC)
Date: Sat, 24 Jun 2023 15:03:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1687619006; x=1687878206;
	bh=0g0U1QkNwFfGzmOITXba0UjVRvJchVE09IDi9mDLtQY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=dFcm1Hd26UpL8ML+j5iaiTYos7PMncEz/Y8oGpa25NznikBKTmDI0UohPYgjID3Zr
	 APVxk2XgdUTtTZpIPW1YUdibSeQaGoHIfytI+nazFHUh24n2je119aYX5lPqm0CdYq
	 72WQoZzqnIKcn0FZdehWB34YXnlg5z0p1vcBRz5Mz3tklzq6RqCdeYMlQ++03M2SCv
	 JF40SiJXEuzT32P7GQlIN+2wqYQFlrZq8il8p2p8oo7kuvMw7GM9iY5pMhZx0yjErK
	 pMX3KY3nQaP6pya+G5ID1NGHD5h5GdrDmHiUiWDLpd+aZubwSgTMXHqrx7qbrPUP+T
	 qPAT/1qkzqtHw==
To: Benno Lossin <benno.lossin@proton.me>
From: =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 4/7] rust: init: wrap type checking struct initializers in a closure
Message-ID: <zLJ2TSszsTrjSQ39Y8JsZLnZQ2qe8JLp_dK7vSArkClDKOzaCzO94OXwYdco6FLBNTr-MeRp0c75a-aKm_8wKlb9aPgfvf9nz2Ha5XbrutE=@protonmail.com>
In-Reply-To: <20230624092330.157338-4-benno.lossin@proton.me>
References: <20230624092330.157338-1-benno.lossin@proton.me> <20230624092330.157338-4-benno.lossin@proton.me>
Feedback-ID: 27884398:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Saturday, June 24th, 2023 at 11:25, Benno Lossin <benno.lossin@proton.me=
> wrote:

> In the implementation of the init macros there is a `if false` statement
> that type checks the initializer to ensure every field is initialized.
> Since the next patch has a stack variable to store the struct, the
> function might allocate too much memory on debug builds. Putting the
> struct into a closure ensures that even in debug builds no stack
> overflow error is caused. In release builds this was not a problem since
> the code was optimized away due to the `if false`.
>=20
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>
> ---
>  rust/kernel/init/macros.rs | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
> index df4281743175..1e0c4aca055a 100644
> --- a/rust/kernel/init/macros.rs
> +++ b/rust/kernel/init/macros.rs
> @@ -1037,14 +1037,18 @@ macro_rules! __init_internal {
>                      // We use unreachable code to ensure that all fields=
 have been mentioned exactly
>                      // once, this struct initializer will still be type-=
checked and complain with a
>                      // very natural error message if a field is forgotte=
n/mentioned more than once.
> -                    #[allow(unreachable_code, clippy::diverging_sub_expr=
ession)]
> +                    #[allow(unreachable_code,
> +                            clippy::diverging_sub_expression,
> +                            clippy::redundant_closure_call)]
>                      if false {
> -                        $crate::__init_internal!(make_initializer:
> -                            @slot(slot),
> -                            @type_name($t),
> -                            @munch_fields($($fields)*,),
> -                            @acc(),
> -                        );
> +                        (|| {
> +                            $crate::__init_internal!(make_initializer:
> +                                @slot(slot),
> +                                @type_name($t),
> +                                @munch_fields($($fields)*,),
> +                                @acc(),
> +                            );
> +                        })();

Is it necessary to call this closure? Typechecking of the closure should ha=
ppen even without calling it.

>                      }
>                  }
>                  Ok(__InitOk)
> --
> 2.41.0

Cheers,
Bj=C3=B6rn
