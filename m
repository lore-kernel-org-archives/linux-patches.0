Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B5140E34;
	Mon, 12 May 2025 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072913; cv=none; b=troobdxNuSkVygGCWQulseGwXWhSBdUi0nLIjoxr3jv8sjd8JKhmnl544YDAaSavTCckugC9osq/aBTPSHUojkqoPWiO7b0PmQDBeob3i4XLVF62HpqOH2qDNuBSdU6LGh/VN1G6Glr9gwfkSzRdNJhfN1N72n1Tl+3mSkihqxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072913; c=relaxed/simple;
	bh=mzQoHr2/yvBkGVRioIEOnhiF9O879SkEZ1KX17Xb6Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA1H2h9p5EUAYiSOiQDqz+30a1AarX5Zs6Nc0QQgSwyFEDzhGuGOkVCNa7fEnIbE3Zo03dYo+1rHjIK0eDi2JUR9w6SEF9ZeHFz4fWh1w3UkVdtQwQapKZP6cWlGM/D2QqbOOCrM3nY7vunRS3wdeEu/96MUvNZRN4SOn6NYAUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1Veh6mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1Veh6mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144DAC4CEE7;
	Mon, 12 May 2025 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072913;
	bh=mzQoHr2/yvBkGVRioIEOnhiF9O879SkEZ1KX17Xb6Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1Veh6mtSiUDi6GaSRhSOqPlF035S+umpe5KQ3H41t2S7j08k6RWblJNeovJrykNb
	 swpU9GBhxRzcE6eQo4pyJEDcxgc5D1WfkSgM3L4dHQgC8TFjQkeGbalrZ39ig4pW3F
	 kUvLSut5zQDZfCvqnnJ5TkeAln8XYxrLYKvG0Gjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 065/184] rust: clean Rust 1.88.0s `unnecessary_transmutes` lint
Date: Mon, 12 May 2025 19:44:26 +0200
Message-ID: <20250512172044.483260996@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 7129ea6e242b00938532537da41ddf5fa3e21471 upstream.

Starting with Rust 1.88.0 (expected 2025-06-26) [1][2], `rustc` may
introduce a new lint that catches unnecessary transmutes, e.g.:

     error: unnecessary transmute
         --> rust/uapi/uapi_generated.rs:23242:18
          |
    23242 |         unsafe { ::core::mem::transmute(self._bitfield_1.get(0usize, 1u8) as u8) }
          |                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: replace this with: `(self._bitfield_1.get(0usize, 1u8) as u8 == 1)`
          |
          = note: `-D unnecessary-transmutes` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(unnecessary_transmutes)]`

There are a lot of them (at least 300), but luckily they are all in
`bindgen`-generated code.

Thus clean all up by allowing it there.

Since unknown lints trigger a lint itself in older compilers, do it
conditionally so that we can keep the `unknown_lints` lint enabled.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/136083 [1]
Link: https://github.com/rust-lang/rust/issues/136067 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250502140237.1659624-4-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig         |    3 +++
 rust/bindings/lib.rs |    1 +
 rust/uapi/lib.rs     |    1 +
 3 files changed, 5 insertions(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -134,6 +134,9 @@ config LD_CAN_USE_KEEP_IN_OVERLAY
 	# https://github.com/llvm/llvm-project/pull/130661
 	def_bool LD_IS_BFD || LLD_VERSION >= 210000
 
+config RUSTC_HAS_UNNECESSARY_TRANSMUTES
+	def_bool RUSTC_VERSION >= 108800
+
 config PAHOLE_VERSION
 	int
 	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -26,6 +26,7 @@
 
 #[allow(dead_code)]
 #[allow(clippy::undocumented_unsafe_blocks)]
+#[cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
 mod bindings_raw {
     // Manual definition for blocklisted types.
     type __kernel_size_t = usize;
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -24,6 +24,7 @@
     unreachable_pub,
     unsafe_op_in_unsafe_fn
 )]
+#![cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
 
 // Manual definition of blocklisted types.
 type __kernel_size_t = usize;


