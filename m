Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8951B1424
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720104463; cv=none; b=J3spJNc3SOpzmQtHeQEhyuGTtXo5/iQsh07OI4aYZDc9KNy9Akz24Liz0OQgDkd8ensNHNWq4o1zBDcDPGjeDciCVWDu9EpEv5nv3PJ29plxba4vXsxhksyx/EAMGLSIZGlIzCKlUhAW23eQvLSyk0CBiI7LMzCeBvWHfIimDnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720104463; c=relaxed/simple;
	bh=/x8J24Gd7MAb2ei7OJV0iflNkUAoN6f9qXBif0ICwgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1JOVEt6EiTGwue63R11m6Z5hKf4dpvxUoeFaGsWIHbo5K4lKCTO+LDjb4ICdjqkTVksL4zZGIdKwiO4jv1DT6Nc4V9ouU991wSzWCfdEwve2ctJ6HgVy++QpxI2MGOBIa9Owvr/cJQlDmEyRfI/hCz5h+AdR2g65MBbrWQQ7Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=nwu2Twgx; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="nwu2Twgx"
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1720104458; bh=Rkh9Gxrbd+RcHt6HdDYebnkryyNZqEZzX12Z6Dir7BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwu2Twgxxr13nOBVdrqqZ86A8fiU1W3t8C49bdSUsb7GjkIMsPyE8ruf/Gm+MCRKv
	 /3eSC47VSuz3T/FUSMGQ54hcLwiz21mEauOcmiaRSA0uEqMQ1tSSfuDBMmd1dBTqaI
	 OHO7XcRQ2+KC28gaRgwHTXPq3NH1gF4J/21a3w+o=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 07/13] rust: warn about `bindgen` versions 0.66.0 and
 0.66.1
Date: Thu, 04 Jul 2024 16:47:37 +0200
Message-ID: <68C4DE68-D996-43FA-BC16-06F13557E494@kloenk.dev>
In-Reply-To: <20240701183625.665574-8-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-8-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



On 1 Jul 2024, at 20:36, Miguel Ojeda wrote:

> `bindgen` versions 0.66.0 and 0.66.1 panic due to C string literals wit=
h
> NUL characters [1]:
>
>     panicked at .cargo/registry/src/index.crates.io-6f17d22bba15001f/bi=
ndgen-0.66.0/codegen/mod.rs:717:71:
>     called `Result::unwrap()` on an `Err` value: FromBytesWithNulError =
{ kind: InteriorNul(4) }
>
> Thus, in preparation for supporting several `bindgen` versions, add a
> version check to warn the user about it.
>
> We could make it an error, but 1) it is going to fail anyway later in t=
he
> build, 2) we would disable `RUST` automatically, which is also painful,=

> 3) someone could be using a patched `bindgen` at that version, 4) the
> interior NUL may go away in the headers (however unlikely). Thus just
> warn about it so that users know why it is failing.
>
> In addition, add a test for the new case.
>
> Link: https://github.com/rust-lang/rust-bindgen/pull/2567 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Finn Behrens <me@kloenk.dev>

> ---
>  scripts/rust_is_available.sh      | 8 ++++++++
>  scripts/rust_is_available_test.py | 7 +++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.s=
h
> index 67cb900124cc..33bbd01ffe51 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -165,6 +165,14 @@ if [ "$rust_bindings_generator_cversion" -gt "$rus=
t_bindings_generator_min_cvers
>  	echo >&2 "***"
>  	warning=3D1
>  fi
> +if [ "$rust_bindings_generator_cversion" -eq 6600 ] || [ "$rust_bindin=
gs_generator_cversion" -eq 6601 ]; then
> +	echo >&2 "***"
> +	echo >&2 "*** Rust bindings generator '$BINDGEN' versions 0.66.0 and =
0.66.1 may not"
> +	echo >&2 "*** work due to a bug (https://github.com/rust-lang/rust-bi=
ndgen/pull/2567)."
> +	echo >&2 "***   Your version:     $rust_bindings_generator_version"
> +	echo >&2 "***"
> +	warning=3D1
> +fi
>
>  # Check that the `libclang` used by the Rust bindings generator is sui=
table.
>  #
> diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_availa=
ble_test.py
> index a255f79aafc2..2b887098c19d 100755
> --- a/scripts/rust_is_available_test.py
> +++ b/scripts/rust_is_available_test.py
> @@ -226,6 +226,13 @@ else:
>          result =3D self.run_script(self.Expected.SUCCESS_WITH_WARNINGS=
, { "BINDGEN": bindgen })
>          self.assertIn(f"Rust bindings generator '{bindgen}' is too new=
=2E This may or may not work.", result.stderr)
>
> +    def test_bindgen_bad_version_0_66_0_and_0_66_1(self):
> +        for version in ("0.66.0", "0.66.1"):
> +            with self.subTest(version=3Dversion):
> +                bindgen =3D self.generate_bindgen_version(f"bindgen {v=
ersion}")
> +                result =3D self.run_script(self.Expected.SUCCESS_WITH_=
WARNINGS, { "BINDGEN": bindgen })
> +                self.assertIn(f"Rust bindings generator '{bindgen}' ve=
rsions 0.66.0 and 0.66.1 may not", result.stderr)
> +
>      def test_bindgen_libclang_failure(self):
>          for env in (
>              { "LLVM_CONFIG_PATH": self.missing },
> -- =

> 2.45.2
