Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9219C350A0B;
	Tue, 21 Oct 2025 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076948; cv=none; b=ZR/NjhDE44/xL3/7ssgkedVBWj5iYbXN6sUNdz05tCrH95nKCV2XEtCPdT0NJf+DWCPucyjRgoLb2rVsogcqBMxNFpf6kcGjVO/v5eq7YBe/xUIGqmibDsLdXnPRNvK7ymYJ/O3+GcfGCymhUG/q9nGxrnW0aS5orJOEth+LBso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076948; c=relaxed/simple;
	bh=VAfJ3KOCUqrXEtu+qNdOSBvOK8+xJMKZH/nLNP7o9cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKtm7D+jkXWzt5UngnQukocQ6kZqUNKrJGqoJy3IQzMbkKKaPDrURNSUmdeKUbJ+5/JKG0u3DFGwDXKwxamFIJgysBuqqCwLAYF8bvqFgQ6zlGA6YioxAUrexuCzo7hWSOBsqaqBvqcGzMfzJLx6TNIGTEB+ni+GYeCsDxEa14E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chemOxIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chemOxIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A51C4CEF1;
	Tue, 21 Oct 2025 20:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076948;
	bh=VAfJ3KOCUqrXEtu+qNdOSBvOK8+xJMKZH/nLNP7o9cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chemOxIb9aECwkRkaRqXABUi8qiDuLwIssz6zvAkjpmUuli6mf5gd/X/ve0BH2ZNu
	 YW2xwalKVaD7nnkNAaebifYNXnU+OHdB0jsjT3PD4BwL7pBtxJkC52E3PEii4mhPGN
	 PD0/dtUQJ2hToQ59LGVqawV8hVs+0kkoIX5cFgYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/136] accel/qaic: Synchronize access to DBC request queue head & tail pointer
Date: Tue, 21 Oct 2025 21:51:14 +0200
Message-ID: <20251021195038.030412171@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>

[ Upstream commit 52e59f7740ba23bbb664914967df9a00208ca10c ]

Two threads of the same process can potential read and write parallelly to
head and tail pointers of the same DBC request queue. This could lead to a
race condition and corrupt the DBC request queue.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Signed-off-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>
[jhugo: Add fixes tag]
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251007061837.206132-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic.h      |  2 ++
 drivers/accel/qaic/qaic_data.c | 12 ++++++++++--
 drivers/accel/qaic/qaic_drv.c  |  3 +++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/qaic/qaic.h b/drivers/accel/qaic/qaic.h
index 02561b6cecc64..2d7b3af09e284 100644
--- a/drivers/accel/qaic/qaic.h
+++ b/drivers/accel/qaic/qaic.h
@@ -91,6 +91,8 @@ struct dma_bridge_chan {
 	 * response queue's head and tail pointer of this DBC.
 	 */
 	void __iomem		*dbc_base;
+	/* Synchronizes access to Request queue's head and tail pointer */
+	struct mutex		req_lock;
 	/* Head of list where each node is a memory handle queued in request queue */
 	struct list_head	xfer_list;
 	/* Synchronizes DBC readers during cleanup */
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index 43aba57b48f05..265eeb4e156fc 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -1357,13 +1357,17 @@ static int __qaic_execute_bo_ioctl(struct drm_device *dev, void *data, struct dr
 		goto release_ch_rcu;
 	}
 
+	ret = mutex_lock_interruptible(&dbc->req_lock);
+	if (ret)
+		goto release_ch_rcu;
+
 	head = readl(dbc->dbc_base + REQHP_OFF);
 	tail = readl(dbc->dbc_base + REQTP_OFF);
 
 	if (head == U32_MAX || tail == U32_MAX) {
 		/* PCI link error */
 		ret = -ENODEV;
-		goto release_ch_rcu;
+		goto unlock_req_lock;
 	}
 
 	queue_level = head <= tail ? tail - head : dbc->nelem - (head - tail);
@@ -1371,11 +1375,12 @@ static int __qaic_execute_bo_ioctl(struct drm_device *dev, void *data, struct dr
 	ret = send_bo_list_to_device(qdev, file_priv, exec, args->hdr.count, is_partial, dbc,
 				     head, &tail);
 	if (ret)
-		goto release_ch_rcu;
+		goto unlock_req_lock;
 
 	/* Finalize commit to hardware */
 	submit_ts = ktime_get_ns();
 	writel(tail, dbc->dbc_base + REQTP_OFF);
+	mutex_unlock(&dbc->req_lock);
 
 	update_profiling_data(file_priv, exec, args->hdr.count, is_partial, received_ts,
 			      submit_ts, queue_level);
@@ -1383,6 +1388,9 @@ static int __qaic_execute_bo_ioctl(struct drm_device *dev, void *data, struct dr
 	if (datapath_polling)
 		schedule_work(&dbc->poll_work);
 
+unlock_req_lock:
+	if (ret)
+		mutex_unlock(&dbc->req_lock);
 release_ch_rcu:
 	srcu_read_unlock(&dbc->ch_lock, rcu_id);
 unlock_dev_srcu:
diff --git a/drivers/accel/qaic/qaic_drv.c b/drivers/accel/qaic/qaic_drv.c
index 10e711c96a670..cb606c4bb8511 100644
--- a/drivers/accel/qaic/qaic_drv.c
+++ b/drivers/accel/qaic/qaic_drv.c
@@ -422,6 +422,9 @@ static struct qaic_device *create_qdev(struct pci_dev *pdev, const struct pci_de
 			return NULL;
 		init_waitqueue_head(&qdev->dbc[i].dbc_release);
 		INIT_LIST_HEAD(&qdev->dbc[i].bo_lists);
+		ret = drmm_mutex_init(drm, &qdev->dbc[i].req_lock);
+		if (ret)
+			return NULL;
 	}
 
 	return qdev;
-- 
2.51.0



