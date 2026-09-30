Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0B751C06C;
	Wed, 30 Sep 2026 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793814; cv=none; b=OmgxSVHemqOxj+gUoLslJBjGrO+j0aNMaKVq2Xx4MKjGsvPpAZg0Am5vDjCjpu4k1FXfd7Z3R9DpmnCfHWQHDhhnSOJ5nVLAeaBEyokQ+O4e6UGjJcR99RUs3e1zgADxaFg4PLwuXE8IDsHP/61uX6VVxVApY98IEXNCdv95ss8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793814; c=relaxed/simple;
	bh=84vW5apAeRQbkqyx2eGK0VGE0Ahd5JfnNQp16SXhg3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5gC0UPF2FGznvhlZb99KjVTsi6NJyK5qKRaPYhffyurBMoc53GhWdSMQbcRduW2J9stcbgef8tPKQA6z4rmW3S7IgMSgOX0J9yrESE8fIXjY2AvJciK0J+r6bNhkp6ew9ZTJkrvHeZLUz5rzHJ93nYwl2hbbq3DIrGleGfr+Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ/xc1XW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ/xc1XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7311F000FF;
	Wed, 30 Sep 2026 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793812;
	bh=+FxYuOcNuUsQjFAIy3dheGdNNwzhLn7av33A4Tp4zdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZ/xc1XWg5oFOWdBHoNBoA6L1cvfclc0URkdzg/fIiv4CbPy734WXg0qJ9G1PadPg
	 JOorUDd8uHANAZ9bPwAV585WUbYg5AG45mSA4itg0bR3qLXUtazsEPVS4Lh0azXFLs
	 WsLAwT5wp3g3eOSx19V1+aLJW7tlq5JRqpoipzOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunfeng Song <springbreeze@stu.pku.edu.cn>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 387/395] rust: net: phy: fix off-by-one bit positions in device status accessors
Date: Wed, 30 Sep 2026 17:30:49 +0200
Message-ID: <20260930152349.099330265@linuxfoundation.org>
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
[ For 6.18.y, re-do the commit manually adjusting the bit numbers to
  make it work with the `bindgen` version available there as Chunfeng
  mentions in [1]. - Miguel ]
Link: https://lore.kernel.org/stable/SEWP216MB9770116738884C46F156A686FAF98D2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/net/phy.rs |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/rust/kernel/net/phy.rs
+++ b/rust/kernel/net/phy.rs
@@ -130,7 +130,7 @@ impl Device {
         // SAFETY: The struct invariant ensures that we may access
         // this field without additional synchronization.
         let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
-        bit_field.get(14, 1) == LINK_IS_UP
+        bit_field.get(15, 1) == LINK_IS_UP
     }
 
     /// Gets the current auto-negotiation configuration.
@@ -142,7 +142,7 @@ impl Device {
         // SAFETY: The struct invariant ensures that we may access
         // this field without additional synchronization.
         let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
-        bit_field.get(13, 1) == u64::from(bindings::AUTONEG_ENABLE)
+        bit_field.get(14, 1) == u64::from(bindings::AUTONEG_ENABLE)
     }
 
     /// Gets the current auto-negotiation state.
@@ -155,7 +155,7 @@ impl Device {
         // SAFETY: The struct invariant ensures that we may access
         // this field without additional synchronization.
         let bit_field = unsafe { &(*self.0.get())._bitfield_1 };
-        bit_field.get(15, 1) == AUTONEG_COMPLETED
+        bit_field.get(16, 1) == AUTONEG_COMPLETED
     }
 
     /// Sets the speed of the PHY.


