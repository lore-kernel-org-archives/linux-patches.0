Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEDE7E110;
	Tue, 29 Apr 2025 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946073; cv=none; b=cCrhA/iseXhnrh8aDsxoHgQ2lqh2FNZiVSn2cuo8z8+y6vTDapmbdI+XxqKmNcJMa5gblJa56Kqc8n8x1AyQGrM+UJ7dUMeQ0w3OselQ7OOstfXt+rWetl99o/XgBQ4BJ6/QXM0nPbozoze0gTNlS531rdB+mdLGBzxlXzQJRCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946073; c=relaxed/simple;
	bh=PsnABcpbRq+AH44q4SWYhLyNhP7FNLizAKmWFXgtrhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfqGSz1MckSNQSj3kow/SvrUN4rgliYoBZ1o7sGDYM545/FT8ZLAjOH+mgvn6JkQAqjTuLzJz7oTzzM/dhywxQwyorKJwFIEbWkLNepjn+/y7dUm4yA50vmnlno83A4lo8YW8llsDodAjpe+d0i6CsbL0xRQqP+/y5LhTgTz1go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpz2+TaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpz2+TaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E85BC4CEE3;
	Tue, 29 Apr 2025 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946073;
	bh=PsnABcpbRq+AH44q4SWYhLyNhP7FNLizAKmWFXgtrhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpz2+TaCJDMsawUAIsPqlP1j1qla2YsiuyGd5NRC5JXR9bS3psj55iQHrCAx7Ix4M
	 9ZkAAvJ1MJUVdxPam/oTW+XYjT1i7N60Qy63tQ8Gm1PjMVcwN++N1XnprRFS8TIwCJ
	 EHhcYBIK9iBk/Sn/C7Y504wpYaM3gs6dGcWNPIXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Christian Schrefl <chrisi.schrefl@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.14 118/311] rust: firmware: Use `ffi::c_char` type in `FwFunc`
Date: Tue, 29 Apr 2025 18:39:15 +0200
Message-ID: <20250429161125.873585868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 rust/kernel/firmware.rs |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/rust/kernel/firmware.rs
+++ b/rust/kernel/firmware.rs
@@ -4,7 +4,7 @@
 //!
 //! C header: [`include/linux/firmware.h`](srctree/include/linux/firmware.h)
 
-use crate::{bindings, device::Device, error::Error, error::Result, str::CStr};
+use crate::{bindings, device::Device, error::Error, error::Result, ffi, str::CStr};
 use core::ptr::NonNull;
 
 /// # Invariants
@@ -12,7 +12,11 @@ use core::ptr::NonNull;
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


