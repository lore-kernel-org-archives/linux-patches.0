Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718CE23F405;
	Tue, 29 Apr 2025 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947783; cv=none; b=ra1LTwaX6Nh6zTnivg8cbXpJTJINHW37lFQWVnU6NSYKDzpDjaREtttt/2+bih69OqEjCcrDfMCSqqJiGkpGNtq1m853vBmgzCU2LkI6WMvomOWtU36Ki+njcqNIQR3TI5m9aQP7kqlbELR8EZpEopBI6DrYUvpJy91NWGRHBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947783; c=relaxed/simple;
	bh=1N+hWieRGA3WvuqvDEbVSHyq6sI6ZZu/hL6g38P4xZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTfjYXx7OkvTm0kpWYd2qIWyU+pnjIZbPbeYfTNh91p/GZlw+34DrGpz7/8atsqmW8MjB9ODI1nodaavgyVhz8UcoH6/w1h/DaXGiFEIsNxp8DmEXmokH4dmBhB3EW7FsbwgaZ07+G6wNMBhYwcv1lgZr91JncCrqhzErzHNId4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOvNZQUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOvNZQUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B27C4CEE9;
	Tue, 29 Apr 2025 17:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947783;
	bh=1N+hWieRGA3WvuqvDEbVSHyq6sI6ZZu/hL6g38P4xZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOvNZQUVBtRhQZje13cxovPfEXKzYMhiZT0XkskJf0rFRoN01HKPMWxd37URu9+BQ
	 DegQLTbUbVQGbXzPN69xg0ppGUJSy3YQ7Hfq58o7pEQTuy3jQNlcs/AdY49H/V4nQZ
	 VG2EHAOC39kYWFDSTP3L24ZXkNYmEDbjJXPSkPpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Christian Schrefl <chrisi.schrefl@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 101/280] rust: firmware: Use `ffi::c_char` type in `FwFunc`
Date: Tue, 29 Apr 2025 18:40:42 +0200
Message-ID: <20250429161119.244779587@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Christian Schrefl <chrisi.schrefl@gmail.com>

commit 53bd97801632c940767f4c8407c2cbdeb56b40e7 upstream.

The `FwFunc` struct contains an function with a char pointer argument,
for which a `*const u8` pointer was used. This is not really the
"proper" type for this, so use a `*const kernel::ffi::c_char` pointer
instead.

This has no real functionality changes, since now `kernel::ffi::c_char`
(which bindgen uses for `char`) is now a type alias to `u8` anyways,
but before commit 1bae8729e50a ("rust: map `long` to `isize` and `char`
to `u8`") the concrete type of `kernel::ffi::c_char` depended on the
architecture (However all supported architectures at the time mapped to
`i8`).

This caused problems on the v6.13 tag when building for 32 bit arm (with
my patches), since back then `*const i8` was used in the function
argument and the function that bindgen generated used
`*const core::ffi::c_char` which Rust mapped to `*const u8` on 32 bit
arm. The stable v6.13.y branch does not have this issue since commit
1bae8729e50a ("rust: map `long` to `isize` and `char` to `u8`") was
backported.

This caused the following build error:
```
error[E0308]: mismatched types
  --> rust/kernel/firmware.rs:20:4
   |
20 |         Self(bindings::request_firmware)
   |         ---- ^^^^^^^^^^^^^^^^^^^^^^^^^^ expected fn pointer, found fn item
   |         |
   |         arguments to this function are incorrect
   |
   = note: expected fn pointer `unsafe extern "C" fn(_, *const i8, _) -> _`
                 found fn item `unsafe extern "C" fn(_, *const u8, _) -> _ {request_firmware}`
note: tuple struct defined here
  --> rust/kernel/firmware.rs:14:8
   |
14 | struct FwFunc(
   |        ^^^^^^

error[E0308]: mismatched types
  --> rust/kernel/firmware.rs:24:14
   |
24 |         Self(bindings::firmware_request_nowarn)
   |         ---- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected fn pointer, found fn item
   |         |
   |         arguments to this function are incorrect
   |
   = note: expected fn pointer `unsafe extern "C" fn(_, *const i8, _) -> _`
                 found fn item `unsafe extern "C" fn(_, *const u8, _) -> _ {firmware_request_nowarn}`
note: tuple struct defined here
  --> rust/kernel/firmware.rs:14:8
   |
14 | struct FwFunc(
   |        ^^^^^^

error[E0308]: mismatched types
  --> rust/kernel/firmware.rs:64:45
   |
64 |         let ret = unsafe { func.0(pfw as _, name.as_char_ptr(), dev.as_raw()) };
   |                            ------           ^^^^^^^^^^^^^^^^^^ expected `*const i8`, found `*const u8`
   |                            |
   |                            arguments to this function are incorrect
   |
   = note: expected raw pointer `*const i8`
              found raw pointer `*const u8`

error: aborting due to 3 previous errors
```

Fixes: de6582833db0 ("rust: add firmware abstractions")
Cc: stable@vger.kernel.org
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Christian Schrefl <chrisi.schrefl@gmail.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/r/20250413-rust_arm_fix_fw_abstaction-v3-1-8dd7c0bbcd47@gmail.com
[ Add firmware prefix to commit subject. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/firmware.rs | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/firmware.rs b/rust/kernel/firmware.rs
index f04b058b09b2..2494c96e105f 100644
--- a/rust/kernel/firmware.rs
+++ b/rust/kernel/firmware.rs
@@ -4,7 +4,7 @@
 //!
 //! C header: [`include/linux/firmware.h`](srctree/include/linux/firmware.h)
 
-use crate::{bindings, device::Device, error::Error, error::Result, str::CStr};
+use crate::{bindings, device::Device, error::Error, error::Result, ffi, str::CStr};
 use core::ptr::NonNull;
 
 /// # Invariants
@@ -12,7 +12,11 @@
 /// One of the following: `bindings::request_firmware`, `bindings::firmware_request_nowarn`,
 /// `bindings::firmware_request_platform`, `bindings::request_firmware_direct`.
 struct FwFunc(
-    unsafe extern "C" fn(*mut *const bindings::firmware, *const u8, *mut bindings::device) -> i32,
+    unsafe extern "C" fn(
+        *mut *const bindings::firmware,
+        *const ffi::c_char,
+        *mut bindings::device,
+    ) -> i32,
 );
 
 impl FwFunc {
-- 
2.49.0



