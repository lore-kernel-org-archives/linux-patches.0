Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B1C224AFB;
	Sun, 23 Nov 2025 16:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763915756; cv=none; b=SzbAbt3VvfaiwaMi5vHf7pvR509O5n/8/rgpBZST5nHuPhUaexk7+U7wlGfhm3hQJtjlX8ZIxwDpjyRlZKQT75NRTy3FUwe47k28aNVsPyDWIx2zs57b8nvpa5Y/sB8d9qQwT12uFJIniCSQjIPhPVANefTr+u3LQQ5jNOqO4Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763915756; c=relaxed/simple;
	bh=UEreune45OmiV31iDxW7oYvMz6N/UExuwtngP1+yOl8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sItUp+vDR9Wz4i8NA2rADtOx1cOsvoVlqxIROJXhNccyE3t31PwK8zejno+cOARfah3ezic+wM0pDcNG0jXBGa4DSmemcvrJHkC5Fqbz1JMilJd0UQ/tzvukn4OZ7m9BhiwuUWglKMcoohFbrzn0mPkdn1AJ6Fq7Rf2PnUty0qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VH39JF8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VH39JF8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD0C113D0;
	Sun, 23 Nov 2025 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763915756;
	bh=UEreune45OmiV31iDxW7oYvMz6N/UExuwtngP1+yOl8=;
	h=From:To:Cc:Subject:Date:From;
	b=VH39JF8RBV1mJrXpGI9px7CB/LOi73deWq1WXQmwQg5ANCHVZBWiv0MVMALYUq/U3
	 0gh3VNkyhiNtc0drt8EFaK5+AYDmoqUQz4EMni7ZfQynSFodD3/wC49IStPB9veN4Q
	 9cde19J3YkKluR5zFVtUByHmlaWM0AVVV3o66W4eCGz+sX4O+5yN3MuKhsABRBvUwf
	 oKt4Qj3wx7ZztzfMW9Uw81u809CurBMioLUKPPW+tHQZ4WixvwRm7JMAiom3viEIQy
	 JDGEsqv1E6N3Ge/GYQ0UTZ12q//KAdocuqpK8uH1ZkRSpL1FpMsL5pwN2xeug0443o
	 uDrT4vPRhsVrA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Igor Korotin <igor.korotin.linux@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg KH <greg@kroah.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Daniel Almeida <daniel.almeida@collabora.com>,
	rust-for-linux@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: i2c: prepare for `core::ffi::CStr`
Date: Sun, 23 Nov 2025 17:35:36 +0100
Message-ID: <20251123163536.1771801-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rust-next tree contains commit:

    3b83f5d5e78a ("rust: replace `CStr` with `core::ffi::CStr`")

which, when merged together with commits:

    57c5bd9aee94 ("rust: i2c: add basic I2C device and driver abstractions")
    f3cc26a417b7 ("rust: i2c: add manual I2C device creation abstractions")

from this tree (driver-core), produces errors like the following:

    error[E0599]: no method named `len_with_nul` found for reference `&'static ffi::CStr` in the current scope
      --> rust/kernel/i2c.rs:48:16
       |
    48 |             id.len_with_nul() <= Self::I2C_NAME_SIZE,
       |                ^^^^^^^^^^^^ method not found in `&CStr`

    error[E0599]: no method named `as_bytes_with_nul` found for reference `&'static ffi::CStr` in the current scope
      --> rust/kernel/i2c.rs:51:22
       |
    51 |         let src = id.as_bytes_with_nul();
       |                      ^^^^^^^^^^^^^^^^^
       |
    help: there is a method `to_bytes_with_nul` with a similar name
       |
    51 |         let src = id.to_bytes_with_nul();
       |                      ~~~~~~~~~~~~~~~~~

which were detected in linux-next by Stephen [1].

The `i2c` code can be independently prepared to be ready for the change,
thus do so.

The change is similar to the one done by Tamir in commit 657403637f7d
("rust: acpi: use `core::ffi::CStr` method names").

Link: https://lore.kernel.org/all/20251120181111.65ce75a0@canb.auug.org.au/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I see that Stephen added this in his Friday's resolution. However, the
`CStrExt` import does not seem needed as it also comes from the prelude,
so that may be removed.

 rust/kernel/i2c.rs | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/rust/kernel/i2c.rs b/rust/kernel/i2c.rs
index 95b056cc1a71..491e6cc25cf4 100644
--- a/rust/kernel/i2c.rs
+++ b/rust/kernel/i2c.rs
@@ -44,11 +44,8 @@ impl DeviceId {
     /// Create a new device id from an I2C 'id' string.
     #[inline(always)]
     pub const fn new(id: &'static CStr) -> Self {
-        build_assert!(
-            id.len_with_nul() <= Self::I2C_NAME_SIZE,
-            "ID exceeds 20 bytes"
-        );
-        let src = id.as_bytes_with_nul();
+        let src = id.to_bytes_with_nul();
+        build_assert!(src.len() <= Self::I2C_NAME_SIZE, "ID exceeds 20 bytes");
         let mut i2c: bindings::i2c_device_id = pin_init::zeroed();
         let mut i = 0;
         while i < src.len() {
@@ -434,11 +431,8 @@ impl I2cBoardInfo {
     /// Create a new [`I2cBoardInfo`] for a kernel driver.
     #[inline(always)]
     pub const fn new(type_: &'static CStr, addr: u16) -> Self {
-        build_assert!(
-            type_.len_with_nul() <= Self::I2C_TYPE_SIZE,
-            "Type exceeds 20 bytes"
-        );
-        let src = type_.as_bytes_with_nul();
+        let src = type_.to_bytes_with_nul();
+        build_assert!(src.len() <= Self::I2C_TYPE_SIZE, "Type exceeds 20 bytes");
         let mut i2c_board_info: bindings::i2c_board_info = pin_init::zeroed();
         let mut i: usize = 0;
         while i < src.len() {

base-commit: 4635406417bb842862d6322c461743c9b128c444
--
2.52.0
