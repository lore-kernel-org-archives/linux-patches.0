Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4084DF4D5;
	Wed, 30 Sep 2026 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793811; cv=none; b=CtmfrAG6kVtCynfKh5JYDn2QMRMInr0j8JU96eWJ8UwROkzIJBtmf/Cz8liBVGcbh8fEo5TC4YcJYEMOVV/2xlji6numQKOCCUZWs0JWPIXOGd5R58Hto4Cu3Uingjg1RobFk6WLs7vNM93tOJsQEgaCUw+vr8zmt3Jgtb50+Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793811; c=relaxed/simple;
	bh=FeH2qhUYtsysyIx4fEEw/AxjciJd/ip/A1e5pgJsNQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPlBLL+oawqfoSJd2Rt6OGZ61UJwRbHV2xYxdEirQKHU9pxmvC6OVPBmSGLnMR4fB4BSyLLJp4K0rbyxA16hlManwASJ5H5BnIx7rm33KoMvLNAi2AN0SpcvrUZddG/47f4bo79EVgkRuF/11RUTkWHMP7Bs4MQJJGzDDQM2H2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyNekMIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyNekMIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D9E1F000FF;
	Wed, 30 Sep 2026 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793810;
	bh=mUCZDn5FiiTVPFjnkajWwznYuJSqzUTc7gFDcJj6WVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZyNekMIFlfRlkTeDfEljKlk23cxKncdkTShegDsDFKok8jITTEUIrFhJEsb/DKHDd
	 cnYDXOrzKednefMe73bKR056d0DgxFfUh62SzXMUh0f6Y1C6jtNxIGNb+shyh5qprB
	 F6bFYaMZkfMZTGWjXvQ8jGYrpjsyxus/IRQs8JsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Chunfeng Song <springbreeze@stu.pku.edu.cn>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 386/395] Revert "rust: net: phy: fix off-by-one bit positions in device status accessors"
Date: Wed, 30 Sep 2026 17:30:48 +0200
Message-ID: <20260930152349.077664484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f22d349940cb34e56f6e8cd86d69c36d3998b33a which is
commit 6fb0a9d9071f1ff0cc5cfc0782302d9c90d642cb upstream.

It was not meant to be backported before 7.1.y -- its tag said:

  Cc: stable@vger.kernel.org # Only 7.1.y and later (requires bindgen's raw pointer accessors).

Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/stable/SEWP216MB9770116738884C46F156A686FAF98D2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM/
Acked-by: Chunfeng Song <springbreeze@stu.pku.edu.cn>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/net/phy.rs |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/rust/kernel/net/phy.rs
+++ b/rust/kernel/net/phy.rs
@@ -123,37 +123,39 @@ impl Device {
     /// Gets the current link state.
     ///
     /// It returns true if the link is up.
-    #[inline]
     pub fn is_link_up(&self) -> bool {
-        let phydev = self.0.get().cast_const();
-        // SAFETY: By the type invariant of `Device`, `phydev` points to a valid
-        // `struct phy_device`, and there is no concurrent write to this field.
-        let link = unsafe { bindings::phy_device::link_raw(phydev) };
-        link == 1
+        const LINK_IS_UP: u64 = 1;
+        // TODO: the code to access to the bit field will be replaced with automatically
+        // generated code by bindgen when it becomes possible.
+        // SAFETY: The struct invariant ensures that we may access
+        // this field without additional synchronization.
+        let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
+        bit_field.get(14, 1) == LINK_IS_UP
     }
 
     /// Gets the current auto-negotiation configuration.
     ///
     /// It returns true if auto-negotiation is enabled.
-    #[inline]
     pub fn is_autoneg_enabled(&self) -> bool {
-        let phydev = self.0.get().cast_const();
-        // SAFETY: By the type invariant of `Device`, `phydev` points to a valid
-        // `struct phy_device`, and there is no concurrent write to this field.
-        let autoneg = unsafe { bindings::phy_device::autoneg_raw(phydev) };
-        autoneg == bindings::AUTONEG_ENABLE
+        // TODO: the code to access to the bit field will be replaced with automatically
+        // generated code by bindgen when it becomes possible.
+        // SAFETY: The struct invariant ensures that we may access
+        // this field without additional synchronization.
+        let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
+        bit_field.get(13, 1) == u64::from(bindings::AUTONEG_ENABLE)
     }
 
     /// Gets the current auto-negotiation state.
     ///
     /// It returns true if auto-negotiation is completed.
-    #[inline]
     pub fn is_autoneg_completed(&self) -> bool {
-        let phydev = self.0.get().cast_const();
-        // SAFETY: By the type invariant of `Device`, `phydev` points to a valid
-        // `struct phy_device`, and there is no concurrent write to this field.
-        let completed = unsafe { bindings::phy_device::autoneg_complete_raw(phydev) };
-        completed == 1
+        const AUTONEG_COMPLETED: u64 = 1;
+        // TODO: the code to access to the bit field will be replaced with automatically
+        // generated code by bindgen when it becomes possible.
+        // SAFETY: The struct invariant ensures that we may access
+        // this field without additional synchronization.
+        let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
+        bit_field.get(15, 1) == AUTONEG_COMPLETED
     }
 
     /// Sets the speed of the PHY.


