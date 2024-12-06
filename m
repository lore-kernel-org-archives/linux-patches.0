Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB131465AB;
	Fri,  6 Dec 2024 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498633; cv=none; b=eaMPfnYp8Rvl8fE/zbpQG/m3VFKLw3pTfEEmcp5WX9CJYRJKyLMxhSI0Hln/dcaq4sFS9qxsy6B6rVhdAnmCHB4vhH5Ua8x8ZlUQ61fSZUAtlpCyYGHIoLD0qwnrTJyt6dhJhsUrisgYkR3AjU2VXWREy62d1tXWkRJZsYVbWG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498633; c=relaxed/simple;
	bh=rPbipgDJ0GwiEaRwr6ku4j5JIjIP9AfvO162+r245CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faGC7dgCGv8SdehzAhNOGhVJfTS3WkPHVTnXP59IxspvGWwo4fN2GYpc81IcnrFo5tiIK/eUBzFHjNLksIcDCzCwtwr4RO/1LfD1U9H0lK73W8uOGlxVUP1UwCxm5YDdqp9hs+b8fzV1mpBd6uRAK9DkyFct6xyfAxWoh95vAAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ao0/3Gbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ao0/3Gbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AE0C4CED1;
	Fri,  6 Dec 2024 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498633;
	bh=rPbipgDJ0GwiEaRwr6ku4j5JIjIP9AfvO162+r245CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ao0/3GbxZH9ke6yES/1MmZTcCh72y65jupfpCd7o2z66pp8COnqs7hG6OYTn8JQm5
	 Al9cqqOMqRDXn4li7PN8ADJBku4tc9crqnKNLNnumCXRm2Y1wEAPTjZCJl7HAtbf8j
	 orjVPmDkI7Yrcq1r7BfvZnTFNLZ/mZeWmrdjbQdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 642/676] scsi: ufs: exynos: Fix hibern8 notify callbacks
Date: Fri,  6 Dec 2024 15:37:41 +0100
Message-ID: <20241206143718.447286135@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
@@ -1228,12 +1228,12 @@ static void exynos_ufs_dev_hw_reset(stru
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
@@ -1261,11 +1261,11 @@ static void exynos_ufs_pre_hibern8(struc
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
 
@@ -1284,7 +1284,7 @@ static void exynos_ufs_post_hibern8(stru
 
 		if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB))
 			exynos_ufs_establish_connt(ufs);
-	} else {
+	} else if (cmd == UIC_CMD_DME_HIBER_ENTER) {
 		ufs->entry_hibern8_t = ktime_get();
 		exynos_ufs_gate_clks(ufs);
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
@@ -1371,15 +1371,15 @@ static int exynos_ufs_pwr_change_notify(
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


