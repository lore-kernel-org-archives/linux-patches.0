Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22A92309B6;
	Mon, 10 Mar 2025 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627216; cv=none; b=FHCpsGs89f3cxJdP9SH/YcUhR1hU0ZUMs1Orc8oYlJsKI6M0yDkg/lGwh98Cq63vbSf/MtVL3w4QST9/eQvfwUoEHdg73SmzjX/b6IsCHaMN0n3ZiqgC4p/xKPfCNnxyPtvSUo60bUE27E2ZZntOF99noiUujT5wmRmwwC1Ni2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627216; c=relaxed/simple;
	bh=Ya6a1uhaRteuLUbOALOreS6aRgq0/cYLUmDZn80oCEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcqm2u3MWqkG8XyJh2NK0hC5gQ56yckXzIZlO48JE4XVa/AZ7ffss6ys3qmxPEZYHLYKwUwCHBo4o+E+BOait9ZOSdy7Z8xS3WC+f9rbgrMLFE/eJLbHFmVgYG9FAT1HZ4pGuTVJZHh9uNQmy440Lz0owMOG6aipMRCp+fwonSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpAkHezo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpAkHezo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCE1C4CEED;
	Mon, 10 Mar 2025 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627216;
	bh=Ya6a1uhaRteuLUbOALOreS6aRgq0/cYLUmDZn80oCEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpAkHezokgtTcuJiS6ok268alKV0U28tdV0u8PZoG+kJp6snBYb/FwpJf7f1ToF/q
	 Hi3AV/CujZxuVaM9nUE8W4xuUiuaWyw8jgF9ZTShtlFJHRm0l2d9m5836kI/CFXxZ0
	 RRA8KznoAtKbFZ1FCHojZzFSCZ4mvCwmPPYlgSds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 054/269] rust: alloc: implement `contains` for `Flags`
Date: Mon, 10 Mar 2025 18:03:27 +0100
Message-ID: <20250310170459.879462074@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

commit 909037ce0369bc3f4fd31743fd2d8d7096f06002 upstream.

Provide a simple helper function to check whether given flags do
contain one or multiple other flags.

This is used by a subsequent patch implementing the Cmalloc `Allocator`
to check for __GFP_ZERO.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-25-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -35,7 +35,7 @@ use core::{alloc::Layout, ptr::NonNull};
 /// They can be combined with the operators `|`, `&`, and `!`.
 ///
 /// Values can be used from the [`flags`] module.
-#[derive(Clone, Copy)]
+#[derive(Clone, Copy, PartialEq)]
 pub struct Flags(u32);
 
 impl Flags {
@@ -43,6 +43,11 @@ impl Flags {
     pub(crate) fn as_raw(self) -> u32 {
         self.0
     }
+
+    /// Check whether `flags` is contained in `self`.
+    pub fn contains(self, flags: Flags) -> bool {
+        (self & flags) == flags
+    }
 }
 
 impl core::ops::BitOr for Flags {


