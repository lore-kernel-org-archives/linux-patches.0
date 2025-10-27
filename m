Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4848431DD87;
	Mon, 27 Oct 2025 19:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593275; cv=none; b=G1HpLq0v0X093ZfQq1zq6/MTWEQCnIfLMAhxABYiELzVwO1kiJiQ90/+rg+VDMzvDN+QNNzzK1wlw1g1O9bniU1kTttEGAzUpS71r76TNAFWyXOI2o48+RZ9TaZiOlK8GYZ7BLmP26OwJpQAsitF2L+cIO+iUYwsWghvDu2k44c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593275; c=relaxed/simple;
	bh=TJhbXW/9flhXoPpjAtqprR7Bg/GBkP0i3T3otEiG6iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3yrGJao/xPiW4sneSupsbBitxvjCQjrYdPsTS5YAsKXriWilmkV1WQRb89h4rLtM3o+Pr6WnjHYgWtf+3Mgb9YA8fW/q9gGaVCQGoOwuJbiu4li+wWLj+ze/Dz+kjJQT9KHEs/EgpW8lCPOfh3X36O2e5A2hgSD6ubGTnTQzak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIQfbFPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIQfbFPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D0CC4CEF1;
	Mon, 27 Oct 2025 19:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593275;
	bh=TJhbXW/9flhXoPpjAtqprR7Bg/GBkP0i3T3otEiG6iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIQfbFPEkK2E96hVTwA5kxAaMBarnDX5PyyPlA0jOpVrJpONfm56oGgRS8GXlMrAP
	 wbbtHIEAoUvkFMJbH/3yshuFqJVgVimNgxo9v7kTLyGVPD4e0vMKE7w28BVx0U7FkT
	 omKMGaOQEjPpWp4vxG7XOzoRqrrQ0veXiAN4ghtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.17 081/184] rust: device: fix device context of Device::parent()
Date: Mon, 27 Oct 2025 19:36:03 +0100
Message-ID: <20251027183517.082200884@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit cfec502b3d091ff7c24df6ccf8079470584315a0 upstream.

Regardless of the DeviceContext of a device, we can't give any
guarantees about the DeviceContext of its parent device.

This is very subtle, since it's only caused by a simple typo, i.e.

	 Self::from_raw(parent)

which preserves the DeviceContext in this case, vs.

	 Device::from_raw(parent)

which discards the DeviceContext.

(I should have noticed it doing the correct thing in auxiliary::Device
subsequently, but somehow missed it.)

Hence, fix both Device::parent() and auxiliary::Device::parent().

Cc: stable@vger.kernel.org
Fixes: a4c9f71e3440 ("rust: device: implement Device::parent()")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/auxiliary.rs |    8 +-------
 rust/kernel/device.rs    |    4 ++--
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/rust/kernel/auxiliary.rs
+++ b/rust/kernel/auxiliary.rs
@@ -217,13 +217,7 @@ impl<Ctx: device::DeviceContext> Device<
 
     /// Returns a reference to the parent [`device::Device`], if any.
     pub fn parent(&self) -> Option<&device::Device> {
-        let ptr: *const Self = self;
-        // CAST: `Device<Ctx: DeviceContext>` types are transparent to each other.
-        let ptr: *const Device = ptr.cast();
-        // SAFETY: `ptr` was derived from `&self`.
-        let this = unsafe { &*ptr };
-
-        this.as_ref().parent()
+        self.as_ref().parent()
     }
 }
 
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -250,7 +250,7 @@ impl<Ctx: DeviceContext> Device<Ctx> {
 
     /// Returns a reference to the parent device, if any.
     #[cfg_attr(not(CONFIG_AUXILIARY_BUS), expect(dead_code))]
-    pub(crate) fn parent(&self) -> Option<&Self> {
+    pub(crate) fn parent(&self) -> Option<&Device> {
         // SAFETY:
         // - By the type invariant `self.as_raw()` is always valid.
         // - The parent device is only ever set at device creation.
@@ -263,7 +263,7 @@ impl<Ctx: DeviceContext> Device<Ctx> {
             // - Since `parent` is not NULL, it must be a valid pointer to a `struct device`.
             // - `parent` is valid for the lifetime of `self`, since a `struct device` holds a
             //   reference count of its parent.
-            Some(unsafe { Self::from_raw(parent) })
+            Some(unsafe { Device::from_raw(parent) })
         }
     }
 


