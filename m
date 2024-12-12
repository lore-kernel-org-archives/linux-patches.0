Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E1D6F2FE;
	Thu, 12 Dec 2024 15:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017784; cv=none; b=Rz8FwahzdOmLDM8UFv3eSBqtZ1JZG3ySQKv3ojtzDmMEGynCXsANHY4EfIq8GtvzHCcCszm4xT3ZMAoYVcLfB3bhFL6w6NCrw6Z55Q6wAerUOp+vmpTj5DDeqq5jAj6lMupbWaQJVLez0w14KdKTOLuwtCYUoHfAgnGF4C9rrys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017784; c=relaxed/simple;
	bh=YsDk1AsVbWybR/K6tdt70ZcNUmfKLb7wotx/8D7ACcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnaB36eK8pr4fVcGwcT/NAWlPjsfBCk7wWsQQTzRn/RUeEnepZJWhFFtpSt+s3S8d5NcA7Mt7hbKSLpTByJIFLw3zCi259j09AZG4Z84i69UA+sMHIVZoqLFZ82x7kJONnBP1eEx6j2titr81gtznlVFdZqdwrKudT5I4mdAWzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6sdXdeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6sdXdeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3532C4CED0;
	Thu, 12 Dec 2024 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017784;
	bh=YsDk1AsVbWybR/K6tdt70ZcNUmfKLb7wotx/8D7ACcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6sdXdeoPjTvyfTllYRKy2IcNldlwvEE2W53w/M7jiMdi28VenL8xXEStEoFT62/V
	 A/xSUTNxGV0HqWGedSW5IlquM6YkuItyRg8MD5L5lI/ugfkYWFAWdRTYnt+Q5/MnT6
	 AepFUokG8HwZU8gYyz3sQxkc46Bax2B2HwWGJuYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/356] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG
Date: Thu, 12 Dec 2024 15:57:09 +0100
Message-ID: <20241212144248.990103107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Ziqi Chen <quic_ziqichen@quicinc.com>

[ Upstream commit 60b4dd1460f6d65739acb0f28d12bd9abaeb34b4 ]

User layer applications can send UIC GET/SET commands via the BSG
framework, and if the user layer application sends a UIC SET command to the
PA_PWRMODE attribute, a power mode change shall be initiated in UniPro and
two interrupts shall be triggered if the power mode is successfully
changed, i.e., UIC Command Completion interrupt and UIC Power Mode
interrupt.

The current UFS BSG code calls ufshcd_send_uic_cmd() directly, with which
the second interrupt, i.e., UIC Power Mode interrupt, shall be treated as
unhandled interrupt. In addition, after the UIC command is completed, user
layer application has to poll UniPro and/or M-PHY state machine to confirm
the power mode change is finished.

Add a new wrapper function ufshcd_send_bsg_uic_cmd() and call it from
ufs_bsg_request() so that if a UIC SET command is targeting the PA_PWRMODE
attribute it can be redirected to ufshcd_uic_pwr_ctrl().

Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Link: https://lore.kernel.org/r/20241119095613.121385-1-quic_ziqichen@quicinc.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c     |  2 +-
 drivers/ufs/core/ufshcd-priv.h |  1 +
 drivers/ufs/core/ufshcd.c      | 36 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 374e5aae4e7e8..fec5993c66c39 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -170,7 +170,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
-		ret = ufshcd_send_uic_cmd(hba, &uc);
+		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index f42d99ce5bf1e..099a54009a16f 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -89,6 +89,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 44b2cd66b8189..f1bb2d5081360 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4206,6 +4206,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	return ret;
 }
 
+/**
+ * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG layer and retrieve the result
+ * @hba: per adapter instance
+ * @uic_cmd: UIC command
+ *
+ * Return: 0 only if success.
+ */
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
+{
+	int ret;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
+	ufshcd_hold(hba);
+
+	if (uic_cmd->argument1 == UIC_ARG_MIB(PA_PWRMODE) &&
+	    uic_cmd->command == UIC_CMD_DME_SET) {
+		ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
+		goto out;
+	}
+
+	mutex_lock(&hba->uic_cmd_mutex);
+	ufshcd_add_delay_before_dme_cmd(hba);
+
+	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
+	if (!ret)
+		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
+
+	mutex_unlock(&hba->uic_cmd_mutex);
+
+out:
+	ufshcd_release(hba);
+	return ret;
+}
+
 /**
  * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
  *				using DME_SET primitives.
-- 
2.43.0



