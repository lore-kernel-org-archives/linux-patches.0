Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FF437C106;
	Fri,  4 Sep 2026 05:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501080; cv=none; b=XYtIrAwRrD7elB/r/Q76wCZm2555mDoEabl2JKUdwN2uGFi9JcE83nDiyPMdDrQdrefwflwDNBiYsvSADv5tXkSJYXuOcxkGmNdMuTUffDnXEu1wKIIjh6QvptqlQrxSfHvOC1LGFGgqYJ98yY7R6wTLro0gYrbYuXVuce1HHeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501080; c=relaxed/simple;
	bh=0m4ITbiJ52g1jOA7rUXbWkQtQ7wgDSflbwWY4q3bbzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XU/wR4J61qO6WJPptymbIf6WGRMMBoLyQh2uWkTI/mGNX4jTNeWoDNs7XP3g1PIgn7snMv8wlPXZZy1zNx08E7L96BanLJDR8eeTsfiLkpCikbDTCyKEjhKB8JafLGcbCCwJWW2++NCtwqf12TKipFIjEbkNqiMs0Z6+EwJO+V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAC7Kq0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAC7Kq0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B212B1F00A3D;
	Fri,  4 Sep 2026 05:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501079;
	bh=dL6oBLolo61PVV9QMLYe5GhDqGJuvVMKfJQpybe95Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iAC7Kq0PhcjzJ5MR2lLvuBf85E6aPaeMGDbtOQ+DcCUHIyEkQja+kdZWycJIi/6dS
	 GScbNpr/dTxIi6Vo/S/tEZIeBMVsPx8zCZOtfpsNvA8+c9KStmEMsFBe+Pq37LCh/M
	 u1LEoJ0xORhDL52FMVVc/b6sH90eOXh9tLgmQ53o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 283/552] sunrpc: defer rq_argp and rq_resp free until after RCU grace period
Date: Fri,  4 Sep 2026 06:57:20 +0200
Message-ID: <20260904045756.377784635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit c479bde671cbe2f9e152834a8b0eb7c3c295bbaf upstream.

svc_rqst_free() frees rqstp->rq_argp and rqstp->rq_resp synchronously
via kfree(), but defers the rqstp struct free via kfree_rcu().  After
svc_exit_thread() calls list_del_rcu() and svc_rqst_free(), there is
a window where RCU readers that started before list_del_rcu() can still
traverse the thread list and find the rqstp.  These readers (e.g.
nfsd_nl_rpc_status_get_dumpit()) dereference rqstp->rq_argp, which has
already been freed — a use-after-free.

Fix this by moving the kfree of rq_argp and rq_resp into an explicit
call_rcu() callback alongside the struct free.  Resources not accessed
by RCU readers (bvec, buffer pages, scratch folio, auth_data) remain
synchronously freed.

Fixes: 812443865c5f ("sunrpc: add a rcu_head to svc_rqst and use kfree_rcu to free it")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-4-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -723,6 +723,15 @@ svc_release_buffer(struct svc_rqst *rqst
 	kfree(rqstp->rq_pages);
 }
 
+static void svc_rqst_free_rcu(struct rcu_head *head)
+{
+	struct svc_rqst *rqstp = container_of(head, struct svc_rqst, rq_rcu_head);
+
+	kfree(rqstp->rq_resp);
+	kfree(rqstp->rq_argp);
+	kfree(rqstp);
+}
+
 static void
 svc_rqst_free(struct svc_rqst *rqstp)
 {
@@ -731,10 +740,8 @@ svc_rqst_free(struct svc_rqst *rqstp)
 	svc_release_buffer(rqstp);
 	if (rqstp->rq_scratch_folio)
 		folio_put(rqstp->rq_scratch_folio);
-	kfree(rqstp->rq_resp);
-	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
-	kfree_rcu(rqstp, rq_rcu_head);
+	call_rcu(&rqstp->rq_rcu_head, svc_rqst_free_rcu);
 }
 
 static struct svc_rqst *


