Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB86157E64;
	Mon, 29 Jan 2024 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548583; cv=none; b=me/uXJBoa9rW/Aq5sYZekRln1HNsR2yWKRhvFcB6CmUQmixApp7izXen41XKqHG4aXsbGBTGK9daqkZWV+8Lu/XtSTfgOEikCyiK8OcLgsAq4MgjJSkLB0Yo50ODG69s7lz0RRS3G2wZ0yOVAxN6lDvpi/Lp1cbEyDwiq8rAQI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548583; c=relaxed/simple;
	bh=0lNdl4Gg5kCyaVPfCLHAkUpHJfIwuyitlwuOedVrfmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIKc6btLpgVFITzojhIThoNI6Rc/sZ6CYHUJaiOn15hO5g+PehNumPBgKNPe1RRMHBdcbfGMBLRDxSe5XrszTssCt2MkInnu7i/YYOQHdJzpC03C6qKqUXSoI93eyzNDEitq6AJxjM8OqYEbKx6oQ0lLa/ZqPxSfggdAlFFEmr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7aPT1aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7aPT1aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE45C433F1;
	Mon, 29 Jan 2024 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548582;
	bh=0lNdl4Gg5kCyaVPfCLHAkUpHJfIwuyitlwuOedVrfmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7aPT1aN46rvCaLEs7V0SsJ176f6b+Cag0oRLmbnXYsrSb0UsVC5ex6eYutKA2snz
	 ouSAflFD3C+IafpCCPpNcIq2YD466kOvB+di1yPTxRm44gOAj4o4WFHWDQcBp4jGMU
	 4Fv9AaBF9bUpGW91iG3OcSWi2FvILiNZc+u4sFRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 6.6 238/331] rbd: dont move requests to the running list on errors
Date: Mon, 29 Jan 2024 09:05:02 -0800
Message-ID: <20240129170021.840689648@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
@@ -3452,14 +3452,15 @@ static bool rbd_lock_add_request(struct
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
@@ -3842,14 +3843,19 @@ static void wake_lock_waiters(struct rbd
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


