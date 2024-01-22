Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0BA64CDA;
	Tue, 23 Jan 2024 00:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971352; cv=none; b=VTprhIDouoFu7x6B3IvHNQO5bTe9vOUoJxATFjMG0gkWC11o37O/Bx4UA/bxM5qpNNDSYdJiFms+eTjswXjgbyukNmLzQhpTzZNXq1RckyLCQ+0KnG4JiFrBzNIoHdAiHPNPnDRh1NwYnfzzhG+H7p9i507aFwS9V1etI260a+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971352; c=relaxed/simple;
	bh=+psj2OCeobZLFsF4iDD5m8lGQFE2kVyuDf0xfsogGvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR9S5Q+DkgyJBMdI58wMi+rMYAjPad2l17DuI6LCcHAlclWZeC2TdJ8lDspw3IVCl7QM4hOoA5a+pGjS27U48AMbrAuRVI/gBPOp492MQP0x80s/uJXW1q4xwyNCJnW+KEzwpwzbYjx0tHK8JqvXLrz2FoGtJEmDhONiCifTn5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T8TCPYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T8TCPYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6D8C43390;
	Tue, 23 Jan 2024 00:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971351;
	bh=+psj2OCeobZLFsF4iDD5m8lGQFE2kVyuDf0xfsogGvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T8TCPYXetQc+GlAbdRMfixiTAtJ+bKvrKAr9mMOROzdRg1REZBMWtOnozKrOXuns
	 Ii79Lbmz1rb1OQBPZovtmdGz8zgGIUyEhN4BA/3iU9Vw0jhl3Lzg1ciONwcXIRrHOE
	 /KR/CLvcMWWNdbZut12keLazN9sGo0Wc0Eoo2JqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/286] scsi: hisi_sas: Replace with standard error code return value
Date: Mon, 22 Jan 2024 15:57:11 -0800
Message-ID: <20240122235736.941961690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit d34ee535705eb43885bc0f561c63046f697355ad ]

In function hisi_sas_controller_prereset(), -ENOSYS (Function not
implemented) should be returned if the driver does not support .soft_reset.
Returns -EPERM (Operation not permitted) if HISI_SAS_RESETTING_BIT is
already be set.

In function _suspend_v3_hw(), returns -EPERM (Operation not permitted) if
HISI_SAS_RESETTING_BIT is already be set.

Fixes: 4522204ab218 ("scsi: hisi_sas: tidy host controller reset function a bit")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e5b9229310a0..8e5d23c6b8de 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1584,10 +1584,10 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 		queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
 
 	if (!hisi_hba->hw->soft_reset)
-		return -1;
+		return -ENOENT;
 
 	if (test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	dev_info(dev, "controller resetting...\n");
 	hisi_sas_controller_reset_prepare(hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0d21c64efa81..f03a09c9e865 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3479,7 +3479,7 @@ static int _suspend_v3_hw(struct device *device)
 	}
 
 	if (test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	scsi_block_requests(shost);
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-- 
2.43.0



