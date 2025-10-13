Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C7D3081D1;
	Mon, 13 Oct 2025 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368420; cv=none; b=SbtQlgDlexGYq+bW6gKuN/FNqZBpNxR0ScHSXmYCu8DlzzKm9ucr/0S1cku/9XODpj9HNmLCJ8FTF2VY4ngnpniinIsgwGi2oiE5919VGUe63lMavRINZ3v8+nmRNgbQGUoXgVNTTHCsPwHHuJyga3fRU0i9E0vQJ7wbAUV5LUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368420; c=relaxed/simple;
	bh=XKiya8boNgNUpgl3JiOzuUAoZA79lofCMbWTUQAtOaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQz9dtzIKI78/fz4ORP3oMO/fyZ2tTc+dBDOa42f1eOv2Cz/suRNFB3pXMr4quCCludygtAKoZi+3jMCV9Y9SK7GAVhRolbRfGVMh20LYpwAZtvzFItRQu9c6VFCJey4NkM7eYU/FuOtbB1A26/fuMlKA1/Of4nNesakbV/Yx3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HD4oXAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HD4oXAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05940C4CEE7;
	Mon, 13 Oct 2025 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368420;
	bh=XKiya8boNgNUpgl3JiOzuUAoZA79lofCMbWTUQAtOaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HD4oXALLCC/PgY8O3T7J6W42sDlfwwotedent8J1Byr+xrl+ZN6CD4J7zYUZqlXw
	 xomgEeXfqtrLeAaHZ2Vq8WzBj9o7eTZfptvO8UPJIxIfkkDDmNE7WcSUMrklkbdgEu
	 onZaFXFxOYAgpkiZvGZGUJorKkgID6bSnEHVmr4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/262] scsi: qla2xxx: edif: Fix incorrect sign of error code
Date: Mon, 13 Oct 2025 16:44:58 +0200
Message-ID: <20251013144331.739001491@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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



