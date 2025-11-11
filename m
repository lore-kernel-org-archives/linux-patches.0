Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70AA2820A0;
	Tue, 11 Nov 2025 01:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823458; cv=none; b=H6mJW8VZrVIhD4+i1LI7amZm3ofV8H4oz1xS0ytNUIpnBAtmq2vVaUCFFQxhTP6WagYQoF+trQGMTIg0SLzdpxHePCf0kxxiA/InGlm+lzs1cfbwEP3NYW7B3a6Q2C9+9XBI8NQXcf15FXGu1PNWrw37aJUmyi5byqwEzXQlC0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823458; c=relaxed/simple;
	bh=hIUfKc31UJD71wAG3WfE3dN25Pm0f8DjATKbtjnQA+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvY9QFLngWl8IZXYwjaR4ZNETlKBPX2XiqgNF9KoTKG/8MoOfL80efx8lC2FZ3mxmU4VCoKf39QJEw7VgKMXcFzFFFhmsaZaVZg6gbVqaSpPdOY522Snt7t5MM0WjokDoZzIx77/tMfCWK5xzcVFqbu0ziecbR2OtDo0XAtU/MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY8pqVue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY8pqVue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41411C4CEF5;
	Tue, 11 Nov 2025 01:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823458;
	bh=hIUfKc31UJD71wAG3WfE3dN25Pm0f8DjATKbtjnQA+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gY8pqVueFxFHSXO0sykUSG9r67GnaF5Sl2NoEJww10qcnu3MfiB5d5JCz9/PHJLdO
	 pa4+CUq27JnBKU7ucYuo7ekQ2SyJ+8JcZn9VfaPyY0DMVfk5EM564PWSPJ4uFaMrlZ
	 UL8KgzuZcdLsV4IddxtPbCoMuxkMkiLtx16cDT8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 304/849] scsi: ufs: host: mediatek: Fix PWM mode switch issue
Date: Tue, 11 Nov 2025 09:37:54 +0900
Message-ID: <20251111004543.757763245@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 7212d624f8638f8ea8ad1ecbb80622c7987bc7a1 ]

Address a failure in switching to PWM mode by ensuring proper
configuration of power modes and adaptation settings. The changes
include checks for SLOW_MODE and adjustments to the desired working mode
and adaptation configuration based on the device's power mode and
hardware version.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250811131423.3444014-6-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 8dd124835151a..4171fa672450d 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1303,6 +1303,10 @@ static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba *hba,
 	    dev_req_params->gear_rx < UFS_HS_G4)
 		return false;
 
+	if (dev_req_params->pwr_tx == SLOW_MODE ||
+	    dev_req_params->pwr_rx == SLOW_MODE)
+		return false;
+
 	return true;
 }
 
@@ -1318,6 +1322,10 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	host_params.hs_rx_gear = UFS_HS_G5;
 	host_params.hs_tx_gear = UFS_HS_G5;
 
+	if (dev_max_params->pwr_rx == SLOW_MODE ||
+	    dev_max_params->pwr_tx == SLOW_MODE)
+		host_params.desired_working_mode = UFS_PWM_MODE;
+
 	ret = ufshcd_negotiate_pwr_params(&host_params, dev_max_params, dev_req_params);
 	if (ret) {
 		pr_info("%s: failed to determine capabilities\n",
@@ -1350,10 +1358,21 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		}
 	}
 
-	if (host->hw_ver.major >= 3) {
+	if (dev_req_params->pwr_rx == FAST_MODE ||
+	    dev_req_params->pwr_rx == FASTAUTO_MODE) {
+		if (host->hw_ver.major >= 3) {
+			ret = ufshcd_dme_configure_adapt(hba,
+						   dev_req_params->gear_tx,
+						   PA_INITIAL_ADAPT);
+		} else {
+			ret = ufshcd_dme_configure_adapt(hba,
+				   dev_req_params->gear_tx,
+				   PA_NO_ADAPT);
+		}
+	} else {
 		ret = ufshcd_dme_configure_adapt(hba,
-					   dev_req_params->gear_tx,
-					   PA_INITIAL_ADAPT);
+			   dev_req_params->gear_tx,
+			   PA_NO_ADAPT);
 	}
 
 	return ret;
-- 
2.51.0



