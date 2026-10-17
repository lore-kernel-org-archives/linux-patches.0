Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FE13C4B8D;
	Sat, 17 Oct 2026 18:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260693; cv=none; b=uE4Bof+fHAEjmVKmJJ1YJYuz8+XQ2GReROwSXq3H+VWSoxn22m+glO6jtMNkyAFXqhA9rxqKguWbdRGx+bwdCjLNDdnkAPGwSUIqrqe/BLmk+woZTtdYXaDmX+aRw5zbTqPok7vwfCKTrIupXAp3zC3iwIx2OgGYp7lAapJx25A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260693; c=relaxed/simple;
	bh=C9Q/dgrWw6N91ssPHAwIqrycYaeZU8iwnCYh5lk/pSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVs2Bgag+J/oAgpyHy1LqwGRuIvHMR3LDtRxN/msDy/pnkYAsKJRgW54wYCHt+H6mJBky8maLfI3wi2z9aigFiptO2Xg6nWKG4tfGrqyqzn4BAbWf6hK7WFJxxgaVD3/F4SWIm8dURsNoFjhu5/7T+HokZEHXqSiVsMTywNBO1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKaPmDEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKaPmDEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B97F1F000C4;
	Sat, 17 Oct 2026 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260692;
	bh=/dxZ1jLppDqOcc3dE/CeRmcDc4JNAbIMotCNDPvxj/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKaPmDEtkKT8u5BX5UP988V6Pbn+F2VTjgrhJsL0WrZjb5+4zDmEBJIasnNV34Z2E
	 uEwSYDFHzHqLYhiNwkOn7sqMS76zEQLes6atfe+7UeXEEr26g6wXTNCcrH9BvefisG
	 8VqRaj1A35vcgrA7G/J3XW9bDu+CELYGXL7ANTTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1588/1674] scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
Date: Sat, 17 Oct 2026 18:04:20 +0200
Message-ID: <20261017160511.850634970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 878613ecb5a36db26859c4fd83daf9283a334fa2 ]

The VP control IOCB selects its target virtual port by setting one bit
in vp_idx_map, a fixed 16-byte (128-bit) array in both
vp_ctrl_entry_24xx and vp_ctrl_entry_24xx_ext. qla25xx_ctrlvp_iocb()
computes map = (vp_index - 1) / 8 and writes vce->vp_idx_map[map]
without checking that map stays within the array.

max_npiv_vports is taken from firmware and only sanitized to a
MIN_MULTI_ID_FABRIC-aligned boundary, so it can legitimately be 191 or
255, and qla24xx_control_vp() only rejects vp_index >= max_npiv_vports.
A vp_index above 128 therefore yields map >= 16 and an out-of-bounds
write of up to 16 bytes past vp_idx_map, corrupting the trailing IOCB
fields (or the adjacent request-ring slot on the 64-byte layout).

Reject a vp_index that cannot be represented in the IOCB bitmap in
qla24xx_control_vp(), and add a defensive ARRAY_SIZE() guard in
qla25xx_ctrlvp_iocb() before the write. Adapters that report the usual
63 or 127 NPIV vports are unaffected.

Fixes: 2853192e154b ("scsi: qla2xxx: Use IOCB path to submit Control VP MBX command")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-49-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++++
 drivers/scsi/qla2xxx/qla_mid.c  | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0a013f34143af..c8a44969a6c30 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3833,6 +3833,12 @@ qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
 	 */
 	map = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) / 8;
 	pos = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) & 7;
+	if (map >= ARRAY_SIZE(vce->vp_idx_map)) {
+		ql_log(ql_log_warn, sp->vha, 0x307c,
+		       "ctrlvp: vp_index %u exceeds vp_idx_map capacity\n",
+		       sp->u.iocb_cmd.u.ctrlvp.vp_index);
+		return;
+	}
 	vce->vp_idx_map[map] |= 1 << pos;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 44dd9373bfb12..86c0217d1763e 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -962,6 +962,14 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
+	/*
+	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
+	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
+	 * if firmware advertises more NPIV vports.
+	 */
+	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+		return QLA_PARAMETER_ERROR;
+
 	/* ref: INIT */
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)
-- 
2.53.0



