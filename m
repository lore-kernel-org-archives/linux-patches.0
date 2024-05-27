Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C17E1754B;
	Mon, 27 May 2024 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836611; cv=none; b=tAfe+Zv2IgERCxOm1stcH54AS9EfL+bwN8OxCFZhZL0Oj2Tr+MPQlU/7N4SxGGz/o8Czsr60geD65O4z90T3ueFbYViPrJOLcRvmrfWsjr3Pp5sJ0IGdbwogygmTWTRK3pZwhAlcpCYmNCgSxnmVgY5z/dHe7jURJvRDNaZt5Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836611; c=relaxed/simple;
	bh=LzqpY+72cu2oKkh5PBLaQAXSpSY1Fwr7HNuRiaCYkZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEv1yU8uGcM0XFVWy84eHyj9UJxcIP3rHuyoL3OzzPG0zbLBkqfSQR/kb4bXPHY+ery7X89iwkX/JVXE2rtSNp+2w5Evr8sUBaG/Nrt2PjeBDKqxXuVrGITcvNp0Rm/tpq/mtZyInDFk2F2wN+hy3cwzPCksjZU82p53gLLRNn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tqEuZoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tqEuZoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A81BC2BBFC;
	Mon, 27 May 2024 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836610;
	bh=LzqpY+72cu2oKkh5PBLaQAXSpSY1Fwr7HNuRiaCYkZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tqEuZoy9vS7xKYyb4GILQdEeaNwggAchzK85zVJx8IO+Fvb16dgJyMANOcMF6vse
	 OkQ9lC4QgNeydHSMWywKEaexfP1MlPuh9f7UfzPONAF4bpadwnCnWkxuVokXrHA2i8
	 1blR/GOr00/GskWvj2VcHI8TIDJMbA57dQaJB7iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 120/427] dlm: fix user space lock decision to copy lvb
Date: Mon, 27 May 2024 20:52:47 +0200
Message-ID: <20240527185613.054891873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit ad191e0eeebf64a60ca2d16ca01a223d2b1dd25e ]

This patch fixes the copy lvb decision for user space lock requests.
Checking dlm_lvb_operations is done earlier, where granted/requested
lock modes are available to use in the matrix.

The decision had been moved to the wrong location, where granted mode
and requested mode where the same, which causes the dlm_lvb_operations
matix to produce the wrong copy decision. For PW or EX requests, the
caller could get invalid lvb data.

Fixes: 61bed0baa4db ("fs: dlm: use a non-static queue for callbacks")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/ast.c          | 14 ++++++++++++++
 fs/dlm/dlm_internal.h |  1 +
 fs/dlm/user.c         | 15 ++-------------
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 1f2f70a1b824e..decedc4ee15f6 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -12,6 +12,7 @@
 #include <trace/events/dlm.h>
 
 #include "dlm_internal.h"
+#include "lvb_table.h"
 #include "memory.h"
 #include "lock.h"
 #include "user.h"
@@ -42,6 +43,7 @@ int dlm_enqueue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 	int rv = DLM_ENQUEUE_CALLBACK_SUCCESS;
 	struct dlm_callback *cb;
+	int copy_lvb = 0;
 	int prev_mode;
 
 	if (flags & DLM_CB_BAST) {
@@ -73,6 +75,17 @@ int dlm_enqueue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 				goto out;
 			}
 		}
+	} else if (flags & DLM_CB_CAST) {
+		if (test_bit(DLM_DFL_USER_BIT, &lkb->lkb_dflags)) {
+			if (lkb->lkb_last_cast)
+				prev_mode = lkb->lkb_last_cb->mode;
+			else
+				prev_mode = -1;
+
+			if (!status && lkb->lkb_lksb->sb_lvbptr &&
+			    dlm_lvb_operations[prev_mode + 1][mode + 1])
+				copy_lvb = 1;
+		}
 	}
 
 	cb = dlm_allocate_cb();
@@ -85,6 +98,7 @@ int dlm_enqueue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 	cb->mode = mode;
 	cb->sb_status = status;
 	cb->sb_flags = (sbflags & 0x000000FF);
+	cb->copy_lvb = copy_lvb;
 	kref_init(&cb->ref);
 	if (!test_and_set_bit(DLM_IFL_CB_PENDING_BIT, &lkb->lkb_iflags))
 		rv = DLM_ENQUEUE_CALLBACK_NEED_SCHED;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 3b4dbce849f0f..a9137c90f3483 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -222,6 +222,7 @@ struct dlm_callback {
 	int			sb_status;	/* copy to lksb status */
 	uint8_t			sb_flags;	/* copy to lksb flags */
 	int8_t			mode; /* rq mode of bast, gr mode of cast */
+	int			copy_lvb;
 
 	struct list_head	list;
 	struct kref		ref;
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 9f9b68448830e..12a483deeef5e 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -21,7 +21,6 @@
 #include "dlm_internal.h"
 #include "lockspace.h"
 #include "lock.h"
-#include "lvb_table.h"
 #include "user.h"
 #include "ast.h"
 #include "config.h"
@@ -806,8 +805,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	struct dlm_lkb *lkb;
 	DECLARE_WAITQUEUE(wait, current);
 	struct dlm_callback *cb;
-	int rv, ret, copy_lvb = 0;
-	int old_mode, new_mode;
+	int rv, ret;
 
 	if (count == sizeof(struct dlm_device_version)) {
 		rv = copy_version_to_user(buf, count);
@@ -864,9 +862,6 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 
 	lkb = list_first_entry(&proc->asts, struct dlm_lkb, lkb_cb_list);
 
-	/* rem_lkb_callback sets a new lkb_last_cast */
-	old_mode = lkb->lkb_last_cast->mode;
-
 	rv = dlm_dequeue_lkb_callback(lkb, &cb);
 	switch (rv) {
 	case DLM_DEQUEUE_CALLBACK_EMPTY:
@@ -895,12 +890,6 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	if (cb->flags & DLM_CB_BAST) {
 		trace_dlm_bast(lkb->lkb_resource->res_ls, lkb, cb->mode);
 	} else if (cb->flags & DLM_CB_CAST) {
-		new_mode = cb->mode;
-
-		if (!cb->sb_status && lkb->lkb_lksb->sb_lvbptr &&
-		    dlm_lvb_operations[old_mode + 1][new_mode + 1])
-			copy_lvb = 1;
-
 		lkb->lkb_lksb->sb_status = cb->sb_status;
 		lkb->lkb_lksb->sb_flags = cb->sb_flags;
 		trace_dlm_ast(lkb->lkb_resource->res_ls, lkb);
@@ -908,7 +897,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 
 	ret = copy_result_to_user(lkb->lkb_ua,
 				  test_bit(DLM_PROC_FLAGS_COMPAT, &proc->flags),
-				  cb->flags, cb->mode, copy_lvb, buf, count);
+				  cb->flags, cb->mode, cb->copy_lvb, buf, count);
 
 	kref_put(&cb->ref, dlm_release_callback);
 
-- 
2.43.0



