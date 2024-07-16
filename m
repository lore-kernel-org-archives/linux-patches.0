Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61C612B72;
	Tue, 16 Jul 2024 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144830; cv=none; b=tI3qdDg+J3zI0y4jk+0+4MY3CGPCwOv0m2bq1mQH0Ib28C+8eb5RWrZ2R0jchSCuWYa3e9bLCO0k/EP4ZqWAAwRYROWmKDjG1tAEVX53zXnuXNYVno9Z0wa6hz/w4ciMFI3X1HAvpq4uKf6A+yfp4en0qZVX0J48hpEFcXxQtbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144830; c=relaxed/simple;
	bh=1XJGghBV1DJw5E9lqSK7YiExnNpLaYBbk9Am7eQJydY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xy813/qHq6GfRkNjF1J+uhY1kztDnZEqgn0+eDvVA/j5nNrpJa7rr+XwnlfPiHuHUqpUhdLCdYl+RLlQPMMb63mzjtDJOt3DmUw7dzr2/i1tBJaaPbDdHV4p/nF0fI3BUCkB+u+isz2ojRtQ6MokoUZ1SUbvfUhw4A7URw12XPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NK4ipvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NK4ipvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2E0C116B1;
	Tue, 16 Jul 2024 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144830;
	bh=1XJGghBV1DJw5E9lqSK7YiExnNpLaYBbk9Am7eQJydY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NK4ipvCIR1gHSnjqCaYqABjrHNXsZRW/ZqtWGn70OzP37SJbSrHS+6F0Sg73/x8I
	 U7lYQPFv4RrO2JpsHZRwJZGvBj9naa3QJ8ZOgwXS3DCiPp0m21do4zkfj4CZDjlf+L
	 4I//vKp25jFAtZpr3VptOgzaOkRDj1+e9DWWCJaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 010/143] cachefiles: cyclic allocation of msg_id to avoid reuse
Date: Tue, 16 Jul 2024 17:30:06 +0200
Message-ID: <20240716152756.385372336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 19f4f399091478c95947f6bd7ad61622300c30d9 ]

Reusing the msg_id after a maliciously completed reopen request may cause
a read request to remain unprocessed and result in a hung, as shown below:

       t1       |      t2       |      t3
-------------------------------------------------
cachefiles_ondemand_select_req
 cachefiles_ondemand_object_is_close(A)
 cachefiles_ondemand_set_object_reopening(A)
 queue_work(fscache_object_wq, &info->work)
                ondemand_object_worker
                 cachefiles_ondemand_init_object(A)
                  cachefiles_ondemand_send_req(OPEN)
                    // get msg_id 6
                    wait_for_completion(&req_A->done)
cachefiles_ondemand_daemon_read
 // read msg_id 6 req_A
 cachefiles_ondemand_get_fd
 copy_to_user
                                // Malicious completion msg_id 6
                                copen 6,-1
                                cachefiles_ondemand_copen
                                 complete(&req_A->done)
                                 // will not set the object to close
                                 // because ondemand_id && fd is valid.

                // ondemand_object_worker() is done
                // but the object is still reopening.

                                // new open req_B
                                cachefiles_ondemand_init_object(B)
                                 cachefiles_ondemand_send_req(OPEN)
                                 // reuse msg_id 6
process_open_req
 copen 6,A.size
 // The expected failed copen was executed successfully

Expect copen to fail, and when it does, it closes fd, which sets the
object to close, and then close triggers reopen again. However, due to
msg_id reuse resulting in a successful copen, the anonymous fd is not
closed until the daemon exits. Therefore read requests waiting for reopen
to complete may trigger hung task.

To avoid this issue, allocate the msg_id cyclically to avoid reusing the
msg_id for a very short duration of time.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-9-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/internal.h |  1 +
 fs/cachefiles/ondemand.c | 20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index a1a1d25e95147..7b99bd98de75b 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -129,6 +129,7 @@ struct cachefiles_cache {
 	unsigned long			req_id_next;
 	struct xarray			ondemand_ids;	/* xarray for ondemand_id allocation */
 	u32				ondemand_id_next;
+	u32				msg_id_next;
 };
 
 static inline bool cachefiles_in_ondemand_mode(struct cachefiles_cache *cache)
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 6b94f616e6579..7e4874f60de10 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -505,20 +505,32 @@ static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
 		smp_mb();
 
 		if (opcode == CACHEFILES_OP_CLOSE &&
-			!cachefiles_ondemand_object_is_open(object)) {
+		    !cachefiles_ondemand_object_is_open(object)) {
 			WARN_ON_ONCE(object->ondemand->ondemand_id == 0);
 			xas_unlock(&xas);
 			ret = -EIO;
 			goto out;
 		}
 
-		xas.xa_index = 0;
+		/*
+		 * Cyclically find a free xas to avoid msg_id reuse that would
+		 * cause the daemon to successfully copen a stale msg_id.
+		 */
+		xas.xa_index = cache->msg_id_next;
 		xas_find_marked(&xas, UINT_MAX, XA_FREE_MARK);
+		if (xas.xa_node == XAS_RESTART) {
+			xas.xa_index = 0;
+			xas_find_marked(&xas, cache->msg_id_next - 1, XA_FREE_MARK);
+		}
 		if (xas.xa_node == XAS_RESTART)
 			xas_set_err(&xas, -EBUSY);
+
 		xas_store(&xas, req);
-		xas_clear_mark(&xas, XA_FREE_MARK);
-		xas_set_mark(&xas, CACHEFILES_REQ_NEW);
+		if (xas_valid(&xas)) {
+			cache->msg_id_next = xas.xa_index + 1;
+			xas_clear_mark(&xas, XA_FREE_MARK);
+			xas_set_mark(&xas, CACHEFILES_REQ_NEW);
+		}
 		xas_unlock(&xas);
 	} while (xas_nomem(&xas, GFP_KERNEL));
 
-- 
2.43.0



