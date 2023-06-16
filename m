Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C1E1ACAC
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 17:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B502C433C8;
	Fri, 16 Jun 2023 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686935676;
	bh=qKxKYOgkzPTzgd9ZUdj6C8hJSgcy3ibMbk9V0xphn48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SRX4YA2O751yHoSKKaP/tmeRHCFXNCnveUNGDQGAtfcFeq+qei5GO6PYrS5wAmHB4
	 ywFWKPfSDb+rh2qnNqt3V189flJ3dqO8dGOMStMERjYbTrGIR9VFJmdrGy67+BJDUB
	 LS4BRWw44IhqkIW1GpIGzzDs5TTpfxfOyszjGG650YcUTTLoPlOjvLAuH9gjrEIsBL
	 zcZTp3pSdnWXM+eHDaQc9tERaOTp64/vLnNMVBe5f6ETASbeXCEr7Pze4TTAoa9bLR
	 N2o0kBe4KxpH6RfgdsABEIw3qgybaH3YCfXWbZcQiaSyJtl8bUnCg3VT0lQKXMXgNh
	 uIx1xDEF5M7Aw==
Date: Fri, 16 Jun 2023 10:14:34 -0700
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
	patches@lists.linux.dev
Subject: Re: [PATCH v2 08/11] kbuild: rust_is_available: normalize version
 matching
Message-ID: <20230616171434.GG3474164@dev-arch.thelio-3990X>
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-9-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616001631.463536-9-ojeda@kernel.org>

On Fri, Jun 16, 2023 at 02:16:28AM +0200, Miguel Ojeda wrote:
> In order to match the version string, `sed` is used in a couple
> cases, and `grep` and `head` in a couple others.
> 
> Make the script more consistent and easier to understand by
> using the same method, `sed`, for all of them.
> 
> This makes the version matching also a bit more strict for
> the changed cases, since the strings `rustc ` and `bindgen `
> will now be required, which should be fine since `rustc`
> complains if one attempts to call it with another program
> name, and `bindgen` uses a hardcoded string.
> 
> In addition, clarify why one of the existing `sed` commands
> does not provide an address like the others.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  scripts/rust_is_available.sh | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> index 810691af66eb..b7e0781fdea9 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -83,8 +83,7 @@ fi
>  # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
>  rust_compiler_version=$( \
>  	LC_ALL=C "$RUSTC" --version 2>/dev/null \
> -		| head -n 1 \
> -		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
> +		| sed -nE '1s:.*rustc ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
>  )
>  rust_compiler_min_version=$($min_tool_version rustc)
>  rust_compiler_cversion=$(get_canonical_version $rust_compiler_version)
> @@ -111,8 +110,7 @@ fi
>  # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
>  rust_bindings_generator_version=$( \
>  	LC_ALL=C "$BINDGEN" --version 2>/dev/null \
> -		| head -n 1 \
> -		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
> +		| sed -nE '1s:.*bindgen ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
>  )
>  rust_bindings_generator_min_version=$($min_tool_version bindgen)
>  rust_bindings_generator_cversion=$(get_canonical_version $rust_bindings_generator_version)
> @@ -155,6 +153,9 @@ fi
>  
>  # `bindgen` returned successfully, thus use the output to check that the version
>  # of the `libclang` found by the Rust bindings generator is suitable.
> +#
> +# Unlike other version checks, note that this one does not necessarily appear
> +# in the first line of the output, thus no `sed` address is provided.
>  bindgen_libclang_version=$( \
>  	echo "$bindgen_libclang_output" \
>  		| sed -nE 's:.*clang version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
> -- 
> 2.41.0
> 
