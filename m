Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5DD28D8DA;
	Mon, 13 Oct 2025 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369805; cv=none; b=m6FTwj7AD8/aQbGMym8MNcdURK/S9aFNVndoerfhf3EcGHJh/UnVX3Q2GmQUtr3GoAx3idAi4lM7SgOYB5a4rphFTuz3kt5a4SO3BqJNHtlDkoAHch/oyO1U/M/pFDYg9ErN2yyIz6m8PKUmAkt+aujtJpw1vBH0xSTkRaf36X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369805; c=relaxed/simple;
	bh=zrzKMcvcgRkX2Qz1zXQfyC0TR9YrxevSSvUWViFjckw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdKDqZpkzG69XNeeDspgnFaSR766moqjSy/i2M336umoO9kOQF89TfpbE5CWaj2syfQ84Hs4XLTDB2Lbb6WBuMoEKvRoJYFQSdCBWf4CBTLOFJlghNQioAcU4ifkkVp3ZhLsfHhLlrIg9y4xLjoPtt/xI0QBZ9GT98dE7NbMcs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j26TtFry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j26TtFry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FDCC4CEE7;
	Mon, 13 Oct 2025 15:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369804;
	bh=zrzKMcvcgRkX2Qz1zXQfyC0TR9YrxevSSvUWViFjckw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j26TtFrysHQDlFT59+LnEXWC31y5tyveqjMzg/tDTR0TCefLbiwYesmfXPGzMBVLh
	 qzdqluACSTu+JdQkG/IrGl4NWFdY6MQv0IdN4Vr2AB7Cj3HyRFWFdT4mxd8yS9jf0A
	 uKVyRxfCLDyLEwIWRfJ339/TzV4sr/ixXKL7Sscw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 373/563] scsi: qla2xxx: edif: Fix incorrect sign of error code
Date: Mon, 13 Oct 2025 16:43:54 +0200
Message-ID: <20251013144424.788591343@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 066b8f3fa85c1be7fb7dbae202231e131d38f7bc ]

Change the error code EAGAIN to -EAGAIN in qla24xx_sadb_update() and
qla_edif_process_els() to align with qla2x00_start_sp() returning
negative error codes or QLA_SUCCESS, preventing logical errors.

Fixes: 0b3f3143d473 ("scsi: qla2xxx: edif: Add retry for ELS passthrough")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Message-ID: <20250905075446.381139-2-rongqianfeng@vivo.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 91bbd3b75bff9..ccd4485087a10 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1798,7 +1798,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
@@ -3649,7 +3649,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		       p->e.extra_rx_xchg_address, p->e.extra_control_flags,
 		       sp->handle, sp->remap.req.len, bsg_job);
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
-- 
2.51.0



