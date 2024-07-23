Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A439613D600;
	Tue, 23 Jul 2024 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759530; cv=none; b=sXZqHqwGTK1KkOeCSbOjTKE7kyzpQq2bLAm+yVevY4gpgDxlH9wWETvICcJRX7wHFJPVJF9kwDfModeR3kWaMNCvLUmyH0DErbyJIh/E5TerY9nV3XprVnEU7sovuUhSCEw1kgb3FFm2lhBfLQXenyBs94DUfE5D/M6PsxfAYQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759530; c=relaxed/simple;
	bh=H9b8+UR1u/LwoDrpdEIm7urzQnAoZJeF2BcJivxBqE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw3Oa11Bu6l5MT5bxJHQvpnoATYIyjh82XutXxcGOTySeDnlOvHMm999288HJS1bxOutWN9s5wiCPBisa4ffNJ0a762CKiMopvXzEQH0ORYZUnyVrT7Kx+Uopn4iSgsKRy8poRQWYfFqrSqeZuG/xQ3v8T38TvbPBmBB3KXYIRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qrf2ET+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qrf2ET+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08C0C4AF0A;
	Tue, 23 Jul 2024 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759530;
	bh=H9b8+UR1u/LwoDrpdEIm7urzQnAoZJeF2BcJivxBqE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qrf2ET+fxnVV4354qE9y7IeC5FM38aMEKv4ix4dLDhg1Hi7IX9oO2JMfsz2rmea+5
	 oglHQQ+WsDEV2Q5bqfBMEiOueyKnHKfEbujYLnyjLFA90aws3Vi5vHmMMoKair7ImI
	 JcnWK5dfPApi1D4TTg+mF/8xL/hI5iDwDVDnckMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/129] cachefiles: make on-demand read killable
Date: Tue, 23 Jul 2024 20:23:10 +0200
Message-ID: <20240723180406.414498340@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit bc9dde6155464e906e630a0a5c17a4cab241ffbb ]

Replacing wait_for_completion() with wait_for_completion_killable() in
cachefiles_ondemand_send_req() allows us to kill processes that might
trigger a hunk_task if the daemon is abnormal.

But now only CACHEFILES_OP_READ is killable, because OP_CLOSE and OP_OPEN
is initiated from kworker context and the signal is prohibited in these
kworker.

Note that when the req in xas changes, i.e. xas_load(&xas) != req, it
means that a process will complete the current request soon, so wait
again for the request to be completed.

In addition, add the cachefiles_ondemand_finish_req() helper function to
simplify the code.

Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-13-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 37489ca2e8571..2185e2908dba8 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -380,6 +380,20 @@ static struct cachefiles_req *cachefiles_ondemand_select_req(struct xa_state *xa
 	return NULL;
 }
 
+static inline bool cachefiles_ondemand_finish_req(struct cachefiles_req *req,
+						  struct xa_state *xas, int err)
+{
+	if (unlikely(!xas || !req))
+		return false;
+
+	if (xa_cmpxchg(xas->xa, xas->xa_index, req, NULL, 0) != req)
+		return false;
+
+	req->error = err;
+	complete(&req->done);
+	return true;
+}
+
 ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 					char __user *_buffer, size_t buflen)
 {
@@ -443,16 +457,8 @@ ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 out:
 	cachefiles_put_object(req->object, cachefiles_obj_put_read_req);
 	/* Remove error request and CLOSE request has no reply */
-	if (ret || msg->opcode == CACHEFILES_OP_CLOSE) {
-		xas_reset(&xas);
-		xas_lock(&xas);
-		if (xas_load(&xas) == req) {
-			req->error = ret;
-			complete(&req->done);
-			xas_store(&xas, NULL);
-		}
-		xas_unlock(&xas);
-	}
+	if (ret || msg->opcode == CACHEFILES_OP_CLOSE)
+		cachefiles_ondemand_finish_req(req, &xas, ret);
 	cachefiles_req_put(req);
 	return ret ? ret : n;
 }
@@ -557,8 +563,18 @@ static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
 		goto out;
 
 	wake_up_all(&cache->daemon_pollwq);
-	wait_for_completion(&req->done);
-	ret = req->error;
+wait:
+	ret = wait_for_completion_killable(&req->done);
+	if (!ret) {
+		ret = req->error;
+	} else {
+		ret = -EINTR;
+		if (!cachefiles_ondemand_finish_req(req, &xas, ret)) {
+			/* Someone will complete it soon. */
+			cpu_relax();
+			goto wait;
+		}
+	}
 	cachefiles_req_put(req);
 	return ret;
 out:
-- 
2.43.0



