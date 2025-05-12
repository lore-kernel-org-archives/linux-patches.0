Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A3E29C349;
	Mon, 12 May 2025 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073101; cv=none; b=jRG9Ug8BtQ5tQTMgYoPqOcKmwt1MV4GunHWlH1JmPGokvaSv3gb4Bf/MqsxYpnm7EOD4mrJ0AGVKdJuh/v+m9zsFG1E+EdanZ4NtS+pItRRjW35QfVnmPwACavJwqxQMJVBy6IpLzpR/5nwKUErbQBLCWpj6YlsoA2VLGqkNW+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073101; c=relaxed/simple;
	bh=SrSlGuuQGcDDC/wk6KJZiNoMPMhRAShhMiAhtOz1H5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGOfz5Ys9l8cLfQuvtqSj/cXuHBmXmJkJ2fOr3eM3RU5yx8xrWcwIuTpR+9KhisjpWsul78+ZOc08+LbeEpjpI+lUVkEUKVDMla1hI9BZqXQqFA7tp7DtjsAYIH5kXoP0kKDgO7sVCAujEqnnxu3iU7TF8NwkQMf+ArDry7qfF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=on83mWZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="on83mWZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE82C4CEE7;
	Mon, 12 May 2025 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073101;
	bh=SrSlGuuQGcDDC/wk6KJZiNoMPMhRAShhMiAhtOz1H5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on83mWZm2aE30czmQIcm6Oc1KIUgCzcN2Svpd2sum0Xv7BmDdIsKgNSDfylat2+us
	 tRSpwcl/T0NuxUKQ8vUXuykpur826mtJVJDdKeqFMOUZ2ddDjRmjG29URP8eypUowt
	 dDlyoR5VpejQPAvJqq2danMkYQc+l3t8CRzUjG6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 154/184] rust: allow Rust 1.87.0s `clippy::ptr_eq` lint
Date: Mon, 12 May 2025 19:45:55 +0200
Message-ID: <20250512172048.090068113@linuxfoundation.org>
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

commit a39f3087092716f2bd531d6fdc20403c3dc2a879 upstream.

Starting with Rust 1.87.0 (expected 2025-05-15) [1], Clippy may expand
the `ptr_eq` lint, e.g.:

    error: use `core::ptr::eq` when comparing raw pointers
       --> rust/kernel/list.rs:438:12
        |
    438 |         if self.first == item {
        |            ^^^^^^^^^^^^^^^^^^ help: try: `core::ptr::eq(self.first, item)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#ptr_eq
        = note: `-D clippy::ptr-eq` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::ptr_eq)]`

It is expected that a PR to relax the lint will be backported [2] by
the time Rust 1.87.0 releases, since the lint was considered too eager
(at least by default) [3].

Thus allow the lint temporarily just in case.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust-clippy/pull/14339 [1]
Link: https://github.com/rust-lang/rust-clippy/pull/14526 [2]
Link: https://github.com/rust-lang/rust-clippy/issues/14525 [3]
Link: https://lore.kernel.org/r/20250502140237.1659624-3-ojeda@kernel.org
[ Converted to `allow`s since backport was confirmed. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/kvec.rs |    3 +++
 rust/kernel/list.rs       |    3 +++
 2 files changed, 6 insertions(+)

--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -2,6 +2,9 @@
 
 //! Implementation of [`Vec`].
 
+// May not be needed in Rust 1.87.0 (pending beta backport).
+#![allow(clippy::ptr_eq)]
+
 use super::{
     allocator::{KVmalloc, Kmalloc, Vmalloc},
     layout::ArrayLayout,
--- a/rust/kernel/list.rs
+++ b/rust/kernel/list.rs
@@ -4,6 +4,9 @@
 
 //! A linked list implementation.
 
+// May not be needed in Rust 1.87.0 (pending beta backport).
+#![allow(clippy::ptr_eq)]
+
 use crate::init::PinInit;
 use crate::sync::ArcBorrow;
 use crate::types::Opaque;


