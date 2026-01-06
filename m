Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F64629B77C;
	Tue,  6 Jan 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720760; cv=none; b=nPkharNSNDzBQiwBMAJP4jFQCEsscxp6pe/vt9YwUBU+Bf8LEt4Xw2sldQ4X0NDUqJsgbxjZqjnQQNRGD+n6yGpGgz4NytdTlBTxhg6ABI5S8pxoKJ5X/X8PjwJAoAHZ+JRGnw7g7sjKhTAGngl8+b1z0o5gL8pQASVex+wthVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720760; c=relaxed/simple;
	bh=2QqoQhBL1DUdYa8PVLC/SGB15lV4xbFlyIl5oHCXZ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+57SH/yKfdURCXBmS7JlXX3+s1Gkp6dcq1AU6Fas0QIE3209mdurB8guJTVbj5eeyT795ejgRBzwNKn3wFgRz8zmT+4aMVH/ZQmBBQnCpRNyEZCchKtZ3dfkDJdSKJEOYcyvIGKZHAd7YImO3Q72HbL5W+rn783fjofh8m5/D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwwJZ7m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwwJZ7m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F312CC116C6;
	Tue,  6 Jan 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720760;
	bh=2QqoQhBL1DUdYa8PVLC/SGB15lV4xbFlyIl5oHCXZ3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwwJZ7m8sIqU7X0Jk0rFINTsQSN2XAvwGyRX5OK99lgvmwZ0VxdHBBGVhxY8KXs7x
	 Z5nK7YE1oAAUUhypbKcWqO3qfpi5Z19hVjJ4WuAxSeQqqmBMxtfYwh6TIu/LnrN8/A
	 Y6BilnVDUzaxhT8ti/rKIBWF3ef9N3qrkeN2YNk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/567] RDMA/bnxt_re: Fix incorrect BAR check in bnxt_qplib_map_creq_db()
Date: Tue,  6 Jan 2026 18:01:55 +0100
Message-ID: <20260106170503.650197505@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 145a417a39d7efbc881f52e829817376972b278c ]

RCFW_COMM_CONS_PCI_BAR_REGION is defined as BAR 2, so checking
!creq_db->reg.bar_id is incorrect and always false.

pci_resource_start() returns the BAR base address, and a value of 0
indicates that the BAR is unassigned. Update the condition to test
bar_base == 0 instead.

This ensures the driver detects and logs an error for an unassigned
RCFW communication BAR.

Fixes: cee0c7bba486 ("RDMA/bnxt_re: Refactor command queue management code")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251217100158.752504-1-alok.a.tiwari@oracle.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 7a099580ca8b..38ded4687122 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -1117,7 +1117,7 @@ static int bnxt_qplib_map_creq_db(struct bnxt_qplib_rcfw *rcfw, u32 reg_offt)
 	creq_db->dbinfo.flags = 0;
 	creq_db->reg.bar_id = RCFW_COMM_CONS_PCI_BAR_REGION;
 	creq_db->reg.bar_base = pci_resource_start(pdev, creq_db->reg.bar_id);
-	if (!creq_db->reg.bar_id)
+	if (!creq_db->reg.bar_base)
 		dev_err(&pdev->dev,
 			"QPLIB: CREQ BAR region %d resc start is 0!",
 			creq_db->reg.bar_id);
-- 
2.51.0



