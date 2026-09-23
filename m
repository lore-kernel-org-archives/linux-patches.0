Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFCE524B19;
	Wed, 23 Sep 2026 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173462; cv=none; b=K6OOQoSSLkn2eJiHrTbswzIOGxB23sFLAAChiaRewgcBvZxqJN0f3yeL9gxPwbtcO2EZGThEKq57ZNk9IqywCZY984oWTcoFE+zSWVwsnteiqPw2YiPu2L71xsOAsN/onB0dLNalR+jGX4xhyBU1Fh/Mozeefiqaj8khuIOIWwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173462; c=relaxed/simple;
	bh=HLruoge/21agTyrisfmU9/79+yXh53vKJ21qi/RYo7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBah3JT5gMzlgu+e5tnhMrj7djEiJ7xi5bRyMk8I/kE3brSp9/gXuRCBKFShgoNtjIgXb7VhUtBEBCu6D0WRTLcRtYinNQOig7xfn+V6vXHiSl2KI/oc+ogPdWi8FD7WUBA8MWkDth5KX2h/n0t1I8IMi321jhQZLB3EV3Ovawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmA0ZMhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmA0ZMhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F281F000FF;
	Wed, 23 Sep 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173460;
	bh=HXI1/MYySCXG8yVcqO+Mg4Sy2mXlfILs83XA0BopjdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmA0ZMhcutboF43Q82ydoZX8uypc5Po1MZDuLb1GTIqoWjDLpFHu5SFXXLZHE3zmt
	 9fG7/MaLAOLwA4EfnvdUKuXPY6clNe9raCAdZeLJe2iiug7DLKXCnnOURu49+E/2co
	 1y/IBPTtEKJl8D47iBpgY9HbojsAWpyaKANr6BII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunfeng Song <springbreeze@stu.pku.edu.cn>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 252/438] rust: net: phy: fix off-by-one bit positions in device status accessors
Date: Wed, 23 Sep 2026 16:04:33 +0200
Message-ID: <20260923140651.302495602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Chunfeng Song <springbreeze@stu.pku.edu.cn>

commit 6fb0a9d9071f1ff0cc5cfc0782302d9c90d642cb upstream.

The hand-written bitfield offsets in is_link_up(), is_autoneg_enabled()
and is_autoneg_completed() were correct when the abstraction was
merged: at that time autoneg, link, and autoneg_complete were at bits
13, 14, and 15 of struct phy_device's first bitfield unit. Commit
2796ff1e3dca ("net: phy: add flag is_genphy_driven to struct phy_device")
later inserted is_genphy_driven just before autoneg, shifting the three
fields up by one, so the accessors now read:

  is_link_up()           reads bit 14 = autoneg
  is_autoneg_enabled()   reads bit 13 = is_genphy_driven
  is_autoneg_completed() reads bit 15 = link

The official ax88796b Rust driver uses all three accessors in its
read_status() implementation, so it inherits the bug.
phy_attach_direct() sets is_genphy_driven only when it falls back to
the generic driver, and ax88796b has a real driver, so
is_genphy_driven stays 0. The broken is_autoneg_enabled() therefore
reads bit 13 as 0, compares it against AUTONEG_ENABLE (1), and always
returns false, so read_status() never reaches the
resolve_aneg_linkmode() call.

The ordinary bindgen accessors take &self. Calling them through
(*phydev).link() would create a shared reference to the complete
bindings::phy_device, which is not appropriate for an object wrapped in
Opaque.

Use the bindgen-generated raw accessors (link_raw(), autoneg_raw(),
and autoneg_complete_raw()) instead. They retain the bit positions and
endianness handling generated from the C layout without creating a Rust
reference to the complete phy_device. Drop the hand-written numbers
together with the TODO comment that marked them as a stopgap.

The raw accessors are only emitted by bindgen 0.71 and later, and were
added at the Rust-for-Linux project's request, so this fix can only be
backported to stable branches whose minimum bindgen version is at least
that, hence the scope on the Cc: stable line below.

Found by a static equivalence audit (C2RustDrv, a C-to-Rust driver
migration tool) that compares hand-written bitfield offsets against
the bindgen layout of struct phy_device. Verified by building the
bindings and checking the generated accessors; no runtime testing was
possible without PHY hardware.

Fixes: 2796ff1e3dca ("net: phy: add flag is_genphy_driven to struct phy_device")
Cc: stable@vger.kernel.org # Only 7.1.y and later (requires bindgen's raw pointer accessors).
Link: https://github.com/rust-lang/rust-bindgen/issues/2674
Signed-off-by: Chunfeng Song <springbreeze@stu.pku.edu.cn>
Reviewed-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Link: https://patch.msgid.link/20260910055110.167110-1-springbreeze@stu.pku.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/net/phy.rs |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

--- a/rust/kernel/net/phy.rs
+++ b/rust/kernel/net/phy.rs
@@ -123,39 +123,37 @@ impl Device {
     /// Gets the current link state.
     ///
     /// It returns true if the link is up.
+    #[inline]
     pub fn is_link_up(&self) -> bool {
-        const LINK_IS_UP: u64 = 1;
-        // TODO: the code to access to the bit field will be replaced with automatically
-        // generated code by bindgen when it becomes possible.
-        // SAFETY: The struct invariant ensures that we may access
-        // this field without additional synchronization.
-        let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
-        bit_field.get(14, 1) == LINK_IS_UP
+        let phydev = self.0.get().cast_const();
+        // SAFETY: By the type invariant of `Device`, `phydev` points to a valid
+        // `struct phy_device`, and there is no concurrent write to this field.
+        let link = unsafe { bindings::phy_device::link_raw(phydev) };
+        link == 1
     }
 
     /// Gets the current auto-negotiation configuration.
     ///
     /// It returns true if auto-negotiation is enabled.
+    #[inline]
     pub fn is_autoneg_enabled(&self) -> bool {
-        // TODO: the code to access to the bit field will be replaced with automatically
-        // generated code by bindgen when it becomes possible.
-        // SAFETY: The struct invariant ensures that we may access
-        // this field without additional synchronization.
-        let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
-        bit_field.get(13, 1) == u64::from(bindings::AUTONEG_ENABLE)
+        let phydev = self.0.get().cast_const();
+        // SAFETY: By the type invariant of `Device`, `phydev` points to a valid
+        // `struct phy_device`, and there is no concurrent write to this field.
+        let autoneg = unsafe { bindings::phy_device::autoneg_raw(phydev) };
+        autoneg == bindings::AUTONEG_ENABLE
     }
 
     /// Gets the current auto-negotiation state.
     ///
     /// It returns true if auto-negotiation is completed.
+    #[inline]
     pub fn is_autoneg_completed(&self) -> bool {
-        const AUTONEG_COMPLETED: u64 = 1;
-        // TODO: the code to access to the bit field will be replaced with automatically
-        // generated code by bindgen when it becomes possible.
-        // SAFETY: The struct invariant ensures that we may access
-        // this field without additional synchronization.
-        let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
-        bit_field.get(15, 1) == AUTONEG_COMPLETED
+        let phydev = self.0.get().cast_const();
+        // SAFETY: By the type invariant of `Device`, `phydev` points to a valid
+        // `struct phy_device`, and there is no concurrent write to this field.
+        let completed = unsafe { bindings::phy_device::autoneg_complete_raw(phydev) };
+        completed == 1
     }
 
     /// Sets the speed of the PHY.


