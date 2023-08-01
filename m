Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57791F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69377C433C8;
	Tue,  1 Aug 2023 09:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882146;
	bh=XDr2d/cNNHlXMxANOUDCVsnnZIzKm0jQOAUPOMCjFwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ5XbNwSRnHFmUygODcDciey2mO8xZUh4Q1/Q09256m5ntetO5wRr1hsH9sKrPPEP
	 MErnYHyE3GRitpG6g0cipTdX0ZSOGgLIMJnzGNfidqZI3qxdGI6sQtMjBhmiuFwlVn
	 Dba6fTk0Qrxd3fmPCmBBKg2gqdOK/GotIyB6KNKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 5.15 147/155] rbd: retrieve and check lock owner twice before blocklisting
Date: Tue,  1 Aug 2023 11:20:59 +0200
Message-ID: <20230801091915.383532464@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
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

commit 588159009d5b7a09c3e5904cffddbe4a4e170301 upstream.

An attempt to acquire exclusive lock can race with the current lock
owner closing the image:

1. lock is held by client123, rbd_lock() returns -EBUSY
2. get_lock_owner_info() returns client123 instance details
3. client123 closes the image, lock is released
4. find_watcher() returns 0 as there is no matching watcher anymore
5. client123 instance gets erroneously blocklisted

Particularly impacted is mirror snapshot scheduler in snapshot-based
mirroring since it happens to open and close images a lot (images are
opened only for as long as it takes to take the next mirror snapshot,
the same client instance is used for all images).

To reduce the potential for erroneous blocklisting, retrieve the lock
owner again after find_watcher() returns 0.  If it's still there, make
sure it matches the previously detected lock owner.

Cc: stable@vger.kernel.org # f38cb9d9c204: rbd: make get_lock_owner_info() return a single locker or NULL
Cc: stable@vger.kernel.org # 8ff2c64c9765: rbd: harden get_lock_owner_info() a bit
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3851,6 +3851,15 @@ static void wake_lock_waiters(struct rbd
 	list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
 }
 
+static bool locker_equal(const struct ceph_locker *lhs,
+			 const struct ceph_locker *rhs)
+{
+	return lhs->id.name.type == rhs->id.name.type &&
+	       lhs->id.name.num == rhs->id.name.num &&
+	       !strcmp(lhs->id.cookie, rhs->id.cookie) &&
+	       ceph_addr_equal_no_type(&lhs->info.addr, &rhs->info.addr);
+}
+
 static void free_locker(struct ceph_locker *locker)
 {
 	if (locker)
@@ -3971,11 +3980,11 @@ out:
 static int rbd_try_lock(struct rbd_device *rbd_dev)
 {
 	struct ceph_client *client = rbd_dev->rbd_client->client;
-	struct ceph_locker *locker;
+	struct ceph_locker *locker, *refreshed_locker;
 	int ret;
 
 	for (;;) {
-		locker = NULL;
+		locker = refreshed_locker = NULL;
 
 		ret = rbd_lock(rbd_dev);
 		if (ret != -EBUSY)
@@ -3995,6 +4004,16 @@ static int rbd_try_lock(struct rbd_devic
 		if (ret)
 			goto out; /* request lock or error */
 
+		refreshed_locker = get_lock_owner_info(rbd_dev);
+		if (IS_ERR(refreshed_locker)) {
+			ret = PTR_ERR(refreshed_locker);
+			refreshed_locker = NULL;
+			goto out;
+		}
+		if (!refreshed_locker ||
+		    !locker_equal(locker, refreshed_locker))
+			goto again;
+
 		rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
 			 ENTITY_NAME(locker->id.name));
 
@@ -4016,10 +4035,12 @@ static int rbd_try_lock(struct rbd_devic
 		}
 
 again:
+		free_locker(refreshed_locker);
 		free_locker(locker);
 	}
 
 out:
+	free_locker(refreshed_locker);
 	free_locker(locker);
 	return ret;
 }


