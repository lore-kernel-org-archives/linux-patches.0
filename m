Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7A1CA6F;
	Sat, 12 Sep 2026 10:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208344; cv=none; b=cTE4xFf6SQxN78Y74iCt90cDpNtiUiNmXnOKUxDdMfuPEnj0QLFntutq8eAU5Igvg1yu76HTHCzIynVVioCTLNHRDnMFsHh8aq27y++0IMhGGdRpugCZQ6yojr6QwrSa5o1ahSfIz589RsGVpheussDOyp7M4ESGrQ0JVK2GsX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208344; c=relaxed/simple;
	bh=GAFoZ11nzZIFPinD3S4RKhIhbFB1pu1tU4oOmJE5kuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzTFu/ZtXH9E2oZsVdFhaCNAmSsT2PXUvRLWYfXBjZwh3/O0lJxv0buib53izS6abAMmt2piCk/zRm0HKzoYMPEuQnvEgRqNO91/NJkgXvf5dBFvHKjrGbmhig4LEGI7VwzMvfxYO0+GSSZacSty2+x7+BAXitNQuf47FkTdbkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+wp2Hw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+wp2Hw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECC01F000FF;
	Sat, 12 Sep 2026 10:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208343;
	bh=Sx9ejGr6yN0bgOnt4NXDLNrnbg5IKU+m27ui9+dYH0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+wp2Hw9RMohnhNMgKE/ehIjjLR19UirjFvZbBNfmoElcchqp+J6OE3xsymDAtyXP
	 0AUTTMmJ44L2HMkYw5xw3kGtHGuxTh6PC2gUs2+XChUXc7ifdP8HyHTusWLnq5hMxj
	 dmZHtPK5AlC8FPcWgyEjJ2jcTE/uDTOE/DWzkcFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0596/1518] remoteproc: core: Attach rproc asynchronously in rproc_add() path via schedule_work()
Date: Sat, 12 Sep 2026 08:46:05 +0200
Message-ID: <20260912065636.907662395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 026a3fada43261e403c6c4d9bda9501547e3f108 ]

Unlike the remoteproc firmware load path where rproc_add() call
rproc_auto_boot_callback() asynchronously and ignores the return value of
rproc_boot(), the attach path calls rproc_boot() synchronously and
propagates its return value back to rproc_add(). This means a failure
during rproc_attach() causes rproc_add() to fail and triggers resource
release, removing the remoteproc from sysfs and making it unavailable for
recovery or further boot attempts.

Align the remoteproc attach path with the firmware load path by
introducing attach_work and scheduling rproc_boot() asynchronously via
schedule_work(). This keeps the remoteproc registered and available in
sysfs even if the initial attach attempt fails, and avoids blocking
rproc_add() on the attach result.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-1-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 74ee3b2f5767 ("remoteproc: Prevent crash handling to race with rproc_del()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 20 ++++++++++++--------
 include/linux/remoteproc.h           |  2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 321ec76d20521..9a2208a2ffbca 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1678,18 +1678,21 @@ static void rproc_auto_boot_callback(const struct firmware *fw, void *context)
 	release_firmware(fw);
 }
 
+static void rproc_attach_work(struct work_struct *work)
+{
+	struct rproc *rproc = container_of(work, struct rproc, attach_work);
+
+	rproc_boot(rproc);
+}
+
 static int rproc_trigger_auto_boot(struct rproc *rproc)
 {
 	int ret;
 
-	/*
-	 * Since the remote processor is in a detached state, it has already
-	 * been booted by another entity.  As such there is no point in waiting
-	 * for a firmware image to be loaded, we can simply initiate the process
-	 * of attaching to it immediately.
-	 */
-	if (rproc->state == RPROC_DETACHED)
-		return rproc_boot(rproc);
+	if (rproc->state == RPROC_DETACHED) {
+		schedule_work(&rproc->attach_work);
+		return 0;
+	}
 
 	/*
 	 * We're initiating an asynchronous firmware loading, so we can
@@ -2520,6 +2523,7 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 	INIT_LIST_HEAD(&rproc->dump_segments);
 
 	INIT_WORK(&rproc->crash_handler, rproc_crash_handler_work);
+	INIT_WORK(&rproc->attach_work, rproc_attach_work);
 
 	rproc->state = RPROC_OFFLINE;
 
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index b4795698d8c2a..580d324a1e8ff 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -526,6 +526,7 @@ enum rproc_features {
  * @subdevs: list of subdevices, to following the running state
  * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
  * @index: index of this rproc device
+ * @attach_work: workqueue for attaching rproc
  * @crash_handler: workqueue for handling a crash
  * @crash_cnt: crash counter
  * @recovery_disabled: flag that state if recovery was disabled
@@ -568,6 +569,7 @@ struct rproc {
 	struct list_head subdevs;
 	struct idr notifyids;
 	int index;
+	struct work_struct attach_work;
 	struct work_struct crash_handler;
 	unsigned int crash_cnt;
 	bool recovery_disabled;
-- 
2.53.0



