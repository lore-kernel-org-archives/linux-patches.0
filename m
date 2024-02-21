Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B4A7BB01;
	Wed, 21 Feb 2024 13:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521453; cv=none; b=Zu/mIlIFKNtCfRLikz19uYCGrA7z+f9g8RQMCZZoH5Cxg5Kk/c+vWSJv17Qgb8OHdlffB7COHjHDHsxLcVchqqiJ+qroqyr7ZdJkEOdzqpUnC2+ZGqvd9Ir1yQTW4bLE/Z3ckgoGGCqQ0xhLmCtNsHgjgo5LwoDyv7r0xU4ZyMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521453; c=relaxed/simple;
	bh=GY04X0Fz5lmuseDgAm3d1RuPHEykwowQS+Irnhk9/Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pReEWtBXFc7HbQTLViqQzCEYmcIlgwjkB3miQXfiTkAxOix4kOEuO7wD+cI25rBTPYd53IQ8s0Qk0MENTsjdozFZmLbGmq5kxpHv+CHkvR4G0uRupCnEbGeveCAxrSpOJfusVRl4OKu82M3ib2kyyRsys2BHmZEfYbYJuYQQ7P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkRLcOGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkRLcOGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D434CC433C7;
	Wed, 21 Feb 2024 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521453;
	bh=GY04X0Fz5lmuseDgAm3d1RuPHEykwowQS+Irnhk9/Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkRLcOGZ3VJEv/vJDdF9D/abBy6lONhZFK7qsYwZBYOG1u+J1rI29baELbAPcx3Jv
	 cAJsJB+6pR17MXZTWtE2VKlBbU+tJwVEyQz6qvr8biv41lOx7NSfAGaDtDYAx08/zj
	 ihakYPUc83W35R3gp/Ex5q9XVsSKYezVL35EtEF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/202] scsi: lpfc: Fix possible file string name overflow when updating firmware
Date: Wed, 21 Feb 2024 14:06:16 +0100
Message-ID: <20240221125934.238862144@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit f5779b529240b715f0e358489ad0ed933bf77c97 ]

Because file_name and phba->ModelName are both declared a size 80 bytes,
the extra ".grp" file extension could cause an overflow into file_name.

Define a ELX_FW_NAME_SIZE macro with value 84.  84 incorporates the 4 extra
characters from ".grp".  file_name is changed to be declared as a char and
initialized to zeros i.e. null chars.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20231031191224.150862-3-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      | 1 +
 drivers/scsi/lpfc/lpfc_init.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 706aca3f7c25..53b661793268 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -32,6 +32,7 @@
 struct lpfc_sli2_slim;
 
 #define ELX_MODEL_NAME_SIZE	80
+#define ELX_FW_NAME_SIZE	84
 
 #define LPFC_PCI_DEV_LP		0x1
 #define LPFC_PCI_DEV_OC		0x2
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c6caacaa3e7a..7db4e893e10e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11428,7 +11428,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 int
 lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 {
-	uint8_t file_name[ELX_MODEL_NAME_SIZE];
+	char file_name[ELX_FW_NAME_SIZE] = {0};
 	int ret;
 	const struct firmware *fw;
 
@@ -11437,7 +11437,7 @@ lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 	    LPFC_SLI_INTF_IF_TYPE_2)
 		return -EPERM;
 
-	snprintf(file_name, ELX_MODEL_NAME_SIZE, "%s.grp", phba->ModelName);
+	scnprintf(file_name, sizeof(file_name), "%s.grp", phba->ModelName);
 
 	if (fw_upgrade == INT_FW_UPGRADE) {
 		ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
-- 
2.43.0



