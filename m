Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E144F20CCCD;
	Fri,  7 Mar 2025 22:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387994; cv=none; b=EMe6ByJT/a1XCxTRjHnvjjVfHJTiRimIMl6Urndal7zgYiB3ug4pPj9iWfoxSx4aV3rwGCuqSzbbeWPe/PzhOnrpjFJ3G9ysypt/QsxF6upDTI/GdDLjZ10BQX0x6U9t9ZlPP5Rt6S/lKiLW6Ym9ycj0xR9NVQcAkbZThzphPMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387994; c=relaxed/simple;
	bh=XyfI0qxW2s+gzaE9WCja1XWBboKS3Xj5Ujq85oW1exw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k78L9n/UPc4E9IK06Uxo4q2pwGvfmyv11EknRQ007SGjg2AS0GW4o0b14KtKiB0kJoBRr/smp9o5M0dYp4nxgMuGjPENu0UzofOa4j/ychD1pW/JfXkUIm7NJywf64a3uDQ6NE0rFEsyvO7Wcy7/gmEoT/Eu66iC4GqipgRjxd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCfLkYnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCfLkYnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E59C4CEE9;
	Fri,  7 Mar 2025 22:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387993;
	bh=XyfI0qxW2s+gzaE9WCja1XWBboKS3Xj5Ujq85oW1exw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCfLkYnbq+2gKGlvu3QMr65fn4NwisbDbU9ys4XS58P8QBTuEAc0+08OMXhYhwdHx
	 V3y9zHdTRIciBgJdslSn85RtcOPfpyfekai4MNiivl4CsXM403/E2Ug8jn4jTJ5Mz/
	 MLBk+swKD3Y2KEke52b8q4ymvYNr4v1ZjeztDwGlT6aY/p8LbjQSdXlmcLzlZQ7u4C
	 n7RNTxx1qWRWXfDrvDxVE/RcBrAQE2IB0kmktyOM05h6HSHh8Y5fO51G4gb5uCZYE0
	 BnpkuDe8nQDYIabEUsb4rBzSWKu1QWx3XMsQEfAAtqNQxhQs4jkiy3/y1oMMAj4Sua
	 IeuVvJfEj1ahw==
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
Subject: [PATCH 6.12.y 58/60] rust: map `__kernel_size_t` and friends also to usize/isize
Date: Fri,  7 Mar 2025 23:50:05 +0100
Message-ID: <20250307225008.779961-59-ojeda@kernel.org>
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

commit 2fd6f55c048d0c863ffbc8590b1bd2edb5ff13e5 upstream.

Currently bindgen has special logic to recognise `size_t` and `ssize_t`
and map them to Rust `usize` and `isize`. Similarly, `ptrdiff_t` is
mapped to `isize`.

However this falls short for `__kernel_size_t`, `__kernel_ssize_t` and
`__kernel_ptrdiff_t`. To ensure that they are mapped to usize/isize
rather than 32/64 integers depending on platform, blocklist them in
bindgen parameters and manually provide their definition.

Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Link: https://lore.kernel.org/r/20240913213041.395655-3-gary@garyguo.net
[ Formatted comment. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/bindgen_parameters | 5 +++++
 rust/bindings/lib.rs    | 5 +++++
 rust/uapi/lib.rs        | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index b7c7483123b7..0f96af8b9a7f 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -1,5 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 
+# We want to map these types to `isize`/`usize` manually, instead of
+# define them as `int`/`long` depending on platform bitwidth.
+--blocklist-type __kernel_s?size_t
+--blocklist-type __kernel_ptrdiff_t
+
 --opaque-type xregs_state
 --opaque-type desc_struct
 --opaque-type arch_lbr_state
diff --git a/rust/bindings/lib.rs b/rust/bindings/lib.rs
index d6da3011281a..014af0d1fc70 100644
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -27,6 +27,11 @@
 #[allow(dead_code)]
 #[allow(clippy::undocumented_unsafe_blocks)]
 mod bindings_raw {
+    // Manual definition for blocklisted types.
+    type __kernel_size_t = usize;
+    type __kernel_ssize_t = isize;
+    type __kernel_ptrdiff_t = isize;
+
     // Use glob import here to expose all helpers.
     // Symbols defined within the module will take precedence to the glob import.
     pub use super::bindings_helper::*;
diff --git a/rust/uapi/lib.rs b/rust/uapi/lib.rs
index fea2de330d19..13495910271f 100644
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -25,4 +25,9 @@
     unsafe_op_in_unsafe_fn
 )]
 
+// Manual definition of blocklisted types.
+type __kernel_size_t = usize;
+type __kernel_ssize_t = isize;
+type __kernel_ptrdiff_t = isize;
+
 include!(concat!(env!("OBJTREE"), "/rust/uapi/uapi_generated.rs"));
-- 
2.48.1

