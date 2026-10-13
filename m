Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403114F5E0A;
	Tue, 13 Oct 2026 12:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893323; cv=none; b=SIprgy5DIDuYri53YZq8Btc05D1EcM54w/0ODw3tR9ggFxUmXLayXxzuhxaPPu4/GSRoN8wtvNAfqZ5mM9HeQylNUSThs+ASFol7d6CSYLjEDMGJPqkw/XwBWYMhhSWEd3JlNrt9lwdIbdFo5lOF7kLfnCzn78EF9Ip0w9XJ1b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893323; c=relaxed/simple;
	bh=3PBIWjiQGPxl+baSbWVvPFeGH5l1UwyU07pGCQqYSr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ked4mRiF4+sFlLz4CawyXxBuKEyq9s5YRJVHQZWfsAYt5vUwcGfZ12/R2IyGLl177MpmW2f1Gs03rHJh+mvcyh1FYIbR3S2An0pqFqKMaljO8dXMMjTrwRfIH3GvgNoF33H/cOnFTVRIiBoBvkYg3GgWGSfX+06+8wPQHYj0jYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyzZgsim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyzZgsim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8701A1F00893;
	Tue, 13 Oct 2026 12:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893321;
	bh=SKYzD40y9ZXPKLu8+lSrbrCJeYfNwzkVOd6zx7dPey0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyzZgsimCZI+qBnsoKehDeGgb1Gre3gyokH16pVMlTl7FH0Hjk49E3/bIpSLo3uXX
	 I/jptaZtVKLvUCQ0i6oV/u7DwiNSAm56IjnSewKlSWo8TE+E+r9hygKRWFgd6KH/x2
	 vVGea6H+5esXAOUm03a4ahHtjqHvtM+GvGEE9UJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/621] media: v4l2-mem2mem: Add a kref to the v4l2_m2m_dev structure
Date: Tue, 13 Oct 2026 13:33:01 +0200
Message-ID: <20261013112925.277064127@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit db6b97a4f8041e479be9ef4b8b07022636c96f50 ]

Adding a reference count to the v4l2_m2m_dev structure allow safely
sharing it across multiple hardware nodes. This can be used to prevent
running jobs concurrently on m2m cores that have some internal resource
sharing.

Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[hverkuil: fix typos in v4l2_m2m_put documentation]
Stable-dep-of: e0203ddf9af7 ("media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 23 +++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           | 21 +++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 21acd9bc86071..bc8218d1cab9f 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -90,6 +90,7 @@ static const char * const m2m_entity_name[] = {
  * @job_work:		worker to run queued jobs.
  * @job_queue_flags:	flags of the queue status, %QUEUE_PAUSED.
  * @m2m_ops:		driver callbacks
+ * @kref:		device reference count
  */
 struct v4l2_m2m_dev {
 	struct v4l2_m2m_ctx	*curr_ctx;
@@ -109,6 +110,8 @@ struct v4l2_m2m_dev {
 	unsigned long		job_queue_flags;
 
 	const struct v4l2_m2m_ops *m2m_ops;
+
+	struct kref kref;
 };
 
 static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx *m2m_ctx,
@@ -1206,6 +1209,7 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 	INIT_LIST_HEAD(&m2m_dev->job_queue);
 	spin_lock_init(&m2m_dev->job_spinlock);
 	INIT_WORK(&m2m_dev->job_work, v4l2_m2m_device_run_work);
+	kref_init(&m2m_dev->kref);
 
 	return m2m_dev;
 }
@@ -1217,6 +1221,25 @@ void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_release);
 
+void v4l2_m2m_get(struct v4l2_m2m_dev *m2m_dev)
+{
+	kref_get(&m2m_dev->kref);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_get);
+
+static void v4l2_m2m_release_from_kref(struct kref *kref)
+{
+	struct v4l2_m2m_dev *m2m_dev = container_of(kref, struct v4l2_m2m_dev, kref);
+
+	v4l2_m2m_release(m2m_dev);
+}
+
+void v4l2_m2m_put(struct v4l2_m2m_dev *m2m_dev)
+{
+	kref_put(&m2m_dev->kref, v4l2_m2m_release_from_kref);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_put);
+
 struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 		void *drv_priv,
 		int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq))
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 500f81f399dfa..08e3c9c4f1e9d 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -544,6 +544,27 @@ v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
  */
 void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
 
+/**
+ * v4l2_m2m_get() - take a reference to the m2m_dev structure
+ *
+ * @m2m_dev: opaque pointer to the internal data to handle M2M context
+ *
+ * This is used to share the M2M device across multiple devices. This
+ * can be used to avoid scheduling two hardware nodes concurrently.
+ */
+void v4l2_m2m_get(struct v4l2_m2m_dev *m2m_dev);
+
+/**
+ * v4l2_m2m_put() - remove a reference to the m2m_dev structure
+ *
+ * @m2m_dev: opaque pointer to the internal data to handle M2M context
+ *
+ * Once the M2M device has no more references, v4l2_m2m_release() will be
+ * called automatically. Users of this method should never call
+ * v4l2_m2m_release() directly. See v4l2_m2m_get() for more details.
+ */
+void v4l2_m2m_put(struct v4l2_m2m_dev *m2m_dev);
+
 /**
  * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
  *
-- 
2.53.0



