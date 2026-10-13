Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A41501F28;
	Tue, 13 Oct 2026 12:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893331; cv=none; b=R8z4xkVhTrooH0Ikpo2cQM9nBNnb98PtzRPmviJYYEXD8J2f7Do/4EUPX9xiFQjJ9o0WLiuz/+yMGgXlDuXv4ocypAfyZ+pgNBl7LGRn2j+bTaJxPYlPSta0qnSWmyIVTmj10U6HJ/Z3QGpjQjqNqMTxYJEZdaE8dAtlXxzk/xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893331; c=relaxed/simple;
	bh=Uw8ZsBLds7uhlxqgRHoNvvavZkWARRJ7vuxCDQI1VuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFZ/nFxcemEvegXnPJZpCcagRY2ijLxIY6KvDKMjz3pSOwhSfZAe0ZiQqoi3fSheN2RX74UlxOQvl6tRoFlzntkv/n+Jue6OcqDSHRj1wwMRS0jrxpl8Ewh6MWWDpXtoTGkC/umsS/ttFH6u/RsWPUeocXYUXNOV47adDcJ6MA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAfx10FR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAfx10FR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1191F000FF;
	Tue, 13 Oct 2026 12:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893330;
	bh=rUcwrrgBgWxBkzxW5QkSkrILJD/jSyFKeWEz41OITRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAfx10FRnw7X3r8HSfAUVSUfg+tEJyC55sZHCdLVeB4sHamW8+whjFrldUXnETwDx
	 Megx+MjvOw65yQCP4YEnBgLlIshezXzmeqmjO245wi4S4pQAVkl9VsUxyfIX06mEDo
	 OdMMF0jTdsu199m1cYcneII33AbTfNNTcC4n3/FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Farhat Abbas <fabbas@cloudlinux.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/621] scsi: qla2xxx: Completely fix fcport double free
Date: Tue, 13 Oct 2026 13:33:04 +0200
Message-ID: <20261013112925.347950438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 5ad867c6f26eb..9a3adf40e0d7c 100644
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



