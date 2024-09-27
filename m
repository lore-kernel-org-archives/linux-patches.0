Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C0913CA81;
	Fri, 27 Sep 2024 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727455477; cv=none; b=l9w0TfNo/g76YL9WFbuSBW60pCokdphUR+SN7HW96q+NtvJg11sMRqIJfbgTmdTewLJ+5SBTgdWmn+3CL2mAnBy6xgT64fhRseFOPLdJu4l6rndTDLzuDkuDQNZY1FY3KV10VmP5HWbXN1njuHxh43gKuVc5zjnOUCG1mYmFZ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727455477; c=relaxed/simple;
	bh=dQlFYnZiLmmXrBCgZzrupIxNDB3rrb6r/SvpSrkLrrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=naQuTWZhTNQ8KuzhtWhPXCnwaBdQas7KzhWjELCf2ktFEvkuHMF0A8H13yUqEPq+3MFeXaARFosCX3cnKOaFpzwQbJwx9emYHcOfCyr6/CA93fbvgUmTpbkRUj+2oeg2JY0YKEyw30dAoml3l+qYMX76NTPUTECCFGYYpqyxk/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNiKJ1Dh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNiKJ1Dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA2FC4AF09;
	Fri, 27 Sep 2024 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727455476;
	bh=dQlFYnZiLmmXrBCgZzrupIxNDB3rrb6r/SvpSrkLrrw=;
	h=From:To:Cc:Subject:Date:From;
	b=PNiKJ1Dh1lIaqqfPDUI1BfZeOtovL5QXkzD+neM56zMqHMofwc2imOpDk/3w2yeox
	 d+Ii2v/Lh/hrwod7VzfwH862w4pARrjvSrCMaSjAHrF0wPNIEsZbEzkuffmkKIz1mW
	 aiS5/zK0rKFteEXSftZddm6afBY5A23ibunXvyZvOYJdqSvpG1Xbsa0q7y6cdCR8Zc
	 hh+3TOFZrU3PhUHYJyt/d9EW/kyGY/4qCc1095A6Jaomb7gskJpo8Fo4I88JFYSUM5
	 /Itzsn5n7xvyMjbpsXr91WESoOb8aI9GoB/n2zyL9ktpXMyBnguO7jfgtdd51mAa4Z
	 T+5bQkZlRulLg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: kunit: use C-string literals to clean warning
Date: Fri, 27 Sep 2024 18:44:14 +0200
Message-ID: <20240927164414.560906-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with upstream Rust commit a5e3a3f9b6bd ("move
`manual_c_str_literals` to complexity"), to be released in Rust 1.83.0
[1], Clippy now warns on `manual_c_str_literals` by default, e.g.:

    error: manually constructing a nul-terminated string
      --> rust/kernel/kunit.rs:21:13
       |
    21 |             b"\x013%pA\0".as_ptr() as _,
       |             ^^^^^^^^^^^^^ help: use a `c""` literal: `c"\x013%pA"`
       |
       = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_c_str_literals
       = note: `-D clippy::manual-c-str-literals` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(clippy::manual_c_str_literals)]`

Apply the suggestion to clean up the warnings.

Link: https://github.com/rust-lang/rust-clippy/pull/13263 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
The cast could also be cleaned up, but that is already done in Gary's
FFI series, so I didn't include another patch.

C-string literals are available since Rust 1.77.0, which is higher than
our minimum version, but LTS kernels do not have Rust 1.77.0. But
perhaps for these is not a big deal, and we could also enable
`feature(c_str_literals)` instead.

 rust/kernel/kunit.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
index 0ba77276ae7e..824da0e9738a 100644
--- a/rust/kernel/kunit.rs
+++ b/rust/kernel/kunit.rs
@@ -18,7 +18,7 @@ pub fn err(args: fmt::Arguments<'_>) {
     #[cfg(CONFIG_PRINTK)]
     unsafe {
         bindings::_printk(
-            b"\x013%pA\0".as_ptr() as _,
+            c"\x013%pA".as_ptr() as _,
             &args as *const _ as *const c_void,
         );
     }
@@ -34,7 +34,7 @@ pub fn info(args: fmt::Arguments<'_>) {
     #[cfg(CONFIG_PRINTK)]
     unsafe {
         bindings::_printk(
-            b"\x016%pA\0".as_ptr() as _,
+            c"\x016%pA".as_ptr() as _,
             &args as *const _ as *const c_void,
         );
     }

base-commit: 570172569238c66a482ec3eb5d766cc9cf255f69
--
2.46.2
