Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308A91ACAC
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 17:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2034EC433C0;
	Fri, 16 Jun 2023 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686935594;
	bh=CG0pIcow6H0crZQ3zE03Q7kny6rgdaTUlNK0ehlZr+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A5y/6F1WLHflgWpO/RYKbZZlKuxyJvRu6f55iCUWWhyIcyfp0jYkBnnB+SijlwJ6y
	 R5fyU3JVx4E1QHwnbHSAoO9eJ24Pt5pyDC2pi1oRPK2+j7i4jHSEzFzNL4if8EqqTa
	 gkmgmEaZ93hiPEjRA60cTrCpaS5GbE8JG8U5r8GcVzSb/ljh/NGkXW/dKaKpV5+HIG
	 bsNjKIJT8Ybk0+Nf/Xe1Kl9uvDNnepKgxVvs1qmoo5sDyh3BmryroJoUBa/shXnoNo
	 hPR2xeQqY/hxtVM8uaAPD4SMO+3JwBf5cqLVaItxieDYUXGsz2rW16Xro1/gUTLB3T
	 gIc+tkhn96n5w==
Date: Fri, 16 Jun 2023 10:13:11 -0700
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
Subject: Re: [PATCH v2 06/11] kbuild: rust_is_available: check that
 environment variables are set
Message-ID: <20230616171311.GE3474164@dev-arch.thelio-3990X>
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-7-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616001631.463536-7-ojeda@kernel.org>

On Fri, Jun 16, 2023 at 02:16:26AM +0200, Miguel Ojeda wrote:
> Sometimes [1] users may attempt to setup the Rust support by
> checking what Kbuild does and they end up finding out about
> `scripts/rust_is_available.sh`. Inevitably, they run the script
> directly, but unless they setup the required variables,
> the result of the script is not meaningful.
> 
> We could add some defaults to the variables, but that could be
> confusing for those that may override the defaults (compared
> to their kernel builds), and `$CC` would not be a simple default
> in any case.
> 
> Therefore, instead, explicitly check whether the expected variables
> are set (`$RUSTC`, `$BINDGEN` and `$CC`). If not, print an explanation
> about the fact that the script is meant to be called from Kbuild,
> since that is the most likely cause for the variables not being set.
> 
> Link: https://lore.kernel.org/oe-kbuild-all/Y6r4mXz5NS0+HVXo@zn.tnic/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  scripts/rust_is_available.sh | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> index 1bdff4472cbe..7e0368babe64 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -28,11 +28,40 @@ print_docs_reference()
>  	echo >&2 "***"
>  }
>  
> +# Print an explanation about the fact that the script is meant to be called from Kbuild.
> +print_kbuild_explanation()
> +{
> +	echo >&2 "***"
> +	echo >&2 "*** This script is intended to be called from Kbuild."
> +	echo >&2 "*** Please use the 'rustavailable' target to call it instead."
> +	echo >&2 "*** Otherwise, the results may not be meaningful."
> +	exit 1
> +}
> +
>  # If the script fails for any reason, or if there was any warning, then
>  # print a reference to the documentation on exit.
>  warning=0
>  trap 'if [ $? -ne 0 ] || [ $warning -ne 0 ]; then print_docs_reference; fi' EXIT
>  
> +# Check that the expected environment variables are set.
> +if [ -z "${RUSTC+x}" ]; then
> +	echo >&2 "***"
> +	echo >&2 "*** Environment variable 'RUSTC' is not set."
> +	print_kbuild_explanation
> +fi
> +
> +if [ -z "${BINDGEN+x}" ]; then
> +	echo >&2 "***"
> +	echo >&2 "*** Environment variable 'BINDGEN' is not set."
> +	print_kbuild_explanation
> +fi
> +
> +if [ -z "${CC+x}" ]; then
> +	echo >&2 "***"
> +	echo >&2 "*** Environment variable 'CC' is not set."
> +	print_kbuild_explanation
> +fi
> +
>  # Check that the Rust compiler exists.
>  if ! command -v "$RUSTC" >/dev/null; then
>  	echo >&2 "***"
> -- 
> 2.41.0
> 
