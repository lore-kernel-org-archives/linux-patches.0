Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B014B36655B;
	Tue,  6 Jan 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722458; cv=none; b=tKwT02GllBFGev5PSXw7+SjCc10kLN60MMa+Xhz9cG9QddZ0JIG8hrPXhGE2prxRKRBerlsTqN/TtyfGA0MN2sZBz652t4lQ4xeDTdPBsgXJ15c62VWtiVDT487wZ2I6sRYVGVPuKo9TwU48AUoEy0hAV/SCGSU53GEvYxrU8HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722458; c=relaxed/simple;
	bh=WzjStEDWmZsIVK+z8hjjruP5zV+YLeHJ25Xp2bKWnj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1G3p3Vl/p5ByBBlDYZn8dofGCS1/tWizQauHlC6OYWiir3bp3INO3aQfTIY2OGMEO24zF/sM9mQmssThAuF1ynUh0ES51evZbK4KJ81mqV17EsME5F+rjN3cvgerZi9TfZv/d1vMXWS+IGTR/HD4OKtF8SNX9uhITJalmYUHpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEPBsnBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEPBsnBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2027C116C6;
	Tue,  6 Jan 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722458;
	bh=WzjStEDWmZsIVK+z8hjjruP5zV+YLeHJ25Xp2bKWnj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEPBsnBsHeVCF4gNF40pMHwFygGcu6JRdixTGuhZ43mJ8x9gxHK7ZmB+94X/CHuJW
	 KjG7SQg0Mn5YrlmQqWoYM+A9rQhbGhAxyf7WOC2hmTv/kc81KdQw0FmuxonxJ0QxA8
	 hnSAcQr8gh9+c6/zSlNRhM0RE38Qf46i1HN/az4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0da83a6c0e2e2bddbd4@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 238/312] RDMA/cm: Fix leaking the multicast GID table reference
Date: Tue,  6 Jan 2026 18:05:12 +0100
Message-ID: <20260106170556.461632302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2009,6 +2009,7 @@ static void destroy_mc(struct rdma_id_pr
 		ib_sa_free_multicast(mc->sa_mc);
 
 	if (rdma_protocol_roce(id_priv->id.device, id_priv->id.port_num)) {
+		struct rdma_cm_event *event = &mc->iboe_join.event;
 		struct rdma_dev_addr *dev_addr =
 			&id_priv->id.route.addr.dev_addr;
 		struct net_device *ndev = NULL;
@@ -2031,6 +2032,8 @@ static void destroy_mc(struct rdma_id_pr
 		dev_put(ndev);
 
 		cancel_work_sync(&mc->iboe_join.work);
+		if (event->event == RDMA_CM_EVENT_MULTICAST_JOIN)
+			rdma_destroy_ah_attr(&event->param.ud.ah_attr);
 	}
 	kfree(mc);
 }


