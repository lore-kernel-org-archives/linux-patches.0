Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD859334C3B;
	Wed, 23 Sep 2026 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173497; cv=none; b=kG/uQPI6POqaSrLy2q/MkgrN5yAf4LYwxFmCFMKaseT/Q54hiecpWr/cpEyxV1hevBuc4cAzzqH7ET/qxhmVyzjYVztVZq2bPhpHr5apjjPfO9vh/O1fEWoq0QKL0reVnY6XBvvIh0O/XRWfJHr0tKSeMXCodZ/x5BLqUBpg09k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173497; c=relaxed/simple;
	bh=xXKLvWuargG7lBzrimIA65tqfCM3sdHtSnL5pM/fRRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/r0oJKSubuCK1UmziPmpmJAQq5FanE3WrsZNdzTgCfd8JkrMKrp3qbM+wSbjhjtr2p8BJkJN/7xTUwLwIGwSjA3jEbTAc3q9sHsf7n5f6kQdeNu38tzuaojMUsj1gwiQytKXM9haV77BfumqsfG4Fx/D5xGoDwzzggZq0HNN7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMnPDWNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMnPDWNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B231F000FF;
	Wed, 23 Sep 2026 14:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173495;
	bh=4c6tVfC7OyShORV2WYynrolu8dqDvlxOzxfztcB9Bqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMnPDWNCT9qmr2qQkmBMHReJsXGTSDzo2mLCTuj7Z3tBM5mMDO+u3EkFOVal9ouIE
	 Yq5m9PJQo5YKblD/+YQq/sMFD0O3QWlB0KKsMcWOo1euW+iW+F+kmqmHuGgxFGyYSy
	 PV9MSyzqIpmjTSFTNmzu4rXS+2c3f1UJ+jv9hi2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a6ffe86390c8a6afc818@syzkaller.appspotmail.com,
	Quanye Yang <quanyeyang@proton.me>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 7.2 265/438] RDMA/ucma: Serialize join and leave on copy_to_user failure
Date: Wed, 23 Sep 2026 16:04:46 +0200
Message-ID: <20260923140651.638285634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

commit 662ade4de9ff5eceb0820a9f8e9fac70ba6a815b upstream.

rdma_join_multicast() queues RoCE work that later reads the ucma_multicast
through event->param.ud.private_data, then list_add()s the CMA multicast
at the head of id_priv->mc_list. rdma_leave_multicast() matches only by
sockaddr and destroys the first hit.

ucma_process_join() used to drop ctx->mutex after a successful join and
retake it only if copy_to_user() failed. Two concurrent JOIN_MCAST calls
with the same address can therefore insert a second CMA entry before the
first thread's leave. leave then cancels the newer work and the older
worker still dereferences the ucma_multicast that the first thread frees.

Keep ctx->mutex held from rdma_join_multicast() through copy_to_user() and,
on -EFAULT, through rdma_leave_multicast() so leave cannot miss this join.
Do not leave if join itself failed: that path never published this address
on mc_list, and a leave-by-addr would destroy an earlier successful join.

Reported-by: syzbot+a6ffe86390c8a6afc818@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a6ffe86390c8a6afc818
Fixes: fe454dc31e84 ("RDMA/ucma: Fix use-after-free bug in ucma_create_uevent")
Cc: stable@vger.kernel.org
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Link: https://patch.msgid.link/20260831-rdma-ucma-mc-uaf-v1-1-b8eeb7046aff@proton.me
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/ucma.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1556,9 +1556,10 @@ static ssize_t ucma_process_join(struct
 	mutex_lock(&ctx->mutex);
 	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *)&mc->addr,
 				  join_state, mc);
-	mutex_unlock(&ctx->mutex);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&ctx->mutex);
 		goto err_xa_erase;
+	}
 
 	resp.id = mc->id;
 	if (copy_to_user(u64_to_user_ptr(cmd->response),
@@ -1566,6 +1567,7 @@ static ssize_t ucma_process_join(struct
 		ret = -EFAULT;
 		goto err_leave_multicast;
 	}
+	mutex_unlock(&ctx->mutex);
 
 	xa_store(&multicast_table, mc->id, mc, 0);
 
@@ -1573,7 +1575,6 @@ static ssize_t ucma_process_join(struct
 	return 0;
 
 err_leave_multicast:
-	mutex_lock(&ctx->mutex);
 	rdma_leave_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr);
 	mutex_unlock(&ctx->mutex);
 	ucma_cleanup_mc_events(mc);


