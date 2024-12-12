Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D3D21504F;
	Thu, 12 Dec 2024 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016309; cv=none; b=FyG/xNRQDsZ34E8m9JMMV9a8L0aFUpDqndQZneCE00a7T7r4u5eFF4msyqkv4VC1Uoc9qdoyaUhmdjmI+vXoZM7oYz6mvYmt5LgRhRi5KlV7S0RCCQWAdO7ldudtG3MF6StGC0qqzI8qbBgKWPXhFSVHbYBwEo+/iFc5urqoQrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016309; c=relaxed/simple;
	bh=0PTAS2LBaZPb0ie9o7+Z/o7CUv2aoPqr0l9e+w2nYas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl0yiVBu9i9XgaQEDRn0ulGQKlqixpXLEynmckZ3hUfhgrGiJvcSrehvvfQPgOP+ImSV2OZu4fiWAJifTkqBopD9oFF0ckBrdpSefZTLShe/+Ba26rZDam8DysBmPQ3c+Wq9TPo1XS2jaRKR/SY20jbWxfZVtt5N2TolzpBo4r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0HcPiLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0HcPiLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AC0C4CED7;
	Thu, 12 Dec 2024 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016309;
	bh=0PTAS2LBaZPb0ie9o7+Z/o7CUv2aoPqr0l9e+w2nYas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0HcPiLWQP2OEh1dH6L5EHErmoRJe1ft7DTtc4Wprb/BB8zESyo8Rwm8pBJzc+9lA
	 EIF9fkwv2cYfv3U2zSz8c2c9FWa5ExlWeGkRfJ95I0Du7Pcpcnb99kM7dlkKCVLCF5
	 8srgPVmMOmZa9GuTTVzGpoHEyZQYWUiJtSzbXMd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 154/466] scsi: ufs: core: Add missing post notify for power mode change
Date: Thu, 12 Dec 2024 15:55:23 +0100
Message-ID: <20241212144312.882527590@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

commit 7f45ed5f0cd5ccbbec79adc6c48a67d6a85fba56 upstream.

When the power mode change is successful but the power mode hasn't
actually changed, the post notification was missed.  Similar to the
approach with hibernate/clock scale/hce enable, having pre/post
notifications in the same function will make it easier to maintain.

Additionally, supplement the description of power parameters for the
pwr_change_notify callback.

Fixes: 7eb584db73be ("ufs: refactor configuring power mode")
Cc: stable@vger.kernel.org #6.11.x
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20241122024943.30589-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    7 ++++---
 include/ufs/ufshcd.h      |   10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4684,9 +4684,6 @@ static int ufshcd_change_power_mode(stru
 		dev_err(hba->dev,
 			"%s: power mode change failed %d\n", __func__, ret);
 	} else {
-		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
-								pwr_mode);
-
 		memcpy(&hba->pwr_info, pwr_mode,
 			sizeof(struct ufs_pa_layer_attr));
 	}
@@ -4715,6 +4712,10 @@ int ufshcd_config_pwr_mode(struct ufs_hb
 
 	ret = ufshcd_change_power_mode(hba, &final_params);
 
+	if (!ret)
+		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
+					&final_params);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -308,7 +308,9 @@ struct ufs_pwr_mode_info {
  *                       to allow variant specific Uni-Pro initialization.
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
- *			to be set.
+ *			to be set. PRE_CHANGE can modify final_params based
+ *			on desired_pwr_mode, but POST_CHANGE must not alter
+ *			the final_params parameter
  * @setup_xfer_req: called before any transfer request is issued
  *                  to set some things
  * @setup_task_mgmt: called before any task management request is issued
@@ -350,9 +352,9 @@ struct ufs_hba_variant_ops {
 	int	(*link_startup_notify)(struct ufs_hba *,
 				       enum ufs_notify_change_status);
 	int	(*pwr_change_notify)(struct ufs_hba *,
-					enum ufs_notify_change_status status,
-					struct ufs_pa_layer_attr *,
-					struct ufs_pa_layer_attr *);
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *desired_pwr_mode,
+				struct ufs_pa_layer_attr *final_params);
 	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
 				  bool is_scsi_cmd);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);


