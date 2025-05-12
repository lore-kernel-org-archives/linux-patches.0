Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD1B23C510;
	Mon, 12 May 2025 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071963; cv=none; b=VL3hUPOlnixS6qEWfv1Wx2a9hyjMoActORWANPPVLTBpmjYpy1VDKAZ/7Iwb+el8hq70JIqJXWbvLj0BN9SHdu0MCF5LDON7bXdpovRF1ls60aW8abh9xxmc3hgyPc/vNcnot+dXPCEKgf2j728gMlUSeDsJNIXspC+/15AvXHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071963; c=relaxed/simple;
	bh=SsPb6slv/52efQbBE4K7mVL9uA6XqHt0NuZ0mddkld0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNL+EOqsyftjQz/XFrBD2B3spPG6J5hr0iIWOzgTwj6HBRMRn+cCVPdwLGkCDGle+nFbk2uhe8NhyiskksF8k1WUIGdwaMFfD6Y2o+Ri/8cdfrTckWiTg6GQlKaGTxYetnTkdq7GLb3y0uuWaSLaN0K4mpm8e+sf06Gb3XAJIaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPLvxV+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPLvxV+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20823C4CEF0;
	Mon, 12 May 2025 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071963;
	bh=SsPb6slv/52efQbBE4K7mVL9uA6XqHt0NuZ0mddkld0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPLvxV+w+hbz1whugjNQs8blVKjtXz6WRArsUdlubXqiz8YQtKI0jEiuozUi8gSCa
	 K/T+Uu1ug381jyIVn25CnTkHvSgZfHRpSR8JT64BSmHkZnVT1QyFyi9SLca4JZXKLN
	 To0Dl1030y/4rMnkV7OL8ncFpeVTAPDtCIfjwhFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 065/197] rust: clean Rust 1.88.0s `unnecessary_transmutes` lint
Date: Mon, 12 May 2025 19:38:35 +0200
Message-ID: <20250512172047.027541352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -137,6 +137,9 @@ config LD_CAN_USE_KEEP_IN_OVERLAY
 config RUSTC_HAS_COERCE_POINTEE
 	def_bool RUSTC_VERSION >= 108400
 
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


