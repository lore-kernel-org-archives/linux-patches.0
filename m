Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9746413AD4;
	Sat,  3 Feb 2024 04:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933774; cv=none; b=bDH78Uuj68XA1eVKsmDV6j+CPq6IH99fk4ZBGHQpVjvhH/DNI1KV1jwHHEC8Tk4ZQj8pxxOn51QGHt9l4JQv4Y8hoET+t+ZH+ju91VIYCeJvng3/vIBUdnL93uWCGzocQ+dgjlmqJgJwOqXuCaecCubvqzNj1CHDtNmalKZtWyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933774; c=relaxed/simple;
	bh=jftSSsNse/Nqr4yYAc+goSCpCLooFDkJxh1z0h/oZ00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2mS/zXQxz9JNhLU4zjQ0vELe1GThFpfrNyxa1GKqa04og50GyMYxs1fwF6+B5RqiaAGYol5wOia5EGc4NsRcuIDnM+b9TYKjztC3xDUqVYhra1ajQOvE36dEMnqCM/2hWASutjMJYVFsQ3ggEvIWgiCTDmiHnMnthqbWDU2zSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TztLErqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TztLErqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AEDC433F1;
	Sat,  3 Feb 2024 04:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933774;
	bh=jftSSsNse/Nqr4yYAc+goSCpCLooFDkJxh1z0h/oZ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TztLErqiS4EZmULtAzEEEpi8oNwxJYdcrRrTcJr6NgI+S15eoMDVT1GDjNJduVFHQ
	 dvFfa7zkKFDITNSKZXljAEb52uG3x0V8wVhn5jxYE1R5J/H6gW628tc5L60ousK+i2
	 EboSA17PbJ67SgZeEONIJJSStVlw26RAW+p6OEgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 077/353] scsi: lpfc: Fix possible file string name overflow when updating firmware
Date: Fri,  2 Feb 2024 20:03:15 -0800
Message-ID: <20240203035406.250327125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index af15f7a22d25..04d608ea9106 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -33,6 +33,7 @@
 struct lpfc_sli2_slim;
 
 #define ELX_MODEL_NAME_SIZE	80
+#define ELX_FW_NAME_SIZE	84
 
 #define LPFC_PCI_DEV_LP		0x1
 #define LPFC_PCI_DEV_OC		0x2
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e7c47ee185a4..70bcee64bc8c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14721,7 +14721,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 int
 lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 {
-	uint8_t file_name[ELX_MODEL_NAME_SIZE];
+	char file_name[ELX_FW_NAME_SIZE] = {0};
 	int ret;
 	const struct firmware *fw;
 
@@ -14730,7 +14730,7 @@ lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 	    LPFC_SLI_INTF_IF_TYPE_2)
 		return -EPERM;
 
-	snprintf(file_name, ELX_MODEL_NAME_SIZE, "%s.grp", phba->ModelName);
+	scnprintf(file_name, sizeof(file_name), "%s.grp", phba->ModelName);
 
 	if (fw_upgrade == INT_FW_UPGRADE) {
 		ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
-- 
2.43.0



