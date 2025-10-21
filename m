Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929A82773F4;
	Tue, 21 Oct 2025 20:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077497; cv=none; b=jW6Z8KbP5Le2zXRtBOn2fM82c0HFC7vyMiZqCR/TvEvVmFO1qqVYLYt2XUZX3NaLXrIBZ7/Y1oIHMODJxBUCUCbYOAiz/Ld1DDSM/fSZZsXbv/e3aQydl4496S/onamVRKkytvOOR91RZoItYr0PlQM/7Ati7oNxiCiNCVjlL9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077497; c=relaxed/simple;
	bh=DSoZoE3mCwUPkPg+d2UA/+B/whXQpF2R22NW0TGSWmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOUF9bbJbDUU7zDnuouRGsqrkNEK0bvzZ5x6NUTvfc34OIh0qnaYPBEnU8KDPxXHJwVK+c/G9hx4Fv7evGUOE61zatg2NV4nc4fs1Q5vhuBgfIB+i27DTDurlyoDcNPd2Kv1pJai09KDJ1AniTn8ZuwlZADYUSbBCSUxkhKvWSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjVQ9TU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjVQ9TU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFB9C4CEF7;
	Tue, 21 Oct 2025 20:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077497;
	bh=DSoZoE3mCwUPkPg+d2UA/+B/whXQpF2R22NW0TGSWmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjVQ9TU7OfGX6I9SH8xo2zjNC067q+bXEScHiXYLqvnpfe2z81XHkubN9Sg32NlEr
	 R33p1FZnL1xUfq/7M6YGouecVM3yjTc+XlKyf51iRNBoybGrZUqC0rTqtFNKM8lBhm
	 RpQRAEoaaNw20jzZgF5d3jAffbRl/vzduO++GtF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 123/159] accel/qaic: Synchronize access to DBC request queue head & tail pointer
Date: Tue, 21 Oct 2025 21:51:40 +0200
Message-ID: <20251021195046.114565555@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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
index c31081e42cee0..820d133236dd1 100644
--- a/drivers/accel/qaic/qaic.h
+++ b/drivers/accel/qaic/qaic.h
@@ -97,6 +97,8 @@ struct dma_bridge_chan {
 	 * response queue's head and tail pointer of this DBC.
 	 */
 	void __iomem		*dbc_base;
+	/* Synchronizes access to Request queue's head and tail pointer */
+	struct mutex		req_lock;
 	/* Head of list where each node is a memory handle queued in request queue */
 	struct list_head	xfer_list;
 	/* Synchronizes DBC readers during cleanup */
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index 797289e9d7806..c4f117edb266e 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -1356,13 +1356,17 @@ static int __qaic_execute_bo_ioctl(struct drm_device *dev, void *data, struct dr
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
@@ -1370,11 +1374,12 @@ static int __qaic_execute_bo_ioctl(struct drm_device *dev, void *data, struct dr
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
@@ -1382,6 +1387,9 @@ static int __qaic_execute_bo_ioctl(struct drm_device *dev, void *data, struct dr
 	if (datapath_polling)
 		schedule_work(&dbc->poll_work);
 
+unlock_req_lock:
+	if (ret)
+		mutex_unlock(&dbc->req_lock);
 release_ch_rcu:
 	srcu_read_unlock(&dbc->ch_lock, rcu_id);
 unlock_dev_srcu:
diff --git a/drivers/accel/qaic/qaic_drv.c b/drivers/accel/qaic/qaic_drv.c
index e31bcb0ecfc94..e162f4b8a262a 100644
--- a/drivers/accel/qaic/qaic_drv.c
+++ b/drivers/accel/qaic/qaic_drv.c
@@ -454,6 +454,9 @@ static struct qaic_device *create_qdev(struct pci_dev *pdev,
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



