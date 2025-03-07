Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2377620CCCD;
	Fri,  7 Mar 2025 22:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387991; cv=none; b=MtcPbUA7wnbMbYGoS8jkouyQ8aufcRo4wUJJNO+BStKqsdM1sC4EZqJnTbcjgPq8wau59o5lWA01mzgzQVxo3Ile4dXVvRY59aI83csYXqKWc7N6Q7Pb6E3yBhmN3c5wqCvjDZvWPwTSSdTvCiO7fOuwDv7QMU+fQ/wWTSXx0yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387991; c=relaxed/simple;
	bh=MatB0J1yPhNc7aboWBkW4yVvdNQQnAdOYZ7GRBfI6Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnleWuLGov25sfkozYqFnxI5qVb0okVJtYJk7FSmVpJM103wyHjluj07gyCa1VeTHUmUvtHQBrzfonm+otDYqex+/4dK7lLnLVXfXhSi0axAAOoJXFWo1oRmFFT5UhdsoQrEYBS/Ri3mY96sYF7Ff0j1cZkQuvyKus5b7Qmbu9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ik/eklap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ik/eklap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9D4C4CEE5;
	Fri,  7 Mar 2025 22:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387991;
	bh=MatB0J1yPhNc7aboWBkW4yVvdNQQnAdOYZ7GRBfI6Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ik/eklapsIRXzSCypROCogCUYGTCxztMSvDrvkNogqHuwuQga38egbLS++ZuoyldV
	 O1ZIkea+OM8A7GL4MzB9p7/3uEBsUxKFMZh8WBfO5ZSTgce3Kr2DX62Kod5Ob2J/hT
	 nmjBFL14JcTN1OpagnHdSsqcSvuBsWjTNTLVcoPwrDvHcSacHkLdDCnYjliRfGf7PB
	 LpQtybp7bShCPdbnbaJmEUapwmqcGtS0LLJj5fHMg3CC+hGb+LbvHkFmaXiwvVV1xt
	 WH1N7fHlnXNGQwXVH+cq/3uKJ1cs9+ODU/YMSOe6Wu+ngU+c9+gEbKV4MkUPgLJuq2
	 AUR4MGkRO3OvQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 57/60] rust: fix size_t in bindgen prototypes of C builtins
Date: Fri,  7 Mar 2025 23:50:04 +0100
Message-ID: <20250307225008.779961-58-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Guo <gary@garyguo.net>

commit 75c1fd41a671a0843b89d1526411a837a7163fa2 upstream.

Without `-fno-builtin`, for functions like memcpy/memmove (and many
others), bindgen seems to be using the clang-provided prototype. This
prototype is ABI-wise compatible, but the issue is that it does not have
the same information as the source code w.r.t. typedefs.

For example, bindgen generates the following:

    extern "C" {
        pub fn strlen(s: *const core::ffi::c_char) -> core::ffi::c_ulong;
    }

note that the return type is `c_ulong` (i.e. unsigned long), despite the
size_t-is-usize behavior (this is default, and we have not opted out
from it using --no-size_t-is-usize).

Similarly, memchr's size argument should be of type `__kernel_size_t`,
but bindgen generates `c_ulong` directly.

We want to ensure any `size_t` is translated to Rust `usize` so that we
can avoid having them be different type on 32-bit and 64-bit
architectures, and hence would require a lot of excessive type casts
when calling FFI functions.

I found that this bindgen behavior (which probably is caused by
libclang) can be disabled by `-fno-builtin`. Using the flag for compiled
code can result in less optimisation because compiler cannot assume
about their properties anymore, but this should not affect bindgen.

[ Trevor asked: "I wonder how reliable this behavior is. Maybe bindgen
  could do a better job controlling this, is there an open issue?".

  Gary replied: ..."apparently this is indeed the suggested approach in
  https://github.com/rust-lang/rust-bindgen/issues/1770". - Miguel ]

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240913213041.395655-2-gary@garyguo.net
[ Formatted comment. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 5e7612f69cea..a6e80caa42c1 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -264,7 +264,11 @@ else
 bindgen_c_flags_lto = $(bindgen_c_flags)
 endif
 
-bindgen_c_flags_final = $(bindgen_c_flags_lto) -D__BINDGEN__
+# `-fno-builtin` is passed to avoid `bindgen` from using `clang` builtin
+# prototypes for functions like `memcpy` -- if this flag is not passed,
+# `bindgen`-generated prototypes use `c_ulong` or `c_uint` depending on
+# architecture instead of generating `usize`.
+bindgen_c_flags_final = $(bindgen_c_flags_lto) -fno-builtin -D__BINDGEN__
 
 # Each `bindgen` release may upgrade the list of Rust target versions. By
 # default, the highest stable release in their list is used. Thus we need to set
-- 
2.48.1

