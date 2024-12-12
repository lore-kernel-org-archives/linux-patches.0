Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CA7223E71;
	Thu, 12 Dec 2024 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021123; cv=none; b=KPjdjkCrCRQPrqmg40kC+GxqNolytLHvgKt/ZHmbhSwslQc4US3z2ktLjbr+jsqRpOTJL8qa+bKpoXt+HEzBDMgBhdnL8PBdxy2mJOQXLmrmzyz/QXrlcZKdjravmy4AOJqbd6nbFQF37MVQbAFxhVvt6M9UL3qlH5HE1a5TH+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021123; c=relaxed/simple;
	bh=8dh86p+n19Sn8DuE/1iwYskYSjywWZt1sHT5RJT0G9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVS5OljfevqUhkoQpVOLcjpwgHe1x7sqmwoDlJnCObeOiK8PYS44w2Oc6Uc82zruOSdoxmtrQ9BO4DNl8iGXfgEG9DiHh28onLDqbu4v1lkrjxlnDrUP2vebWebh/YUxooqzHmbyx7GR3QDDq0jpoHg0opsoO9COBuG7hG8gYJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9uJlQt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9uJlQt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326E6C4CECE;
	Thu, 12 Dec 2024 16:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021123;
	bh=8dh86p+n19Sn8DuE/1iwYskYSjywWZt1sHT5RJT0G9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9uJlQt8IysNajXnBTYJwoxWzwCyrbManVJLYyaji2WqRAN5A6texJPblnDtvEm/I
	 27zQ+0JiiZiQb4WUsWIbGf83EOtJn5DCPLOjMLBlD+lFDVzQsErVbh1NTWiXGcZV02
	 v8VXQCXSY5eeAUMwfw9vzPw0TZr0Xbm2Bk5DbL7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 622/772] scsi: ufs: core: Add missing post notify for power mode change
Date: Thu, 12 Dec 2024 15:59:27 +0100
Message-ID: <20241212144415.626148624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4449,9 +4449,6 @@ static int ufshcd_change_power_mode(stru
 		dev_err(hba->dev,
 			"%s: power mode change failed %d\n", __func__, ret);
 	} else {
-		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
-								pwr_mode);
-
 		memcpy(&hba->pwr_info, pwr_mode,
 			sizeof(struct ufs_pa_layer_attr));
 	}
@@ -4478,6 +4475,10 @@ int ufshcd_config_pwr_mode(struct ufs_hb
 
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
@@ -281,7 +281,9 @@ struct ufs_pwr_mode_info {
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
@@ -312,9 +314,9 @@ struct ufs_hba_variant_ops {
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


