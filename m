Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB311A619E;
	Tue, 30 Jul 2024 16:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358348; cv=none; b=i4c3wILGS0/kdYMH4E0+6deb1eL2lwtEU0hTyB9JYFE6v9GbLhqDToHvo9t/SYf/Mkurhmshgs+3Dapr56XmTL4jJgXn3wpzqrpObpsSfcKdxouMYF6LF3l4+x4L8vOr1xTQ92XBbn+L0u2Vs0PIEm4O93LWBjri1EyeHjBgWVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358348; c=relaxed/simple;
	bh=wp23HBVgriKIiJaMcmb3VhgtzxaU2lQKIBZoMV8pIUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdPtKiunfOzcYk0S31dvzHEhQhBERjOF9XAPnN8RO8UZgmtikiMgamw01y6jh6nWNcLk10MRIfrkAeD1/oNtg2MXfrh8ktDuhAruUMEsayyvr2eBD1fT13okWDuhDAU0Zx3eVGWu2PTQ0C3dOM7kq3/PTMrePy5VdZ8dKBtdhSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxV8qPUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxV8qPUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE086C32782;
	Tue, 30 Jul 2024 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358348;
	bh=wp23HBVgriKIiJaMcmb3VhgtzxaU2lQKIBZoMV8pIUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxV8qPUFGuFnMbuSr+MhKB2FpGJYb4YxL6xDXH4EeJYn3/NY32Q9TcVeqMGIyLoH9
	 /O8sG9/euuLqiN0Wdk2Aq//9mQfPKsqx4rosMygz0jU4VfgcUa2Av1VhlRFm73rqxS
	 zYohcAx6XzLBiUMSruNG7D8PGyI9iUz0kHQXiBIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 6.1 382/440] rbd: dont assume RBD_LOCK_STATE_LOCKED for exclusive mappings
Date: Tue, 30 Jul 2024 17:50:15 +0200
Message-ID: <20240730151630.728041233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

commit 2237ceb71f89837ac47c5dce2aaa2c2b3a337a3c upstream.

Every time a watch is reestablished after getting lost, we need to
update the cookie which involves quiescing exclusive lock.  For this,
we transition from RBD_LOCK_STATE_LOCKED to RBD_LOCK_STATE_QUIESCING
roughly for the duration of rbd_reacquire_lock() call.  If the mapping
is exclusive and I/O happens to arrive in this time window, it's failed
with EROFS (later translated to EIO) based on the wrong assumption in
rbd_img_exclusive_lock() -- "lock got released?" check there stopped
making sense with commit a2b1da09793d ("rbd: lock should be quiesced on
reacquire").

To make it worse, any such I/O is added to the acquiring list before
EROFS is returned and this sets up for violating rbd_lock_del_request()
precondition that the request is either on the running list or not on
any list at all -- see commit ded080c86b3f ("rbd: don't move requests
to the running list on errors").  rbd_lock_del_request() ends up
processing these requests as if they were on the running list which
screws up quiescing_wait completion counter and ultimately leads to

    rbd_assert(!completion_done(&rbd_dev->quiescing_wait));

being triggered on the next watch error.

Cc: stable@vger.kernel.org # 06ef84c4e9c4: rbd: rename RBD_LOCK_STATE_RELEASING and releasing_wait
Cc: stable@vger.kernel.org
Fixes: 637cd060537d ("rbd: new exclusive lock wait/wake code")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3458,6 +3458,7 @@ static void rbd_lock_del_request(struct
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
 	spin_lock(&rbd_dev->lock_lists_lock);
 	if (!list_empty(&img_req->lock_item)) {
+		rbd_assert(!list_empty(&rbd_dev->running_list));
 		list_del_init(&img_req->lock_item);
 		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING &&
 			       list_empty(&rbd_dev->running_list));
@@ -3477,11 +3478,6 @@ static int rbd_img_exclusive_lock(struct
 	if (rbd_lock_add_request(img_req))
 		return 1;
 
-	if (rbd_dev->opts->exclusive) {
-		WARN_ON(1); /* lock got released? */
-		return -EROFS;
-	}
-
 	/*
 	 * Note the use of mod_delayed_work() in rbd_acquire_lock()
 	 * and cancel_delayed_work() in wake_lock_waiters().
@@ -4602,6 +4598,10 @@ static void rbd_reacquire_lock(struct rb
 			rbd_warn(rbd_dev, "failed to update lock cookie: %d",
 				 ret);
 
+		if (rbd_dev->opts->exclusive)
+			rbd_warn(rbd_dev,
+			     "temporarily releasing lock on exclusive mapping");
+
 		/*
 		 * Lock cookie cannot be updated on older OSDs, so do
 		 * a manual release and queue an acquire.


