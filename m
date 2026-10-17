Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6013238E8BB;
	Sat, 17 Oct 2026 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253886; cv=none; b=TFbuEuypiVCQgKaCduBPRxnXv/accH04VCtZmCzj2F9BntK1UsKwIMLHtdNHN/8fgrVJroGZfDT2pAZhKQtLFWC95nRuwkH7Nig+aBy4o1Tzi59Y/1cScxVfZVTBKVWcVPfYzzQe1RNLf2UGG/8SZqrYOav+GxortleOGjBQFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253886; c=relaxed/simple;
	bh=f3GIAeOWDYebSXg/eWPHZZubnjCcxyiNDM+LPttqwBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXfyeReu2KtjhXN2Ykibw0f0/OlGnzzCz7rWtmV86X616LwPagM+tKTBAwS846GhbpKigoLYuUt/r1bhG5rDvbedDf0U3rYfHeOhD++yq7KGTCd3+myuVn6m6sxIFlBYq5P7DtusPcWELQPSk2BktR58Y1YQrYc60/wOHEAm7uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aT8gsVOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aT8gsVOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9041F000C4;
	Sat, 17 Oct 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253885;
	bh=gsjS/lMzOyNG1a7hmJjF6uXYWnXSmK4+puMu2hS9zfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aT8gsVOlcZ2kEbsjNXOYKTSc7XArltnO5lrn/qvyhoXobgukQ+dgSX5tZUXZBlrE1
	 za7uO8L6oEILIlAbeZGPg5qARexSMadcSXfYEwd5SGHsxPfkuNxe/SOCNp+yunfEQ2
	 YodfHdFdwX7mvYtrKMFUHzR4xc83cOp61OJ+lEpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Farhat Abbas <fabbas@cloudlinux.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/869] scsi: qla2xxx: Completely fix fcport double free
Date: Sat, 17 Oct 2026 17:51:46 +0200
Message-ID: <20261017160043.856603627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit c0b7da13a04bd70ef6070bfb9ea85f582294560a ]

In qla24xx_els_dcmd_iocb() sp->free is set to qla2x00_els_dcmd_sp_free().
When an error happens, this function is called by qla2x00_sp_release(),
when kref_put() releases the first and the last reference.

qla2x00_els_dcmd_sp_free() frees fcport by calling qla2x00_free_fcport().
Doing it one more time after kref_put() is a bad idea.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Fixes: 4895009c4bb7 ("scsi: qla2xxx: Prevent command send on chip reset")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Farhat Abbas <fabbas@cloudlinux.com>
Link: https://patch.msgid.link/aYsDln9NFQQsPDgg@vova-pc
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 17231a8dab988..c8a44969a6c30 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2758,7 +2758,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2783,7 +2782,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
-- 
2.53.0



