Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC87212E5E;
	Tue, 23 Jan 2024 00:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968289; cv=none; b=uh/Ig8hjnijLNRDB5qbM02npDgymcF+84kLNOnlypv+eomup5+qOYrlfVj6vpHV3wsgMuwUgDKPKoVdZfnpa+wiSUtx1ZYZbl1o00p5mmr3ifQRgd65LevvrMFOK/oHffMxN4VZGkdMc7Z7z6vL/7HineD+HcaJavFdHU+L5D2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968289; c=relaxed/simple;
	bh=8mh4aMHJzqXdCt60Y70GEktbQqhooGhBwqYBxBUIUK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPQFFKLYHS/4wWWDoSZLgchReMHoLOiTZT9mO4aNn/zQmLgPFi1I6AMUTaaFxaF1vzyiKhiunNu9aLkFzZoz4sjsVrfCdX9d0VmPPW5hCK9fnMRP3k5cznVnBkNhq0XRvBqX1LSaz7w+GtFuitv2EGK2fJrqKTal8k7u6QFjp6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxoYL0Lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxoYL0Lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE870C433F1;
	Tue, 23 Jan 2024 00:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968289;
	bh=8mh4aMHJzqXdCt60Y70GEktbQqhooGhBwqYBxBUIUK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxoYL0Lo5SJUhA7xpmPAEcD905LpvSiFARmu02X3sb4/FI1RDmR5GtCSe5YB0Tzv+
	 7p7DASp+DO00qVaXLyj3+GvC2xlxzfvNDuIFbvAwMrXHvOo37NvgRrv2cANF0tj2if
	 xmh/vicVy9+Lz/o8I77HyAwbPaaXkNXWcVaZ86Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/148] scsi: hisi_sas: Replace with standard error code return value
Date: Mon, 22 Jan 2024 15:57:08 -0800
Message-ID: <20240122235715.311301462@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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
index de4f41bce8e9..076abeb11ed4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1381,10 +1381,10 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 	int rc;
 
 	if (!hisi_hba->hw->soft_reset)
-		return -1;
+		return -ENOENT;
 
 	if (test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	dev_info(dev, "controller resetting...\n");
 	hisi_sas_controller_reset_prepare(hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 16b7ea556118..c5ffaa32bdd9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2546,7 +2546,7 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 
 	if (test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	scsi_block_requests(shost);
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-- 
2.43.0



