Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155AA366
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 05:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8100C43398
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 05:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673501353;
	bh=NIDeF0qr5dTfp6q3dFL1NSocIKxhkjUOWkIF2RxNI90=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tjfdD0GGQqh3mHroEoMk0jBfLGyj+vGhPLBwXwDJAlSgG+WtOMJtNd8X3Di012NpT
	 ywCQ0wUqyU6zBYOYkAOHHaxAfJt6SDWWPJN7UQnfY5nNDofJkbPTzx3+0RKSSH4XX4
	 me0NScf4zyV0+gwM4DpHNAmbsm2LeXV5awASpwQBHq1kSeGjiXmtqCcdlmfFfnu5r5
	 5bfJOPQukomdQEW09Ocb1VB+r44MZn0BBHOuU25c5RujHL0L9V+/TuF4jTY6zPwqw+
	 4aMvOIdAfn2pil+zbhzeSOl77lJ+97mpiYTo1o+JJbOwAKfm2GI6cGVtn7cN+qLQOe
	 LZ//3R+TzK3aQ==
Received: by mail-ot1-f44.google.com with SMTP id x25-20020a056830115900b00670932eff32so10034369otq.3
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 21:29:13 -0800 (PST)
X-Gm-Message-State: AFqh2kohAz2lE3fmKcObpI1nlfm/QR12bm6Tn2HcFnzBbfD+s4ZE4zIt
	BpQOUDBRnMLiCwKfMyrSYR/VzPX0STKg8KnVWP0=
X-Google-Smtp-Source: AMrXdXsSeAn3HBMEAO9E44OB06sCAHFENTcpFHnvluvknjPtirsq0UJHX5LWEAK1YxtFebGeDPkwoJzd5O8XrB4oENw=
X-Received: by 2002:a05:6830:31a8:b0:684:c0c2:59c6 with SMTP id
 q8-20020a05683031a800b00684c0c259c6mr124477ots.343.1673501352782; Wed, 11 Jan
 2023 21:29:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-4-ojeda@kernel.org>
In-Reply-To: <20230109204520.539080-4-ojeda@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 12 Jan 2023 14:28:36 +0900
X-Gmail-Original-Message-ID: <CAK7LNARuGz=oFukWH4g=7zg1EbWP9rxpVXPgPrJBKHzLQW4N1Q@mail.gmail.com>
Message-ID: <CAK7LNARuGz=oFukWH4g=7zg1EbWP9rxpVXPgPrJBKHzLQW4N1Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] kbuild: rust_is_available: check if the script was
 invoked from Kbuild
To: Miguel Ojeda <ojeda@kernel.org>
Cc: linux-kbuild@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 10, 2023 at 5:46 AM Miguel Ojeda <ojeda@kernel.org> wrote:
>
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
> Therefore, instead, print a warning when the script detects
> the user may be invoking it, by testing `$MAKEFLAGS`.
>
> Link: https://lore.kernel.org/oe-kbuild-all/Y6r4mXz5NS0+HVXo@zn.tnic/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/rust_is_available.sh | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> index cd87729ca3bf..0c082a248f15 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -35,6 +35,16 @@ print_docs_reference()
>  warning=0
>  trap 'if [ $? -ne 0 ] || [ $warning -ne 0 ]; then print_docs_reference; fi' EXIT
>
> +# Check whether the script was invoked from Kbuild.
> +if [ -z "${MAKEFLAGS+x}" ]; then
> +       echo >&2 "***"
> +       echo >&2 "*** This script is intended to be called from Kbuild."
> +       echo >&2 "*** Please use the 'rustavailable' target to call it instead."
> +       echo >&2 "*** Otherwise, the results may not be meaningful."
> +       echo >&2 "***"
> +       warning=1
> +fi


I do not like this.
We do not need to cater to every oddity.

Checking MAKEFLAGS is too much.

You can check RUSTC/BINDGEN/CC if you persist in this.




diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index a6f84dd2f71c..524aee03384a 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -34,7 +34,7 @@ warning=0
 trap 'if [ $? -ne 0 ] || [ $warning -ne 0 ]; then
print_docs_reference; fi' EXIT

 # Check that the Rust compiler exists.
-if ! command -v "$RUSTC" >/dev/null; then
+if ! command -v "${RUSTC:?RUSTC is not set}" >/dev/null; then
        echo >&2 "***"
        echo >&2 "*** Rust compiler '$RUSTC' could not be found."
        echo >&2 "***"
@@ -42,7 +42,7 @@ if ! command -v "$RUSTC" >/dev/null; then
 fi

 # Check that the Rust bindings generator exists.
-if ! command -v "$BINDGEN" >/dev/null; then
+if ! command -v "${BINDGEN:?BINDGEN is not set}" >/dev/null; then
        echo >&2 "***"
        echo >&2 "*** Rust bindings generator '$BINDGEN' could not be found."
        echo >&2 "***"
@@ -150,7 +150,7 @@ fi
 #
 # In the future, we might be able to perform a full version check, see
 # https://github.com/rust-lang/rust-bindgen/issues/2138.
-cc_name=$($(dirname $0)/cc-version.sh "$CC" | cut -f1 -d' ')
+cc_name=$($(dirname $0)/cc-version.sh ${CC:?CC is not set} | cut -f1 -d' ')
 if [ "$cc_name" = Clang ]; then
        clang_version=$( \
                LC_ALL=C "$CC" --version 2>/dev/null \








-- 
Best Regards
Masahiro Yamada
