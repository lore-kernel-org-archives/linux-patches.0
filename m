Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCEE1A76B7;
	Tue, 30 Jul 2024 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359674; cv=none; b=dZr1CPdqOUYIZ3t/YCvLlF0UlqaUsqsEfuv5PwyUYKgMPQ4lDOEEh5F8NNgLgiFYRqz5nPeBOgj0LNNfgljP3Je4dL4MwhrsGdPSLR/EpI+x/8pE4tNEioZ9V7JWgU6moUtLyoV5T3THsdp3XjsW5eZWfHYkOLc2+ostPiq4C+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359674; c=relaxed/simple;
	bh=kDIHgHu9N9O5dRKsOuW4mUMjGQvt+MIAAcRYjClXJMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dkm9zIqmT+HNbN+UglICP+8Nu9LjubxTgb3Hkox+hoiGwnVfViqyPCPGWEgT5vtvhDCN2vclo6HZ1MCHmq/pISQf7W5RY/xXLlGBOmlM6gUaUxVL59S7nrjrC2UBWxies0PrPTKGH0wrK4zYQp9/fBVnIBsdm4T7ZkNuSHEnPTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNpqaMB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNpqaMB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917D8C32782;
	Tue, 30 Jul 2024 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359674;
	bh=kDIHgHu9N9O5dRKsOuW4mUMjGQvt+MIAAcRYjClXJMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNpqaMB7uxhG/jd/iAYdvG0Gd2LXF1bQ3x01kEnevqj18pjftrlaa1NqvzQze6AY9
	 Q+086PXB6d7ZiGet8RL5iHR44QkDwfARrRr03MFiXy2cZ79/PmlAk+LzhUeEbePdIK
	 ucBCm4JaFMJr94LrVDEbDXo8ynsglJzWHhG6dTAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Su Yue <glass.su@suse.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 517/809] md-cluster: fix hanging issue while a new disk adding
Date: Tue, 30 Jul 2024 17:46:33 +0200
Message-ID: <20240730151745.159785700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

[ Upstream commit fff42f213824fa434a4b6cf906b4331fe6e9302b ]

The commit 1bbe254e4336 ("md-cluster: check for timeout while a
new disk adding") is correct in terms of code syntax but not
suite real clustered code logic.

When a timeout occurs while adding a new disk, if recv_daemon()
bypasses the unlock for ack_lockres:CR, another node will be waiting
to grab EX lock. This will cause the cluster to hang indefinitely.

How to fix:

1. In dlm_lock_sync(), change the wait behaviour from forever to a
   timeout, This could avoid the hanging issue when another node
   fails to handle cluster msg. Another result of this change is
   that if another node receives an unknown msg (e.g. a new msg_type),
   the old code will hang, whereas the new code will timeout and fail.
   This could help cluster_md handle new msg_type from different
   nodes with different kernel/module versions (e.g. The user only
   updates one leg's kernel and monitors the stability of the new
   kernel).
2. The old code for __sendmsg() always returns 0 (success) under the
   design (must successfully unlock ->message_lockres). This commit
   makes this function return an error number when an error occurs.

Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk adding")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Acked-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240709104120.22243-1-heming.zhao@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-cluster.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 8e36a0feec098..b5a802ae17bb2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -15,6 +15,7 @@
 
 #define LVB_SIZE	64
 #define NEW_DEV_TIMEOUT 5000
+#define WAIT_DLM_LOCK_TIMEOUT (30 * HZ)
 
 struct dlm_lock_resource {
 	dlm_lockspace_t *ls;
@@ -130,8 +131,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
 			0, sync_ast, res, res->bast);
 	if (ret)
 		return ret;
-	wait_event(res->sync_locking, res->sync_locking_done);
+	ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
+				WAIT_DLM_LOCK_TIMEOUT);
 	res->sync_locking_done = false;
+	if (!ret) {
+		pr_err("locking DLM '%s' timeout!\n", res->name);
+		return -EBUSY;
+	}
 	if (res->lksb.sb_status == 0)
 		res->mode = mode;
 	return res->lksb.sb_status;
@@ -743,7 +749,7 @@ static void unlock_comm(struct md_cluster_info *cinfo)
  */
 static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 {
-	int error;
+	int error, unlock_error;
 	int slot = cinfo->slot_number - 1;
 
 	cmsg->slot = cpu_to_le32(slot);
@@ -751,7 +757,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
 	if (error) {
 		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
-		goto failed_message;
+		return error;
 	}
 
 	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg,
@@ -781,14 +787,10 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	}
 
 failed_ack:
-	error = dlm_unlock_sync(cinfo->message_lockres);
-	if (unlikely(error != 0)) {
+	while ((unlock_error = dlm_unlock_sync(cinfo->message_lockres)))
 		pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
-			error);
-		/* in case the message can't be released due to some reason */
-		goto failed_ack;
-	}
-failed_message:
+			unlock_error);
+
 	return error;
 }
 
-- 
2.43.0



