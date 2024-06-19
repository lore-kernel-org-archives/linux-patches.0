Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D9882495;
	Wed, 19 Jun 2024 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803069; cv=none; b=gz7huvRxiaa+d0kfyLAPCZCTFIcx2R1U7OcwzdHLmlHrhAOZGP4di4KTjicYtPksK8c/8ej4YxvvtnExfiP+B1XIj8yPs2LaBbTQYlu3YaVIsP7whjn0sRnymI79ErtDd6iI5ZJOY6t5QCnjk0JFN8O7Eu61DT32u9Dvho/ZoTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803069; c=relaxed/simple;
	bh=0poYw+htLpunm5k3JMNiJjEFNzbSWDr5q/bCqCoBKZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e34rS4dKrT6CKAupjz0aH91A6Om7hokN8i1QGyBTiBLhPnI4YNgfA9NqsGgy0KVLx1i0L3LHqcLNMRHm0KteA4Nplq4gYQK+ViY5Ybbkhcuez1rTgEDFFHkdvbTgcZa4cOPXtR8dn4NNe/Qe90qC07RJHZrud2WFv26V0XqIkRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9kCrnSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9kCrnSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D9AC2BBFC;
	Wed, 19 Jun 2024 13:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803069;
	bh=0poYw+htLpunm5k3JMNiJjEFNzbSWDr5q/bCqCoBKZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9kCrnSxaUtyXL3ABJs5YqmqvRKbpVOw0lZnyQM3cZc37FHLsiHRI4vsinBTiUsyq
	 3ihRVmsCxs/BO+jExIqFye7jVLMh6idcBmq1Pq9qqqBNW4Tao0WDE84OKVmKTxsfuC
	 y3mwrAK7Mks6PqxH81Ld+eClIaOwptWd16Y8mNes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 112/281] cachefiles: fix slab-use-after-free in cachefiles_ondemand_get_fd()
Date: Wed, 19 Jun 2024 14:54:31 +0200
Message-ID: <20240619125614.158651071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

[ Upstream commit de3e26f9e5b76fc628077578c001c4a51bf54d06 ]

We got the following issue in a fuzz test of randomly issuing the restore
command:

==================================================================
BUG: KASAN: slab-use-after-free in cachefiles_ondemand_daemon_read+0x609/0xab0
Write of size 4 at addr ffff888109164a80 by task ondemand-04-dae/4962

CPU: 11 PID: 4962 Comm: ondemand-04-dae Not tainted 6.8.0-rc7-dirty #542
Call Trace:
 kasan_report+0x94/0xc0
 cachefiles_ondemand_daemon_read+0x609/0xab0
 vfs_read+0x169/0xb50
 ksys_read+0xf5/0x1e0

Allocated by task 626:
 __kmalloc+0x1df/0x4b0
 cachefiles_ondemand_send_req+0x24d/0x690
 cachefiles_create_tmpfile+0x249/0xb30
 cachefiles_create_file+0x6f/0x140
 cachefiles_look_up_object+0x29c/0xa60
 cachefiles_lookup_cookie+0x37d/0xca0
 fscache_cookie_state_machine+0x43c/0x1230
 [...]

Freed by task 626:
 kfree+0xf1/0x2c0
 cachefiles_ondemand_send_req+0x568/0x690
 cachefiles_create_tmpfile+0x249/0xb30
 cachefiles_create_file+0x6f/0x140
 cachefiles_look_up_object+0x29c/0xa60
 cachefiles_lookup_cookie+0x37d/0xca0
 fscache_cookie_state_machine+0x43c/0x1230
 [...]
==================================================================

Following is the process that triggers the issue:

     mount  |   daemon_thread1    |    daemon_thread2
------------------------------------------------------------
 cachefiles_ondemand_init_object
  cachefiles_ondemand_send_req
   REQ_A = kzalloc(sizeof(*req) + data_len)
   wait_for_completion(&REQ_A->done)

            cachefiles_daemon_read
             cachefiles_ondemand_daemon_read
              REQ_A = cachefiles_ondemand_select_req
              cachefiles_ondemand_get_fd
              copy_to_user(_buffer, msg, n)
            process_open_req(REQ_A)
                                  ------ restore ------
                                  cachefiles_ondemand_restore
                                  xas_for_each(&xas, req, ULONG_MAX)
                                   xas_set_mark(&xas, CACHEFILES_REQ_NEW);

                                  cachefiles_daemon_read
                                   cachefiles_ondemand_daemon_read
                                    REQ_A = cachefiles_ondemand_select_req

             write(devfd, ("copen %u,%llu", msg->msg_id, size));
             cachefiles_ondemand_copen
              xa_erase(&cache->reqs, id)
              complete(&REQ_A->done)
   kfree(REQ_A)
                                    cachefiles_ondemand_get_fd(REQ_A)
                                     fd = get_unused_fd_flags
                                     file = anon_inode_getfile
                                     fd_install(fd, file)
                                     load = (void *)REQ_A->msg.data;
                                     load->fd = fd;
                                     // load UAF !!!

This issue is caused by issuing a restore command when the daemon is still
alive, which results in a request being processed multiple times thus
triggering a UAF. So to avoid this problem, add an additional reference
count to cachefiles_req, which is held while waiting and reading, and then
released when the waiting and reading is over.

Note that since there is only one reference count for waiting, we need to
avoid the same request being completed multiple times, so we can only
complete the request if it is successfully removed from the xarray.

Fixes: e73fa11a356c ("cachefiles: add restore command to recover inflight ondemand read requests")
Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-4-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/internal.h |  1 +
 fs/cachefiles/ondemand.c | 23 +++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index d33169f0018b1..7745b8abc3aa3 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -138,6 +138,7 @@ static inline bool cachefiles_in_ondemand_mode(struct cachefiles_cache *cache)
 struct cachefiles_req {
 	struct cachefiles_object *object;
 	struct completion done;
+	refcount_t ref;
 	int error;
 	struct cachefiles_msg msg;
 };
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 4ba42f1fa3b40..c011fb24d2382 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -4,6 +4,12 @@
 #include <linux/uio.h>
 #include "internal.h"
 
+static inline void cachefiles_req_put(struct cachefiles_req *req)
+{
+	if (refcount_dec_and_test(&req->ref))
+		kfree(req);
+}
+
 static int cachefiles_ondemand_fd_release(struct inode *inode,
 					  struct file *file)
 {
@@ -330,6 +336,7 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 
 	xas_clear_mark(&xas, CACHEFILES_REQ_NEW);
 	cache->req_id_next = xas.xa_index + 1;
+	refcount_inc(&req->ref);
 	xa_unlock(&cache->reqs);
 
 	id = xas.xa_index;
@@ -356,15 +363,22 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 		complete(&req->done);
 	}
 
+	cachefiles_req_put(req);
 	return n;
 
 err_put_fd:
 	if (msg->opcode == CACHEFILES_OP_OPEN)
 		close_fd(((struct cachefiles_open *)msg->data)->fd);
 error:
-	xa_erase(&cache->reqs, id);
-	req->error = ret;
-	complete(&req->done);
+	xas_reset(&xas);
+	xas_lock(&xas);
+	if (xas_load(&xas) == req) {
+		req->error = ret;
+		complete(&req->done);
+		xas_store(&xas, NULL);
+	}
+	xas_unlock(&xas);
+	cachefiles_req_put(req);
 	return ret;
 }
 
@@ -395,6 +409,7 @@ static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
 		goto out;
 	}
 
+	refcount_set(&req->ref, 1);
 	req->object = object;
 	init_completion(&req->done);
 	req->msg.opcode = opcode;
@@ -456,7 +471,7 @@ static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
 	wake_up_all(&cache->daemon_pollwq);
 	wait_for_completion(&req->done);
 	ret = req->error;
-	kfree(req);
+	cachefiles_req_put(req);
 	return ret;
 out:
 	/* Reset the object to close state in error handling path.
-- 
2.43.0



