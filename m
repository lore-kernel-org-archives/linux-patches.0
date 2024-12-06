Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FF61494D9;
	Fri,  6 Dec 2024 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496197; cv=none; b=e0+HrdE+nEpcOge//JHLLFlSc0BNxTmVJCQtE5daiCSDXfqdj9pGsiDtJ+Vxxy7HQbLGxofddZtKb6vX/o6NVQmufem3SLmdCPTfzvTyHNbO3czmXPxEH6Rj9pvqudXYomNn6gD+4wbhvJAUHNnXsi/8OT+NytZO+0aJlWotWd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496197; c=relaxed/simple;
	bh=t/oU4eogs5yPq7802+7N+ni9Er7Ni5Pa+2Da/HUBgpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buPoxKITPVciRrffjHMZB6+/tz9mxZlyzX38OzT9Tbds8XqXwwlV8VGLInB5DH0a1Q+NjP9nvsv6l76VRXzzawvXdZqbrfs0R4/6vFuGFTWbfKwhteQO2rRIfsSf0OKVBmkhMpRW7RO+sMJRFBRyeyYXkpmw3TI7KJSWfACtDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOgsfOAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOgsfOAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BCDC4CED1;
	Fri,  6 Dec 2024 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496197;
	bh=t/oU4eogs5yPq7802+7N+ni9Er7Ni5Pa+2Da/HUBgpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOgsfOAwvNBZsrMGbRTvG3yTfyxC4HKI/XG3ArLpX8ayHFEj95RTmPm07r9wPbI3b
	 5c3HaayggaI7JPeDdk+VQNh76TpAZfWOaurgYYT0cxsb6I0pjyWtTnpHYHY7Oh6Bvx
	 8HtYKcN88067rFqfVhhjgUdf+VgnV+d2tSEPEG/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 079/146] scsi: ufs: exynos: Fix hibern8 notify callbacks
Date: Fri,  6 Dec 2024 15:36:50 +0100
Message-ID: <20241206143530.702367999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Peter Griffin <peter.griffin@linaro.org>

commit ceef938bbf8b93ba3a218b4adc244cde94b582aa upstream.

v1 of the patch which introduced the ufshcd_vops_hibern8_notify()
callback used a bool instead of an enum. In v2 this was updated to an
enum based on the review feedback in [1].

ufs-exynos hibernate calls have always been broken upstream as it
follows the v1 bool implementation.

Link: https://patchwork.kernel.org/project/linux-scsi/patch/001f01d23994$719997c0$54ccc740$@samsung.com/ [1]
Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20241031150033.3440894-13-peter.griffin@linaro.org
Cc: stable@vger.kernel.org
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-exynos.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1487,12 +1487,12 @@ static void exynos_ufs_dev_hw_reset(stru
 	hci_writel(ufs, 1 << 0, HCI_GPIO_OUT);
 }
 
-static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, u8 enter)
+static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
 
-	if (!enter) {
+	if (cmd == UIC_CMD_DME_HIBER_EXIT) {
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
 			exynos_ufs_disable_auto_ctrl_hcc(ufs);
 		exynos_ufs_ungate_clks(ufs);
@@ -1520,11 +1520,11 @@ static void exynos_ufs_pre_hibern8(struc
 	}
 }
 
-static void exynos_ufs_post_hibern8(struct ufs_hba *hba, u8 enter)
+static void exynos_ufs_post_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
-	if (!enter) {
+	if (cmd == UIC_CMD_DME_HIBER_EXIT) {
 		u32 cur_mode = 0;
 		u32 pwrmode;
 
@@ -1543,7 +1543,7 @@ static void exynos_ufs_post_hibern8(stru
 
 		if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB))
 			exynos_ufs_establish_connt(ufs);
-	} else {
+	} else if (cmd == UIC_CMD_DME_HIBER_ENTER) {
 		ufs->entry_hibern8_t = ktime_get();
 		exynos_ufs_gate_clks(ufs);
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
@@ -1630,15 +1630,15 @@ static int exynos_ufs_pwr_change_notify(
 }
 
 static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
-				     enum uic_cmd_dme enter,
+				     enum uic_cmd_dme cmd,
 				     enum ufs_notify_change_status notify)
 {
 	switch ((u8)notify) {
 	case PRE_CHANGE:
-		exynos_ufs_pre_hibern8(hba, enter);
+		exynos_ufs_pre_hibern8(hba, cmd);
 		break;
 	case POST_CHANGE:
-		exynos_ufs_post_hibern8(hba, enter);
+		exynos_ufs_post_hibern8(hba, cmd);
 		break;
 	}
 }


