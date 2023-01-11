Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B38A20FF
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 10:43:28 +0000 (UTC)
Date: Wed, 11 Jan 2023 10:43:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1673433792; x=1673692992;
	bh=o+PuleZmpSn/N3Ya5Al4hVV23Ksr3vGfrc/S9YnGjqM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=rdLIvJkY+rMENix8x8WopjFmdXzTQ5vCVHoH3dDUBLFK96mD7Ty4jdRufyx0q0/He
	 cCvxoWiL0m5FdLjlR8yCbOKEmpbAMGf4ysZ46Ipj9QRV3uCVckY7qqt56Rl+F/8z89
	 1hjAbeYBtW6fUQN3sc84pEYWZjfoLseK5XGQJWLPOkCQG8msOnoONcyRN7wHU6l/dh
	 VTsM8eKpBVeTgksuBu8tYR5joEiRevu+7bv/77P1vcwCKo6mBmxRxpm43CMwXsZNqt
	 ImU+RWrm2ssilOfSlSy0LISsoj1/B1TLlmjZlBqMztP6zMwdNSVMNrowYdMQj63CBN
	 fneoTVYIh4NJw==
To: Miguel Ojeda <ojeda@kernel.org>
From: =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
Subject: Re: [PATCH] rust: print: avoid evaluating arguments in `pr_*` macros in `unsafe` blocks
Message-ID: <F8m0QCk5z20aveREvWRtVenzcjNhG_bjk3TBRaQIFTEF2eLz9Y-d-H0QxOMQAaBCeZmjACtRHGrnRjUv8pRRqr24FkOZh1y4oMYRXYlxdAQ=@protonmail.com>
In-Reply-To: <20230109204912.539790-1-ojeda@kernel.org>
References: <20230109204912.539790-1-ojeda@kernel.org>
Feedback-ID: 27884398:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, January 9th, 2023 at 21:49, Miguel Ojeda <ojeda@kernel.org> wrot=
e:

> At the moment it is possible to perform unsafe operations in
> the arguments of `pr_*` macros since they are evaluated inside
> an `unsafe` block:
>
>     let x =3D &10u32 as *const u32;
>     pr_info!("{}", *x);
>
> In other words, this is a soundness issue.
>
> Fix it so that it requires an explicit `unsafe` block.
>
> Reported-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Reported-by: Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
> Link: https://github.com/Rust-for-Linux/linux/issues/479
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>

> ---
>  rust/kernel/print.rs | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
> index 29bf9c2e8aee..30103325696d 100644
> --- a/rust/kernel/print.rs
> +++ b/rust/kernel/print.rs
> @@ -142,17 +142,24 @@ pub fn call_printk_cont(args: fmt::Arguments<'_>) {
>  macro_rules! print_macro (
>      // The non-continuation cases (most of them, e.g. `INFO`).
>      ($format_string:path, false, $($arg:tt)+) =3D> (
> -        // SAFETY: This hidden macro should only be called by the docume=
nted
> -        // printing macros which ensure the format string is one of the =
fixed
> -        // ones. All `__LOG_PREFIX`s are null-terminated as they are gen=
erated
> -        // by the `module!` proc macro or fixed values defined in a kern=
el
> -        // crate.
> -        unsafe {
> -            $crate::print::call_printk(
> -                &$format_string,
> -                crate::__LOG_PREFIX,
> -                format_args!($($arg)+),
> -            );
> +        // To remain sound, `arg`s must be expanded outside the `unsafe`=
 block.
> +        // Typically one would use a `let` binding for that; however, `f=
ormat_args!`
> +        // takes borrows on the arguments, but does not extend the scope=
 of temporaries.
> +        // Therefore, a `match` expression is used to keep them around, =
since
> +        // the scrutinee is kept until the end of the `match`.
> +        match format_args!($($arg)+) {
> +            // SAFETY: This hidden macro should only be called by the do=
cumented
> +            // printing macros which ensure the format string is one of =
the fixed
> +            // ones. All `__LOG_PREFIX`s are null-terminated as they are=
 generated
> +            // by the `module!` proc macro or fixed values defined in a =
kernel
> +            // crate.
> +            args =3D> unsafe {
> +                $crate::print::call_printk(
> +                    &$format_string,
> +                    crate::__LOG_PREFIX,
> +                    args,
> +                );
> +            }
>          }
>      );
>
>
> base-commit: b7bfaa761d760e72a969d116517eaa12e404c262
> --
> 2.39.0
