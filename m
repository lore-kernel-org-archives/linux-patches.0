Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C515F3FD133;
	Wed, 20 May 2026 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302665; cv=none; b=c06Tr2iBXuIYJrBMBFY+Gor2w8BGrjYzv8cyyVb4h2/yVemZdP6TWzozOc8741H0kAe+7AfwM39uJtSlYkrxuO2rr7zi1bioVHklDG+ZwGVqXVifkzM54YfbPN6WRfkZGRP7u0yzJ7e5Z2OdWsJ7yxJ/xFpOUw+ZB61tU0r56fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302665; c=relaxed/simple;
	bh=390IE5xO26ZfABZET5oNPqnVv+DQHejY8RfPu2gLYRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QphU/pnhzPfquFQ7YzwXPZu9HQRWMPgBDytvg3SJLwiOOKgpkXKfAWdRd7SACkhIhxnEp3a8VmIQmpAL3Q8sRT1qzyCnVx2+8o7elCEb4+I33JaOnj5wtkRgpEyTlrzQqSjv68NyC0J5HqCPBdRIlY96uybXWYdxiYDXU5uOTss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM84Rc8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM84Rc8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D0B1F000E9;
	Wed, 20 May 2026 18:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302664;
	bh=NsFtirGl4BAe2HxLXsJRHW4KK7fm2yiboKhj2XzjIbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bM84Rc8G0/vARaPnISelNqi4I5m8+K8AqMFWfTcz1OSt5nWLZQ8KMHSACPT2feSpi
	 rgjrGqeAsd79HdWVgfXYGi7F7KElFOTQHWd8njfec7jfy8Tn9HitDSld6kLZjTH07X
	 2U6jHd5oVi0awVWRKw4t3/4+uKuTGui+70nIbsAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6985cb8e543ea90ba8ee@syzkaller.appspotmail.com,
	Kohei Enju <kohei@enjuk.jp>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/508] vhost_net: fix sleeping with preempt-disabled in vhost_net_busy_poll()
Date: Wed, 20 May 2026 18:22:57 +0200
Message-ID: <20260520162106.304855349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit e08a9fac5cf8c3fecf4755e7e3ac059f78b8f83d ]

syzbot reported "sleeping function called from invalid context" in
vhost_net_busy_poll().

Commit 030881372460 ("vhost_net: basic polling support") introduced a
busy-poll loop and preempt_{disable,enable}() around it, where each
iteration calls a sleepable function inside the loop.

The purpose of disabling preemption was to keep local_clock()-based
timeout accounting on a single CPU, rather than as a requirement of
busy-poll itself:

https://lore.kernel.org/1448435489-5949-4-git-send-email-jasowang@redhat.com

>From this perspective, migrate_disable() is sufficient here, so replace
preempt_disable() with migrate_disable(), avoiding sleepable accesses
from a preempt-disabled context.

Fixes: 030881372460 ("vhost_net: basic polling support")
Tested-by: syzbot+6985cb8e543ea90ba8ee@syzkaller.appspotmail.com
Reported-by: syzbot+6985cb8e543ea90ba8ee@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69e6a414.050a0220.24bfd3.002d.GAE@google.com/T/
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 5ad237d77a9a9..b26d9a8e4e055 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -547,7 +547,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	busyloop_timeout = poll_rx ? rvq->busyloop_timeout:
 				     tvq->busyloop_timeout;
 
-	preempt_disable();
+	migrate_disable();
 	endtime = busy_clock() + busyloop_timeout;
 
 	while (vhost_can_busy_poll(endtime)) {
@@ -564,7 +564,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 		cpu_relax();
 	}
 
-	preempt_enable();
+	migrate_enable();
 
 	if (poll_rx || sock_has_rx_data(sock))
 		vhost_net_busy_poll_try_queue(net, vq);
-- 
2.53.0



