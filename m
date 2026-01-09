Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B251933032C;
	Fri,  9 Jan 2026 12:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962812; cv=none; b=XwLWBKvEW+5tAj5e73Krs8Ap37V//i3zPqVvQyeyq1ADwjj//X2Zz5cZipNyVBcWLrQ+W1FFx9GRvg1v031jWH5MtMYN92dZE4rdZoJ3walWKCUWAyX9+zCS81Ov1BKWo9OphuvHGbVmvnwEsQykfnVJma1l5AZ0MAL0YxTtEsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962812; c=relaxed/simple;
	bh=GD/FkCQa+PElaka9yyyUNwrh/VGGmly6mMIYmsYNboE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXn+dudgRNp6vToP4sXsW0tjLU+16qfmBUx+firWlLH5Mh/dT2/06WlzSf+8E3OpTMuyz6Y6TkbUZUCaLLZtgshfSNcCsGue5w9KR0Q9ZMZY1uqr5TQwRGQgkIXD6VfmCBPIF09bl8EmTYUNc3XU3G4NKMYoFhSZ/PPIT2lJBVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZ42fJBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZ42fJBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006ADC4CEF1;
	Fri,  9 Jan 2026 12:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962812;
	bh=GD/FkCQa+PElaka9yyyUNwrh/VGGmly6mMIYmsYNboE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZ42fJBhnGT4sl0QGdzzLlDo2u7glsjYoaQVYGmQO4oVuHOrOoTqPY9nVSNQo9xxY
	 xv+y0pNP13lGrrj7owDZ6xvkPTSU1m+jf+3IX913I8VpmHNlRa9kz7Rslbq7eez3TK
	 AJN6RjK9kZIH4Rx/5FDqPpFwFYzA6rBMU+0Qw7bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0da83a6c0e2e2bddbd4@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 497/634] RDMA/cm: Fix leaking the multicast GID table reference
Date: Fri,  9 Jan 2026 12:42:55 +0100
Message-ID: <20260109112136.247362558@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1970,6 +1970,7 @@ static void destroy_mc(struct rdma_id_pr
 		ib_sa_free_multicast(mc->sa_mc);
 
 	if (rdma_protocol_roce(id_priv->id.device, id_priv->id.port_num)) {
+		struct rdma_cm_event *event = &mc->iboe_join.event;
 		struct rdma_dev_addr *dev_addr =
 			&id_priv->id.route.addr.dev_addr;
 		struct net_device *ndev = NULL;
@@ -1992,6 +1993,8 @@ static void destroy_mc(struct rdma_id_pr
 		dev_put(ndev);
 
 		cancel_work_sync(&mc->iboe_join.work);
+		if (event->event == RDMA_CM_EVENT_MULTICAST_JOIN)
+			rdma_destroy_ah_attr(&event->param.ud.ah_attr);
 	}
 	kfree(mc);
 }


