Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768F7224D6;
	Fri,  9 Jan 2026 12:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961119; cv=none; b=bZ9YFCcyJutVG2G+ZaVLuMXEgKVcPTBgEZUn97NW2qvv0EnZhVZ1TXwVYov1vaTWpFhFu9WJjH0MqNqj+SVkySc78qH7IvVFZqQYYx7QsWT/N1INXeCXoojVUjqtMQKwbJOwPnohPT/M4kWaD+bRU1nsGiPILNkqdnKqWjVhvTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961119; c=relaxed/simple;
	bh=//tHedoQi8N+OjfFvovI+RGIJ2US60mSR3lTiAU2jyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sx+vyNKutdxxsgEu0OLBPLBQ59bhR0/QZYB8eEKqJXKMwnBqUsPijPNgFG+SFrJ+lEooGxNDJkufnHqZhzy7OhjfVSe2MptsHcaoZ1gOlISd8DSNwN2DUturXdyblDc7w5vRvWXxdzO3gwd8EmqWU/u0jjhbcsJXA1uQfyTO1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rascf6QY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rascf6QY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D4AC4CEF1;
	Fri,  9 Jan 2026 12:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961119;
	bh=//tHedoQi8N+OjfFvovI+RGIJ2US60mSR3lTiAU2jyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rascf6QYqqq1/MNpJnjm1kyX11E9ushC9ZO2KttXuSNAwr+mRiSthBuxnSP3m/cO/
	 YIqNXM6uekbZ4yWtSTc1oIpisgwFPJfwtZRryhEDScdE1n7/Gha1ZUWp8Sa/41QnKY
	 f+9RadMEKfn4LeD0DeYVTkIEEglFA+lvO0lpMzwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0da83a6c0e2e2bddbd4@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 608/737] RDMA/cm: Fix leaking the multicast GID table reference
Date: Fri,  9 Jan 2026 12:42:27 +0100
Message-ID: <20260109112156.876656528@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1993,6 +1993,7 @@ static void destroy_mc(struct rdma_id_pr
 		ib_sa_free_multicast(mc->sa_mc);
 
 	if (rdma_protocol_roce(id_priv->id.device, id_priv->id.port_num)) {
+		struct rdma_cm_event *event = &mc->iboe_join.event;
 		struct rdma_dev_addr *dev_addr =
 			&id_priv->id.route.addr.dev_addr;
 		struct net_device *ndev = NULL;
@@ -2015,6 +2016,8 @@ static void destroy_mc(struct rdma_id_pr
 		dev_put(ndev);
 
 		cancel_work_sync(&mc->iboe_join.work);
+		if (event->event == RDMA_CM_EVENT_MULTICAST_JOIN)
+			rdma_destroy_ah_attr(&event->param.ud.ah_attr);
 	}
 	kfree(mc);
 }


