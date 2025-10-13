Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05E3271468;
	Mon, 13 Oct 2025 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367745; cv=none; b=H+U9vV3pDn2UdSrdzOG4JNd0/82CQJaCqUtMP/VrEH17kR8MhW+R6tQxzWl7RbITi6lCTC4KIjjT0QcqzlU4DNgLgR8IDUfYsk8usJ992RtVaWzfadEOZSNnievN3KFc+uCKYcceKCiukz0pV7OemZU8v6WLMDtrA1uDXg2ViAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367745; c=relaxed/simple;
	bh=w57l2UuXbaGrESFjwd6xaRXjQ2L8O7hI0nvMNBRKroc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeBf2w78T8MPiQVu10U+FbyqYBDnArRy1bSFhZwoYEJmxLcFIaU+kosGEuWhEszZYu/80rauOTAbIBw8b/CuwRNslvusVijxcN1RQcuSvlMX0+O3jAeoWd0/ZbWrRtkoK2cv7kpb/BbRsBWLwiIvHV7JcxIb13ZwBpp4ORAEKRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EP7Rdcjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EP7Rdcjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651A8C4CEE7;
	Mon, 13 Oct 2025 15:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367744;
	bh=w57l2UuXbaGrESFjwd6xaRXjQ2L8O7hI0nvMNBRKroc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EP7RdcjzTb9RKbRkt+b7QHYzsvytA8oZdnmwf52rKmcDhhSQZ2a5ZbUjeE1fCOpsB
	 xTuIk8PwCjKxeJFP7wfGi4BkFj+Va4TMjLPz/rzYQ1dnRVgPPd2uTSKGkeUzFNYP7c
	 2n6rhA9iDygC0JEDIFDFUKh4Nl8kAm7F7/djGYl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/196] scsi: qla2xxx: edif: Fix incorrect sign of error code
Date: Mon, 13 Oct 2025 16:45:10 +0200
Message-ID: <20251013144319.614750221@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index dcde55c8ee5de..be20e2c457b8e 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1797,7 +1797,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
@@ -3648,7 +3648,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
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



