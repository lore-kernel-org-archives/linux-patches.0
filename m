Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7442C345CBE;
	Tue, 11 Nov 2025 01:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824752; cv=none; b=JCT8fDp0gyT24RVzRxkP3rgWZXZdBIe9szRAC257cXlZw1wpFhVcn+TydnXbn2JNuqYfgpLgL2gXbZqXtiHs45J9QQnS/y25Ksrg3blUTDEu3tk1akQPLPMK+EaRHlHtewnN87XXpOJuQlMc2Zu5zUCfK31oG0JdJcsgRQFXQDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824752; c=relaxed/simple;
	bh=b88virH20WIQtLbqA6pcvULXPjs/8p/hANHNPwjDm7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3JavfLng1uWlBmT3sVCyx5/lefQFKUuHoWB+XmQMvqKO3G2w2DtZb4HBuoYnUnMwcUkrD3uiLbULW9IF67PjZ4Dlq3ZR1ObP/riHC/0Cvz9Byyqex1R2j+hPEewSvrZncbtUeWmyvY2VE6l5pLzpVLbjAuLkNs5HgUXPgKJtng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTX5XdkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTX5XdkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA7DC113D0;
	Tue, 11 Nov 2025 01:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824752;
	bh=b88virH20WIQtLbqA6pcvULXPjs/8p/hANHNPwjDm7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTX5XdkYFaiKZ2sKUWq+0PHTLkJWvKnemkh5CtrOLX4Lw5ItyY9yZGP63ZKiOp6cc
	 PUPaqUt5PyV40yWZmx5YRpLeoa7Vy7BrLJUAnJOBvCOxl9w2OywnXR8eZRnJiqNJ2p
	 X1PwYI7zGpqsBQkJhWjvxwL1v23avlookDntFoIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palash Kambar <quic_pkambar@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 563/849] scsi: ufs: ufs-qcom: Disable lane clocks during phy hibern8
Date: Tue, 11 Nov 2025 09:42:13 +0900
Message-ID: <20251111004550.023470799@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Palash Kambar <quic_pkambar@quicinc.com>

[ Upstream commit c1553fc105dff28f79bef90fab207235f5f2d977 ]

Currently, the UFS lane clocks remain enabled even after the link enters
the Hibern8 state and are only disabled during runtime/system
suspend.This patch modifies the behavior to disable the lane clocks
during ufs_qcom_setup_clocks(), which is invoked shortly after the link
enters Hibern8 via gate work.

While hibern8_notify() offers immediate control, toggling clocks on
every transition isn't ideal due to varied contexts like clock scaling.
Since setup_clocks() manages PHY/controller resources and is invoked
soon after Hibern8 entry, it serves as a central and stable point for
clock gating.

Signed-off-by: Palash Kambar <quic_pkambar@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Message-ID: <20250909055149.2068737-1-quic_pkambar@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 3ea6b08d2b526..2b6eb377eec07 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1183,6 +1183,13 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 	case PRE_CHANGE:
 		if (on) {
 			ufs_qcom_icc_update_bw(host);
+			if (ufs_qcom_is_link_hibern8(hba)) {
+				err = ufs_qcom_enable_lane_clks(host);
+				if (err) {
+					dev_err(hba->dev, "enable lane clks failed, ret=%d\n", err);
+					return err;
+				}
+			}
 		} else {
 			if (!ufs_qcom_is_link_active(hba)) {
 				/* disable device ref_clk */
@@ -1208,6 +1215,9 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 			if (ufshcd_is_hs_mode(&hba->pwr_info))
 				ufs_qcom_dev_ref_clk_ctrl(host, true);
 		} else {
+			if (ufs_qcom_is_link_hibern8(hba))
+				ufs_qcom_disable_lane_clks(host);
+
 			ufs_qcom_icc_set_bw(host, ufs_qcom_bw_table[MODE_MIN][0][0].mem_bw,
 					    ufs_qcom_bw_table[MODE_MIN][0][0].cfg_bw);
 		}
-- 
2.51.0



