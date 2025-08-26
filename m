Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9BC33CE88;
	Tue, 26 Aug 2025 11:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207796; cv=none; b=F5wzGCMonyCt1lk+JQEQVG63KHfhAMOGFyECn/TRGTCLGH4mT4NH384UkSyWCL9ycVZyBqpjYk0GOQeO5whuEb0gVV+C1iuSMmhw36y/T2bQdwsOOeC/QEV0HKZMwgUWP8HrUadk26Y/hUcdo91AsgtkYvFSrCj3ZLQJL98S2c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207796; c=relaxed/simple;
	bh=Vce4iuGtJkTxMr45g94zfvdyzjmUK9CKF8Bc6Vtikq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8Q4xCK8U8KNcRTdUOhoREoaS8pOcHc6c72irW6jhSfDckEkdWo19wzUboT61yxcrN4StKfxI8SiSK0lb5wf3f/1cRWrD6sXyb1graNYTulP/D1CQRZraOI4ophJHbdhy9AMecXZKHb0TXgw/zaq+3v5KQtb/KwvMb6IUY2eGvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH76php/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH76php/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF4FC4CEF1;
	Tue, 26 Aug 2025 11:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207796;
	bh=Vce4iuGtJkTxMr45g94zfvdyzjmUK9CKF8Bc6Vtikq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CH76php/rAIGz0tjqGubYrK2lDPAV6M/NUbP69yWgklIemmhHfLHAhL/q30ivioFX
	 3DZ/lDGdDmnvSutKR1EnCTJ2gUfZHkbmmqG5hPmbfMjcZKFLLMaMIoG5fs3s04Wu0g
	 tAKOS1tSjDZE1r9d9b4UWrfMFSgk13UFTN17kYd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.16 280/457] rust: faux: fix C header link
Date: Tue, 26 Aug 2025 13:09:24 +0200
Message-ID: <20250826110944.299237831@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit a5ba9ad417254c49ecf06ac5ab36ec4b12ee133f upstream.

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

Cc: stable <stable@kernel.org>
Link: https://github.com/rust-lang/rust/pull/132748 [1]
Fixes: 78418f300d39 ("rust/kernel: Add faux device bindings")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Benno Lossin <lossin@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250804171311.1186538-1-ojeda@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
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
-- 
2.50.1



