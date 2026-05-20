Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B4A349AFF;
	Wed, 20 May 2026 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299236; cv=none; b=nYsKxH095uCqU7KMZwbBKApz91z6din7XdtCRyyfm67ZpFl7YSJkGuqquWiJ0gzUcCMswZ9UHfmvc9EKp9vEO+OGuMqI1+N12sGNZzg7yZplHS6Jbq57KtSRZWasYKx0GqGsyoawQpt+rMifT9nMSTo9Y4VpgqrUZR3t9SJHZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299236; c=relaxed/simple;
	bh=H3SiyVuJm65tGoN0tfifXwWlhL4iYGKqvGT6mSkIY6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um4U+p/sSVUOt86jJ5fOzdYvNRCU1wQK/K5LLJ5eb6JAPOPVuixdkKs5WGssMQHIwm4VBJl4t/EspWu2YIp2kE8tU7r+YpgpXQ3ka63CCDPFTa/BDelDELG+3Bzqct+xDVzIdn7gBNAyDCcPD1E9EbauYp2FUDsuehefU7MmdMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fh4+tlCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fh4+tlCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43A51F000E9;
	Wed, 20 May 2026 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299235;
	bh=rvC3xNqEylWqkJo3tOswJeyoOWpkf927SnNEPe4HDb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fh4+tlCbTY29jk57pbN1pmRFu5nCWzrmTSkb9NO8LkqEvafVvaVLdoJIU4/mIoaqN
	 Kb0mQ0wkxKQsJYcTYWg/s8RSmXAzF1FXiW37QxndYdyVRl4zQtcFUjFEjrFZGcUwdw
	 k6gS6VGLDKfVWQLXXMXiygdD6O0llPPBffaJIk3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6985cb8e543ea90ba8ee@syzkaller.appspotmail.com,
	Kohei Enju <kohei@enjuk.jp>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 715/957] vhost_net: fix sleeping with preempt-disabled in vhost_net_busy_poll()
Date: Wed, 20 May 2026 18:19:58 +0200
Message-ID: <20260520162150.054035147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 1e77c0482b849..e11b46a1c9374 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -562,7 +562,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	busyloop_timeout = poll_rx ? rvq->busyloop_timeout:
 				     tvq->busyloop_timeout;
 
-	preempt_disable();
+	migrate_disable();
 	endtime = busy_clock() + busyloop_timeout;
 
 	while (vhost_can_busy_poll(endtime)) {
@@ -579,7 +579,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 		cpu_relax();
 	}
 
-	preempt_enable();
+	migrate_enable();
 
 	if (poll_rx || sock_has_rx_data(sock))
 		vhost_net_busy_poll_try_queue(net, vq);
-- 
2.53.0



