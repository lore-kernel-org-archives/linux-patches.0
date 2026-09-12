Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C483A7F47;
	Sat, 12 Sep 2026 18:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239155; cv=none; b=MryElsmJEAFygoY3VGhCumcGl3sk7VMgUvL9auLjCkb0oMkrN8Pk83+TfpgFQzl8jWZJyKu7IKKClBWib2ASpGjDScs01cE42Fgg+3lkQiG/9YHOGoGjKo3Z/KRwZkKAPDkeL/KMwVWWZmPZLLiJbPoysn1WBIWBNzUyjOEr6wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239155; c=relaxed/simple;
	bh=KMObFZgQChJF95HHYEd53rJTZgOeIQgf6LayJhQ4HWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDU3CqSvCi4//dKhaksGMpw7HQ2T9EDi1RAi8pMVB2OEtwjxUen8rGJIkzWR0wwGXvtNNp9fssXEyOa9VBCQSbOsIY92CLwsISz7HEdym+HK/yyeppH/QX2d6Y/w2X16EdvX4L8dBMM5WzbFgcWCKI/wi65kEX5vzMr4AW/R+g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UThH+tKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UThH+tKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BE11F000FF;
	Sat, 12 Sep 2026 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239154;
	bh=p0B90ZBJ+FEqYIELWG0QmI96MsDoSMmdZ//Y/LcyPlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UThH+tKQrejEzOtPIQHTQdKGmJYa5dnWZRdt2Pc1KKqxVzWrlC2z1Q64kEI4kPZIq
	 dl73RkUZ2wukpoC0JNeM55D/Q6MjSi62W/IzYS9QX9vsUczBNgZIbK/bLzP0/IF1Ja
	 G+olKAfxNycM16QfjSFqNbABpR0rJ/2VdHl+2eyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/935] remoteproc: core: Attach rproc asynchronously in rproc_add() path via schedule_work()
Date: Sat, 12 Sep 2026 09:00:37 +0200
Message-ID: <20260912065540.766618794@linuxfoundation.org>
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
index 7c3383807aa9c..11ffaa5d06ca3 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1788,18 +1788,21 @@ static void rproc_auto_boot_callback(const struct firmware *fw, void *context)
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
@@ -2570,6 +2573,7 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 	INIT_LIST_HEAD(&rproc->dump_segments);
 
 	INIT_WORK(&rproc->crash_handler, rproc_crash_handler_work);
+	INIT_WORK(&rproc->attach_work, rproc_attach_work);
 
 	rproc->state = RPROC_OFFLINE;
 
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 83c09ac36b13b..3e98e55a2ce86 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -512,6 +512,7 @@ struct rproc_dump_segment {
  * @subdevs: list of subdevices, to following the running state
  * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
  * @index: index of this rproc device
+ * @attach_work: workqueue for attaching rproc
  * @crash_handler: workqueue for handling a crash
  * @crash_cnt: crash counter
  * @recovery_disabled: flag that state if recovery was disabled
@@ -552,6 +553,7 @@ struct rproc {
 	struct list_head subdevs;
 	struct idr notifyids;
 	int index;
+	struct work_struct attach_work;
 	struct work_struct crash_handler;
 	unsigned int crash_cnt;
 	bool recovery_disabled;
-- 
2.53.0



