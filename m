Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EEA5867D0;
	Thu, 17 Sep 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660901; cv=none; b=EdeJp+m7s551hLUV3SKfDIZHGOIKwVDhDAx7wI/dyvG3q8Cf5CfnYVtjk0wOLfiwohGZpC4Oh2JQyJyG6CMm+DvymYtVafovaCLUeY2LYSOPE9RFjvCreQtqx8IXi8dJVjkVudkqZBFXssUvUM8QcWoS7DuSSjATL10F5VJnRTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660901; c=relaxed/simple;
	bh=S1rVX9+DYdDIYbIvN17Tk+RPYdeyREZITpFFFU9tI28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsNMqOyUlkWtZ6Ejc5z4DhrcpiFMh83aQo2VLS8aaaWmmfyOpPCWG642hS7t/LB0Y7bWJ6Y81qKDFn0Y9QISW5mfy7vbBtWQd3Zm3JvKNew769vCtf7CMiRzoXXHiYGAbesi0iINrG3pk8UTZkE1lU9exiJFzUIBlvoteHz15LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMiwi0/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMiwi0/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA0B1F000FF;
	Thu, 17 Sep 2026 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660900;
	bh=bRnjCzPzgbSpz3QW8E5gMg/O23l9AdUYhV/50SPxLS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMiwi0/aIfhHH6/0dbQJIESv+clw9/PuwcF74v+kjyIA1OpLFeeXq4sxx48zj9LT1
	 Q1xm17SI59o3ijtl3SmfUY3dtIWW2avRfdtK1xB+yW9/fa8MB9qiTrKv3oOg+Lk75r
	 ApbBR4ZGsTvw5vY3H6mfAuDIchrCCCUR4czRoDjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0016/1250] drm/xe: Fix null pointer dereference in devcoredump cleanup
Date: Thu, 17 Sep 2026 15:56:51 +0100
Message-ID: <20260917151552.366463960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit 12ef528d78adc8ea4e7e3db594f3bcac327e79fa ]

In xe_devcoredump_snapshot_free(), ss->gt may be NULL when the snapshot
was never fully populated (e.g., when cleanup is triggered without a
prior capture). Guard the xe_guc_capture_put_matched_nodes() call with
IS_ERR_OR_NULL() to prevent a null dereference.

In xe_devcoredump_free(), the deferred work is only queued when a
coredump is captured, so guard cancel_work_sync() with a check on
coredump->captured.

Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260326181017.2060209-1-zhanjun.dong@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_devcoredump.c b/drivers/gpu/drm/xe/xe_devcoredump.c
index 203e3038cc817..26a294f79e79f 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -150,7 +150,8 @@ static void xe_devcoredump_snapshot_free(struct xe_devcoredump_snapshot *ss)
 	xe_guc_ct_snapshot_free(ss->guc.ct);
 	ss->guc.ct = NULL;
 
-	xe_guc_capture_put_matched_nodes(&ss->gt->uc.guc);
+	if (!IS_ERR_OR_NULL(ss->gt))
+		xe_guc_capture_put_matched_nodes(&ss->gt->uc.guc);
 	ss->matched_node = NULL;
 
 	xe_guc_exec_queue_snapshot_free(ss->ge);
@@ -255,7 +256,8 @@ static void xe_devcoredump_free(void *data)
 	if (!data || !coredump_to_xe(coredump))
 		return;
 
-	cancel_work_sync(&coredump->snapshot.work);
+	if (coredump->captured)
+		cancel_work_sync(&coredump->snapshot.work);
 
 	mutex_lock(&coredump->lock);
 
-- 
2.53.0



