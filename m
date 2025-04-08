Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7EA268C6B;
	Tue,  8 Apr 2025 12:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116442; cv=none; b=dUSj4khtTcD5EM69NV3/xoPOMH1ovN76pLsmVVPxajmDqiWUsRnBW7n2uNA5Bxvsj846XsAL7YWd8CLdrAvDMtGbT4rylaSmdlqXATYPAH4JiUYRkDXa1wCsQ+iJR0X1+IJYiRnLYtOFL5X5Pz71H9M79UKROgFAbK7VVTerIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116442; c=relaxed/simple;
	bh=K/h5NQvRlUUepPTDYwYxs5jHNNuy1/AU6l+vHg55PUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIl2Wn9W4NdGpOsF4XmPUenwrtL7wD4qMHykSyYjiSmJ12NdrFYttZ1NWcEF0f5L4c+jXg4aJ6Bd/6PfD4TjK6wnyiTgxwfwnuK0APnBM6RI7cnNQi/2VBDpWeIEHU8BqeDlKR7defPCm4bfxqdrf20kpM4w3o/Fc3VtfA/NB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgQ4f4VS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgQ4f4VS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F261C4CEE5;
	Tue,  8 Apr 2025 12:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116442;
	bh=K/h5NQvRlUUepPTDYwYxs5jHNNuy1/AU6l+vHg55PUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgQ4f4VSb1LdkIFMLCQeo4EQdLciD+Q9AtWmFtZE+QP4OoAxLRVBorGIsLswi72QW
	 YTp4JkWqERA/6O1UojNva1UqpRZSt3l7dAK2yLSxsfc2Bqh0UYYH4W19ybwy/5KO31
	 KdRPYB5BBOpriPoW+Ej2NIQz7BptS1tDCEcFML3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Petr Mladek <pmladek@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/423] rust: fix signature of rust_fmt_argument
Date: Tue,  8 Apr 2025 12:47:49 +0200
Message-ID: <20250408104849.062098860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 901b3290bd4dc35e613d13abd03c129e754dd3dd ]

Without this change, the rest of this series will emit the following
error message:

error[E0308]: `if` and `else` have incompatible types
  --> <linux>/rust/kernel/print.rs:22:22
   |
21 | #[export]
   | --------- expected because of this
22 | unsafe extern "C" fn rust_fmt_argument(
   |                      ^^^^^^^^^^^^^^^^^ expected `u8`, found `i8`
   |
   = note: expected fn item `unsafe extern "C" fn(*mut u8, *mut u8, *mut c_void) -> *mut u8 {bindings::rust_fmt_argument}`
              found fn item `unsafe extern "C" fn(*mut i8, *mut i8, *const c_void) -> *mut i8 {print::rust_fmt_argument}`

The error may be different depending on the architecture.

To fix this, change the void pointer argument to use a const pointer,
and change the imports to use crate::ffi instead of core::ffi for
integer types.

Fixes: 787983da7718 ("vsprintf: add new `%pA` format specifier")
Reviewed-by: Tamir Duberstein <tamird@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20250303-export-macro-v3-1-41fbad85a27f@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vsprintf.c       | 2 +-
 rust/kernel/print.rs | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c5e2ec9303c5d..a69e71a1ca55e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2255,7 +2255,7 @@ int __init no_hash_pointers_enable(char *str)
 early_param("no_hash_pointers", no_hash_pointers_enable);
 
 /* Used for Rust formatting ('%pA'). */
-char *rust_fmt_argument(char *buf, char *end, void *ptr);
+char *rust_fmt_argument(char *buf, char *end, const void *ptr);
 
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index a28077a7cb301..e52cd64333bcc 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -6,12 +6,11 @@
 //!
 //! Reference: <https://docs.kernel.org/core-api/printk-basics.html>
 
-use core::{
+use crate::{
     ffi::{c_char, c_void},
-    fmt,
+    str::RawFormatter,
 };
-
-use crate::str::RawFormatter;
+use core::fmt;
 
 // Called from `vsprintf` with format specifier `%pA`.
 #[expect(clippy::missing_safety_doc)]
-- 
2.39.5



