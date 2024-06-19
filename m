Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA7E82495;
	Wed, 19 Jun 2024 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803072; cv=none; b=sSvkRz7RUzVT4fxGOWuFe3NM3xTMmEDJpNmc9bl3BMQ8gy//XnZN19HYFFxRFcDJrHuXvMxotzyqohz51tKH+xUmHTEkbEZi+ZvOr8sb5xemnBA+hbaQqvZR5LVVmdQR0PNFCZcL9v2r4aJGlZeI7YmKUjE02aCITrV07gBy7OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803072; c=relaxed/simple;
	bh=swK+N+MVJvaNJeA66V7QCUYPwoBHxQs86IT9kPGljV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYgpJOM9Tp3pNhnthgnY8h3/1NjQHh9pYGc3pJ6dBqk7bzt8WRbcS4fNom/N3+818yOIbdXSC5jGCPp8/q4s5qdeL5Jp0BK+YAt4hzqJFaFJDvBsARch09NDFD02eujlUjgB16cTafXJ9OxzxDrtUOJT5SR5hx95mjpHiE1nF9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OviB8pEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OviB8pEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCAAC2BBFC;
	Wed, 19 Jun 2024 13:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803072;
	bh=swK+N+MVJvaNJeA66V7QCUYPwoBHxQs86IT9kPGljV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OviB8pEqD+4HiOWvJcYbciC/i8uwHmWdyNuJ5FD1Gb2WBR8y1hbqTDQvRn7MM2qVZ
	 82+0z0NDamC9ni15lz+rtxC5njggxIX3bAuLhMB6v1MznjU25dDwxKyzS7H8VYp710
	 fmarUBe5sbriBxJOYMsV+byyRst+8yRonniXvDAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 113/281] cachefiles: fix slab-use-after-free in cachefiles_ondemand_daemon_read()
Date: Wed, 19 Jun 2024 14:54:32 +0200
Message-ID: <20240619125614.196375593@linuxfoundation.org>
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

[ Upstream commit da4a827416066191aafeeccee50a8836a826ba10 ]

We got the following issue in a fuzz test of randomly issuing the restore
command:

==================================================================
BUG: KASAN: slab-use-after-free in cachefiles_ondemand_daemon_read+0xb41/0xb60
Read of size 8 at addr ffff888122e84088 by task ondemand-04-dae/963

CPU: 13 PID: 963 Comm: ondemand-04-dae Not tainted 6.8.0-dirty #564
Call Trace:
 kasan_report+0x93/0xc0
 cachefiles_ondemand_daemon_read+0xb41/0xb60
 vfs_read+0x169/0xb50
 ksys_read+0xf5/0x1e0

Allocated by task 116:
 kmem_cache_alloc+0x140/0x3a0
 cachefiles_lookup_cookie+0x140/0xcd0
 fscache_cookie_state_machine+0x43c/0x1230
 [...]

Freed by task 792:
 kmem_cache_free+0xfe/0x390
 cachefiles_put_object+0x241/0x480
 fscache_cookie_state_machine+0x5c8/0x1230
 [...]
==================================================================

Following is the process that triggers the issue:

     mount  |   daemon_thread1    |    daemon_thread2
------------------------------------------------------------
cachefiles_withdraw_cookie
 cachefiles_ondemand_clean_object(object)
  cachefiles_ondemand_send_req
   REQ_A = kzalloc(sizeof(*req) + data_len)
   wait_for_completion(&REQ_A->done)

            cachefiles_daemon_read
             cachefiles_ondemand_daemon_read
              REQ_A = cachefiles_ondemand_select_req
              msg->object_id = req->object->ondemand->ondemand_id
                                  ------ restore ------
                                  cachefiles_ondemand_restore
                                  xas_for_each(&xas, req, ULONG_MAX)
                                   xas_set_mark(&xas, CACHEFILES_REQ_NEW)

                                  cachefiles_daemon_read
                                   cachefiles_ondemand_daemon_read
                                    REQ_A = cachefiles_ondemand_select_req
              copy_to_user(_buffer, msg, n)
               xa_erase(&cache->reqs, id)
               complete(&REQ_A->done)
              ------ close(fd) ------
              cachefiles_ondemand_fd_release
               cachefiles_put_object
 cachefiles_put_object
  kmem_cache_free(cachefiles_object_jar, object)
                                    REQ_A->object->ondemand->ondemand_id
                                     // object UAF !!!

When we see the request within xa_lock, req->object must not have been
freed yet, so grab the reference count of object before xa_unlock to
avoid the above issue.

Fixes: 0a7e54c1959c ("cachefiles: resend an open request if the read request's object is closed")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-5-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c          | 3 +++
 include/trace/events/cachefiles.h | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index c011fb24d2382..3dd002108a872 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -337,6 +337,7 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	xas_clear_mark(&xas, CACHEFILES_REQ_NEW);
 	cache->req_id_next = xas.xa_index + 1;
 	refcount_inc(&req->ref);
+	cachefiles_grab_object(req->object, cachefiles_obj_get_read_req);
 	xa_unlock(&cache->reqs);
 
 	id = xas.xa_index;
@@ -357,6 +358,7 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 		goto err_put_fd;
 	}
 
+	cachefiles_put_object(req->object, cachefiles_obj_put_read_req);
 	/* CLOSE request has no reply */
 	if (msg->opcode == CACHEFILES_OP_CLOSE) {
 		xa_erase(&cache->reqs, id);
@@ -370,6 +372,7 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	if (msg->opcode == CACHEFILES_OP_OPEN)
 		close_fd(((struct cachefiles_open *)msg->data)->fd);
 error:
+	cachefiles_put_object(req->object, cachefiles_obj_put_read_req);
 	xas_reset(&xas);
 	xas_lock(&xas);
 	if (xas_load(&xas) == req) {
diff --git a/include/trace/events/cachefiles.h b/include/trace/events/cachefiles.h
index e3213af847cdf..7d931db02b934 100644
--- a/include/trace/events/cachefiles.h
+++ b/include/trace/events/cachefiles.h
@@ -33,6 +33,8 @@ enum cachefiles_obj_ref_trace {
 	cachefiles_obj_see_withdrawal,
 	cachefiles_obj_get_ondemand_fd,
 	cachefiles_obj_put_ondemand_fd,
+	cachefiles_obj_get_read_req,
+	cachefiles_obj_put_read_req,
 };
 
 enum fscache_why_object_killed {
@@ -129,7 +131,9 @@ enum cachefiles_error_trace {
 	EM(cachefiles_obj_see_withdraw_cookie,	"SEE withdraw_cookie")	\
 	EM(cachefiles_obj_see_withdrawal,	"SEE withdrawal")	\
 	EM(cachefiles_obj_get_ondemand_fd,      "GET ondemand_fd")	\
-	E_(cachefiles_obj_put_ondemand_fd,      "PUT ondemand_fd")
+	EM(cachefiles_obj_put_ondemand_fd,      "PUT ondemand_fd")	\
+	EM(cachefiles_obj_get_read_req,		"GET read_req")		\
+	E_(cachefiles_obj_put_read_req,		"PUT read_req")
 
 #define cachefiles_coherency_traces					\
 	EM(cachefiles_coherency_check_aux,	"BAD aux ")		\
-- 
2.43.0



