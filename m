Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0FE11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBA3C433C7;
	Mon, 28 Aug 2023 10:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219650;
	bh=V8ucc3Z3tsAf2SMoCfHeteAFLkIz01fAsSShwwFtFq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMxI/8+QBwCVugzGe54rOAvFUhq22GMz53XocRTRnINwT9io+vyYK1cYbKCbQR5nm
	 gih6fDVLjzUBahTZfo2dQhFppeBXJF1w45l5p3gvHHOTe5PzYii5E8IXBAZ3dVZ6bi
	 loRYgIXavBhOP4Yb4lk826wbZEPldSKStn3u5io0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/84] rbd: retrieve and check lock owner twice before blocklisting
Date: Mon, 28 Aug 2023 12:13:40 +0200
Message-ID: <20230828101150.000780397@linuxfoundation.org>
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

[ Upstream commit 588159009d5b7a09c3e5904cffddbe4a4e170301 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index dcb43c633c5e7..60d3a143ff450 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3914,6 +3914,15 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
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
@@ -4025,11 +4034,11 @@ static int find_watcher(struct rbd_device *rbd_dev,
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
@@ -4049,6 +4058,16 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
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
 
@@ -4070,10 +4089,12 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
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
-- 
2.40.1



