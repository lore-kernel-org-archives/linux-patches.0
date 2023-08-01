Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241B21F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979E8C433C7;
	Tue,  1 Aug 2023 09:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881844;
	bh=dWcf/R750Buawz2Py6+NQACT1zETv7K1TX4Qd6rwSso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A78xYhGsu6hGS8y/TbY21MsB6ZRg0qjXWjOAYpRaazpPoA+UPOhzwDMd6CZbmIjWa
	 aDMz5jkSe6+hcO3xNZ+27YTIatZqXspyxNWZbHLozZ3VR/ieImHChNiniKXYbTCOml
	 dsGMRQsh7E9n/i457op/waUMMFnwmxFC+3XR6odM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/155] dlm: rearrange async condition return
Date: Tue,  1 Aug 2023 11:18:52 +0200
Message-ID: <20230801091910.926469520@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
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

[ Upstream commit a800ba77fd285c6391a82819867ac64e9ab3af46 ]

This patch moves the return of FILE_LOCK_DEFERRED a little bit earlier
than checking afterwards again if the request was an asynchronous request.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 59e45c758ca1 ("fs: dlm: interrupt posix locks only when process is killed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/plock.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index e70e23eca03ec..01fb7d8c0bca5 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -149,26 +149,25 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 		op_data->file	= file;
 
 		op->data = op_data;
+
+		send_op(op);
+		rv = FILE_LOCK_DEFERRED;
+		goto out;
 	} else {
 		op->info.owner	= (__u64)(long) fl->fl_owner;
 	}
 
 	send_op(op);
 
-	if (!op->data) {
-		rv = wait_event_interruptible(recv_wq, (op->done != 0));
-		if (rv == -ERESTARTSYS) {
-			log_debug(ls, "dlm_posix_lock: wait killed %llx",
-				  (unsigned long long)number);
-			spin_lock(&ops_lock);
-			list_del(&op->list);
-			spin_unlock(&ops_lock);
-			dlm_release_plock_op(op);
-			do_unlock_close(ls, number, file, fl);
-			goto out;
-		}
-	} else {
-		rv = FILE_LOCK_DEFERRED;
+	rv = wait_event_interruptible(recv_wq, (op->done != 0));
+	if (rv == -ERESTARTSYS) {
+		log_debug(ls, "%s: wait killed %llx", __func__,
+			  (unsigned long long)number);
+		spin_lock(&ops_lock);
+		list_del(&op->list);
+		spin_unlock(&ops_lock);
+		dlm_release_plock_op(op);
+		do_unlock_close(ls, number, file, fl);
 		goto out;
 	}
 
-- 
2.39.2



