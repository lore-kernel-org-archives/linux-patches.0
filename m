Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA1F155322;
	Mon, 16 Sep 2024 12:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488729; cv=none; b=JyE21bCgFYfjnReBecNA+xsnmRY7SH9bXXW1knewhTPgmWfI0rHky+hAhXoiBAiBJlOOa/zIJjRfqD9EsEI3SPn0Y1UrLHteAjKD8H9HrXjqduHG3ejhrhTk4ZKC/SpGwDsnjTBZ9hAh/RDe3EvdWGa/BFkf5gMVjPZAoV4zhiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488729; c=relaxed/simple;
	bh=c/ea3m9QKBIMJ94PeIuB7Qo9YWO3KXPZa9wHo65iLkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLSPDZ2Gvd67LaMJB5nPxWlXUBmtRXREIMqJoRCbklPMFZa8bXN2R+Q0Jo3Tnb71vh/h02Nzhx9tdwZE5b+L5YrYz0O4nGJCf6bPgwzdOoZ4vx9C4slqpGEbLWEjqDbuVClDSL+vmYWJfBW3hgQOb/jHJdOqge9vSa2iXQoM6OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkU1ipVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkU1ipVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23334C4CEC4;
	Mon, 16 Sep 2024 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488729;
	bh=c/ea3m9QKBIMJ94PeIuB7Qo9YWO3KXPZa9wHo65iLkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkU1ipVWYtJa/7yldi6QKBIjPQvFDozCjmONeE4y1vTgPZb3QyAjhVE+O0Rz++R0Y
	 WYjIMNNXrKnl83HM1Y//c8fHCBG5lxBSJgg1tWEHTXtl+7SH2wHNmfhTUtolE5x52M
	 gc740wIXt8pnYRauKt6ulT2IwQq6do1wWfGSbyfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 79/91] drm/syncobj: Fix syncobj leak in drm_syncobj_eventfd_ioctl
Date: Mon, 16 Sep 2024 13:44:55 +0200
Message-ID: <20240916114227.064798315@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

commit 8c7c44be57672e1474bf15a451011c291e85fda4 upstream.

A syncobj reference is taken in drm_syncobj_find, but not released if
eventfd_ctx_fdget or kzalloc fails. Put the reference in these error
paths.

Reported-by: Xingyu Jin <xingyuj@google.com>
Fixes: c7a472297169 ("drm/syncobj: add IOCTL to register an eventfd")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by. Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org # 6.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20240909205400.3498337-1-tjmercier@google.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_syncobj.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -1421,6 +1421,7 @@ drm_syncobj_eventfd_ioctl(struct drm_dev
 	struct drm_syncobj *syncobj;
 	struct eventfd_ctx *ev_fd_ctx;
 	struct syncobj_eventfd_entry *entry;
+	int ret;
 
 	if (!drm_core_check_feature(dev, DRIVER_SYNCOBJ_TIMELINE))
 		return -EOPNOTSUPP;
@@ -1436,13 +1437,15 @@ drm_syncobj_eventfd_ioctl(struct drm_dev
 		return -ENOENT;
 
 	ev_fd_ctx = eventfd_ctx_fdget(args->fd);
-	if (IS_ERR(ev_fd_ctx))
-		return PTR_ERR(ev_fd_ctx);
+	if (IS_ERR(ev_fd_ctx)) {
+		ret = PTR_ERR(ev_fd_ctx);
+		goto err_fdget;
+	}
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
-		eventfd_ctx_put(ev_fd_ctx);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_kzalloc;
 	}
 	entry->syncobj = syncobj;
 	entry->ev_fd_ctx = ev_fd_ctx;
@@ -1453,6 +1456,12 @@ drm_syncobj_eventfd_ioctl(struct drm_dev
 	drm_syncobj_put(syncobj);
 
 	return 0;
+
+err_kzalloc:
+	eventfd_ctx_put(ev_fd_ctx);
+err_fdget:
+	drm_syncobj_put(syncobj);
+	return ret;
 }
 
 int


