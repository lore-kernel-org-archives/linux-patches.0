Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3291301707;
	Tue, 11 Nov 2025 01:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825454; cv=none; b=FvBJMeNzTBscA55qfoidCv1u4ra7LYnp7PlSJy88Nj0LiS6UvR4a10JiWq7elFGcYaaWmj5GtvAhGbHTUefl1A7Es1wmi2WDJxqD/cGfptWQuf3DD7ygaX2GvALEGYvFTwWm6jeGvy08I7GK877FF9qyWV/+mOUWZOOunIAKC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825454; c=relaxed/simple;
	bh=9HVQRDeMZmdkNBY0zqXtiZQ+9JpAX5SjsvBOVyrjenU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spI5Iqav9GaDdF26hHlXHFMess/ABJDbIdElCsgiorXJ0YIzAeKhxkP0yFYRcpo5LlgkmavzDvjmnMnFDh5C5nvqoyII3NMCpOzYdycfiKa8WI9TCN6MPCc53Xj+0dLriEHArzFLSzoAeN9UItzHfddCmOo7JlR7hVof88dQcxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFZuWRkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFZuWRkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3988FC4CEF5;
	Tue, 11 Nov 2025 01:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825454;
	bh=9HVQRDeMZmdkNBY0zqXtiZQ+9JpAX5SjsvBOVyrjenU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFZuWRkOVM1REjhCTHBbQ3qhddl40wXZ9k57H8jA2BmlCXFPKxzs7G/Vi5O880AEK
	 LH8DrD1F93w05zxHrcXS/CIXvPod3QqH4Z6hxdBAupSNzXZp4UIEb+Xo9B+2qrhBi5
	 EHrfMLUWYarylzxUsOJDAYQz2ok4DDJV+91ZfWVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lee <chullee@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 755/849] scsi: ufs: core: Revert "Make HID attributes visible"
Date: Tue, 11 Nov 2025 09:45:25 +0900
Message-ID: <20251111004554.685418171@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f838d624fd1183e07db86f3138bcd05fd7630a1e ]

Patch "Make HID attributes visible" is needed for older kernel versions
(e.g. 6.12) where ufs_get_device_desc() is called from ufshcd_probe_hba().
In these older kernel versions ufshcd_get_device_desc() may be called
after the sysfs attributes have been added. In the upstream kernel however
ufshcd_get_device_desc() is called before ufs_sysfs_add_nodes(). See also
the ufshcd_device_params_init() call from ufshcd_init(). Hence, calling
sysfs_update_group() is not necessary.

See also commit 69f5eb78d4b0 ("scsi: ufs: core: Move the
ufshcd_device_init(hba, true) call") in kernel v6.13.

This patch fixes the following kernel warning:

sysfs: cannot create duplicate filename '/devices/platform/3c2d0000.ufs/hid'
Workqueue: async async_run_entry_fn
Call trace:
 dump_backtrace+0xfc/0x17c
 show_stack+0x18/0x28
 dump_stack_lvl+0x40/0x104
 dump_stack+0x18/0x3c
 sysfs_warn_dup+0x6c/0xc8
 internal_create_group+0x1c8/0x504
 sysfs_create_groups+0x38/0x9c
 ufs_sysfs_add_nodes+0x20/0x58
 ufshcd_init+0x1114/0x134c
 ufshcd_pltfrm_init+0x728/0x7d8
 ufs_google_probe+0x30/0x84
 platform_probe+0xa0/0xe0
 really_probe+0x114/0x454
 __driver_probe_device+0xa4/0x160
 driver_probe_device+0x44/0x23c
 __device_attach_driver+0x15c/0x1f4
 bus_for_each_drv+0x10c/0x168
 __device_attach_async_helper+0x80/0xf8
 async_run_entry_fn+0x4c/0x17c
 process_one_work+0x26c/0x65c
 worker_thread+0x33c/0x498
 kthread+0x110/0x134
 ret_from_fork+0x10/0x20
ufshcd 3c2d0000.ufs: ufs_sysfs_add_nodes: sysfs groups creation failed (err = -17)

Cc: Daniel Lee <chullee@google.com>
Cc: Peter Wang <peter.wang@mediatek.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://patch.msgid.link/20251028222433.1108299-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-sysfs.c | 2 +-
 drivers/ufs/core/ufs-sysfs.h | 1 -
 drivers/ufs/core/ufshcd.c    | 2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index c040afc6668e8..0086816b27cd9 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobject *kobj,
 	return	hba->dev_info.hid_sup ? attr->mode : 0;
 }
 
-const struct attribute_group ufs_sysfs_hid_group = {
+static const struct attribute_group ufs_sysfs_hid_group = {
 	.name = "hid",
 	.attrs = ufs_sysfs_hid,
 	.is_visible = ufs_sysfs_hid_is_visible,
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 6efb82a082fdd..8d94af3b80771 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -14,6 +14,5 @@ void ufs_sysfs_remove_nodes(struct device *dev);
 
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
-extern const struct attribute_group ufs_sysfs_hid_group;
 
 #endif
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8208a26c3ed63..9e10287d5d6be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8481,8 +8481,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
 
-	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
-
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index,
-- 
2.51.0



