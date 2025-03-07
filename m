Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32587256C93;
	Fri,  7 Mar 2025 22:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387953; cv=none; b=CZ7jzsOX4+gxEVuBvi6x7L/fp/oklVIu/YtyYtyk+99OVaAPW9HCaWbt2jpJhHesq2h6iJBqRgwfQ9/dnqqHPoYVNPgL6FN09AG6V8EyNw+RQn1tDI3VUinFJ71pQpMKYcWXmNbPeCIvnc6UbyV9rhEsXzJN0uVZc9XdPB89KC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387953; c=relaxed/simple;
	bh=WlfylzQeyKacsKZOnAzATuF1sqqVRMvwVo/ZI3QrPN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRW+2ND6s4Ub02qsr5k2k00wE6TBlXFsT9A6XpqJYWEY7p7dZIE+dpdaqjEaCcfiYHvB4qtJmVqSWzUgVBAOpDHB8eFhDh5FrDOrC6PoQuFUCSG8zY9h0wT9081denYFgZuLY/O5FlROeRGp5VG/dCzYZ/w//oNxlg5I4S7u6T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUCaeQoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUCaeQoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5630C4CED1;
	Fri,  7 Mar 2025 22:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387953;
	bh=WlfylzQeyKacsKZOnAzATuF1sqqVRMvwVo/ZI3QrPN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUCaeQoNf/P0jCwi8u4LQHyaRg+M4P1nbwWBaiu+JQfyAFtpc2rLSY/cbE8962sxT
	 Ti/ZiRDLZ0l7tENR1qB5mnvXsipOLUFuc3YOY6rxJqG0l7hYiL4N1Wienhxv+dky5c
	 Bz+LsnCFHz3LoHggtW65efqYN+myyoky8/7HSvTv8MJPmCW4TNIyqA9site+yKjqev
	 wuKVjoFCxBrIXUtyiZlD2sVbndgr/oI7HZGDf6tzhH2b/PYnHtj2glLVEPGZVOb4zm
	 Cwb4I5OczhmFn++MX5AFQHYKJk1bjV/ao3S+5jUniZqU/zVDbTGh3YUj7gerbwN9OD
	 b78CdyGPq+Kag==
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
Subject: [PATCH 6.12.y 43/60] rust: alloc: implement `contains` for `Flags`
Date: Fri,  7 Mar 2025 23:49:50 +0100
Message-ID: <20250307225008.779961-44-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 rust/kernel/alloc.rs | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 7fc2e404e594..049fca7a514d 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -35,7 +35,7 @@
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
-- 
2.48.1

