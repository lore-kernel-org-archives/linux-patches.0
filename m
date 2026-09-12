Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666022BDC0E;
	Sat, 12 Sep 2026 07:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199489; cv=none; b=bEovtcW5wSPI0+o1dGoTbM8fpc1yOeDzNOHI4kXKU5PiKqlD6Wr9OfBTb/VH3dpHVfk7G4vcuf8XNm9/FxZ/ktzCAuVaLCD+eEoTZEO4u35GgEOqFHwj2qLqiD1/6T6lHL6/39RZip2qAxC24UL2ZaB3Orq7Frv+GKbN9lbo4bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199489; c=relaxed/simple;
	bh=aljWuZp8s8sBXGq767ksYGxtY37e1IEz9gZoWHvY30M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGGUJx8pJaJji3U9uPRl0ewyZGZBf8bYcU59PUe+rMaoYfvnGsKudomV056cMfBnJCtFuWN62iG0A1pyUdOlABet1kZ7N5X12r3VXv/WH+7mb/t8gXOQ4tRltakZ9z/dxsWUw1YYfJDcsmxPDCMrfN0bNGaqSZCwQSMAw+zXg8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMRocqbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMRocqbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E2D1F000FF;
	Sat, 12 Sep 2026 07:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199488;
	bh=+RJhBqpocGj4/Iki69rxra64E6pylJVbh0k10rrDyYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMRocqbJGWtsA5mI/hSJCSVSoaJbXKJdZrblqB/UKEECUJdmfgxp/Xw63MxY6aepw
	 Mo/nDAFol3Cy86f8mMjc0jb9HIQC/8U/jzaDpeIoFUW3r3OFlyDg3Qkm1J/huTdKTz
	 jbgC5j5HP8jrduEhwStzATUIyzSbS4e07zz183v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0552/1815] rust: device: make lifetime on `Core` and `CoreInternal` invariant
Date: Sat, 12 Sep 2026 08:38:22 +0200
Message-ID: <20260912065701.843605649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit f7acb19abcd867e5d2e1feb6197dcc65aa3b8e45 ]

Currently the lifetime on `Core` and `CoreInternal` is covariant. This
means that they can be coerced into shorter living lifetimes. On `probe`
function, signature has `&'bound Device<Core<'a>>`; the type's wellformness
would imply `'a: 'bound` and thus the type can be coerced `&'bound
Device<Core<'bound>>`, defeating the purpose of having the lifetime bound
to prevent users of the `Core` type to escape the function.

Fix this by making the lifetime invariant, so the coercion is impossible.
The lifetime here only needs to be "branded" so it does not coerce or unify
with other lifetimes, so we do not need to ensure `'bound: 'a`.

This requires modifying `nova-core` which relies on this implied bound due
to pre-2024 capture rule. The "use" bound can be removed if built with
edition 2024.

Fixes: 24799831d631 ("rust: device: make Core and CoreInternal lifetime-parameterized")
Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260713201455.640151-1-gary@kernel.org
[ Fixup the debugfs sample to use an explicit lifetime instead of
  Core<'_>. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gpu.rs |  6 +++---
 rust/kernel/device.rs        | 10 ++++++++--
 samples/rust/rust_debugfs.rs |  4 +++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/nova-core/gpu.rs b/drivers/gpu/nova-core/gpu.rs
index b3c91731db45d..b603b0bd2692b 100644
--- a/drivers/gpu/nova-core/gpu.rs
+++ b/drivers/gpu/nova-core/gpu.rs
@@ -285,10 +285,10 @@ pub(crate) struct Gpu<'gpu> {
 }
 
 impl<'gpu> Gpu<'gpu> {
-    pub(crate) fn new(
-        pdev: &'gpu pci::Device<device::Core<'_>>,
+    pub(crate) fn new<'a>(
+        pdev: &'gpu pci::Device<device::Core<'a>>,
         bar: Bar0<'gpu>,
-    ) -> impl PinInit<Self, Error> + 'gpu {
+    ) -> impl PinInit<Self, Error> + use<'gpu, 'a> {
         try_pin_init!(Self {
             device: pdev.as_ref(),
             spec: Spec::new(pdev.as_ref(), bar).inspect(|spec| {
diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 1a38b3bbdfb7d..09ad8ec31548c 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -511,7 +511,11 @@ pub struct Normal;
 /// callback it appears in. It is intended to be used for synchronization purposes. Bus device
 /// implementations can implement methods for [`Device<Core>`], such that they can only be called
 /// from bus callbacks.
-pub struct Core<'a>(PhantomData<&'a ()>);
+///
+/// The lifetime `'a` is for "lifetime branding" purpose. Callbacks need to polymorphic over this
+/// lifetime so the `&'bound Device<Core<'_>>` provided to them cannot outlive the scope of the
+/// function. For this reason, it needs to be invariant.
+pub struct Core<'a>(PhantomData<fn(&'a ()) -> &'a ()>);
 
 /// Semantically the same as [`Core`], but reserved for internal usage of the corresponding bus
 /// abstraction.
@@ -522,7 +526,9 @@ pub struct Core<'a>(PhantomData<&'a ()>);
 ///
 /// This context mainly exists to share generic [`Device`] infrastructure that should only be called
 /// from bus callbacks with bus abstractions, but without making them accessible for drivers.
-pub struct CoreInternal<'a>(PhantomData<&'a ()>);
+///
+/// Lifetime `'a` is invariant for the same reason as [`Core`].
+pub struct CoreInternal<'a>(PhantomData<fn(&'a ()) -> &'a ()>);
 
 /// The [`Bound`] context is the [`DeviceContext`] of a bus specific device when it is guaranteed to
 /// be bound to a driver.
diff --git a/samples/rust/rust_debugfs.rs b/samples/rust/rust_debugfs.rs
index 1f59e08aaa4b0..0b27ad96ecbfa 100644
--- a/samples/rust/rust_debugfs.rs
+++ b/samples/rust/rust_debugfs.rs
@@ -147,7 +147,9 @@ impl RustDebugFs {
         dir.read_write_file(c"pair", new_mutex!(Inner { x: 3, y: 10 }))
     }
 
-    fn new<'a>(pdev: &'a platform::Device<Core<'_>>) -> impl PinInit<Self, Error> + 'a {
+    fn new<'a, 'b>(
+        pdev: &'a platform::Device<Core<'b>>,
+    ) -> impl PinInit<Self, Error> + use<'a, 'b> {
         let debugfs = Dir::new(c"sample_debugfs");
         let dev = pdev.as_ref();
 
-- 
2.53.0



