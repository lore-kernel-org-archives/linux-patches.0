Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886962D0C94;
	Sat, 12 Sep 2026 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217537; cv=none; b=mb6XSiXDOs5m3BG9kyBTUG9D4Sk+gmUAm+FICt91wqp41FhqDeE/zFWthGyNeppQuDqOLsYD41o0SpUMueF20O2eLxC0KbkWVE3YEnNlvvnbW32FssoXOsk0qeJ6ZVBr5TuhLRMiERNNAsoBNJ4zm1Yg7b/InmG5XhXdyw2E444=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217537; c=relaxed/simple;
	bh=O4CCaQ/GCdu8UEFhHgdvm3RljvPBRqsh2Po1aUvhZD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L24Tqgdke/3EJh9mdtNnitdHXdL9hUpSOHweeAeoPhBtsW9isedOxRZfY4p7IEeq6ZzGTGshs9ljCaJQjBVXWBa9tbdjZCpPEstU0CjaMPjOPG7qOgOjFJ7uhLO6oP2mW4DMlh3qQwVInpYFt647mihHHGMTQYYTUJ8K/U6Ck2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWu7h+sQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWu7h+sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDA31F000FF;
	Sat, 12 Sep 2026 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217536;
	bh=cr+0kWZ0JiF3NSUG9eJuIfbPKvSvEcRAT9WlreE71Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWu7h+sQnz6MTcXqxFT1YRBkt+efb0kJFX0yy0J6btUp+YxOHGzJGI9hqRAzpUOR6
	 R5ddYX8YPm3LPRrKyWTkKpT5+X4MPG72qaWISbQJ6Q4FpQr/mcKIxdAGkRgUpjEQi3
	 m73SVlUCDmARevNyqvFl96kaeMS2dVEoJFqJsu/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0930/1376] module/dups: Fix use-after-free in kmod_dup_req lifetime handling
Date: Sat, 12 Sep 2026 08:55:56 +0200
Message-ID: <20260912065628.290294437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 5eecb11b543f9f417bcf0dea239ff99c6af65dbd ]

The kmod dups code uses RCU to ensure that a kmod_dup_req instance is freed
only after it is no longer referenced. When releasing an instance, the
kmod_dup_request_delete() function removes the kmod_dup_req from the
dup_kmod_reqs list, waits via synchronize_rcu() and finally frees it.
However, this doesn't work correctly because parallel users referencing the
instance in kmod_dup_request_exists_wait() don't enter an RCU read-side
critical section. This can result in a use-after-free.

The kmod_dup_request_exists_wait() function may need to hold a valid
reference to a kmod_dup_req instance across a blocking wait until the
corresponding modprobe command completes. This makes it unsuitable for RCU.

Fix the issue by changing the lifecycle management of kmod_dup_req to use
reference counting.

Fixes: 8660484ed1cf ("module: add debugging auto-load duplicate module support")
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/dups.c | 56 +++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 16 deletions(-)

diff --git a/kernel/module/dups.c b/kernel/module/dups.c
index 7b9b08031d7d2..c21b675c239b7 100644
--- a/kernel/module/dups.c
+++ b/kernel/module/dups.c
@@ -30,6 +30,7 @@
 #include <linux/ptrace.h>
 #include <linux/async.h>
 #include <linux/uaccess.h>
+#include <linux/refcount.h>
 
 #include "internal.h"
 
@@ -38,13 +39,12 @@
 static bool enable_dups_trace = IS_ENABLED(CONFIG_MODULE_DEBUG_AUTOLOAD_DUPS_TRACE);
 module_param(enable_dups_trace, bool_enable_only, 0644);
 
-/*
- * Protects dup_kmod_reqs list, adds / removals with RCU.
- */
+/* A mutex-protected list of active kmod requests. */
 static DEFINE_MUTEX(kmod_dup_mutex);
 static LIST_HEAD(dup_kmod_reqs);
 
 struct kmod_dup_req {
+	refcount_t refcount;
 	struct list_head list;
 	char name[MODULE_NAME_LEN];
 	struct completion first_req_done;
@@ -52,12 +52,24 @@ struct kmod_dup_req {
 	int dup_ret;
 };
 
+static void get_kmod_req(struct kmod_dup_req *kmod_req)
+{
+	refcount_inc(&kmod_req->refcount);
+}
+
+static void put_kmod_req(struct kmod_dup_req *kmod_req)
+{
+	if (refcount_dec_and_test(&kmod_req->refcount))
+		kfree(kmod_req);
+}
+
 static struct kmod_dup_req *kmod_dup_request_lookup(char *module_name)
 {
 	struct kmod_dup_req *kmod_req;
 
-	list_for_each_entry_rcu(kmod_req, &dup_kmod_reqs, list,
-				lockdep_is_held(&kmod_dup_mutex)) {
+	lockdep_assert_held(&kmod_dup_mutex);
+
+	list_for_each_entry(kmod_req, &dup_kmod_reqs, list) {
 		if (strlen(kmod_req->name) == strlen(module_name) &&
 		    !memcmp(kmod_req->name, module_name, strlen(module_name))) {
 			return kmod_req;
@@ -86,10 +98,10 @@ static void kmod_dup_request_delete(struct work_struct *work)
 	 * just returning 0.
 	 */
 	mutex_lock(&kmod_dup_mutex);
-	list_del_rcu(&kmod_req->list);
-	synchronize_rcu();
+	list_del(&kmod_req->list);
 	mutex_unlock(&kmod_dup_mutex);
-	kfree(kmod_req);
+
+	put_kmod_req(kmod_req);
 }
 
 bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
@@ -105,6 +117,7 @@ bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 	if (!new_kmod_req)
 		return false;
 
+	refcount_set(&new_kmod_req->refcount, 1);
 	strscpy(new_kmod_req->name, module_name);
 	INIT_DELAYED_WORK(&new_kmod_req->delete_work, kmod_dup_request_delete);
 	init_completion(&new_kmod_req->first_req_done);
@@ -136,10 +149,12 @@ bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 		 * keep tab on duplicates later.
 		 */
 		pr_debug("New request_module() for %s\n", module_name);
-		list_add_rcu(&new_kmod_req->list, &dup_kmod_reqs);
+		list_add(&new_kmod_req->list, &dup_kmod_reqs);
 		mutex_unlock(&kmod_dup_mutex);
 		return false;
 	}
+
+	get_kmod_req(kmod_req);
 	mutex_unlock(&kmod_dup_mutex);
 
 	/* We are dealing with a duplicate request now */
@@ -169,7 +184,7 @@ bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 		 * calls bail out right away.
 		 */
 		*dup_ret = 0;
-		return true;
+		goto out;
 	}
 
 	/*
@@ -184,12 +199,14 @@ bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 					TASK_KILLABLE);
 	if (ret) {
 		*dup_ret = ret;
-		return true;
+		goto out;
 	}
 
 	/* Now the duplicate request has the same exact return value as the first request */
 	*dup_ret = kmod_req->dup_ret;
 
+out:
+	put_kmod_req(kmod_req);
 	return true;
 }
 
@@ -199,15 +216,25 @@ void kmod_dup_request_announce(char *module_name, int ret)
 
 	mutex_lock(&kmod_dup_mutex);
 
+	/*
+	 * Look for a kmod_dup_req previously added in
+	 * kmod_dup_request_exists_wait(). Note that a request_module_nowait()
+	 * without its own kmod_dup_req entry can announce a result of
+	 * a concurrent request_module() call.
+	 */
 	kmod_req = kmod_dup_request_lookup(module_name);
-	if (!kmod_req)
-		goto out;
+	if (!kmod_req || completion_done(&kmod_req->first_req_done)) {
+		mutex_unlock(&kmod_dup_mutex);
+		return;
+	}
 
 	kmod_req->dup_ret = ret;
 
 	/* Inform all duplicate waiters to check the return value. */
 	complete_all(&kmod_req->first_req_done);
 
+	mutex_unlock(&kmod_dup_mutex);
+
 	/*
 	 * Now that we have allowed prior request_module() calls to go on
 	 * with life, let's schedule deleting this entry. We don't have
@@ -216,7 +243,4 @@ void kmod_dup_request_announce(char *module_name, int ret)
 	 * possible abuses of vmalloc() incurred by finit_module() thrashing.
 	 */
 	queue_delayed_work(system_dfl_wq, &kmod_req->delete_work, 60 * HZ);
-
-out:
-	mutex_unlock(&kmod_dup_mutex);
 }
-- 
2.53.0



