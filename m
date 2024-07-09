Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C134D19E7FE;
	Tue,  9 Jul 2024 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541197; cv=none; b=adsoPhmbUdIfZ585H6DlyxYIefjJmsltZkTAi9p4FnLbcaOROZQtWOlu4LjXf2XpuwLcux6K5gzXFjmUhvUbT66NmFnWRNaQa/vYhWUzz7eMRMGzlgAZBTEkkDIheCEcd5BRUmGHpe8R1FXhiDIRT9KrStWwBco5Y005aB8n+fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541197; c=relaxed/simple;
	bh=2pby4D5fS3dFluQWFLoAGxUrOb4RA6QuYD47Ndufehc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2fug6/Uer50jKEq4tMPgj014K81mCGI8AZZsTZbcPNJQezsbse/XzC6NrAnoF4aWwlhmRuHIAx47xeITJ4x7dCaYJE5gOpcmyJb3V3tCJoaxrg5LZp0wjrLGtQZDXqID8VT02XOqkgFDPZ5mp6BMTtZUAdyX0uDKlR3p5fXiIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvW82XJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvW82XJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03109C3277B;
	Tue,  9 Jul 2024 16:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541197;
	bh=2pby4D5fS3dFluQWFLoAGxUrOb4RA6QuYD47Ndufehc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvW82XJ0KGA4yUoIKiHdQz1hSygq0i1tB5K/6WU8v8NyfVTPQbpn0xyyS7vj1gL0D
	 aZIBw2ku6vq3eKnvvHPLOJ5uACql6geC/jDeH1xUdIxbs86xMFyKYmMPkpke0vDdaA
	 ecTldTybDRHc1ro7IaTjwJJpeaQhKmjOYLV6ZcQjJYB9ViUTDi2dod1OS1HPDFCZy7
	 Xh2nf2desmajdKF6zmLbG+m6GtAs4atuYY+NJTmZT9fjBrhcDTbMNP+arGmeIbBRYu
	 YMNpmqsaGoLB8/bGec5Klx1713LKsxgMC69HlGDUFz6vc70te+3aVr9Zu0NleMhbwA
	 puePBcEycx8wQ==
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
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>
Subject: [PATCH v2 03/13] rust: allow `dead_code` for never constructed bindings
Date: Tue,  9 Jul 2024 18:05:58 +0200
Message-ID: <20240709160615.998336-4-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Finn Behrens <me@kloenk.dev>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
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

