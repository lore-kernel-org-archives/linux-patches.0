Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF6016F858;
	Mon,  1 Jul 2024 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859019; cv=none; b=ZZRkOXMuq/xMV7ZwZ0Zv+2+shSVtNAhmT+gvpSBPPPRT/DU0bpniH5VkQIS2z0nyouM45WG5Uv3XcV3e4NP2Fj4HkdTlE/WnTWIOIydUxIV+nOqlypArsZEzEDUYGzp9ni5UAfNF7n5eLB4Wn+bf5EVm72xktPyO2kDGfGC7aGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859019; c=relaxed/simple;
	bh=rm8M/J0bYu0L+Ae9lzxK5fSlBMY0XQYEBrgyKIJ6aAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A53ei0oPhrpfuskKvoiCrFoHqAqbDwgRjfcEf5xzfeNN7dk7mk2ZUTYMmZRgVkV9C3mA+z236Fwtpm7NOtj1/PUdW6azLZ+J/a257ytNJUSYFZUc3kFUhaYUW3syz8/ZV4jiIkIuTtHEF7+KuKl7SBQNkYK7IXrgpsdwq3O0iyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/ozxgse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/ozxgse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF93C116B1;
	Mon,  1 Jul 2024 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859019;
	bh=rm8M/J0bYu0L+Ae9lzxK5fSlBMY0XQYEBrgyKIJ6aAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/ozxgseXMekCcRSxI2x+cLzbgHBCb6CG0o7zxQwoNmyxk9yXucEQTDkx7zjcRJI/
	 wYTEL9wej3+Ceqndq2VkRUZ1ETsjVhh52x4dl4/egKPcUeQ/jhr0cHIKAnDKh8EAVT
	 gUHD33OmfHxoiq4UjVSWuMgLz4vyTsjE8PEqnsGmidzJO5SKrzfanQtjhqNwXLD/MB
	 LUv+3fStNPXOwTo7ZY7EPCwHDJPc7dal+WCLJEOLLirLu00Q2CIpaA197HSrjQxoRd
	 CPboo+OD5ShIBhU9s6f7dLKIR+xtM3JwXRFJ5CaaFvgPowTxZHNC17cEN7QffJce54
	 +x1b2/fmnPxkQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 03/13] rust: allow `dead_code` for never constructed bindings
Date: Mon,  1 Jul 2024 20:36:13 +0200
Message-ID: <20240701183625.665574-4-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with the upcoming Rust 1.80.0 (since upstream commit 35130d7233e9
("Detect pub structs never constructed and unused associated constants
in traits")), the `dead_code` pass detects more cases, which triggers
in the `bindings` crate:

    warning: struct `boot_params` is never constructed
        --> rust/bindings/bindings_generated.rs:10684:12
        |
    10684 | pub struct boot_params {
        |            ^^^^^^^^^^^
        |
        = note: `#[warn(dead_code)]` on by default

As well as in the `uapi` one:

    warning: struct `boot_params` is never constructed
        --> rust/uapi/uapi_generated.rs:10392:12
        |
    10392 | pub struct boot_params {
        |            ^^^^^^^^^^^
        |
        = note: `#[warn(dead_code)]` on by default

These are all expected, since we do not use all the structs in the
bindings that `bindgen` generates from the C headers.

Therefore, allow them.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/bindings/lib.rs | 1 +
 rust/uapi/lib.rs     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/rust/bindings/lib.rs b/rust/bindings/lib.rs
index 40ddaee50d8b..93a1a3fc97bc 100644
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -24,6 +24,7 @@
     unsafe_op_in_unsafe_fn
 )]
 
+#[allow(dead_code)]
 mod bindings_raw {
     // Use glob import here to expose all helpers.
     // Symbols defined within the module will take precedence to the glob import.
diff --git a/rust/uapi/lib.rs b/rust/uapi/lib.rs
index 0caad902ba40..80a00260e3e7 100644
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -14,6 +14,7 @@
 #![cfg_attr(test, allow(unsafe_op_in_unsafe_fn))]
 #![allow(
     clippy::all,
+    dead_code,
     missing_docs,
     non_camel_case_types,
     non_upper_case_globals,
-- 
2.45.2

