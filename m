Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777AA53365;
	Thu, 12 Dec 2024 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020824; cv=none; b=kJKW/4JWdcH8JwYnmZPkxYP3QbWdGjvhAiQTmOO72IbAtfcYRQ+Tgou8DFMZSoqAAdTkcY1E1StJ/Wa1VtXQmaiE/wEEkhodvwnzvY6oSbEu12rskXYp1NNCI2/fJAAyFWn0gIhWOyTPfv9u3yKRFrYwgwHn8tk8zFHimgyrwqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020824; c=relaxed/simple;
	bh=ldbOzl6XD+0CJLrG9QYOr9Oynoy6bN/RT66SOBek1Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noCx5pLlfk36QO0NdZ9MAUCRZaQEnPugZ85zrMxeODShQIl9RkxoQiqSjfTVTtxibbzjNv9LFRoXcoablQrwsJdHp+Z/tkGwsDI5msNlMZsLtWV3RZAPAVCWV3i5+SX8LT40KaiSBc4gi7P//92Kb+ACq3XIJtWJwR2wkV9lr5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIzSlPqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIzSlPqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762A7C4CECE;
	Thu, 12 Dec 2024 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020824;
	bh=ldbOzl6XD+0CJLrG9QYOr9Oynoy6bN/RT66SOBek1Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIzSlPqOXbPKikMtFY8921KBklbbOvN6wxubkbeerXoIDEeqJMOcOAqMi0rXMH1xa
	 HazvLN4zV1Ojp0fKfsvCDkzp8ZZPQ9dHgj0ABjTA5qNWpXP7I5IkkFfSE5CkWZ3WjX
	 BWEJ0rK7kmrsSc57qWFFNAEM/Ty7yvpl1umvkCV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 569/772] i3c: master: svc: add hot join support
Date: Thu, 12 Dec 2024 15:58:34 +0100
Message-ID: <20241212144413.473267318@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 05b26c31a4859af9e75b7de77458e99358364fe1 ]

Add hot join support for svc master controller. Disable hot join by
default.
User can use sysfs entry to enable hot join.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231201222532.2431484-3-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 25bc99be5fe5 ("i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 61 +++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 77bb7c0468250..807a9fe647b7c 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -128,6 +128,9 @@
 /* This parameter depends on the implementation and may be tuned */
 #define SVC_I3C_FIFO_SIZE 16
 
+#define SVC_I3C_EVENT_IBI	BIT(0)
+#define SVC_I3C_EVENT_HOTJOIN	BIT(1)
+
 struct svc_i3c_cmd {
 	u8 addr;
 	bool rnw;
@@ -171,6 +174,7 @@ struct svc_i3c_xfer {
  * @ibi.tbq_slot: To be queued IBI slot
  * @ibi.lock: IBI lock
  * @lock: Transfer lock, protect between IBI work thread and callbacks from master
+ * @enabled_events: Bit masks for enable events (IBI, HotJoin).
  */
 struct svc_i3c_master {
 	struct i3c_master_controller base;
@@ -199,6 +203,7 @@ struct svc_i3c_master {
 		spinlock_t lock;
 	} ibi;
 	struct mutex lock;
+	int enabled_events;
 };
 
 /**
@@ -213,6 +218,11 @@ struct svc_i3c_i2c_dev_data {
 	struct i3c_generic_ibi_pool *ibi_pool;
 };
 
+static inline bool is_events_enabled(struct svc_i3c_master *master, u32 mask)
+{
+	return !!(master->enabled_events & mask);
+}
+
 static bool svc_i3c_master_error(struct svc_i3c_master *master)
 {
 	u32 mstatus, merrwarn;
@@ -432,13 +442,16 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 	switch (ibitype) {
 	case SVC_I3C_MSTATUS_IBITYPE_IBI:
 		dev = svc_i3c_master_dev_from_addr(master, ibiaddr);
-		if (!dev)
+		if (!dev || !is_events_enabled(master, SVC_I3C_EVENT_IBI))
 			svc_i3c_master_nack_ibi(master);
 		else
 			svc_i3c_master_handle_ibi(master, dev);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_HOT_JOIN:
-		svc_i3c_master_ack_ibi(master, false);
+		if (is_events_enabled(master, SVC_I3C_EVENT_HOTJOIN))
+			svc_i3c_master_ack_ibi(master, false);
+		else
+			svc_i3c_master_nack_ibi(master);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_nack_ibi(master);
@@ -475,7 +488,9 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 		svc_i3c_master_emit_stop(master);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_HOT_JOIN:
-		queue_work(master->base.wq, &master->hj_work);
+		svc_i3c_master_emit_stop(master);
+		if (is_events_enabled(master, SVC_I3C_EVENT_HOTJOIN))
+			queue_work(master->base.wq, &master->hj_work);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 	default:
@@ -1475,6 +1490,7 @@ static int svc_i3c_master_enable_ibi(struct i3c_dev_desc *dev)
 		return ret;
 	}
 
+	master->enabled_events |= SVC_I3C_EVENT_IBI;
 	svc_i3c_master_enable_interrupts(master, SVC_I3C_MINT_SLVSTART);
 
 	return i3c_master_enec_locked(m, dev->info.dyn_addr, I3C_CCC_EVENT_SIR);
@@ -1486,7 +1502,9 @@ static int svc_i3c_master_disable_ibi(struct i3c_dev_desc *dev)
 	struct svc_i3c_master *master = to_svc_i3c_master(m);
 	int ret;
 
-	svc_i3c_master_disable_interrupts(master);
+	master->enabled_events &= ~SVC_I3C_EVENT_IBI;
+	if (!master->enabled_events)
+		svc_i3c_master_disable_interrupts(master);
 
 	ret = i3c_master_disec_locked(m, dev->info.dyn_addr, I3C_CCC_EVENT_SIR);
 
@@ -1496,6 +1514,39 @@ static int svc_i3c_master_disable_ibi(struct i3c_dev_desc *dev)
 	return ret;
 }
 
+static int svc_i3c_master_enable_hotjoin(struct i3c_master_controller *m)
+{
+	struct svc_i3c_master *master = to_svc_i3c_master(m);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(master->dev);
+	if (ret < 0) {
+		dev_err(master->dev, "<%s> Cannot get runtime PM.\n", __func__);
+		return ret;
+	}
+
+	master->enabled_events |= SVC_I3C_EVENT_HOTJOIN;
+
+	svc_i3c_master_enable_interrupts(master, SVC_I3C_MINT_SLVSTART);
+
+	return 0;
+}
+
+static int svc_i3c_master_disable_hotjoin(struct i3c_master_controller *m)
+{
+	struct svc_i3c_master *master = to_svc_i3c_master(m);
+
+	master->enabled_events &= ~SVC_I3C_EVENT_HOTJOIN;
+
+	if (!master->enabled_events)
+		svc_i3c_master_disable_interrupts(master);
+
+	pm_runtime_mark_last_busy(master->dev);
+	pm_runtime_put_autosuspend(master->dev);
+
+	return 0;
+}
+
 static void svc_i3c_master_recycle_ibi_slot(struct i3c_dev_desc *dev,
 					    struct i3c_ibi_slot *slot)
 {
@@ -1522,6 +1573,8 @@ static const struct i3c_master_controller_ops svc_i3c_master_ops = {
 	.recycle_ibi_slot = svc_i3c_master_recycle_ibi_slot,
 	.enable_ibi = svc_i3c_master_enable_ibi,
 	.disable_ibi = svc_i3c_master_disable_ibi,
+	.enable_hotjoin = svc_i3c_master_enable_hotjoin,
+	.disable_hotjoin = svc_i3c_master_disable_hotjoin,
 };
 
 static int svc_i3c_master_prepare_clks(struct svc_i3c_master *master)
-- 
2.43.0



