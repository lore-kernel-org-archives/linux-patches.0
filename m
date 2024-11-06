Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F9118C00E;
	Wed,  6 Nov 2024 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896101; cv=none; b=AYmqAkEzI9/KV4KmwmzPa7mYcY93Nulu+7eITkCHt/Xq03b+K9Dj3RNjn35psDsUV7rnG2a5EXTKiKSw57fxiAXACbA9TeTSk3iZA3Gobut8r0Uz5QDtx522HJJysAg+N/ctEcPW7PDM1TrILWE3sdf4hx6HcUYN4u3WPJZQFXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896101; c=relaxed/simple;
	bh=ZrNuHz7JOWvkkf0z1N6txNCTs0oMZArIodHrsskDXhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO4y4RQVgCcxEL9FRx+xDNaQOB+1S9o6elF33VN6WKvs6rh2t9wPrfTVSKyDR+ZWMH6n8f/zqhgv30sgeL38ekAGaOaC7ilpfcHFpqeOuj4P+y+lHfu3pkjFYyQdMY2/1pBEG1o+3AkVL2muYLFgsfY89ydo7Xza2Nsfdi0pTe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmlwGrIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmlwGrIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82348C4CECD;
	Wed,  6 Nov 2024 12:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896100;
	bh=ZrNuHz7JOWvkkf0z1N6txNCTs0oMZArIodHrsskDXhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmlwGrImTpGpbnrL6PipG7qESjj6jxWsw9Lw9Be1MuYwfncWfwUyzqUXRDGYIXcoC
	 sigxf5uHEPSpCy5SNCse8RLPwOvqk/SmYxaQoPdf9yBGLPL/+QWwGdiIJw+4z7eOLg
	 YRXIakDMlKxiIax73+HKIrEzAo6n76mUwWUwiVAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 091/245] rust: device: change the from_raw() function
Date: Wed,  6 Nov 2024 13:02:24 +0100
Message-ID: <20241106120321.447759782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>

[ Upstream commit cc4332afb5631b0e9d2ce5699b7f4b7caf743526 ]

The function Device::from_raw() increments a refcount by a call to
bindings::get_device(ptr). This can be confused because usually
from_raw() functions don't increment a refcount.
Hence, rename Device::from_raw() to avoid confuion with other "from_raw"
semantics.

The new name of function should be "get_device" to be consistent with
the function get_device() already exist in .c files.

This function body also changed, because the `into()` will convert the
`&'a Device` into `ARef<Device>` and also call `inc_ref` from the
`AlwaysRefCounted` trait implemented for Device.

Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Closes: https://github.com/Rust-for-Linux/linux/issues/1088
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20241001205603.106278-1-trintaeoitogc@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/device.rs   | 15 +++------------
 rust/kernel/firmware.rs |  2 +-
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 851018eef885e..c8199ee079eff 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -51,18 +51,9 @@ impl Device {
     ///
     /// It must also be ensured that `bindings::device::release` can be called from any thread.
     /// While not officially documented, this should be the case for any `struct device`.
-    pub unsafe fn from_raw(ptr: *mut bindings::device) -> ARef<Self> {
-        // SAFETY: By the safety requirements, ptr is valid.
-        // Initially increase the reference count by one to compensate for the final decrement once
-        // this newly created `ARef<Device>` instance is dropped.
-        unsafe { bindings::get_device(ptr) };
-
-        // CAST: `Self` is a `repr(transparent)` wrapper around `bindings::device`.
-        let ptr = ptr.cast::<Self>();
-
-        // SAFETY: `ptr` is valid by the safety requirements of this function. By the above call to
-        // `bindings::get_device` we also own a reference to the underlying `struct device`.
-        unsafe { ARef::from_raw(ptr::NonNull::new_unchecked(ptr)) }
+    pub unsafe fn get_device(ptr: *mut bindings::device) -> ARef<Self> {
+        // SAFETY: By the safety requirements ptr is valid
+        unsafe { Self::as_ref(ptr) }.into()
     }
 
     /// Obtain the raw `struct device *`.
diff --git a/rust/kernel/firmware.rs b/rust/kernel/firmware.rs
index dee5b4b18aec4..13a374a5cdb74 100644
--- a/rust/kernel/firmware.rs
+++ b/rust/kernel/firmware.rs
@@ -44,7 +44,7 @@ fn request_nowarn() -> Self {
 ///
 /// # fn no_run() -> Result<(), Error> {
 /// # // SAFETY: *NOT* safe, just for the example to get an `ARef<Device>` instance
-/// # let dev = unsafe { Device::from_raw(core::ptr::null_mut()) };
+/// # let dev = unsafe { Device::get_device(core::ptr::null_mut()) };
 ///
 /// let fw = Firmware::request(c_str!("path/to/firmware.bin"), &dev)?;
 /// let blob = fw.data();
-- 
2.43.0



