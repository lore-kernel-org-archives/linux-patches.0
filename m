Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F7D36B923;
	Sat, 12 Sep 2026 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239609; cv=none; b=CEkdW8xPLAeZT3we+Y3LyX+u2ElPkLG3EtWv3Pzv471UzvnQoMYAmz4Uqxlo1QWJ7G0jgXYWNyy4tkb8EpF0eHqftv+tj8CeIJzKjg8E0y7Wk4x9Du2SFyKUBo0z3JRSNqJWBc5vw2P7GRZnWgcz7vAwsfsxatH65HaB+t83V0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239609; c=relaxed/simple;
	bh=m+ZTSLqCM+qDMfEw6Z9bbXSQbofM6+0mD+D38OD9/Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6rL2nQ7IKQ5M4WGknFTT5D+7Lf5SATFCeAN0Or6u0aQk9sr0wLWSihg6MV2X1zy26BIVdJl5NvpXER4q4VdOFqeFAdfKrmxEuLdW6Ot7tnc1K//J+Fwremwt9ceLEsQtvjsYgbC3EGB3PPA4P7TVxkY9AT/2HmppMHTZw/YpVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaVw3idt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaVw3idt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5A21F000FF;
	Sat, 12 Sep 2026 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239608;
	bh=C1RzLZ2ipctl73n3M+g5hF2GheAW7sjv0Pc+c5zSM7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaVw3idtoQKgFInhWt7SX6gp3SIyyW4S3E2rsvMo7eS2dbQv9u5z5PiRrtsMizHqI
	 ZPSpt1vWz2EAqN0mY+7F6vxyR1fHQFhoTiKnBJs1N6UesVh+aW2665vbFWYeZgBhGa
	 mWBy7zXZMNQ+qEfgW5y+8NswW2N6BOnypKD4xfhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 699/935] remoteproc: use rsc_table_for_each_entry() in rproc_handle_resources()
Date: Sat, 12 Sep 2026 09:02:09 +0200
Message-ID: <20260912065542.871545471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 49abb5d6e1ac8169cdfc0c3aa4408e0d90ee5696 ]

Replace the open-coded resource table iteration loop in
rproc_handle_resources() with the rsc_table_for_each_entry() helper.

The remoteproc-specific dispatch logic (vendor resource handling via
rproc_handle_rsc(), RSC_LAST bounds check, handler table lookup) is
moved into a local callback rproc_handle_rsc_entry(), keeping the
iteration mechanics in one canonical place.

The callback receives the payload offset within the table so that
handlers which write back into the resource table (e.g.
rproc_handle_carveout() recording a dynamically allocated address via
rsc_offset) continue to work correctly.

No functional change.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260506050107.1985033-3-mukesh.ojha@oss.qualcomm.com
Stable-dep-of: bb840ea69347 ("remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 81 +++++++++++++---------------
 include/linux/rsc_table.h            | 53 ++++++++++++++++++
 2 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index bada40563b385..a41b793e994e4 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1126,60 +1126,55 @@ static rproc_handle_resource_t rproc_loading_handlers[RSC_LAST] = {
 	[RSC_VDEV] = rproc_handle_vdev,
 };
 
-/* handle firmware resource entries before booting the remote processor */
-static int rproc_handle_resources(struct rproc *rproc,
-				  rproc_handle_resource_t handlers[RSC_LAST])
+struct rproc_rsc_cb_data {
+	struct rproc *rproc;
+	rproc_handle_resource_t *handlers;
+};
+
+static int rproc_handle_rsc_entry(u32 type, void *rsc, int offset,
+				  int avail, void *data)
 {
+	struct rproc_rsc_cb_data *d = data;
+	struct rproc *rproc = d->rproc;
 	struct device *dev = &rproc->dev;
 	rproc_handle_resource_t handler;
-	int ret = 0, i;
-
-	if (!rproc->table_ptr)
-		return 0;
+	int ret;
 
-	for (i = 0; i < rproc->table_ptr->num; i++) {
-		int offset = rproc->table_ptr->offset[i];
-		struct fw_rsc_hdr *hdr = (void *)rproc->table_ptr + offset;
-		int avail = rproc->table_sz - offset - sizeof(*hdr);
-		void *rsc = (void *)hdr + sizeof(*hdr);
+	dev_dbg(dev, "rsc: type %d\n", type);
 
-		/* make sure table isn't truncated */
-		if (avail < 0) {
-			dev_err(dev, "rsc table is truncated\n");
-			return -EINVAL;
-		}
-
-		dev_dbg(dev, "rsc: type %d\n", hdr->type);
+	if (type >= RSC_VENDOR_START && type <= RSC_VENDOR_END) {
+		ret = rproc_handle_rsc(rproc, type, rsc, offset, avail);
+		if (ret == RSC_HANDLED)
+			return 0;
+		if (ret < 0)
+			return ret;
+		dev_warn(dev, "unsupported vendor resource %d\n", type);
+		return 0;
+	}
 
-		if (hdr->type >= RSC_VENDOR_START &&
-		    hdr->type <= RSC_VENDOR_END) {
-			ret = rproc_handle_rsc(rproc, hdr->type, rsc,
-					       offset + sizeof(*hdr), avail);
-			if (ret == RSC_HANDLED)
-				continue;
-			else if (ret < 0)
-				break;
+	if (type >= RSC_LAST) {
+		dev_warn(dev, "unsupported resource %d\n", type);
+		return 0;
+	}
 
-			dev_warn(dev, "unsupported vendor resource %d\n",
-				 hdr->type);
-			continue;
-		}
+	handler = d->handlers[type];
+	if (!handler)
+		return 0;
 
-		if (hdr->type >= RSC_LAST) {
-			dev_warn(dev, "unsupported resource %d\n", hdr->type);
-			continue;
-		}
+	return handler(rproc, rsc, offset, avail);
+}
 
-		handler = handlers[hdr->type];
-		if (!handler)
-			continue;
+/* handle firmware resource entries before booting the remote processor */
+static int rproc_handle_resources(struct rproc *rproc,
+				  rproc_handle_resource_t handlers[RSC_LAST])
+{
+	struct rproc_rsc_cb_data d = { .rproc = rproc, .handlers = handlers };
 
-		ret = handler(rproc, rsc, offset + sizeof(*hdr), avail);
-		if (ret)
-			break;
-	}
+	if (!rproc->table_ptr)
+		return 0;
 
-	return ret;
+	return rsc_table_for_each_entry(rproc->table_ptr, rproc->table_sz,
+					&rproc->dev, rproc_handle_rsc_entry, &d);
 }
 
 static int rproc_prepare_subdevices(struct rproc *rproc)
diff --git a/include/linux/rsc_table.h b/include/linux/rsc_table.h
index c32c8b6cd2a77..c6d6d553d8f11 100644
--- a/include/linux/rsc_table.h
+++ b/include/linux/rsc_table.h
@@ -303,4 +303,57 @@ struct fw_rsc_vdev {
 	struct fw_rsc_vdev_vring vring[];
 } __packed;
 
+/**
+ * rsc_table_for_each_entry() - iterate over all entries in a resource table
+ * @table:    pointer to the resource table
+ * @table_sz: total size of the table buffer in bytes
+ * @dev:      device used for error logging
+ * @cb:       callback invoked for each entry:
+ *              @type   - value from enum fw_resource_type
+ *              @rsc    - pointer to the entry payload (past struct fw_rsc_hdr)
+ *              @offset - byte offset of the payload within the table; callers
+ *                        that write back into the table (e.g. to record a
+ *                        dynamically allocated address) use this to locate the
+ *                        entry for later update
+ *              @avail  - bytes available in the payload
+ *              @data   - caller-supplied private pointer
+ *            Return 0 to continue iteration, non-zero to stop.
+ * @data:     private pointer forwarded to @cb on every call
+ *
+ * Iterates over every resource entry in @table, performing the standard
+ * truncation check, and invokes @cb for each one. Iteration stops on the
+ * first non-zero return from @cb or on a malformed table.
+ *
+ * Returns 0 after a complete iteration, -EINVAL if the table is truncated,
+ * or the first non-zero value returned by @cb.
+ */
+static inline int rsc_table_for_each_entry(struct resource_table *table,
+					   size_t table_sz,
+					   struct device *dev,
+					   int (*cb)(u32 type, void *rsc,
+						     int offset, int avail,
+						     void *data),
+					   void *data) {
+	int i, ret;
+
+	for (i = 0; i < table->num; i++) {
+		int offset = table->offset[i];
+		struct fw_rsc_hdr *hdr = (void *)table + offset;
+		int avail = table_sz - offset - sizeof(*hdr);
+		int rsc_offset = offset + sizeof(*hdr);
+		void *rsc = (void *)hdr + sizeof(*hdr);
+
+		if (avail < 0) {
+			dev_err(dev, "rsc table is truncated\n");
+			return -EINVAL;
+		}
+
+		ret = cb(hdr->type, rsc, rsc_offset, avail, data);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 #endif /* RSC_TABLE_H */
-- 
2.53.0



