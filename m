Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510E30CD94;
	Mon, 13 Oct 2025 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369930; cv=none; b=mz0ZuQYVZBPmKc9ZDkqnLLnLDXrXLCEm2+8J4OTVoHzyygjclKlYHX/4HAK/VbNyduyUVFbnGfo3w9F6KyxRI8uWIsX4PVscmZwx8ut7g3DnIpA7Z6hsokQJe4B0qXptZMBgbyHC6r7OHySk9n0ZpsUzjocbgZgVNtQl6oGrr7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369930; c=relaxed/simple;
	bh=0YkN3ixfBKpUPnDqLCMuaVAdv2B6GmZm0E7cOq0onVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPjSSmoOECB/FF9AR0z7+iW7zSlJ6mirtjBIlIkTplAJ3FXd2rHh6z9gajdgXRTXyIJpbKE1uxQvWjKWwvn4g+KBxCAkwdOw7+2EDjST0nSXXzaJffP4FVbLp9GEfjFsRw5w2hWu3cGu8ATEBUtcVRkKiDrknQu4YxwCfnTugEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xiv1OWzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xiv1OWzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91D2C4CEE7;
	Mon, 13 Oct 2025 15:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369930;
	bh=0YkN3ixfBKpUPnDqLCMuaVAdv2B6GmZm0E7cOq0onVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xiv1OWzcs7yz8XZnN2lP5xjQtRq3x2Ltj28WWdfKm09nKdvS+r/hgCFzna0NTsWYc
	 aD2fMJHQyahXhsN5CHvJVHHp62ktwonwKWkGfXmTpZ9X1VS6ZBAlsbz5txmskEkHqg
	 OB4IMYCiARiIf8lfj2aIeX+weKWh47EeSRfC8qiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 375/563] scsi: qla2xxx: Fix incorrect sign of error code in qla_nvme_xmt_ls_rsp()
Date: Mon, 13 Oct 2025 16:43:56 +0200
Message-ID: <20251013144424.861750106@linuxfoundation.org>
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

[ Upstream commit 9877c004e9f4d10e7786ac80a50321705d76e036 ]

Change the error code EAGAIN to -EAGAIN in qla_nvme_xmt_ls_rsp() to
align with qla2x00_start_sp() returning negative error codes or
QLA_SUCCESS, preventing logical errors.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Message-ID: <20250905075446.381139-4-rongqianfeng@vivo.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8ee2e337c9e1b..316594aa40cc5 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -419,7 +419,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(PURLS_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < PURLS_RETRY_COUNT)
-- 
2.51.0



