Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFC5762C1;
	Wed, 21 Feb 2024 13:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523736; cv=none; b=fic1a2UVqv1V8bY8menHktRb+F3jODanT7PfViNbtC0gtaZ4Aekz+L16mCPlWXzDXFuQULVWU46tC9VMN/yTufWBrTeev4hInSkj+la2hKz09qnHdbOj/cJ4hUYYPxrhBsjmyWEfWlyYGVcSCvy6lXEZfbKVMUVq1JZv+mD0wko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523736; c=relaxed/simple;
	bh=4WFsQ1H+fe+oP8VM0QWYBjJCDKqCoRrM6P75oaLCimY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y567RC0cxAgbw35q4Ek1ycQGWnYtuoJV2rLcPAdLjkFw3m7U0hrHOQg4k2HD7U+ONtpGI+op4SQLE0T2j3cR9oxqg39Q6sVPsGXaUDCGeG+sgmWfUXKAcLQ1tdRmGN1s5ZoPnW1NcfHMrAvV+UPzA0+ujhQtD6JHzqy2cpEJ08g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAp0m3V/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAp0m3V/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AB3C433F1;
	Wed, 21 Feb 2024 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523736;
	bh=4WFsQ1H+fe+oP8VM0QWYBjJCDKqCoRrM6P75oaLCimY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAp0m3V/t52EtuYWc5CJck2BBhbIienTkwKIxxqEusqGADcHdrtnN/6dBBo7d9LNK
	 ro1pfPBQ/DhDB2FRSsp+2l8M0aBArEjGMSCgBq6WGdYkmKtbYCaZOntF7nID9QTfjn
	 FKRr9vVgQNxWMc4m0w2yga1MjEQkvAjBIRGE6/yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/379] bnxt_en: Wait for FLR to complete during probe
Date: Wed, 21 Feb 2024 14:03:43 +0100
Message-ID: <20240221125956.221107894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 3c1069fa42872f95cf3c6fedf80723d391e12d57 ]

The first message to firmware may fail if the device is undergoing FLR.
The driver has some recovery logic for this failure scenario but we must
wait 100 msec for FLR to complete before proceeding.  Otherwise the
recovery will always fail.

Fixes: ba02629ff6cb ("bnxt_en: log firmware status on firmware init failure")
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240117234515.226944-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 584f365de563..059552f4154d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11331,6 +11331,11 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 
 	bp->fw_cap = 0;
 	rc = bnxt_hwrm_ver_get(bp);
+	/* FW may be unresponsive after FLR. FLR must complete within 100 msec
+	 * so wait before continuing with recovery.
+	 */
+	if (rc)
+		msleep(100);
 	bnxt_try_map_fw_health_reg(bp);
 	if (rc) {
 		if (bp->fw_health && bp->fw_health->status_reliable) {
-- 
2.43.0



