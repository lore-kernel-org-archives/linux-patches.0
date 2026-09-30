Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9768357D11;
	Wed, 30 Sep 2026 15:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783509; cv=none; b=fPiXwThI3RfXlMUgQbOFK0Z7cb4GgHZVo8sKRwttF+gHpFV92IW+LDKRxhLCFX1CJPgpBf3LtlRHVWL+KgFagNYotqc4f9Fo2YTgZoMzDc2dL+mcO62onqiNiMmjRDnwMnZOOnxj4l+zdHI8+KWl20DSP0GFhFM6sbawbhqIk/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783509; c=relaxed/simple;
	bh=V3N+7DUw7ci3FXjLJm+VGPDwTUG6OTaaAnCAFSWdxIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8/Tqa45QT1CqVkcAY4bdPKIk/uW574V3/5YZCMwCa1qvV6+s0aLWIZqOjF88VSQhf1/mNGWQGhh94cnAhUaHOK0kWiK877/3ktj5J8tD32DWlWLb6H8MR8hHjVHBxV7wz+IIGS95Rldnt5FoQIny5wHRHTV5j8aXmK2vnCypOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9YnBFkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9YnBFkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383DD1F00893;
	Wed, 30 Sep 2026 15:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783503;
	bh=zQdaeKreaEGR7E++H3P9hZrE8H4PIENy/yHDN6C6M3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9YnBFkCwmV0VvyqLuCXjDVkvI8p0HMe/558CTLFrGqVbsnCmo/hr3yRJNlF+Cmsn
	 QJ/T7bTG9DgFLt3edFBjLL8HkiX/Iarh7daLT88qFVmACy58kFe7uMjdZni2nwa0ij
	 9/lJ4taXU9l3Hq3hm1WNTqAQd3j3AxGXAMLcMkkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a6ffe86390c8a6afc818@syzkaller.appspotmail.com,
	Quanye Yang <quanyeyang@proton.me>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.10 422/595] RDMA/ucma: Serialize join and leave on copy_to_user failure
Date: Wed, 30 Sep 2026 17:25:15 +0200
Message-ID: <20260930152356.754171919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1488,9 +1488,10 @@ static ssize_t ucma_process_join(struct
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
@@ -1498,6 +1499,7 @@ static ssize_t ucma_process_join(struct
 		ret = -EFAULT;
 		goto err_leave_multicast;
 	}
+	mutex_unlock(&ctx->mutex);
 
 	xa_store(&multicast_table, mc->id, mc, 0);
 
@@ -1505,7 +1507,6 @@ static ssize_t ucma_process_join(struct
 	return 0;
 
 err_leave_multicast:
-	mutex_lock(&ctx->mutex);
 	rdma_leave_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr);
 	mutex_unlock(&ctx->mutex);
 	ucma_cleanup_mc_events(mc);


