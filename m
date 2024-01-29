Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975F415AAB1;
	Mon, 29 Jan 2024 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548358; cv=none; b=lQQ/2dwGd6P+qZ36erQ9KkBQdEUel2ZfNewm5WIt2rnaJ3oXh8cIFGv0h0vxEc0MDNnO7XKwjcH9wIiAz6Tw5zKte4Xu10u7rKjEAnCVTGzoeA/8X23ouizt6sZMWgXoqJtV+O0TL2I+Zr1+fj9K/6yXyVO0cUoofxL2yQf35IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548358; c=relaxed/simple;
	bh=aeFpKtlsK5m216kqswKmwBFjqbWkkx+tXv8rkFpod6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F34Hf1ZJnb9nRoPKXnJrM/wr6FRYFFbjyNjOHmp+kFwbbj2qYUiCvnITtpA3twD2HG03/+ty4XrjfeORFHgcWiuvecOFe9dpCwf/FHomzq9m+lVldeRyLfyabwgabWApe58og4In3+Zuhu1ngHYBwB/mP3vF8V6VrKlGukdeDK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7yojyQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7yojyQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EBBC433F1;
	Mon, 29 Jan 2024 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548358;
	bh=aeFpKtlsK5m216kqswKmwBFjqbWkkx+tXv8rkFpod6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7yojyQdNNshLceC8f2ziyDLkEvQWYXa35qeal+EsL00BiLJspGrcWOXHvv2EiRUu
	 A/m5q3mIqsCqvoOTjBeSCV2HWOfJii1bdhisw4L5ys0VoAVuqNy95aiChadxrP5F2I
	 5bF8mnvcMDF64Z8f1Z5150sk0sChln0NltVuukRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 6.1 121/185] rbd: dont move requests to the running list on errors
Date: Mon, 29 Jan 2024 09:05:21 -0800
Message-ID: <20240129170002.481663595@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Ilya Dryomov <idryomov@gmail.com>

commit ded080c86b3f99683774af0441a58fc2e3d60cae upstream.

The running list is supposed to contain requests that are pinning the
exclusive lock, i.e. those that must be flushed before exclusive lock
is released.  When wake_lock_waiters() is called to handle an error,
requests on the acquiring list are failed with that error and no
flushing takes place.  Briefly moving them to the running list is not
only pointless but also harmful: if exclusive lock gets acquired
before all of their state machines are scheduled and go through
rbd_lock_del_request(), we trigger

    rbd_assert(list_empty(&rbd_dev->running_list));

in rbd_try_acquire_lock().

Cc: stable@vger.kernel.org
Fixes: 637cd060537d ("rbd: new exclusive lock wait/wake code")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3453,14 +3453,15 @@ static bool rbd_lock_add_request(struct
 static void rbd_lock_del_request(struct rbd_img_request *img_req)
 {
 	struct rbd_device *rbd_dev = img_req->rbd_dev;
-	bool need_wakeup;
+	bool need_wakeup = false;
 
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
 	spin_lock(&rbd_dev->lock_lists_lock);
-	rbd_assert(!list_empty(&img_req->lock_item));
-	list_del_init(&img_req->lock_item);
-	need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
-		       list_empty(&rbd_dev->running_list));
+	if (!list_empty(&img_req->lock_item)) {
+		list_del_init(&img_req->lock_item);
+		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
+			       list_empty(&rbd_dev->running_list));
+	}
 	spin_unlock(&rbd_dev->lock_lists_lock);
 	if (need_wakeup)
 		complete(&rbd_dev->releasing_wait);
@@ -3843,14 +3844,19 @@ static void wake_lock_waiters(struct rbd
 		return;
 	}
 
-	list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item) {
+	while (!list_empty(&rbd_dev->acquiring_list)) {
+		img_req = list_first_entry(&rbd_dev->acquiring_list,
+					   struct rbd_img_request, lock_item);
 		mutex_lock(&img_req->state_mutex);
 		rbd_assert(img_req->state == RBD_IMG_EXCLUSIVE_LOCK);
+		if (!result)
+			list_move_tail(&img_req->lock_item,
+				       &rbd_dev->running_list);
+		else
+			list_del_init(&img_req->lock_item);
 		rbd_img_schedule(img_req, result);
 		mutex_unlock(&img_req->state_mutex);
 	}
-
-	list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
 }
 
 static bool locker_equal(const struct ceph_locker *lhs,


