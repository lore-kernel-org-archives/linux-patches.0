Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D00D2D7810;
	Wed, 25 Feb 2026 06:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002631; cv=none; b=dutY+kueqW+1d/ueWmR3NbWLdDm47kJph96hF3SCt1twvWDQf8SDByBX2g41IXoluakpnY0cos53uqHRd9wm35d1RikP26JFVI/rtcS+jfxwpWVIftohdM0bAC5Oz8AhFSLbBxuVtieyPFiB7uUoIlf9p4WRtHRPxUNghcBe4cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002631; c=relaxed/simple;
	bh=CjUSKwflgaRtygOlzDTP90hX1YCBXuce4idtO5Tzq9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma1ew8ygZmYYS8JfZiD+fL5zNnMxJwKVZLrF6En3dbT0WryBI1c3KrrEhRXWJB35n/RNBmjsvea45VxM8SqieVLzZHaftSUQGM1UsLNxv85kUM+HtfroUIrIdj1Y0TKIrDORJBE0zOJ196kvxKf/Vdipxu18CrMA9rLIJ5oPZU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pu0rf1xi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pu0rf1xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10A3C116D0;
	Wed, 25 Feb 2026 06:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002631;
	bh=CjUSKwflgaRtygOlzDTP90hX1YCBXuce4idtO5Tzq9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pu0rf1xispj8RUygtax+ER06xqtRMbbOp593A6VlLoBGZZIHYCrEbO/BYeIuou268
	 lyi7fUnSuXYJ3KdvUfzWN/4+49IMjDhMys15rMSSpI5xtpsMtHANrOzf3S+lRL5I5K
	 RJWkUSi7T07NyLpHAb5zMPJkXj3oZI1+TxKBv9iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 393/641] scsi: csiostor: Fix dereference of null pointer rn
Date: Tue, 24 Feb 2026 17:21:59 -0800
Message-ID: <20260225012358.098002986@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 1982257570b84dc33753d536dd969fd357a014e9 ]

The error exit path when rn is NULL ends up deferencing the null pointer rn
via the use of the macro CSIO_INC_STATS. Fix this by adding a new error
return path label after the use of the macro to avoid the deference.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20260129155332.196338-1-colin.i.king@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 34bde6650fae0..356a7c577ec3e 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2074,7 +2074,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		goto fail_ret;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
@@ -2220,6 +2220,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
+fail_ret:
 	return FAILED;
 }
 
-- 
2.51.0



