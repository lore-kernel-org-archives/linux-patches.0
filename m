Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE4A330B30;
	Fri, 17 Oct 2025 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716210; cv=none; b=c0LqLs4QBvc6LohuGLm8zUhKAVvRlbYfkRwFMoC/igpbGCIGBKjFTHtyGUCEbLMzwrtTGvk88Tn/J4WQDUw2CpA7+1IxwVXzVeNJAa3j/OJB92SJ8Ieh12xstRlF5YUXsksrTGThMZi3MY4e7FtH6rXgJ/0RNtNt+i88MwNb1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716210; c=relaxed/simple;
	bh=UYtnd2OKhOq1zXXzIPcAsN/JFO5Z20hAEtmxiEfs9is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEXi48Yv2ByrZUiQhrdB3T9m7uVN3k/j5Didl/M5so9yyv7vw3R6jclQeF1SZFKiiXP3fpiFrSJmZyJGRvfu8Y4OLig+dPl2ZxzO7uLQOPHQMhXs+8qPsSMNYGMTekjDrZzbmqVJosbg2zsFl+aNSaOSF4rPjPmFr2rFL7KJ0Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIaeGvvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIaeGvvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75316C113D0;
	Fri, 17 Oct 2025 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716209;
	bh=UYtnd2OKhOq1zXXzIPcAsN/JFO5Z20hAEtmxiEfs9is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIaeGvvqzgBZmij1i9EA+ELa3uwdMLXbKnKllNfb2DLuAO/yLnmBlU0OeSqWGQ4e2
	 Bjjg/roqExH3PRC3pB6Oj+rJEhV1T5F1v4wbXMOmBH5DU2QUbHnMaNqj8gvNtnGgqU
	 LYw8LZkERo2GbapBVToTImDid5WedCxt7lIMvt8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/276] scsi: qla2xxx: edif: Fix incorrect sign of error code
Date: Fri, 17 Oct 2025 16:52:52 +0200
Message-ID: <20251017145145.372200366@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ac702f74dd984..dfc7bff420cda 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1539,7 +1539,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
@@ -3525,7 +3525,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
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



