Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9093CF42;
	Wed, 21 Feb 2024 14:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525146; cv=none; b=oFDufO8oU80MM0x7DpO1BX/8FEUU7m9oH/9N2n+nylDbOYc74/dvbF40rHu9yWEnbPL7n5cNZH+oEwuW1ZEirwb7Cj5aAurJAcaPefMETLeKsBmMecRGJ2N848PyBLmhsTXaUFnb/n+lFGPbYFFp2X+bTWegW44dmBttmRiwC6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525146; c=relaxed/simple;
	bh=2cBSjX2JnCAtoKrat72Vm1LpmxCKomjtWpDVrDaK4xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7qm45LO4jI3MzLlnf9DIv/gydU4vFHY80AFFDTTfu9ij3vNnyqMeba05gFHyGK3xuQ+sq5cKYp37aWg+PCIxTvux1EoZyzZgySoiMed0HBxzTKIbaVBah8Ly8QOAQim/8g6PZJbrRnUFnq3uXzNscHuC1XN1IbS0UuFgnBkuzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT8UZdF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT8UZdF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05C4C433F1;
	Wed, 21 Feb 2024 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525146;
	bh=2cBSjX2JnCAtoKrat72Vm1LpmxCKomjtWpDVrDaK4xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uT8UZdF/MADe6oms4fn6SSZxB3iuVRL2u9OOIH6jMR6NdyTpEsZVCEhPadeLH9o0w
	 IvullkfP+xXMEwCDHFhoxTZA67cf+//eYBoDzuJ7kqUM7DIU5I2pfL3pg+t0DhQ7v6
	 9PM2GZeNOREgVeFx26au4BtzaGGcnnCL4p8bsUUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 5.4 046/267] rbd: dont move requests to the running list on errors
Date: Wed, 21 Feb 2024 14:06:27 +0100
Message-ID: <20240221125941.459688539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3603,14 +3603,15 @@ static bool rbd_lock_add_request(struct
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
@@ -3997,14 +3998,19 @@ static void wake_lock_waiters(struct rbd
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
 
 static int get_lock_owner_info(struct rbd_device *rbd_dev,


