Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C79F3D2FE4;
	Thu, 15 Jan 2026 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499729; cv=none; b=WPeSdMBYY8Ch2eTb08GeX/Ym9kL7oTIV2p8ZVR6GM3pLzv/9mWUfrssqqpxnI+E+PYr/eaP6PU9huTzUMdNynBanxawAIbzpaco0NTDAkF7GQw2tclNe2D99t9xvY569g0AH6TQr+u+RonQeWHahG8k0zQmD4xxn7v801LfBlqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499729; c=relaxed/simple;
	bh=tqHYNrgN9Md66lX0Cx8LLKN3gV+uPR74Sb3t2djiCr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FW4kMyfFThEUW38YYZeiM3p49NCWpdnOnjjaWas06crxmj2T/dLG+CIZLmZTN+5jkj//BceI2kYpIqAyB6QxO2ffhoJLi3iiocytJaI5XmZX2hRSpJFETtj9KhbCkdPDWdg1axBH2+b5TWuyJOE4qs+1yBopvyXtbVOyoFE34ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3L8tEd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3L8tEd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D5CC116D0;
	Thu, 15 Jan 2026 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499729;
	bh=tqHYNrgN9Md66lX0Cx8LLKN3gV+uPR74Sb3t2djiCr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3L8tEd9/iVo45/pI2VkAwPvrfjBZ7fbvHVFzLXCWGRsui831U9SUWxXuiUgp/GlC
	 Bfwxpuae1AJxnd8WZmyGfFhaGgSmdPgKl/hJaz0XTLtRhmDVIuXDFYZtyvUtD3a8Dk
	 mv4GxNQDZHzWoUxosKO4/Jg6eaunFdvxIaGFS0tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0da83a6c0e2e2bddbd4@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 329/451] RDMA/cm: Fix leaking the multicast GID table reference
Date: Thu, 15 Jan 2026 17:48:50 +0100
Message-ID: <20260115164242.798604093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit 57f3cb6c84159d12ba343574df2115fb18dd83ca upstream.

If the CM ID is destroyed while the CM event for multicast creating is
still queued the cancel_work_sync() will prevent the work from running
which also prevents destroying the ah_attr. This leaks a refcount and
triggers a WARN:

   GID entry ref leak for dev syz1 index 2 ref=573
   WARNING: CPU: 1 PID: 655 at drivers/infiniband/core/cache.c:809 release_gid_table drivers/infiniband/core/cache.c:806 [inline]
   WARNING: CPU: 1 PID: 655 at drivers/infiniband/core/cache.c:809 gid_table_release_one+0x284/0x3cc drivers/infiniband/core/cache.c:886

Destroy the ah_attr after canceling the work, it is safe to call this
twice.

Link: https://patch.msgid.link/r/0-v1-4285d070a6b2+20a-rdma_mc_gid_leak_syz_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: fe454dc31e84 ("RDMA/ucma: Fix use-after-free bug in ucma_create_uevent")
Reported-by: syzbot+b0da83a6c0e2e2bddbd4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68232e7b.050a0220.f2294.09f6.GAE@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1840,6 +1840,7 @@ static void destroy_mc(struct rdma_id_pr
 		ib_sa_free_multicast(mc->sa_mc);
 
 	if (rdma_protocol_roce(id_priv->id.device, id_priv->id.port_num)) {
+		struct rdma_cm_event *event = &mc->iboe_join.event;
 		struct rdma_dev_addr *dev_addr =
 			&id_priv->id.route.addr.dev_addr;
 		struct net_device *ndev = NULL;
@@ -1862,6 +1863,8 @@ static void destroy_mc(struct rdma_id_pr
 		dev_put(ndev);
 
 		cancel_work_sync(&mc->iboe_join.work);
+		if (event->event == RDMA_CM_EVENT_MULTICAST_JOIN)
+			rdma_destroy_ah_attr(&event->param.ud.ah_attr);
 	}
 	kfree(mc);
 }


