Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF42268688;
	Tue,  8 Apr 2025 11:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113249; cv=none; b=YCL+tQ8O+azlOFbuMwneXj24wRSPDso1FbIqqVdiX1lVfKRyMOzjN2QI7yzzSfiwRyXmh16mkosuecYtAES074yZ/vFoK4Kyo8p7IKwkKPx/Tq9IsEljjDvzTwx0MMN58bGjjpjXn6eZi56fIwDjHQsQecykAq1B7WVpNodDyU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113249; c=relaxed/simple;
	bh=ybfdQ1ujdbX7dz1xZRwTPBtQwjfDuomu1G+gyFsumuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBNlNkbtRqK1M6ze+Yrxh+brzgyd4FNFYcY7m6p0J5W4zMRxASzqRIQs82Ab0WRdgz40yRr9MMeV9M5Ov+RETE0bNl9YdzvJhf4W18A59uieLgxgEW72DpjrXiU79LpyCLFedARd+f53ZSPXkCcP3p1THAEJbuPVrLpKISQOaFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebGcQxw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebGcQxw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD12C4CEE5;
	Tue,  8 Apr 2025 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113249;
	bh=ybfdQ1ujdbX7dz1xZRwTPBtQwjfDuomu1G+gyFsumuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebGcQxw60zNaXo3RzXHiMCfXSyz1VWyf7qllbsa57Dha7zT3WsOOM5McqY29mKpuV
	 68pZkr+c8M0F2tK7e3Hh6+hXUzNlAZPvsMWkEnk+Nf9rpAePk2qsAp2L5icQBJwl6Q
	 CwdwCz3FqKo4nPGDNf2IfG7NYLUlHRyz7the4da0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Petr Mladek <pmladek@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/268] rust: fix signature of rust_fmt_argument
Date: Tue,  8 Apr 2025 12:48:20 +0200
Message-ID: <20250408104830.890872754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2aa408441cd3e..14b27db236cc8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2275,7 +2275,7 @@ int __init no_hash_pointers_enable(char *str)
 early_param("no_hash_pointers", no_hash_pointers_enable);
 
 /* Used for Rust formatting ('%pA'). */
-char *rust_fmt_argument(char *buf, char *end, void *ptr);
+char *rust_fmt_argument(char *buf, char *end, const void *ptr);
 
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index f48926e3e9fe3..34788218ea5d2 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -6,12 +6,11 @@
 //!
 //! Reference: <https://www.kernel.org/doc/html/latest/core-api/printk-basics.html>
 
-use core::{
+use crate::{
     ffi::{c_char, c_void},
-    fmt,
+    str::RawFormatter,
 };
-
-use crate::str::RawFormatter;
+use core::fmt;
 
 #[cfg(CONFIG_PRINTK)]
 use crate::bindings;
-- 
2.39.5



