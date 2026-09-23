Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AF453A3A5;
	Wed, 23 Sep 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174850; cv=none; b=sTphWipwgnCk6oTAKFXvGNoSCmIHlEYMCtl0No4FoNwBnzcyLfhuWoqT588QDK9r+rD3yA9Iq5x+V3jBxrXbqHcflBUFeKVF++EdkL8n2gktgqqkUOAgo3jFOxKr7+7xMStvXHrSdS8LqlqhuJm5MtwxwI0djkcDc1/I0JPbg9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174850; c=relaxed/simple;
	bh=XJ/hOmX6mXjOdXpmZbrg7Ci2RcofFimxYAHx+YUptIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASCDqVmhRt3n0olF0B3wA3pLgce06zy01ToMdrCzF3T3rZEmtyT2TVuWm4QDdEPEKmu2RXSgr5IS1bmuWvp4Fjgr8XBVRbTGwjVfivA3uduo2tog0gUzxSLrZvajFQKzjwOTU3n6tuPvYpg1VbOOCPFS+B9oYZB6WZb6elyGpjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lToq00Zs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lToq00Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BCD1F000FF;
	Wed, 23 Sep 2026 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174848;
	bh=u+MPBWmyR3f6tJ6at2K/xAWOKeRmKRGBeQyLU+C/SgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lToq00ZsB5Hjv68dH/ekZhPXkwJJLNbFhj5LjDUJC5st8M2tfSk+5ylm+N5hDZsvS
	 vACu/uD7i5GeUsIlZQz26IxY+VBtUPD8XjdlZja0xHSb6zR4DtSvdkio0DLZXMyhV5
	 /SFnAdc9uBtsvdscIGV6d7oqsO6uO1d9OznzaD+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunfeng Song <springbreeze@stu.pku.edu.cn>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positions in device status accessors
Date: Wed, 23 Sep 2026 16:04:44 +0200
Message-ID: <20260923140648.864493062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
 rust/kernel/net/phy.rs | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/rust/kernel/net/phy.rs b/rust/kernel/net/phy.rs
index 956cda573ddb..c4e7b1d6c6f4 100644
--- a/rust/kernel/net/phy.rs
+++ b/rust/kernel/net/phy.rs
@@ -123,39 +123,37 @@ pub fn state(&self) -> DeviceState {
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
-- 
2.55.0



