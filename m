Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BA3535FD6;
	Wed, 30 Sep 2026 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790026; cv=none; b=RJHXOhNi3iQNJQN8Lhw0Bf8T3KHKZlxXVSQsRpOJeuaUs0wAFms4vElnGpkZkSrMQrq2pEvU+Spt19o72QDCA5XLI4iZpRHDRopJnZPoqvAF8QjIinir0NQPdtk9nPnSNM38AnDlOHR94idWQvajX8wd/Eth06dCw1ocYsF8wjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790026; c=relaxed/simple;
	bh=Te1YxiogU0CtggRrEm24fIN6+lohXwvz7pq4+bE3tnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaIU8myauLgvXpQl356XQae29jg1mS8v98wmMXkku20792hkw5Sb0ZrUW5Seul1SqEU0fDgGKi1vwU4eiuDFsv6T0r1mk1qGQ7dF3uumri3TmDNWyViL+/+dAL9KdnlFvyFNq5/s7KwrDjMYrHNlcXhxJ3PLr1JgqIPfFIRHIlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXVJ2M8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXVJ2M8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBEE1F000FF;
	Wed, 30 Sep 2026 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790025;
	bh=/YT9rhxYfiMoBJk2XZZQvHRWEoENiLhLDXxc1w5vCWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXVJ2M8VUtB0Pu7Tby69QJgV8oV47kloo8WoizmqQ32a4kziPx4M6LE+jO4fiEPAT
	 Th0oPPGNTxo1ftYcjps9ksncWyHx1yHLajWNcj6x0u8g1JjuYSuYSktRnXSp48qwZJ
	 MX687wmOtF/MfnF8IsWFYttEmcYYHy8olew3wxFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 682/877] scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity
Date: Wed, 30 Sep 2026 17:26:33 +0200
Message-ID: <20260930152429.392901811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 2ac6a829843cf3df522d19e091276109b94c4c7a ]

ha->max_npiv_vports is taken from firmware (mcp->mb[11]) and only
constrained so that (max_npiv_vports + 1) is a multiple of
MIN_MULTI_ID_FABRIC, which permits values of 63, 127, 191 and 255.
NPIV vports are then allocated up to that count.

VP enable uses the VP_CONFIG IOCB, which addresses a vport through a
plain vp_index byte, so a vp_index beyond 128 is enabled without issue.
VP disable, however, uses the VP_CTRL IOCB, which selects target vports
through the fixed 128-bit vp_idx_map bitmap. qla24xx_control_vp()
rejects a vp_index past that bitmap and the IOCB builder cannot set a bit
beyond 127, yet qla24xx_vport_delete() frees the local state regardless.
A vport with vp_index > 128 can therefore be created and enabled but
never disabled, leaving it permanently active in firmware: a resource
leak.

Cap ha->max_npiv_vports at init to the vp_idx_map capacity so such
vports are never created. This collapses 191/255 to 127 (still
modulo-valid) and leaves the real-world 63/127 cases unaffected.

Fixes: 4d0ea24769c8 ("[SCSI] qla2xxx: Retrieve max-NPIV support capabilities from FW.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-20-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ adapted the qla24xx_control_vp() hunk to include the prerequisite bounds-check block missing from this branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_fw.h   |    4 ++++
 drivers/scsi/qla2xxx/qla_init.c |   13 +++++++++++++
 drivers/scsi/qla2xxx/qla_mid.c  |    8 ++++++++
 3 files changed, 25 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1442,6 +1442,10 @@ struct vp_ctrl_entry_24xx {
 	uint8_t reserved_5[24];
 };
 
+/* vp_idx_map is a 128-bit (16-byte) bitmap selecting target VPs. */
+#define VP_CTRL_IDX_MAP_BITS \
+	(sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+
 /*
  * Modify Virtual Port Configuration IOCB
  */
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4408,6 +4408,19 @@ enable_82xx_npiv:
 					    MIN_MULTI_ID_FABRIC))
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
+
+					/*
+					 * The VP_CTRL IOCB selects target VPs
+					 * through the fixed vp_idx_map bitmap,
+					 * so a vp_index beyond it can be enabled
+					 * via VP_CONFIG but never disabled via
+					 * VP_CTRL, leaking the VP.  Cap the count
+					 * to the bitmap capacity.
+					 */
+					if (ha->max_npiv_vports >=
+					    VP_CTRL_IDX_MAP_BITS)
+						ha->max_npiv_vports =
+						    VP_CTRL_IDX_MAP_BITS - 1;
 				}
 				qla2x00_get_resource_cnts(vha);
 				qla_init_iocb_limit(vha);
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -970,6 +970,14 @@ int qla24xx_control_vp(scsi_qla_host_t *
 	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
 		return QLA_PARAMETER_ERROR;
 
+	/*
+	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
+	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
+	 * if firmware advertises more NPIV vports.
+	 */
+	if (vp_index > VP_CTRL_IDX_MAP_BITS)
+		return QLA_PARAMETER_ERROR;
+
 	/* ref: INIT */
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)


