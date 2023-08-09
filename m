Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E596131
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E2FC433C7;
	Wed,  9 Aug 2023 10:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578133;
	bh=ZWr4A6f7OluqMPKskemNZ9VWQGqgXQ6/ciRFmKNIfZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8lzFyXXfgG9xbvPMNq+cvJFyE8qAeKxEb3RIsyADzVEFQEPNeCy0r/OzPVxRphDk
	 SA3Z9c/Y7KG7rQOSl+UzsR1k34nSNS4qCBWBOh4WcEDV/uTNNk+KoFt5w/kdZoa0WU
	 sFEDYV5Icss52UTv0BWc6SNh/FmEfZzrCAGOxva8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 6.4 117/165] rbd: prevent busy loop when requesting exclusive lock
Date: Wed,  9 Aug 2023 12:40:48 +0200
Message-ID: <20230809103646.618610684@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Dryomov <idryomov@gmail.com>

commit 9d01e07fd1bfb4daae156ab528aa196f5ac2b2bc upstream.

Due to rbd_try_acquire_lock() effectively swallowing all but
EBLOCKLISTED error from rbd_try_lock() ("request lock anyway") and
rbd_request_lock() returning ETIMEDOUT error not only for an actual
notify timeout but also when the lock owner doesn't respond, a busy
loop inside of rbd_acquire_lock() between rbd_try_acquire_lock() and
rbd_request_lock() is possible.

Requesting the lock on EBUSY error (returned by get_lock_owner_info()
if an incompatible lock or invalid lock owner is detected) makes very
little sense.  The same goes for ETIMEDOUT error (might pop up pretty
much anywhere if osd_request_timeout option is set) and many others.

Just fail I/O requests on rbd_dev->acquiring_list immediately on any
error from rbd_try_lock().

Cc: stable@vger.kernel.org # 588159009d5b: rbd: retrieve and check lock owner twice before blocklisting
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3675,7 +3675,7 @@ static int rbd_lock(struct rbd_device *r
 	ret = ceph_cls_lock(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
 			    RBD_LOCK_NAME, CEPH_CLS_LOCK_EXCLUSIVE, cookie,
 			    RBD_LOCK_TAG, "", 0);
-	if (ret)
+	if (ret && ret != -EEXIST)
 		return ret;
 
 	__rbd_lock(rbd_dev, cookie);
@@ -3878,7 +3878,7 @@ static struct ceph_locker *get_lock_owne
 				 &rbd_dev->header_oloc, RBD_LOCK_NAME,
 				 &lock_type, &lock_tag, &lockers, &num_lockers);
 	if (ret) {
-		rbd_warn(rbd_dev, "failed to retrieve lockers: %d", ret);
+		rbd_warn(rbd_dev, "failed to get header lockers: %d", ret);
 		return ERR_PTR(ret);
 	}
 
@@ -3940,8 +3940,10 @@ static int find_watcher(struct rbd_devic
 	ret = ceph_osdc_list_watchers(osdc, &rbd_dev->header_oid,
 				      &rbd_dev->header_oloc, &watchers,
 				      &num_watchers);
-	if (ret)
+	if (ret) {
+		rbd_warn(rbd_dev, "failed to get watchers: %d", ret);
 		return ret;
+	}
 
 	sscanf(locker->id.cookie, RBD_LOCK_COOKIE_PREFIX " %llu", &cookie);
 	for (i = 0; i < num_watchers; i++) {
@@ -3985,8 +3987,12 @@ static int rbd_try_lock(struct rbd_devic
 		locker = refreshed_locker = NULL;
 
 		ret = rbd_lock(rbd_dev);
-		if (ret != -EBUSY)
+		if (!ret)
+			goto out;
+		if (ret != -EBUSY) {
+			rbd_warn(rbd_dev, "failed to lock header: %d", ret);
 			goto out;
+		}
 
 		/* determine if the current lock holder is still alive */
 		locker = get_lock_owner_info(rbd_dev);
@@ -4089,11 +4095,8 @@ static int rbd_try_acquire_lock(struct r
 
 	ret = rbd_try_lock(rbd_dev);
 	if (ret < 0) {
-		rbd_warn(rbd_dev, "failed to lock header: %d", ret);
-		if (ret == -EBLOCKLISTED)
-			goto out;
-
-		ret = 1; /* request lock anyway */
+		rbd_warn(rbd_dev, "failed to acquire lock: %d", ret);
+		goto out;
 	}
 	if (ret > 0) {
 		up_write(&rbd_dev->lock_rwsem);
@@ -6627,12 +6630,11 @@ static int rbd_add_acquire_lock(struct r
 		cancel_delayed_work_sync(&rbd_dev->lock_dwork);
 		if (!ret)
 			ret = -ETIMEDOUT;
-	}
 
-	if (ret) {
-		rbd_warn(rbd_dev, "failed to acquire exclusive lock: %ld", ret);
-		return ret;
+		rbd_warn(rbd_dev, "failed to acquire lock: %ld", ret);
 	}
+	if (ret)
+		return ret;
 
 	/*
 	 * The lock may have been released by now, unless automatic lock


