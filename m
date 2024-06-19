Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943D682495;
	Wed, 19 Jun 2024 13:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803078; cv=none; b=P/IA/5tza2WK9uB5iU0Ted0tt7z1qt7+ajyPi7QBAx8noImjrBR4HQ/9P2GAmramS3SNeokKht5/8sA1Y9bPmSVBSxN2eWYNONsdfWDSfwOQtObomaKP6AblHmx3AVxlOnjbr03ncAWWHAN5K2655KL5asM75vC8H+yA4G0pFmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803078; c=relaxed/simple;
	bh=TRo7rOK6hlsYuYaarOwNvG/Dlq6DVg9cYDvdm3HWI4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYMmcwsY/Z/0Vrst2T9HaiuYlNHOjEUycjcYk0CqpwqTlvSJAvlo39twbaSu9K5eF2wHghd1JHF04K1mQiqw1eFjMzk2P1EHZZUzG5I1+30SSa3HMlwjQfMZWTe0XpmGGRfPqQsSzWApIdDGtH/ta2SLEcitx45WWmcU1yvmZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycp4raqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycp4raqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199E1C2BBFC;
	Wed, 19 Jun 2024 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803078;
	bh=TRo7rOK6hlsYuYaarOwNvG/Dlq6DVg9cYDvdm3HWI4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycp4raqgJoKhDmE+wnUNDcSj6hOqju93lxHUIPG8+x0Fcp8bRKsw98BV0+YkPMfM7
	 5EBWQXvDZmPB9ezEj4xM3aStW8rTsiR8aNooGSYF53j0jAjwbT5owNcKcmwktzjV/8
	 x5vk4Cdsb/qYIVYnpoQq7fKA7DQTA0d3r42iHPCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 115/281] cachefiles: remove err_put_fd label in cachefiles_ondemand_daemon_read()
Date: Wed, 19 Jun 2024 14:54:34 +0200
Message-ID: <20240619125614.273548230@linuxfoundation.org>
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

[ Upstream commit 3e6d704f02aa4c50c7bc5fe91a4401df249a137b ]

The err_put_fd label is only used once, so remove it to make the code
more readable. In addition, the logic for deleting error request and
CLOSE request is merged to simplify the code.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-6-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 4988e35e95fc ("cachefiles: never get a new anonymous fd if ondemand_id is valid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 45 ++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 7b667ddc84ca5..c8389bb118f5b 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -337,7 +337,6 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 {
 	struct cachefiles_req *req;
 	struct cachefiles_msg *msg;
-	unsigned long id = 0;
 	size_t n;
 	int ret = 0;
 	XA_STATE(xas, &cache->reqs, cache->req_id_next);
@@ -372,49 +371,37 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 	cachefiles_grab_object(req->object, cachefiles_obj_get_read_req);
 	xa_unlock(&cache->reqs);
 
-	id = xas.xa_index;
-
 	if (msg->opcode == CACHEFILES_OP_OPEN) {
 		ret = cachefiles_ondemand_get_fd(req);
 		if (ret) {
 			cachefiles_ondemand_set_object_close(req->object);
-			goto error;
+			goto out;
 		}
 	}
 
-	msg->msg_id = id;
+	msg->msg_id = xas.xa_index;
 	msg->object_id = req->object->ondemand->ondemand_id;
 
 	if (copy_to_user(_buffer, msg, n) != 0) {
 		ret = -EFAULT;
-		goto err_put_fd;
-	}
-
-	cachefiles_put_object(req->object, cachefiles_obj_put_read_req);
-	/* CLOSE request has no reply */
-	if (msg->opcode == CACHEFILES_OP_CLOSE) {
-		xa_erase(&cache->reqs, id);
-		complete(&req->done);
+		if (msg->opcode == CACHEFILES_OP_OPEN)
+			close_fd(((struct cachefiles_open *)msg->data)->fd);
 	}
-
-	cachefiles_req_put(req);
-	return n;
-
-err_put_fd:
-	if (msg->opcode == CACHEFILES_OP_OPEN)
-		close_fd(((struct cachefiles_open *)msg->data)->fd);
-error:
+out:
 	cachefiles_put_object(req->object, cachefiles_obj_put_read_req);
-	xas_reset(&xas);
-	xas_lock(&xas);
-	if (xas_load(&xas) == req) {
-		req->error = ret;
-		complete(&req->done);
-		xas_store(&xas, NULL);
+	/* Remove error request and CLOSE request has no reply */
+	if (ret || msg->opcode == CACHEFILES_OP_CLOSE) {
+		xas_reset(&xas);
+		xas_lock(&xas);
+		if (xas_load(&xas) == req) {
+			req->error = ret;
+			complete(&req->done);
+			xas_store(&xas, NULL);
+		}
+		xas_unlock(&xas);
 	}
-	xas_unlock(&xas);
 	cachefiles_req_put(req);
-	return ret;
+	return ret ? ret : n;
 }
 
 typedef int (*init_req_fn)(struct cachefiles_req *req, void *private);
-- 
2.43.0



