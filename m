Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7401218C07
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 17:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC2AC433C8;
	Fri, 16 Jun 2023 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686935521;
	bh=L5y6zXF08tEbBhI51U9tyt9pakLlguN2cCvEZbd7tFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fvlJYYh9UqgtrtbfwEHUD6d5Cxn22isE9KJvEunCabqSPiC0DwxlpKh62jWvavSjV
	 I2tvLb87GVwCfNDmbHdssss04W5FcmlKkru/Uicf4Hi8e4T3sRO8uQBYLb6ZDb1Z1f
	 G+5EQcBxalrp4c6jNaavq//anhGDXesOZM1qAcidDomfBmNPPNRUMTwcX19Iv+vYXW
	 0F0hC2uhm0vMxWcP2YiVGuHr3KuUGfqoRT64oPXlcd5GSk5F1wEze/Ui2KIQeiVut8
	 IS+83Ev7P0h2wJc2e5hhqitfyge2zKiqBUkAR1s586XRPtpgIcLD1skUhnnKLxUq/o
	 2Rh3ix9zoIv5A==
Date: Fri, 16 Jun 2023 10:11:59 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>, linux-kbuild@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	=?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>,
	Alexandru Radovici <msg4alex@gmail.com>,
	Matthew Leach <dev@mattleach.net>
Subject: Re: [PATCH v2 05/11] kbuild: rust_is_available: add check for
 `bindgen` invocation
Message-ID: <20230616171159.GD3474164@dev-arch.thelio-3990X>
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-6-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616001631.463536-6-ojeda@kernel.org>

On Fri, Jun 16, 2023 at 02:16:25AM +0200, Miguel Ojeda wrote:
> `scripts/rust_is_available.sh` calls `bindgen` with a special
> header in order to check whether the `libclang` version in use
> is suitable.
> 
> However, the invocation itself may fail if, for instance, `bindgen`
> cannot locate `libclang`. This is fine for Kconfig (since the
> script will still fail and therefore disable Rust as it should),
> but it is pretty confusing for users of the `rustavailable` target
> given the error will be unrelated:
> 
>     ./scripts/rust_is_available.sh: 21: arithmetic expression: expecting primary: "100000 *  + 100 *  + "
>     make: *** [Makefile:1816: rustavailable] Error 2
> 
> Instead, run the `bindgen` invocation independently in a previous
> step, saving its output and return code. If it fails, then show
> the user a proper error message. Otherwise, continue as usual
> with the saved output.
> 
> Since the previous patch we show a reference to the docs, and
> the docs now explain how `bindgen` looks for `libclang`,
> thus the error message can leverage the documentation, avoiding
> duplication here (and making users aware of the setup guide in
> the documentation).
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://lore.kernel.org/rust-for-linux/CAKwvOdm5JT4wbdQQYuW+RT07rCi6whGBM2iUAyg8A1CmLXG6Nw@mail.gmail.com/
> Reported-by: François Valenduc <francoisvalenduc@gmail.com>
> Closes: https://github.com/Rust-for-Linux/linux/issues/934
> Reported-by: Alexandru Radovici <msg4alex@gmail.com>
> Closes: https://github.com/Rust-for-Linux/linux/pull/921
> Reported-by: Matthew Leach <dev@mattleach.net>
> Closes: https://lore.kernel.org/rust-for-linux/20230507084116.1099067-1-dev@mattleach.net/
> Fixes: 78521f3399ab ("scripts: add `rust_is_available.sh`")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  scripts/rust_is_available.sh | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> index 6b8131d5b547..1bdff4472cbe 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -106,8 +106,28 @@ if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cvers
>  fi
>  
>  # Check that the `libclang` used by the Rust bindings generator is suitable.
> +#
> +# In order to do that, first invoke `bindgen` to get the `libclang` version
> +# found by `bindgen`. This step may already fail if, for instance, `libclang`
> +# is not found, thus inform the user in such a case.
> +bindgen_libclang_output=$( \
> +	LC_ALL=C "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null
> +) || bindgen_libclang_code=$?
> +if [ -n "$bindgen_libclang_code" ]; then
> +	echo >&2 "***"
> +	echo >&2 "*** Running '$BINDGEN' to check the libclang version (used by the Rust"
> +	echo >&2 "*** bindings generator) failed with code $bindgen_libclang_code. This may be caused by"
> +	echo >&2 "*** a failure to locate libclang. See output and docs below for details:"
> +	echo >&2 "***"
> +	echo >&2 "$bindgen_libclang_output"
> +	echo >&2 "***"
> +	exit 1
> +fi
> +
> +# `bindgen` returned successfully, thus use the output to check that the version
> +# of the `libclang` found by the Rust bindings generator is suitable.
>  bindgen_libclang_version=$( \
> -	LC_ALL=C "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null \
> +	echo "$bindgen_libclang_output" \
>  		| grep -F 'clang version ' \
>  		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
>  		| head -n 1 \
> -- 
> 2.41.0
> 
