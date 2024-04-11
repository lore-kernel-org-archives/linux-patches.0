Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658E41448F6;
	Thu, 11 Apr 2024 10:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830572; cv=none; b=VPyYRNR05HwN1Xa+Q3UU6bQQSSBIt4JsevUaex/6hVpX8Ini/t2l4xxedE8ZnN93+/cf3u1GVmGOa/wtXOcmxNhJjbvK1JuwmKnyQGv/AjeXQNTW9YWmHiwrJmkwmsxRS3NfwSHZC9aZ0TbNbkqotsuLy5QGzUREz1rKwon8GrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830572; c=relaxed/simple;
	bh=WnbQC11FODpP+fvO/QPbKvaWA+62N1wDfxJP+U2EK50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0QDY2ryi/XQHbGC5UpJkipVkbac0HSwGKKR/sT9a5wB3f33xV/DCg2PNHEoruzI/X0HCZm7Te/Zw6W1h1Kbx/oXB5ImAbs519oSbmsQWVCkiHDwfNnLouYySpeJQsWFr4Dq1gLYUBwBsZG4JyAoyBjAUeRmgLYIWsVsZu6FdJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KC+dYEeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KC+dYEeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B6EC433C7;
	Thu, 11 Apr 2024 10:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830572;
	bh=WnbQC11FODpP+fvO/QPbKvaWA+62N1wDfxJP+U2EK50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KC+dYEeUh9YEBu5RqgWl1zRlGnE1zrh1Nwbg44+VpcP1O28nOHnAdulA1McDHFmxY
	 pJ3IB2UNrz1EiMJjXOi6yjtsTsD9Oz5dinvjLWjRFc2jHXDwluARA9RUM0w3gtSXog
	 eSQ1Lb2N9vR8j8897SLzn753jjqQh3yVSNmF97Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Reitz <mreitz@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/215] fuse: store fuse_conn in fuse_req
Date: Thu, 11 Apr 2024 11:54:14 +0200
Message-ID: <20240411095426.249853460@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Max Reitz <mreitz@redhat.com>

[ Upstream commit 24754db2728a87c513cc480c70c09072a7a40ba6 ]

Every fuse_req belongs to a fuse_conn.  Right now, we always know which
fuse_conn that is based on the respective device, but we want to allow
multiple (sub)mounts per single connection, and then the corresponding
filesystem is not going to be so trivial to obtain.

Storing a pointer to the associated fuse_conn in every fuse_req will
allow us to trivially find any request's superblock (and thus
filesystem) even then.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: b1fe686a765e ("fuse: don't unhash root")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c    | 13 +++++++------
 fs/fuse/fuse_i.h |  3 +++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ac6a8da340139..185cae8a7ce11 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -40,20 +40,21 @@ static struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
-static void fuse_request_init(struct fuse_req *req)
+static void fuse_request_init(struct fuse_conn *fc, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
 	INIT_LIST_HEAD(&req->intr_entry);
 	init_waitqueue_head(&req->waitq);
 	refcount_set(&req->count, 1);
 	__set_bit(FR_PENDING, &req->flags);
+	req->fc = fc;
 }
 
-static struct fuse_req *fuse_request_alloc(gfp_t flags)
+static struct fuse_req *fuse_request_alloc(struct fuse_conn *fc, gfp_t flags)
 {
 	struct fuse_req *req = kmem_cache_zalloc(fuse_req_cachep, flags);
 	if (req)
-		fuse_request_init(req);
+		fuse_request_init(fc, req);
 
 	return req;
 }
@@ -125,7 +126,7 @@ static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
 	if (fc->conn_error)
 		goto out;
 
-	req = fuse_request_alloc(GFP_KERNEL);
+	req = fuse_request_alloc(fc, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!req) {
 		if (for_background)
@@ -480,7 +481,7 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 
 	if (args->force) {
 		atomic_inc(&fc->num_waiting);
-		req = fuse_request_alloc(GFP_KERNEL | __GFP_NOFAIL);
+		req = fuse_request_alloc(fc, GFP_KERNEL | __GFP_NOFAIL);
 
 		if (!args->nocreds)
 			fuse_force_creds(fc, req);
@@ -547,7 +548,7 @@ int fuse_simple_background(struct fuse_conn *fc, struct fuse_args *args,
 
 	if (args->force) {
 		WARN_ON(!args->nocreds);
-		req = fuse_request_alloc(gfp_flags);
+		req = fuse_request_alloc(fc, gfp_flags);
 		if (!req)
 			return -ENOMEM;
 		__set_bit(FR_BACKGROUND, &req->flags);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 83c2855bc7406..7138b780c9abd 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -363,6 +363,9 @@ struct fuse_req {
 	/** virtio-fs's physically contiguous buffer for in and out args */
 	void *argbuf;
 #endif
+
+	/** fuse_conn this request belongs to */
+	struct fuse_conn *fc;
 };
 
 struct fuse_iqueue;
-- 
2.43.0



