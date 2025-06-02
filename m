Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93F922D795;
	Mon,  2 Jun 2025 15:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877294; cv=none; b=gPYtDMKhcgYmeWNiHBQILIN0MmKBDudYsuMGn0DB7wX5BKR+QqlnTsOApZaplztmKwn4y7PqlRVArSBRjdw9FVSpXVPXuYo+fTefJUC0c3uNCfSEg+R8niTjVstNE3QKRBVYXk05cK8M5pRiD9m9XQwxH90ucHsSRRvPAcR/Rm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877294; c=relaxed/simple;
	bh=eqp6bGq1HCLu2rTTk8Y0qr+2m5BOptoH8vKOduRa9Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip2GcWuyhsbScUrZo2dw5lJZhz0Uau7QPHFuMhxwfrmGEoO17xczkL91u8DddCDsDGPO4VKThMAIEsz4epq8pPMFBKvdhKaEU3F5sRf03HR0O7bqg2HHoBfsGyXpoHJJIehftodntxWAvdMXUeYfjNbHTV6sRt1inu9b09PtknA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2aakXVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2aakXVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED06FC4CEEB;
	Mon,  2 Jun 2025 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877292;
	bh=eqp6bGq1HCLu2rTTk8Y0qr+2m5BOptoH8vKOduRa9Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2aakXVPdwldxAcldWfsCmzlvh56X6S1m+25sEIaT5CnCWEvQu5wzI2w4mU3Yh2cA
	 twq8OX+lETaCRWNWrmW65Ljmw8WuUBFXefrJJlnvDc+/le+F6iCGdqCFNYjQiJiqXd
	 zBbSvI1B5DX4nVdEy86nWt2T1UQFKWY5Q5eW5iEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Zhu <tony.zhu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/325] dmaengine: idxd: add per DSA wq workqueue for processing cr faults
Date: Mon,  2 Jun 2025 15:48:27 +0200
Message-ID: <20250602134329.168547077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 2f30decd2f23a376d2ed73dfe4c601421edf501a ]

Add a workqueue for user submitted completion record fault processing.
The workqueue creation and destruction lifetime will be tied to the user
sub-driver since it will only be used when the wq is a user type.

Tested-by: Tony Zhu <tony.zhu@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20230407203143.2189681-7-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8dfa57aabff6 ("dmaengine: idxd: Fix allowing write() from different address spaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 11 +++++++++++
 drivers/dma/idxd/idxd.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 9f8adb7013eba..e2a89873c6e1a 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -408,6 +408,13 @@ static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
 	}
 
 	mutex_lock(&wq->wq_lock);
+
+	wq->wq = create_workqueue(dev_name(wq_confdev(wq)));
+	if (!wq->wq) {
+		rc = -ENOMEM;
+		goto wq_err;
+	}
+
 	wq->type = IDXD_WQT_USER;
 	rc = drv_enable_wq(wq);
 	if (rc < 0)
@@ -426,7 +433,9 @@ static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
 err_cdev:
 	drv_disable_wq(wq);
 err:
+	destroy_workqueue(wq->wq);
 	wq->type = IDXD_WQT_NONE;
+wq_err:
 	mutex_unlock(&wq->wq_lock);
 	return rc;
 }
@@ -439,6 +448,8 @@ static void idxd_user_drv_remove(struct idxd_dev *idxd_dev)
 	idxd_wq_del_cdev(wq);
 	drv_disable_wq(wq);
 	wq->type = IDXD_WQT_NONE;
+	destroy_workqueue(wq->wq);
+	wq->wq = NULL;
 	mutex_unlock(&wq->wq_lock);
 }
 
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 14c6ef987fede..5dbb67ff1c0cb 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -185,6 +185,7 @@ struct idxd_wq {
 	struct idxd_dev idxd_dev;
 	struct idxd_cdev *idxd_cdev;
 	struct wait_queue_head err_queue;
+	struct workqueue_struct *wq;
 	struct idxd_device *idxd;
 	int id;
 	struct idxd_irq_entry ie;
-- 
2.39.5



