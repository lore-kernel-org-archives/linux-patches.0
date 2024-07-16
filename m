Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC0819E82C;
	Tue, 16 Jul 2024 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145337; cv=none; b=QULLQbz26EVsFWWKs3MsEbMsKZZzkMOJO8YtD/wzhA8vgvIyHclv3eYPtzaFKVN/qaX5rdbAA4iVVz1hR+0LTub4IvVt6Qkk5vZxZSYq0sd3Q9kwhAgHcN7nWm4rlsESJuSWiWEuDBNpkBB0TebcoSI2lFZTMAZNBnmyFfkFGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145337; c=relaxed/simple;
	bh=vbS6efU/rdVSxbf3P2nVizOX1Zfla0DvKhdiB87XIMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQbv5lki9ur3zIV5knyBqbxkFQiQfGwb8gvE+pU/h96aZ/1s0gRojzX9mkcs47ZJ1TowauCkTuIwLUjUXD4Vit9urDAGZAEK9pPe1XFvKC0oED8vHLbWf1wceQmgdnJoaQTwcw2hZBYNSKsPfoFf4TdyoO174Ai4hLi1k0T58GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALvXovEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALvXovEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3008EC116B1;
	Tue, 16 Jul 2024 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145336;
	bh=vbS6efU/rdVSxbf3P2nVizOX1Zfla0DvKhdiB87XIMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALvXovEC9n/Avuc9qlJlxyuxRTJCSxutINfpbyEw/QNeUl8f/O2LIEYaxNFRhL0YC
	 VbXfKS1+DrZQiWKnxlmckcaQZ7i0TgZJkKVI2iw074CAy7Ruw0pGFQ5IWE80l6Kgou
	 PU4nth4ptB4vKpC07wpE3YMnKOb3WP3/g1dGJFQc=
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
Subject: [PATCH 6.1 04/96] cachefiles: stop sending new request when dropping object
Date: Tue, 16 Jul 2024 17:31:15 +0200
Message-ID: <20240716152746.689078610@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit b2415d1f4566b6939acacc69637eaa57815829c1 ]

Added CACHEFILES_ONDEMAND_OBJSTATE_DROPPING indicates that the cachefiles
object is being dropped, and is set after the close request for the dropped
object completes, and no new requests are allowed to be sent after this
state.

This prepares for the later addition of cancel_work_sync(). It prevents
leftover reopen requests from being sent, to avoid processing unnecessary
requests and to avoid cancel_work_sync() blocking by waiting for daemon to
complete the reopen requests.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-6-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 12e009d60852 ("cachefiles: wait for ondemand_object_worker to finish when dropping object")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/internal.h |  2 ++
 fs/cachefiles/ondemand.c | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index e0eac16e4741c..94f59123726ca 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -48,6 +48,7 @@ enum cachefiles_object_state {
 	CACHEFILES_ONDEMAND_OBJSTATE_CLOSE, /* Anonymous fd closed by daemon or initial state */
 	CACHEFILES_ONDEMAND_OBJSTATE_OPEN, /* Anonymous fd associated with object is available */
 	CACHEFILES_ONDEMAND_OBJSTATE_REOPENING, /* Object that was closed and is being reopened. */
+	CACHEFILES_ONDEMAND_OBJSTATE_DROPPING, /* Object is being dropped. */
 };
 
 struct cachefiles_ondemand_info {
@@ -335,6 +336,7 @@ cachefiles_ondemand_set_object_##_state(struct cachefiles_object *object) \
 CACHEFILES_OBJECT_STATE_FUNCS(open, OPEN);
 CACHEFILES_OBJECT_STATE_FUNCS(close, CLOSE);
 CACHEFILES_OBJECT_STATE_FUNCS(reopening, REOPENING);
+CACHEFILES_OBJECT_STATE_FUNCS(dropping, DROPPING);
 
 static inline bool cachefiles_ondemand_is_reopening_read(struct cachefiles_req *req)
 {
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 4b39f0422e590..cc2de0e3ee60f 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -494,7 +494,8 @@ static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
 		 */
 		xas_lock(&xas);
 
-		if (test_bit(CACHEFILES_DEAD, &cache->flags)) {
+		if (test_bit(CACHEFILES_DEAD, &cache->flags) ||
+		    cachefiles_ondemand_object_is_dropping(object)) {
 			xas_unlock(&xas);
 			ret = -EIO;
 			goto out;
@@ -535,7 +536,8 @@ static int cachefiles_ondemand_send_req(struct cachefiles_object *object,
 	 * If error occurs after creating the anonymous fd,
 	 * cachefiles_ondemand_fd_release() will set object to close.
 	 */
-	if (opcode == CACHEFILES_OP_OPEN)
+	if (opcode == CACHEFILES_OP_OPEN &&
+	    !cachefiles_ondemand_object_is_dropping(object))
 		cachefiles_ondemand_set_object_close(object);
 	kfree(req);
 	return ret;
@@ -634,8 +636,12 @@ int cachefiles_ondemand_init_object(struct cachefiles_object *object)
 
 void cachefiles_ondemand_clean_object(struct cachefiles_object *object)
 {
+	if (!object->ondemand)
+		return;
+
 	cachefiles_ondemand_send_req(object, CACHEFILES_OP_CLOSE, 0,
 			cachefiles_ondemand_init_close_req, NULL);
+	cachefiles_ondemand_set_object_dropping(object);
 }
 
 int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
-- 
2.43.0



