Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B9819E7F7;
	Tue, 16 Jul 2024 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145332; cv=none; b=Hm72vsOHOJjuk5VA7mQjDmJRfcwfUhCl7J3Y2jjg8a/6k+ncs0N/VA00nQ2/9DzQGEq3G6KFE9aOuTunmxifzwYK9yHNPveEm31BPO37Iv3LyVsRGU9tloNAhx2FnSmxN+sTD2mEHoXNSDgojMCiuEnI6Ik5M7cu5yWfKZOjVqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145332; c=relaxed/simple;
	bh=KnG1VaZv2Fc8t4ESjUkozP2JsxGkfIF73+D9Z9aGZVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUQRirHkHNI5MOsQrGaDZVNXML9eLm0gV3EvDmLzZ0CMS6wXtj71XZLGFvMiMKRuwHPHt2CoiumRpOsU43knu3zw44w8Z4XI6VDgk46/rJB27hpv+pIT7Gh0m4Vm1lDDfgtp+ZmvLPVKNvwCQ1pVMeyfdA1R5bZ+WPLeDGnHlFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVMrxlhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVMrxlhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E88C116B1;
	Tue, 16 Jul 2024 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145330;
	bh=KnG1VaZv2Fc8t4ESjUkozP2JsxGkfIF73+D9Z9aGZVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVMrxlhYFUVIaJZAU+jhLUE3U4+YeSiki8pjZY0vPBfX1WDqcsezQ86JgfGnIimTk
	 PYlxA9WXWmrGg6dOPTWtI0cu3BpYWH1N6EFD+wBlhG9Ym+ByMBTzH8WbznQ9jG8rmP
	 XRyavTFCRupQmI5m4/dGqIgIhrcK4yXgQy1/79sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Yin <yinxin.x@bytedance.com>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/96] cachefiles: narrow the scope of triggering EPOLLIN events in ondemand mode
Date: Tue, 16 Jul 2024 17:31:14 +0200
Message-ID: <20240716152746.651765928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Jia Zhu <zhujia.zj@bytedance.com>

[ Upstream commit b817e22b2e91257ace32a6768c3c003faeaa1c5c ]

Don't trigger EPOLLIN when there are only reopening read requests in
xarray.

Suggested-by: Xin Yin <yinxin.x@bytedance.com>
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Link: https://lore.kernel.org/r/20231120041422.75170-5-zhujia.zj@bytedance.com
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 12e009d60852 ("cachefiles: wait for ondemand_object_worker to finish when dropping object")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/daemon.c   | 14 ++++++++++++--
 fs/cachefiles/internal.h | 12 ++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index b9945e4f697be..06cdf1a8a16f6 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -357,14 +357,24 @@ static __poll_t cachefiles_daemon_poll(struct file *file,
 					   struct poll_table_struct *poll)
 {
 	struct cachefiles_cache *cache = file->private_data;
+	XA_STATE(xas, &cache->reqs, 0);
+	struct cachefiles_req *req;
 	__poll_t mask;
 
 	poll_wait(file, &cache->daemon_pollwq, poll);
 	mask = 0;
 
 	if (cachefiles_in_ondemand_mode(cache)) {
-		if (!xa_empty(&cache->reqs))
-			mask |= EPOLLIN;
+		if (!xa_empty(&cache->reqs)) {
+			rcu_read_lock();
+			xas_for_each_marked(&xas, req, ULONG_MAX, CACHEFILES_REQ_NEW) {
+				if (!cachefiles_ondemand_is_reopening_read(req)) {
+					mask |= EPOLLIN;
+					break;
+				}
+			}
+			rcu_read_unlock();
+		}
 	} else {
 		if (test_bit(CACHEFILES_STATE_CHANGED, &cache->flags))
 			mask |= EPOLLIN;
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 3eea52462fc87..e0eac16e4741c 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -335,6 +335,13 @@ cachefiles_ondemand_set_object_##_state(struct cachefiles_object *object) \
 CACHEFILES_OBJECT_STATE_FUNCS(open, OPEN);
 CACHEFILES_OBJECT_STATE_FUNCS(close, CLOSE);
 CACHEFILES_OBJECT_STATE_FUNCS(reopening, REOPENING);
+
+static inline bool cachefiles_ondemand_is_reopening_read(struct cachefiles_req *req)
+{
+	return cachefiles_ondemand_object_is_reopening(req->object) &&
+			req->msg.opcode == CACHEFILES_OP_READ;
+}
+
 #else
 static inline ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 					char __user *_buffer, size_t buflen)
@@ -365,6 +372,11 @@ static inline int cachefiles_ondemand_init_obj_info(struct cachefiles_object *ob
 static inline void cachefiles_ondemand_deinit_obj_info(struct cachefiles_object *obj)
 {
 }
+
+static inline bool cachefiles_ondemand_is_reopening_read(struct cachefiles_req *req)
+{
+	return false;
+}
 #endif
 
 /*
-- 
2.43.0



