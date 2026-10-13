Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6C4E9C27;
	Tue, 13 Oct 2026 12:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893386; cv=none; b=ktly54wNEj2mhcDYiGiY3oY7b7U2saDraA5AWGi0WJ+3wsGVqv+/IuaoaZwQZm567kvwkrnoY9Xhy5C2auwGRQ7Hzp1Ybh/dvUFaPPNi55qe92Ud8RxdL9W21BY1OGLHnbPI0Xj26EgLA68teui+ajkE4PWbFnXShCD8oNA2/3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893386; c=relaxed/simple;
	bh=1BT0JAc39wReS64ONM94OFsD4FUqfIkfbgP4pIR+q1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cbuax94ywO2pUoERjuozUgZvkrH7csHfj3aWvO71bYaGpp77WsdFRPCCplDD9Kk0e8SMscpeVHVa206NqxaHIn4bIrp02Y65hzoIsy56skEvfyH0PlqGvPnokUoalNTye8CqDRB/5iHNsWFFOSnmuHEnp0utxqWJNsOk83ua7gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1T+vSJR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1T+vSJR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805FC1F000FF;
	Tue, 13 Oct 2026 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893385;
	bh=8QkCbhsGMTBGqTBgXS3nnflAVlOKxLjvGESDksgsCEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1T+vSJR/iQdDG60RrOhDdlxmCqVzhRUTNd2O4CxSuF8ZKpPlWwx6joaHH7jiKk6Zd
	 XonUrhsoY0txLBHnn2H1B7iA/jWvsNyE+LfBQX7nx7o8W0oihR27Q29VJ3BnWmvS13
	 NpMuItd7odFHoGAtpcYBOSigc4esJDJZqJHnNNMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 155/621] accel/amdxdna: Fix NULL pointer dereference of mgmt_chann
Date: Tue, 13 Oct 2026 13:32:30 +0200
Message-ID: <20261013112924.532009147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 6270ee26e1edd862ea17e3eba148ca8fb2c99dc9 ]

mgmt_chann may be set to NULL if the firmware returns an unexpected
error in aie2_send_mgmt_msg_wait(). This can later lead to a NULL
pointer dereference in aie2_hw_stop().

Fix this by introducing a dedicated helper to destroy mgmt_chann
and by adding proper NULL checks before accessing it.

Fixes: b87f920b9344 ("accel/amdxdna: Support hardware mailbox")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260226213857.3068474-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_message.c | 17 ++++++++++++-----
 drivers/accel/amdxdna/aie2_pci.c     |  7 ++-----
 drivers/accel/amdxdna/aie2_pci.h     |  1 +
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index 932d495230511..41fbe09b8047a 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -39,11 +39,8 @@ static int aie2_send_mgmt_msg_wait(struct amdxdna_dev_hdl *ndev,
 
 	drm_WARN_ON(&xdna->ddev, xdna->rpm_on && !mutex_is_locked(&xdna->dev_lock));
 	ret = xdna_send_msg_wait(xdna, ndev->mgmt_chann, msg);
-	if (ret == -ETIME) {
-		xdna_mailbox_stop_channel(ndev->mgmt_chann);
-		xdna_mailbox_destroy_channel(ndev->mgmt_chann);
-		ndev->mgmt_chann = NULL;
-	}
+	if (ret == -ETIME)
+		aie2_destroy_mgmt_chann(ndev);
 
 	if (!ret && *hdl->data != AIE2_STATUS_SUCCESS) {
 		XDNA_ERR(xdna, "command opcode 0x%x failed, status 0x%x",
@@ -54,6 +51,16 @@ static int aie2_send_mgmt_msg_wait(struct amdxdna_dev_hdl *ndev,
 	return ret;
 }
 
+void aie2_destroy_mgmt_chann(struct amdxdna_dev_hdl *ndev)
+{
+	if (!ndev->mgmt_chann)
+		return;
+
+	xdna_mailbox_stop_channel(ndev->mgmt_chann);
+	xdna_mailbox_destroy_channel(ndev->mgmt_chann);
+	ndev->mgmt_chann = NULL;
+}
+
 int aie2_suspend_fw(struct amdxdna_dev_hdl *ndev)
 {
 	DECLARE_AIE2_MSG(suspend, MSG_OP_SUSPEND);
diff --git a/drivers/accel/amdxdna/aie2_pci.c b/drivers/accel/amdxdna/aie2_pci.c
index 6e3698ed45198..884800e5fd38d 100644
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -326,9 +326,7 @@ static void aie2_hw_stop(struct amdxdna_dev *xdna)
 	}
 
 	aie2_mgmt_fw_fini(ndev);
-	xdna_mailbox_stop_channel(ndev->mgmt_chann);
-	xdna_mailbox_destroy_channel(ndev->mgmt_chann);
-	ndev->mgmt_chann = NULL;
+	aie2_destroy_mgmt_chann(ndev);
 	drmm_kfree(&xdna->ddev, ndev->mbox);
 	ndev->mbox = NULL;
 	aie2_psp_stop(ndev->psp_hdl);
@@ -437,8 +435,7 @@ static int aie2_hw_start(struct amdxdna_dev *xdna)
 	return 0;
 
 destroy_mgmt_chann:
-	xdna_mailbox_stop_channel(ndev->mgmt_chann);
-	xdna_mailbox_destroy_channel(ndev->mgmt_chann);
+	aie2_destroy_mgmt_chann(ndev);
 stop_psp:
 	aie2_psp_stop(ndev->psp_hdl);
 fini_smu:
diff --git a/drivers/accel/amdxdna/aie2_pci.h b/drivers/accel/amdxdna/aie2_pci.h
index 12fec3cf8c8db..7fbe9b2ebac23 100644
--- a/drivers/accel/amdxdna/aie2_pci.h
+++ b/drivers/accel/amdxdna/aie2_pci.h
@@ -260,6 +260,7 @@ int aie2_error_async_events_send(struct amdxdna_dev_hdl *ndev);
 int aie2_error_async_msg_thread(void *data);
 
 /* aie2_message.c */
+void aie2_destroy_mgmt_chann(struct amdxdna_dev_hdl *ndev);
 int aie2_suspend_fw(struct amdxdna_dev_hdl *ndev);
 int aie2_resume_fw(struct amdxdna_dev_hdl *ndev);
 int aie2_set_runtime_cfg(struct amdxdna_dev_hdl *ndev, u32 type, u64 value);
-- 
2.53.0



