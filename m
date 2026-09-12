Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6E345561A;
	Sat, 12 Sep 2026 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209954; cv=none; b=O0ksJZgY3tN2Rtj3AmBnajV0jk6TIMZm3rlIYOAm+OtbBuM8//BnpzHSCVJX3yZOTBd/BTzloyIc0W+9XPhW7zTrf3gM6/AfGx2/fogMA5dWk6iNUIVH5SaY7QPwga5D+99QOWzRvrvk+294DHfFApLLpiruN3/RkcPWoG8gVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209954; c=relaxed/simple;
	bh=IejIheMdBanX+9lLYBLxwfBwOt3g/82laCAXiPpEN1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh1mT3QV5lNpybMrjb9Dw0ql6OZk6wcgyXdGQN8kmA1T4UeX+vAO/GnNl/XFQLS8WG8IuPTEXJS+ltVA2BwMbokl3tYCzF/wkAf6cOVWYt9u9c/vYVV8UbqHJEGAoDbr7Hxrji+kT3NfGrL0/XTF/ATGzM8D0d8+TtPuxyHXXNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eW2Q9ZPb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eW2Q9ZPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AEB1F000FF;
	Sat, 12 Sep 2026 10:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209953;
	bh=/hTsbHo5J+lrk1EkpQ29N3vFS2gJqGB/mwFLC0FVEzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eW2Q9ZPbLu+IT0jwT8fgpy+TRYLYZQRr7kEfA9kILLVMw0ijpCMhgfTtS7/J5iOEJ
	 l0SRMz0G/CiEJ3/SDhyjZGIXuRE0wBiCw9cKNjRGIwmKZRgCj+QBpzCagpdPFGKts8
	 YBTUndaaAC+CmwLcF1iYVbC/EE96YzqST4RMidsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0928/1518] module/dups: Inform duplicate requests about the result directly
Date: Sat, 12 Sep 2026 08:51:37 +0200
Message-ID: <20260912065644.444295842@linuxfoundation.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit d258ed8a86bb46bbbbc84fb914478259a1e694a4 ]

When kmod_dup_request_announce() announces the completion of
a request_module() call to duplicate waiters, it queues a work item to
invoke kmod_dup_request_complete(), and only that function calls
complete_all().

This adds an arbitrary delay that is unnecessary and provides little
benefit. Call complete_all() directly from kmod_dup_request_announce()
instead.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Stable-dep-of: 5eecb11b543f ("module/dups: Fix use-after-free in kmod_dup_req lifetime handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/dups.c | 43 +++++++++----------------------------------
 1 file changed, 9 insertions(+), 34 deletions(-)

diff --git a/kernel/module/dups.c b/kernel/module/dups.c
index 6ecc42193de24..7b9b08031d7d2 100644
--- a/kernel/module/dups.c
+++ b/kernel/module/dups.c
@@ -48,7 +48,6 @@ struct kmod_dup_req {
 	struct list_head list;
 	char name[MODULE_NAME_LEN];
 	struct completion first_req_done;
-	struct work_struct complete_work;
 	struct delayed_work delete_work;
 	int dup_ret;
 };
@@ -93,29 +92,6 @@ static void kmod_dup_request_delete(struct work_struct *work)
 	kfree(kmod_req);
 }
 
-static void kmod_dup_request_complete(struct work_struct *work)
-{
-	struct kmod_dup_req *kmod_req;
-
-	kmod_req = container_of(work, struct kmod_dup_req, complete_work);
-
-	/*
-	 * This will ensure that the kernel will let all the waiters get
-	 * informed its time to check the return value. It's time to
-	 * go home.
-	 */
-	complete_all(&kmod_req->first_req_done);
-
-	/*
-	 * Now that we have allowed prior request_module() calls to go on
-	 * with life, let's schedule deleting this entry. We don't have
-	 * to do it right away, but we *eventually* want to do it so to not
-	 * let this linger forever as this is just a boot optimization for
-	 * possible abuses of vmalloc() incurred by finit_module() thrashing.
-	 */
-	queue_delayed_work(system_dfl_wq, &kmod_req->delete_work, 60 * HZ);
-}
-
 bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 {
 	struct kmod_dup_req *kmod_req, *new_kmod_req;
@@ -130,7 +106,6 @@ bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 		return false;
 
 	strscpy(new_kmod_req->name, module_name);
-	INIT_WORK(&new_kmod_req->complete_work, kmod_dup_request_complete);
 	INIT_DELAYED_WORK(&new_kmod_req->delete_work, kmod_dup_request_delete);
 	init_completion(&new_kmod_req->first_req_done);
 
@@ -230,17 +205,17 @@ void kmod_dup_request_announce(char *module_name, int ret)
 
 	kmod_req->dup_ret = ret;
 
+	/* Inform all duplicate waiters to check the return value. */
+	complete_all(&kmod_req->first_req_done);
+
 	/*
-	 * If we complete() here we may allow duplicate threads
-	 * to continue before the first one that submitted the
-	 * request. We're in no rush also, given that each and
-	 * every bounce back to userspace is slow we avoid that
-	 * with a slight delay here. So queueue up the completion
-	 * and let duplicates suffer, just wait a tad bit longer.
-	 * There is no rush. But we also don't want to hold the
-	 * caller up forever or introduce any boot delays.
+	 * Now that we have allowed prior request_module() calls to go on
+	 * with life, let's schedule deleting this entry. We don't have
+	 * to do it right away, but we *eventually* want to do it so to not
+	 * let this linger forever as this is just a boot optimization for
+	 * possible abuses of vmalloc() incurred by finit_module() thrashing.
 	 */
-	queue_work(system_dfl_wq, &kmod_req->complete_work);
+	queue_delayed_work(system_dfl_wq, &kmod_req->delete_work, 60 * HZ);
 
 out:
 	mutex_unlock(&kmod_dup_mutex);
-- 
2.53.0



