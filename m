Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4127515968;
	Wed, 30 Sep 2026 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786906; cv=none; b=Iwt88I5McBjcJtP6ho9SnCQ21KnPFVQj72SgaKA/m20Ww5NVA32x+1uP+LzquCWOw9TUCm3mHyL/EGcvsQr8Ed+9mYX5mv34muKenInSwScI7K9+jLUYIfwv3cCI1+t/RwM18zEZZovCJsY3Yb7hAx8QJIRhNjcTgH9Qzp0PiOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786906; c=relaxed/simple;
	bh=vbYnuK0w8HVblDI5tElyriPy0j6QEyJgdCDhNttgt3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isb4ihIDHILPxvEMkfIUPi0Zx9Co6uOAZxvR1/hdl0Bqdlf+3OgwGJkCA0VNFGfP5Q73NfuS4Z1sFB14PDsV43HdUyOQi3LTg1SzdFhHz4h1kskcbUGh3vmixbBmjtIcd/mHTkYf8nMbMdCFbpKOZQqqflhm4FiC7QT0pfDkrhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHvxHY0X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHvxHY0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098561F000FF;
	Wed, 30 Sep 2026 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786904;
	bh=j5hsej93twWbCTtwft7e6noM0V7sMYUBPv76HGtPmHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHvxHY0XEBQoXxTLbSTX6QR+DFY28bovpplEtN+4dnLOIQAo0ew4pC/wRBLaVfSk3
	 RreYrvmHlqmWGtGUS1Drs41OsZ7xB9MV44PZSnPETLrE+XQSCsWNbnmxlvkxc8aRfv
	 SsQOc8ZF7C1Z2ZrFjQ62cQ1ejVwA9DjQjP/pIxFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 042/457] KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save
Date: Wed, 30 Sep 2026 17:22:27 +0200
Message-ID: <20260930152346.944010811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit cc5d96036e01ac330d24b2f0c336d60f82ab4930 ]

vgic_its_save_device_tables() aborts with -EINVAL when a device's entry
falls outside the device table, which a guest can arrange on its own: an
indirect table lets it clear an L1 entry's valid bit without touching
GITS_BASER. That fails a save userspace should be able to issue
reliably.

Skip the device instead, and point the saved DTE chain past it, as
commit ad1e686e2378d ("KVM: arm64: vgic-its: Point saved ITEs at the
next valid entry") does for ITEs. compute_next_devid_offset() takes the
next device off the list whether or not it was saved, so the predecessor
would otherwise point at an entry the save never wrote. Restore follows
that offset while it stays inside the table being scanned: within an L2
block, or anywhere in a flat table. Both need userspace to remove a
memslot under the table, since dropping an L1 entry takes the whole
block with it and scan_its_table() stops at the block boundary.

Fixes: 57a9a117154c9 ("KVM: arm64: vgic-its: Device table save/restore")
Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/86bjaz5s6v.wl-maz@kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260821064445.615838-4-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index b9a6316f2e00a..7dc5ef5a6e33a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2024,18 +2024,22 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	return ret;
 }
 
-static u32 compute_next_devid_offset(struct list_head *h,
+static u32 compute_next_devid_offset(struct vgic_its *its, u64 baser,
 				     struct its_device *dev)
 {
-	struct its_device *next;
-	u32 next_offset;
+	struct its_device *next = dev;
 
-	if (list_is_last(&dev->dev_list, h))
-		return 0;
-	next = list_next_entry(dev, dev_list);
-	next_offset = next->device_id - dev->device_id;
+	/*
+	 * Point at the next device vgic_its_save_device_tables() saves. It
+	 * sorts device_list first, so the subtraction cannot underflow.
+	 */
+	list_for_each_entry_continue(next, &its->device_list, dev_list) {
+		if (vgic_its_check_id(its, baser, next->device_id, NULL))
+			return min_t(u32, next->device_id - dev->device_id,
+				     VITS_DTE_MAX_DEVID_OFFSET);
+	}
 
-	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
+	return 0;
 }
 
 static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
@@ -2275,17 +2279,18 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
  * vgic_its_save_dte - Save a device table entry at a given GPA
  *
  * @its: ITS handle
+ * @baser: GITS_BASER<dev> the caller is saving against
  * @dev: ITS device
  * @ptr: GPA
  */
-static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
-			     gpa_t ptr)
+static int vgic_its_save_dte(struct vgic_its *its, u64 baser,
+			     struct its_device *dev, gpa_t ptr)
 {
 	u64 val, itt_addr_field;
 	u32 next_offset;
 
 	itt_addr_field = dev->itt_addr >> 8;
-	next_offset = compute_next_devid_offset(&its->device_list, dev);
+	next_offset = compute_next_devid_offset(its, baser, dev);
 	val = (1ULL << KVM_ITS_DTE_VALID_SHIFT |
 	       ((u64)next_offset << KVM_ITS_DTE_NEXT_SHIFT) |
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
@@ -2384,15 +2389,16 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
 		int ret;
 		gpa_t eaddr;
 
+		/* Don't fail a save that userspace must be able to issue. */
 		if (!vgic_its_check_id(its, baser,
 				       dev->device_id, &eaddr))
-			return -EINVAL;
+			continue;
 
 		ret = vgic_its_save_itt(its, dev);
 		if (ret)
 			return ret;
 
-		ret = vgic_its_save_dte(its, dev, eaddr);
+		ret = vgic_its_save_dte(its, baser, dev, eaddr);
 		if (ret)
 			return ret;
 	}
-- 
2.53.0



