Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F160235A922;
	Fri,  9 Jan 2026 12:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960497; cv=none; b=lux/qWsNGrcHaWHk9qRDIzq4Xok2qju65Lc8cy/69PXrzJcQ6dAIGpRKN7E5czy7POif9WRSt8AfX3Uix3JcMa0lohmtf1fgH95GOsACN00qwHXMxmHGw492ZyiAjS8dtvx2a3hGWoyfL7eYXhOyBkW2oMWoz+iTA9oCHcPa+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960497; c=relaxed/simple;
	bh=Ca3pPDM0ra7CRO53DwaqfJvb06Djj8OnJgG2ZMWwia0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ4FOnCDP5SId4KVNK1S4aI5Kk5D/g0r1/Ivfi6vRd/EY3e17E2DUFjcmRN6xmUT3I1NzPQb5PcfUNzSVzs5qGmcMfazZlOEt/NXU3LPG9NyZ4eBqTAjeVtdKcYnAr1GF1fl26/Qt3ZBmWVzZszvVpTAyeSU0L9Ceh5+tA/CEis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEuJVhLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEuJVhLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819A4C4CEF1;
	Fri,  9 Jan 2026 12:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960496;
	bh=Ca3pPDM0ra7CRO53DwaqfJvb06Djj8OnJgG2ZMWwia0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEuJVhLlR4nbf7HFMoHYecFsACewZqX3PK62RtUXNGyHARh88rSYRRzbi5poP+Df0
	 rfpIlthLda+JneiBm8OONsin/PRbDpQ30oSC3WRuyxEnRWS6E7FEbWSoSFCV4YaGJX
	 cWoV46WTesZCkVTbQjr6SIF9UMbFMbWkm/ha+2tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 392/737] scsi: qla2xxx: Fix initiator mode with qlini_mode=exclusive
Date: Fri,  9 Jan 2026 12:38:51 +0100
Message-ID: <20260109112148.745013043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit 8f58fc64d559b5fda1b0a5e2a71422be61e79ab9 ]

When given the module parameter qlini_mode=exclusive, qla2xxx in
initiator mode is initially unable to successfully send SCSI commands to
devices it finds while scanning, resulting in an escalating series of
resets until an adapter reset clears the issue.  Fix by checking the
active mode instead of the module parameter.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://patch.msgid.link/1715ec14-ba9a-45dc-9cf2-d41aa6b81b5e@cybernetics.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0a3a5af67f0a..4c7cf581bc86 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3459,13 +3459,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mqenable = 0;
 
 	if (ha->mqenable) {
-		bool startit = false;
-
-		if (QLA_TGT_MODE_ENABLED())
-			startit = false;
-
-		if (ql2x_ini_mode == QLA2XXX_INI_MODE_ENABLED)
-			startit = true;
+		bool startit = !!(host->active_mode & MODE_INITIATOR);
 
 		/* Create start of day qpairs for Block MQ */
 		for (i = 0; i < ha->max_qpairs; i++)
-- 
2.51.0



