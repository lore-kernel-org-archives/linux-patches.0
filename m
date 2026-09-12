Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B330143F0AD;
	Sat, 12 Sep 2026 08:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202373; cv=none; b=DsUuwmDH/HnVM3gAPJfMdJSHTgWyumeAm22rU7vFtg1rDWhhs/VYlaQEmCeEOgMGpe9IPV+9+JhG19CuLCrgyusNmrrKLemip7du8p+6Cxbk6CWz2yIBYtjGDQSFC7ig+UjJqBFeuKu/IvecIhBMNRLykWf71Rua2nuDNXqR9UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202373; c=relaxed/simple;
	bh=sS3BYLGqM+jiZXj/yba9Vxx8DFnskphQIQNPs2nG6fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eY5E/PAxXYtEEIHgjIseZCOEGASpu58DVcf1J96aA6JU9eFW9O4WNcMsbPjP4FjahPIvKQiplBuSBfcu/Lk/KZZbq9+d/4F1jV66Cr7dzvwIiIpXHW9Cy/UZ4Dxb2ZtlTGOvFTGBPB42A1eh2rr65aJ8e8iTUuX6r/dvqgurcwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGS4AEWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGS4AEWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AED01F00898;
	Sat, 12 Sep 2026 08:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202370;
	bh=JcnSPbCF+NsmWuZAmnioyhsAlDmezYjZa9Icb+tMx1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGS4AEWxyy6zSSXDzdAZwbdqQEQJY+s7T8Mhh4iKh2oznl3UNe0tTgdLmL+BgR6q4
	 aM3OzKp01CHz/mNPCuJkvJsfxMitZRLp8z9zjR3/Shz1ozdzTp4G6xnwaHdwdETuZu
	 mUNZ2fieNR2dsJabWp93U/nGXV36MCxVZFm9divM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1146/1815] module/dups: Inform duplicate requests about the result directly
Date: Sat, 12 Sep 2026 08:48:16 +0200
Message-ID: <20260912065715.917084297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8b6f8f177de4f..45080f451e5c6 100644
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



