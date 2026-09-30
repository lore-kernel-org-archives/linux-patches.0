Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFCB51DDE8;
	Wed, 30 Sep 2026 18:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792938; cv=none; b=G5Dj2dkfB+MfNPG67jQG/8X1DXtc+UYa5iBzx+HtGBG4aJec2pgVb4yV9zSYdgJM7Qve+zAr/YT6Q8s/NS2frnXuYcGQqhvgI0VnCWk+8gTeFCR59drtk2Dpm78PNrKSYcRJo+ZagW1Yjy4xLfgpJKEyRLCauHg61RDQmZgNDlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792938; c=relaxed/simple;
	bh=glsCWxi7jR1KV2fORy0A4NTc91WbAlu3Ij3+wzJhtQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF5yjCkQdD/qKgJPqFpsUc1qnfQI03VSrgrotbrEAL0hWbvY9QKager5ckytm+pqLVZuyNPcEWsbVkQpEd1sjWKgbylNf6uD5AMJ8+tCcR3GKFOYfPNxsKQFmilChxQlBfz+h/rk4P+Lxm5SnfCKDFBAsyYO7wk64QYDRArVO30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SniOK8t1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SniOK8t1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D3A1F000FF;
	Wed, 30 Sep 2026 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792936;
	bh=S6rPMt0llyGqNDbwXmNbpH8PC7T977YL6efhg/Z5OzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SniOK8t1rdifTzlviqI6aDiTNj6BirqdBP3Jyy1US3KVo2W5DIK8SR5IxlhsQRRfS
	 jhKHGjwMAJl8jPfNMDZ31ud1E2fr7EtCmINjaokceYFGVWlRjO7IWZx3Afj6NkyAL/
	 ynYjVi8y5orYMjfvrdo8NN5JAVF9pFyCLFdNbZow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/395] KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save
Date: Wed, 30 Sep 2026 17:24:55 +0200
Message-ID: <20260930152341.340860852@linuxfoundation.org>
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
index 9b5f8d308fac0..763fa5dff1672 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2017,18 +2017,22 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
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
@@ -2268,17 +2272,18 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
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
@@ -2377,15 +2382,16 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
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



