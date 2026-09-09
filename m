Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664322EB874;
	Wed,  9 Sep 2026 14:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964157; cv=none; b=IRSnsNf3n3PZEviRkjM1a2v1m2UD2GQtjAeAc68FThyHtaj139RiKjVjvMGY7IDjJIFZ66y8ab+dUSrwcFDbWR8gb7A8++MsjWrXPLi0hlyUz5YQOMnMQFeIrKCuQgCd+umfYUWSZPsd7jNOhq3qU14qTbQ6QuANJK4NkcfGU5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964157; c=relaxed/simple;
	bh=8W4g2NGh7kqQed7yrISWC7PUu0gZF1SD018QuhOxiK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhtWPaNgUrg+0g64t5+Hmclg4tz6yAmWPjpmJVb4hDadLvR59iG6jmOmvBZB24P+o+reFsd4eps4ibSJKKbvQmrDGrtbwbBH/iI+vs006Wt/YkwaHSLYS6UsqGn2Dq3SmrgDxPpFGQR1aKzWNj9qKy2o7U7ydNpVd9KuFXUI3xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4LE80K4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4LE80K4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDA31F00A3A;
	Wed,  9 Sep 2026 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964156;
	bh=XO2D/XcEyueroxBKy14busHTql9CgIlAZYnUfijprfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4LE80K41a79L2HD82msj/RoEglrBywDytd/PTWx8THHnJtXL73RMsJiqA3b85LPu
	 SJnUm5NK9KdowQsnownAePVJ04dFTPHtAMJ3EIoLfxkEW2bHzQ7QYnyf/ee5d+c1hA
	 h2EMiu/Qwgm5fp71DNDetugwgUijc+DFXArmhH1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 327/583] scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
Date: Wed,  9 Sep 2026 15:40:12 +0200
Message-ID: <20260909134249.323124629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 793cedee296fd819bfadc2a7ec4d52faf9c09a0a upstream.

In the format 1 path, the virtual port is located on ha->vp_list while
holding vport_slock, but the lock is dropped before vp is used:
qla_update_host_map() is called and VP_IDX_ACQUIRED/REGISTER_FC4_NEEDED/
REGISTER_FDMI_NEEDED are set on vp. No reference is taken across that
window, so a concurrent qla24xx_deallocate_vp_id() can tear the vport
down and free it, leading to a use-after-free.

Take a vport reference (vref_count) under vport_slock when the matching
vp is found, and drop it after the last use of
vp. qla24xx_deallocate_vp_id() waits for vref_count to reach zero before
unlinking and freeing the vport, so the pointer stays valid. This
matches the reference idiom already used by the other ha->vp_list
traversals.

Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-51-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4146,6 +4146,7 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			list_for_each_entry(vp, &ha->vp_list, list) {
 				if (rptid_entry->vp_idx == vp->vp_idx) {
 					found = 1;
+					atomic_inc(&vp->vref_count);
 					break;
 				}
 			}
@@ -4163,6 +4164,8 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
+
+			atomic_dec(&vp->vref_count);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);


