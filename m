Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0915A171CE;
	Sat,  3 Feb 2024 04:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933550; cv=none; b=o1VdDyhpx1N6wujKUYN+at5nI1k9Tob2tr+KtCBTK3r7qmDJZszIvoMYvMW7TNG2gqYIhcyzUvj638EA9A79nai611HyoZx/5mpaAYh3pHWgUt19HiZi6XvTwLThAS4rZpqxngU8FksRYfsJWy8hqZQBiw82fQGaIVicYj2Xx6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933550; c=relaxed/simple;
	bh=pbD4UmnparE82yhBd2L9D35D8cwjvUmU9bgPFn6wSJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7P8VVK9sMIaMGBNMoLZv7ODW5f8rL38nHfkjh0igqMWqokX1c6LcYQkATnELxGOlJy1STrSZV1GnWAgePWXGZvucvW5Hi/Hxak/AQKKemFh/ia75eNgyBA5lDl4X9NLtuYsYuDKwkm30TNHc3o0VHPycBCNVr2S/GOIsHDlGj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1mLXyG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1mLXyG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B55C433A6;
	Sat,  3 Feb 2024 04:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933549;
	bh=pbD4UmnparE82yhBd2L9D35D8cwjvUmU9bgPFn6wSJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1mLXyG/rrlVIUh6aLTX5BjHrlsH9g1qiQKoaZSNYCI9nK+kqEFOGycr1gUmsqgcX
	 IKc0HhQTeO1iKE/WnuCPqNpxnUCSaU70v7dNOtel3YqecGWy4CgXH8PNqunxvHsCrS
	 6W/6qjv5Bmye6yPPaa4zpFCPfVo/KzmDhEqB7DXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/322] scsi: lpfc: Fix possible file string name overflow when updating firmware
Date: Fri,  2 Feb 2024 20:02:49 -0800
Message-ID: <20240203035401.495985386@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9e59c050103d..2c336953e56c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14725,7 +14725,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 int
 lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 {
-	uint8_t file_name[ELX_MODEL_NAME_SIZE];
+	char file_name[ELX_FW_NAME_SIZE] = {0};
 	int ret;
 	const struct firmware *fw;
 
@@ -14734,7 +14734,7 @@ lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 	    LPFC_SLI_INTF_IF_TYPE_2)
 		return -EPERM;
 
-	snprintf(file_name, ELX_MODEL_NAME_SIZE, "%s.grp", phba->ModelName);
+	scnprintf(file_name, sizeof(file_name), "%s.grp", phba->ModelName);
 
 	if (fw_upgrade == INT_FW_UPGRADE) {
 		ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
-- 
2.43.0



