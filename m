Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1724D330D35;
	Thu, 16 Jul 2026 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210042; cv=none; b=aE7+4hlrZVBWAwWhSxjYgVwDQ+Maes3c901eflQaMTyzXDqrxm23566Zf7O1Mw78Zdu9syDTsVtmlDikRAHEMwvYKQTemj7VhbZsnUhHxkxj2cWr7lqkr0X/vMtDVcE8wELyedpUj9KvBtAfuRVofaqgPRf4Jkg/rcwTA2i1EJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210042; c=relaxed/simple;
	bh=JwEzYZSo1K4MERnMctkJnBvhlK98sJay0zGHMYXdUV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzuzAKS103XebucciAKlstzKKoxE/DmC4L0v5h5qtAxlsGqYg6hSuEXFSjD0bcOg2ok2j72nNcfYaodYhcYU1n17CzLC7Adv3U4v/1EaeI9JlgZYKGZIKx/gsmYx3vUclNNwCHNUUdK3AcL3vVD3vX0NYLN6FiZS0r/xRaxb7V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJqJoKC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJqJoKC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48211F000E9;
	Thu, 16 Jul 2026 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210041;
	bh=3aRwX4OiBOIFh89Yn0OGdnZ9vNKTma4GTV0INQes5EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJqJoKC9N3q+DkTjCeUeLq7CgZ+vuoIOG6KtY9LD/cner81iIQxLaGP0gkmQp06e/
	 g/3S1VjKUbuJ2q0eydOfukqno8TYABoNE6caOwH6rqpHs6vfGQKwkigToN6Iqzg4Ku
	 ScU8pPhiZ8nqX6bUak3xa1Fk9FAmEQRef9+RipTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	stable <stable@kernel.org>,
	Nicolas Pitre <npitre@baylibre.com>
Subject: [PATCH 7.1 416/518] vt: fix spurious modifier in CSI/cursor key sequences
Date: Thu, 16 Jul 2026 15:31:24 +0200
Message-ID: <20260716133056.940259242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <npitre@baylibre.com>

commit e9ad4d5ca309cb517d3f7a85251c3c5328f40f1f upstream.

csi_modifier_param() builds the xterm modifier parameter from
shift_state, counting KG_SHIFTL/KG_SHIFTR as Shift, KG_ALTGR as Alt
and KG_CTRLL/KG_CTRLR as Ctrl in addition to the canonical KG_SHIFT,
KG_ALT and KG_CTRL.

That is wrong when those weights are not plain modifiers. Keymaps
derived from XKB layouts (by kbd's xkbsupport, and by the
console-setup used in Debian, Ubuntu and others) encode the active
layout group using KG_SHIFTL/KG_SHIFTR:

	group 1: -
	group 2: shiftl
	group 3: shiftr
	group 4: shiftl | shiftr

So while a non-default layout group is selected, KG_SHIFTL and/or
KG_SHIFTR are set in shift_state with no Shift key held.
csi_modifier_param() then adds a spurious Shift to every cursor and
CSI key: pressing Up while group 2 is active emits ESC[1;2A (Shift+Up)
instead of ESC[A. KG_ALTGR has the same problem since it is the
standard third-level selector.

Normal keymaps bind the physical Shift/Ctrl/Alt keys to KG_SHIFT,
KG_CTRL and KG_ALT, leaving the left/right and AltGr weights free for
layout and level selection. Count only those canonical weights, so
genuine modifiers are still encoded while layout/level selectors are
not.

Fixes: 4af70f151671 ("vt: add modifier support to cursor keys")
Reported-by: Alexey Gladkov <legion@kernel.org>
Closes: https://lore.kernel.org/kbd/aj2gR0Y7sM6i9s2G@example.org/
Cc: stable <stable@kernel.org>
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://patch.msgid.link/20260626024833.3419086-1-nico@fluxnic.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/keyboard.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index dfdea0842149..763a3f1b7be0 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -765,16 +765,22 @@ static void k_fn(struct vc_data *vc, unsigned char value, char up_flag)
 /*
  * Compute xterm-style modifier parameter for CSI sequences.
  * Returns 1 + (shift ? 1 : 0) + (alt ? 2 : 0) + (ctrl ? 4 : 0)
+ *
+ * Only the canonical modifier weights are counted. The left/right variants
+ * (KG_SHIFTL, KG_SHIFTR, KG_CTRLL, KG_CTRLR) and KG_ALTGR are commonly
+ * repurposed as keymap layout-group or level selectors rather than as plain
+ * modifiers (for instance XKB-derived keymaps select the layout group with
+ * KG_SHIFTL/KG_SHIFTR), so counting them would encode a spurious modifier.
  */
 static int csi_modifier_param(void)
 {
 	int mod = 1;
 
-	if (shift_state & (BIT(KG_SHIFT) | BIT(KG_SHIFTL) | BIT(KG_SHIFTR)))
+	if (shift_state & BIT(KG_SHIFT))
 		mod += 1;
-	if (shift_state & (BIT(KG_ALT) | BIT(KG_ALTGR)))
+	if (shift_state & BIT(KG_ALT))
 		mod += 2;
-	if (shift_state & (BIT(KG_CTRL) | BIT(KG_CTRLL) | BIT(KG_CTRLR)))
+	if (shift_state & BIT(KG_CTRL))
 		mod += 4;
 	return mod;
 }
-- 
2.55.0



