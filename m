Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBB534F270;
	Tue, 16 Dec 2025 11:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885649; cv=none; b=rC0dZ2nvQRRwUSQugpLwYU1lX79OWtndUFsx1xssTZFxmcTPu9Y3CjQZIZTK344llIyOA+2lZhb60UPpLY6I+gQph06qI7vq30PWgT4TWtzIoi+oRaHKQN7R7QWxdNOYcZvYCV0ZxG37fiunJ/3TtorBI55lu7tENZpAuSrS2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885649; c=relaxed/simple;
	bh=leaDV+k2FvhUhBhExaJpJaMecTEtdjYwEyv1ay79jzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJFWGVKPtPfIaBY5PwOlmzJePT2yCzsBHSa0Wb/fAePcB/P5znHTP2av/EQ5Gdyy1wMTu1Ds1XuPSjVpTxOaWy4lhNQReb3eExPr8Xau2/bwzq+uG1g5SmfQxQd8JhsnLIbojtTmQgMTb/4q0gY3j5c8LqOolwBnW/tMPxbZZ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNSCvPJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNSCvPJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D44C4CEF1;
	Tue, 16 Dec 2025 11:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885649;
	bh=leaDV+k2FvhUhBhExaJpJaMecTEtdjYwEyv1ay79jzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNSCvPJbr6tTYc79S6PJ8bAF97ZCCOo3WJ+Fw1UEo4LjrJDaZzVTYubcZfmEEvShI
	 9KzUtPYQjcOjaOW1AtD9YWmnMFHBcmehimTo4ZT5+KAgzW33Yv28HzPEsRuVyLyncx
	 PE77dsmY8fkBZWUHcDtG4gxMgFg2nQGXyHoKHyL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Worth <carl@os.amperecomputing.com>,
	Leo Yan <leo.yan@arm.com>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 201/507] coresight: tmc: add the handle of the event to the path
Date: Tue, 16 Dec 2025 12:10:42 +0100
Message-ID: <20251216111352.794755194@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Carl Worth <carl@os.amperecomputing.com>

[ Upstream commit aaa5abcc9d44d2c8484f779ab46d242d774cabcb ]

The handle is essential for retrieving the AUX_EVENT of each CPU and is
required in perf mode. It has been added to the coresight_path so that
dependent devices can access it from the path when needed.

The existing bug can be reproduced with:
perf record -e cs_etm//k -C 0-9 dd if=/dev/zero of=/dev/null

Showing an oops as follows:
Unable to handle kernel paging request at virtual address 000f6e84934ed19e

Call trace:
 tmc_etr_get_buffer+0x30/0x80 [coresight_tmc] (P)
 catu_enable_hw+0xbc/0x3d0 [coresight_catu]
 catu_enable+0x70/0xe0 [coresight_catu]
 coresight_enable_path+0xb0/0x258 [coresight]

Fixes: 080ee83cc361 ("Coresight: Change functions to accept the coresight_path")
Signed-off-by: Carl Worth <carl@os.amperecomputing.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Co-developed-by: Jie Gan <jie.gan@oss.qualcomm.com>
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250925-fix_helper_data-v2-1-edd8a07c1646@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c |  1 +
 drivers/hwtracing/coresight/coresight-tmc-etr.c  |  3 ++-
 include/linux/coresight.h                        | 10 ++++++----
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index f1551c08ecb20..20fdd09b75c93 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -520,6 +520,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 		goto out;
 
 	path = etm_event_cpu_path(event_data, cpu);
+	path->handle = handle;
 	/* We need a sink, no need to continue without one */
 	sink = coresight_get_sink(path);
 	if (WARN_ON_ONCE(!sink))
diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 800be06598c1b..60b0e0a6da057 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -1334,7 +1334,8 @@ static int tmc_enable_etr_sink_sysfs(struct coresight_device *csdev)
 struct etr_buf *tmc_etr_get_buffer(struct coresight_device *csdev,
 				   enum cs_mode mode, void *data)
 {
-	struct perf_output_handle *handle = data;
+	struct coresight_path *path = data;
+	struct perf_output_handle *handle = path->handle;
 	struct etr_perf_buffer *etr_perf;
 
 	switch (mode) {
diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index bb49080ec8f96..ead03818d7d75 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -333,12 +333,14 @@ static struct coresight_dev_list (var) = {				\
 
 /**
  * struct coresight_path - data needed by enable/disable path
- * @path_list:              path from source to sink.
- * @trace_id:          trace_id of the whole path.
+ * @path_list:		path from source to sink.
+ * @trace_id:		trace_id of the whole path.
+ * @handle:		handle of the aux_event.
  */
 struct coresight_path {
-	struct list_head	path_list;
-	u8			trace_id;
+	struct list_head		path_list;
+	u8				trace_id;
+	struct perf_output_handle	*handle;
 };
 
 enum cs_mode {
-- 
2.51.0



