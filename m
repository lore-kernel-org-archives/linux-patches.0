Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3DA2156FF;
	Thu, 12 Dec 2024 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015926; cv=none; b=BloPtK9UDZ59HF5SfoduSxUad9Xj82wmgVWtM4Za9fGxyDiu2ayRhDXYr1TwvZ56fvrLarE4UlUnB7iBO9F8776l1+oka+yGfzHjbiGxLnZxs3K1wZSlRI7v4TKwTu60IRH+uA2um2IPAAEaVde3iW0Rkmk+9LylB+FYHfb1REk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015926; c=relaxed/simple;
	bh=7WuhiLLDENYYysBX66R8vmaagI0e3LGRuHa7frv7gLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9d39OIgraka/5nvXnlomqtHzY0KjcQEAjy8jAUREHykxKd/JfefXsn03gLCyIa9qKwhYpaTT/vjJbkYkviStVPOgKmP06AJjHEVRvuBvdsEOTBmh6VmO9TOfe+Y2n0yUslW+RNPtJS2uVC4cnKIHz8azAtC9uuFjScIT3yuG04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOvsmUAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOvsmUAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C6BC4CECE;
	Thu, 12 Dec 2024 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015926;
	bh=7WuhiLLDENYYysBX66R8vmaagI0e3LGRuHa7frv7gLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOvsmUATiD5Z1l6gX2+SLkBEnl/5hWWDA3I7Rs0R0LuCKcIAFFcZr2toLg8ZCQUyE
	 e7fXx2V3/NcEOkXjiPCNIhLGwuBRErzdCrv+L40GSLCm/k4mUCYPHKdDqAv4La/1Iw
	 kv1e3Q23vCTT88SkNIc+8XJWjmscpyZ/eAPYzoww=
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
Subject: [PATCH 6.12 082/466] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG
Date: Thu, 12 Dec 2024 15:54:11 +0100
Message-ID: <20241212144310.058439345@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 433d0480391ea..6c09d97ae0065 100644
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
index 7aea8fbaeee88..9ffd94ddf8c7c 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -84,6 +84,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f68e13aac8d37..6a0e86a8069be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4340,6 +4340,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
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



