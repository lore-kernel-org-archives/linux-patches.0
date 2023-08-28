Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B104611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED79FC433C8;
	Mon, 28 Aug 2023 10:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219251;
	bh=kZCqamOnE4ZHwPtQ/gHM18npCJoSWiWTPW0RHl3lmLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmzvMU/0shVTtUGXwmt0BuXnMYMKbeiOr9x3EGO4yDC1TR95IwI9lCZqN1kArdCHj
	 dxGMYZ25uIz+2YuTt8IMz9JVax2oFqRWW1nwu3coH1DfQfZFdwAvp3UzjDv3T3Rb8Y
	 WkbVeckYgCeHWaF4UxNC+mdB9wr5Fn7mdxexRk40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/158] fs: dlm: use dlm_plock_info for do_unlock_close
Date: Mon, 28 Aug 2023 12:13:17 +0200
Message-ID: <20230828101200.683064751@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 4d413ae9ced4180c0e2114553c3a7560b509b0f8 ]

This patch refactors do_unlock_close() by using only struct dlm_plock_info
as a parameter.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 57e2c2f2d94c ("fs: dlm: fix mismatch of plock results from userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/plock.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 0d00ca2c44c71..fa8969c0a5f55 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -80,8 +80,7 @@ static void send_op(struct plock_op *op)
    abandoned waiter.  So, we have to insert the unlock-close when the
    lock call is interrupted. */
 
-static void do_unlock_close(struct dlm_ls *ls, u64 number,
-			    struct file *file, struct file_lock *fl)
+static void do_unlock_close(const struct dlm_plock_info *info)
 {
 	struct plock_op *op;
 
@@ -90,15 +89,12 @@ static void do_unlock_close(struct dlm_ls *ls, u64 number,
 		return;
 
 	op->info.optype		= DLM_PLOCK_OP_UNLOCK;
-	op->info.pid		= fl->fl_pid;
-	op->info.fsid		= ls->ls_global_id;
-	op->info.number		= number;
+	op->info.pid		= info->pid;
+	op->info.fsid		= info->fsid;
+	op->info.number		= info->number;
 	op->info.start		= 0;
 	op->info.end		= OFFSET_MAX;
-	if (fl->fl_lmops && fl->fl_lmops->lm_grant)
-		op->info.owner	= (__u64) fl->fl_pid;
-	else
-		op->info.owner	= (__u64)(long) fl->fl_owner;
+	op->info.owner		= info->owner;
 
 	op->info.flags |= DLM_PLOCK_FL_CLOSE;
 	send_op(op);
@@ -168,7 +164,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 			  __func__, ls->ls_global_id,
 			  (unsigned long long)number, op->info.pid);
 		dlm_release_plock_op(op);
-		do_unlock_close(ls, number, file, fl);
+		do_unlock_close(&op->info);
 		goto out;
 	}
 
-- 
2.40.1



