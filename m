Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67FB3AC1C;
	Mon,  4 Aug 2025 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754327614; cv=none; b=Alr+3PROaLGUzpEWtTlCXceadFt8jHKUDnTg0ccvEJ0J83bSO0K1yNBgH8HnEksIrKYCh6bsN6iy81OuFAxkDgsps6oH83zPhdrWdlzR2pGlqedVfUM5mBmpCbD/pYX9Q5325CDx/mqKjqblX1LoA2X8dtwUM/oLs0qz2WtFNmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754327614; c=relaxed/simple;
	bh=7E1lY8jxWW3f7BiTEDhPp5QNAEv+WgKZsbaaNANDdAg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BLktqUFmirsFQyFY1zFXN+NSAj/00OF/gX6vU53QVNPmKhuWbDdhvi5acsLDJ/Td4TKNmXe53uOQNxO60IzPZ4KNYpzNYn2XK678pO7qOcBccTDObOCJNJ0gSEXWyzs2D7QNUV/iI1vUjyAAnQRcmOTQ0xqFgPoV0fynzwHwWhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2PxFW+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2PxFW+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E75C4CEE7;
	Mon,  4 Aug 2025 17:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754327614;
	bh=7E1lY8jxWW3f7BiTEDhPp5QNAEv+WgKZsbaaNANDdAg=;
	h=From:To:Cc:Subject:Date:From;
	b=f2PxFW+JAlum/Xf0ViNxMPvlP0p1YuzO0nTd7i4M5MvIfwW40L0Y6ijajAYSl0o3n
	 8ukO1tV77iIcaowbl9YckrKEKdPVoVj3xRO2kcTDH+pTVdbP/uCjjoxLW7YZIlfwkA
	 cfsEbSavtVnMez51N1b6TKaS9EGdq3dv9ttgW0u/6e5MEy9uKotaYYhg30TBP++Z/1
	 6NohQhYSusxq8xWUL1himR5i65OB17jw7I7osjco2vNmsw1WMzzQAW9Y06/aQ0xSQt
	 ZrDfLpvgbsLZbxXXegmusihRR3ipmGlwCKOHUc4u+CAv5pDpy3WtfSAjPIu4CwZOQw
	 IiYYAbsUYvZjA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] rust: faux: fix C header link
Date: Mon,  4 Aug 2025 19:13:11 +0200
Message-ID: <20250804171311.1186538-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.91.0 (expected 2025-10-30), `rustdoc` has improved
some false negatives around intra-doc links [1], and it found a broken
intra-doc link we currently have:

    error: unresolved link to `include/linux/device/faux.h`
     --> rust/kernel/faux.rs:7:17
      |
    7 | //! C header: [`include/linux/device/faux.h`]
      |                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ no item named `include/linux/device/faux.h` in scope
      |
      = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
      = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
      = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

Our `srctree/` C header links are not intra-doc links, thus they need
the link destination.

Thus fix it.

Cc: stable@vger.kernel.org
Link: https://github.com/rust-lang/rust/pull/132748 [1]
Fixes: 78418f300d39 ("rust/kernel: Add faux device bindings")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
It may have been in 1.90, but the beta branch does not have it, and the
rollup PR says 1.91, unlike the PR itself, so I picked 1.91. It happened
just after the version bump to 1.91, so it may have to do with that.

 rust/kernel/faux.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/faux.rs b/rust/kernel/faux.rs
index 7a906099993f..7fe2dd197e37 100644
--- a/rust/kernel/faux.rs
+++ b/rust/kernel/faux.rs
@@ -4,7 +4,7 @@
 //!
 //! This module provides bindings for working with faux devices in kernel modules.
 //!
-//! C header: [`include/linux/device/faux.h`]
+//! C header: [`include/linux/device/faux.h`](srctree/include/linux/device/faux.h)

 use crate::{bindings, device, error::code::*, prelude::*};
 use core::ptr::{addr_of_mut, null, null_mut, NonNull};

base-commit: d2eedaa3909be9102d648a4a0a50ccf64f96c54f
--
2.50.1
