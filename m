Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F9411C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89022C433C8;
	Mon, 28 Aug 2023 10:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219656;
	bh=86rLZKebt7vrAARwgIJjlAcXKoVpTF8WP9wP57Fzddg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICW8uPRzdQIX8oZgr807IXlntqMPVqf0o55rsuz5gq/TY0V6qDd6lKxM1Hls4fELt
	 jIxa16DUIHaFdz5gFspBWaeKmDkXy7G2bsp1j6l2fPa/hXdKkERORZI0M6ygTCAA1a
	 EMbd505ODZiQb3ld4evKwtAqGsedS4vKDr9FUgC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/84] rbd: prevent busy loop when requesting exclusive lock
Date: Mon, 28 Aug 2023 12:13:41 +0200
Message-ID: <20230828101150.052493251@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 9d01e07fd1bfb4daae156ab528aa196f5ac2b2bc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 60d3a143ff450..95cbd5790ed60 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3740,7 +3740,7 @@ static int rbd_lock(struct rbd_device *rbd_dev)
 	ret = ceph_cls_lock(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
 			    RBD_LOCK_NAME, CEPH_CLS_LOCK_EXCLUSIVE, cookie,
 			    RBD_LOCK_TAG, "", 0);
-	if (ret)
+	if (ret && ret != -EEXIST)
 		return ret;
 
 	__rbd_lock(rbd_dev, cookie);
@@ -3944,7 +3944,7 @@ static struct ceph_locker *get_lock_owner_info(struct rbd_device *rbd_dev)
 				 &rbd_dev->header_oloc, RBD_LOCK_NAME,
 				 &lock_type, &lock_tag, &lockers, &num_lockers);
 	if (ret) {
-		rbd_warn(rbd_dev, "failed to retrieve lockers: %d", ret);
+		rbd_warn(rbd_dev, "failed to get header lockers: %d", ret);
 		return ERR_PTR(ret);
 	}
 
@@ -3996,8 +3996,10 @@ static int find_watcher(struct rbd_device *rbd_dev,
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
@@ -4041,8 +4043,12 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
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
@@ -4145,11 +4151,8 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
 
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
@@ -6699,12 +6702,11 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
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
-- 
2.40.1



