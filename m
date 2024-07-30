Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B221A2C20;
	Tue, 30 Jul 2024 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355054; cv=none; b=OAly4eNiJqlWqEqy368KYAqiTRSpEjDKw++B2bUDn56tcQW5856UhgysD/OG/QP8YZVTX0WUu+ln3neXLIPJ9qbd0E2Gv1k18cnMcPTp9dQtQzi1ntavcditY/P94nBt43NJnNzJYvGMQnqBVyKQmVAcr/vKfNTEIVkLG0IbelE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355054; c=relaxed/simple;
	bh=49nCfpBcPYDlmJkZCymASY+VJ8tTSgBlWvAgS2mBsYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ltq6Ysvx2/QVJUZoJSxMGCDfwKf9viKHVaYokfzAoMIFucsgRwzS8mvTwpe6JGZoFt1hAg8i9lqTMLFQE02OCPp+Vr8JOy6+RutLLYoyXmK2EKPoujiXKOLoEZWBja8NH9kF8OwCT4CjwGDbn5/7TN92NqJVOBP3q5cWLoGRGMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIpFsmvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIpFsmvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD443C4AF0A;
	Tue, 30 Jul 2024 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722355053;
	bh=49nCfpBcPYDlmJkZCymASY+VJ8tTSgBlWvAgS2mBsYg=;
	h=From:To:Cc:Subject:Date:From;
	b=eIpFsmvy4dtDIE8UwA7Tw4X3Nj9Ytd60ybQYhMYgSFNV5Wf6TOnnPJ2fAh0TZmgut
	 Hy9cgmuEObvgo+eoCz/dsDBfn3XSvbu2QD9ZmwxsXe5plqO8TlDC05dwE+7uhTnbNb
	 Tb42RDSpGOBEtivwJlpP4m/lHaYY15pUIhuoGxwxGHRNuLVFQowR3WZBp14hSs6Fva
	 +4PTtVxoTWo7irjknDbvpwY/xBsm8/MByXLAWVoAKrzZZe4KdKB69BXRCqMI6/OIgw
	 VChMGvchkBTwGRbJSRWoPEjKsckhG2a21lcJYz66SlcG7ypDw3C9xYZALGmV7M1jHn
	 mojn9YMS7N9Eg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Russell King <linux@armlinux.org.uk>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Christian Schrefl <chrisi.schrefl@gmail.com>,
	Jamie Cunliffe <Jamie.Cunliffe@arm.com>,
	Sven Van Asbroeck <thesven73@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: error: allow `useless_conversion` for 32-bit builds
Date: Tue, 30 Jul 2024 17:57:02 +0200
Message-ID: <20240730155702.1110144-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the new Rust support for 32-bit arm [1], Clippy warns:

    error: useless conversion to the same type: `i32`
       --> rust/kernel/error.rs:139:36
        |
    139 |         unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
        |                                    ^^^^^^^^^^^^^ help: consider removing `.into()`: `self.0`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#useless_conversion
        = note: `-D clippy::useless-conversion` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::useless_conversion)]`

The `self.0.into()` converts an `c_int` into `ERR_PTR`'s parameter
which is a `c_long`. Thus, both types are `i32` in 32-bit. Therefore,
allow it for those architectures.

Link: https://lore.kernel.org/rust-for-linux/2dbd1491-149d-443c-9802-75786a6a3b73@gmail.com/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 145f5c397009..6f1587a2524e 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -135,8 +135,11 @@ pub(crate) fn to_blk_status(self) -> bindings::blk_status_t {
     /// Returns the error encoded as a pointer.
     #[allow(dead_code)]
     pub(crate) fn to_ptr<T>(self) -> *mut T {
+        #[cfg_attr(target_pointer_width = "32", allow(clippy::useless_conversion))]
         // SAFETY: `self.0` is a valid error due to its invariant.
-        unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
+        unsafe {
+            bindings::ERR_PTR(self.0.into()) as *mut _
+        }
     }
 
     /// Returns a string representing the error, if one exists.

base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.46.0

