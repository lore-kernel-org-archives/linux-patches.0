Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703C321D44
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74A3C433C7;
	Fri, 21 Jul 2023 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956420;
	bh=MpIs+etA03iShV9WxqOZ4+logoMRbUEK9OXnoneUfI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOCdCxgW8pWpEfxgizr5NlV+jWz4OUb0u8IOcmIYaVElvTlSTJos5KJxAbJ0lT4Ie
	 ZkUUjlnO720LUk+CxZV1pL2b6vHoWxrLErfzJ05HQVd5byrWZQyMylSw04pnDfvMib
	 kP9zP47OFjhi84q+ZkGhknmtRw339rLx1Vwcvcao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.4 187/292] fs: dlm: fix cleanup pending ops when interrupted
Date: Fri, 21 Jul 2023 18:04:56 +0200
Message-ID: <20230721160536.928661176@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit c847f4e203046a2c93d8a1cf0348315c0b655a60 upstream.

Immediately clean up a posix lock request if it is interrupted
while waiting for a result from user space (dlm_controld.)  This
largely reverts the recent commit b92a4e3f86b1 ("fs: dlm: change
posix lock sigint handling"). That previous commit attempted
to defer lock cleanup to the point in time when a result from
user space arrived. The deferred approach was not reliable
because some dlm plock ops may not receive replies.

Cc: stable@vger.kernel.org
Fixes: b92a4e3f86b1 ("fs: dlm: change posix lock sigint handling")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/plock.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -30,8 +30,6 @@ struct plock_async_data {
 struct plock_op {
 	struct list_head list;
 	int done;
-	/* if lock op got interrupted while waiting dlm_controld reply */
-	bool sigint;
 	struct dlm_plock_info info;
 	/* if set indicates async handling */
 	struct plock_async_data *data;
@@ -167,12 +165,14 @@ int dlm_posix_lock(dlm_lockspace_t *lock
 			spin_unlock(&ops_lock);
 			goto do_lock_wait;
 		}
-
-		op->sigint = true;
+		list_del(&op->list);
 		spin_unlock(&ops_lock);
+
 		log_debug(ls, "%s: wait interrupted %x %llx pid %d",
 			  __func__, ls->ls_global_id,
 			  (unsigned long long)number, op->info.pid);
+		do_unlock_close(&op->info);
+		dlm_release_plock_op(op);
 		goto out;
 	}
 
@@ -434,19 +434,6 @@ static ssize_t dev_write(struct file *fi
 		if (iter->info.fsid == info.fsid &&
 		    iter->info.number == info.number &&
 		    iter->info.owner == info.owner) {
-			if (iter->sigint) {
-				list_del(&iter->list);
-				spin_unlock(&ops_lock);
-
-				pr_debug("%s: sigint cleanup %x %llx pid %d",
-					  __func__, iter->info.fsid,
-					  (unsigned long long)iter->info.number,
-					  iter->info.pid);
-				do_unlock_close(&iter->info);
-				memcpy(&iter->info, &info, sizeof(info));
-				dlm_release_plock_op(iter);
-				return count;
-			}
 			list_del_init(&iter->list);
 			memcpy(&iter->info, &info, sizeof(info));
 			if (iter->data)
@@ -465,8 +452,8 @@ static ssize_t dev_write(struct file *fi
 		else
 			wake_up(&recv_wq);
 	} else
-		log_print("%s: no op %x %llx", __func__,
-			  info.fsid, (unsigned long long)info.number);
+		pr_debug("%s: no op %x %llx", __func__,
+			 info.fsid, (unsigned long long)info.number);
 	return count;
 }
 


