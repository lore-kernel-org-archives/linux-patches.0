Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4EE1AE87B
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720103449; cv=none; b=VQ+CVrnKhFJmyiaWGpPaMFYSe1yRba24KDy1452H+XP+hqlbA3AwAzpi/Wdrr/5U1idFRk6meY8cYK83Pk8fq53Z0Y5Z/+LmzHqHGupwTc38xRMDfA5qnSu8ImzYqyH3jXycPG5TkT9JL50OExOMcCaM+EyL1VNj8jdiT3gngC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720103449; c=relaxed/simple;
	bh=/YfCTdnQGm2e8OteT+w3ZReS3qKp7v0iVq6bSYgaw8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BAMd+Nk6W7BFe/F8zAtUgnGZwJEey6EhObs3Mm3YAoFPDurpQbUYB6eR9vJucEwDGqxpgPYm/Lp1UtuAxBF3ko24f+6GQPKeJvxs30KK9YxELzFVSoNww6aec4fg0Fy8Te55gwIcoaptG18xGYBTWnkfN83wOnQ62X6j6GXAEVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=RESvNLgk; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="RESvNLgk"
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1720103444; bh=K5wwMCMBuM9kqaDI2K/jUVHFm330IHcLZCFjZvDmBOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RESvNLgkzNEYWo0uOI7+z0PK3dxr+TJM5aPbh52iMnWb3y9EWWePhSC67u0MN5iDV
	 o7hkNVkdGYfaL6guLXM8S6j0FW4ijvF2NV8afoS9VsuOA2PKMAWMWIkSjDUsB4nYEB
	 ncFgKDYVdfYz8jAViMHzeu9zMcb7PRQ7GMDCg7UE=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 03/13] rust: allow `dead_code` for never constructed
 bindings
Date: Thu, 04 Jul 2024 16:30:43 +0200
Message-ID: <B8FF33D5-07E4-433A-AB35-EAE83265595B@kloenk.dev>
In-Reply-To: <20240701183625.665574-4-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain



On 1 Jul 2024, at 20:36, Miguel Ojeda wrote:

> Starting with the upcoming Rust 1.80.0 (since upstream commit 35130d7233e9
> ("Detect pub structs never constructed and unused associated constants
> in traits")), the `dead_code` pass detects more cases, which triggers
> in the `bindings` crate:
>
>     warning: struct `boot_params` is never constructed
>         --> rust/bindings/bindings_generated.rs:10684:12
>         |
>     10684 | pub struct boot_params {
>         |            ^^^^^^^^^^^
>         |
>         = note: `#[warn(dead_code)]` on by default
>
> As well as in the `uapi` one:
>
>     warning: struct `boot_params` is never constructed
>         --> rust/uapi/uapi_generated.rs:10392:12
>         |
>     10392 | pub struct boot_params {
>         |            ^^^^^^^^^^^
>         |
>         = note: `#[warn(dead_code)]` on by default
>
> These are all expected, since we do not use all the structs in the
> bindings that `bindgen` generates from the C headers.
>
> Therefore, allow them.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Finn Behrens <me@kloenk.dev>

> ---
>  rust/bindings/lib.rs | 1 +
>  rust/uapi/lib.rs     | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/rust/bindings/lib.rs b/rust/bindings/lib.rs
> index 40ddaee50d8b..93a1a3fc97bc 100644
> --- a/rust/bindings/lib.rs
> +++ b/rust/bindings/lib.rs
> @@ -24,6 +24,7 @@
>      unsafe_op_in_unsafe_fn
>  )]
>
> +#[allow(dead_code)]
>  mod bindings_raw {
>      // Use glob import here to expose all helpers.
>      // Symbols defined within the module will take precedence to the glob import.
> diff --git a/rust/uapi/lib.rs b/rust/uapi/lib.rs
> index 0caad902ba40..80a00260e3e7 100644
> --- a/rust/uapi/lib.rs
> +++ b/rust/uapi/lib.rs
> @@ -14,6 +14,7 @@
>  #![cfg_attr(test, allow(unsafe_op_in_unsafe_fn))]
>  #![allow(
>      clippy::all,
> +    dead_code,
>      missing_docs,
>      non_camel_case_types,
>      non_upper_case_globals,
> -- 
> 2.45.2
