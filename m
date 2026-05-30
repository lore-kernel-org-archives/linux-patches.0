Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C577362157;
	Sat, 30 May 2026 18:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164666; cv=none; b=Nt7kbmp2XHynT47wLe3NPqlXDbgLfy9IkjxVIEdFUAH2OqtJNAkOEHUn4xchQ9vbnaVQC0HVkSdwDQz6DglBnDKM9s1pGk1Q+oD7kklV59zdwO8+VAIFkil644K/CIJy1hVz//k/VhbNRnJ5ssOAYiaSH9Ft3iXx0G65RqX+y50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164666; c=relaxed/simple;
	bh=4ynk9e3P27gJIgKXRyKJyaE1g41T8IUQ2GlJIS0X5Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXjA5SIaFyOmRaNwcjJeF1KhWjWQjMvAj3aOpgiw+/m78wDL2S8y1IWKwG9+SOvbfGJx5/bc8RjWLwINIn8+8aTYspA17NtTGoWVkhGYTdjcnhSM+075lSAMgMlpcqfh29ou8nEj56hl+hahc+9W/XvqrOyruwFwFY8erusqI9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egUTKK2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egUTKK2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB311F00893;
	Sat, 30 May 2026 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164664;
	bh=TtcJClyrgtetp3v3iQqx7bsnx86a5tTft3niQXVk5Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egUTKK2NrDH8M1GYve9lnxu3OLCTMdZxd6OBzK98ZRobf07PiKvu4pueamCsiu6Pt
	 Q69OjOR9Y+N2MRi96h8i/wvkCogkAU7XgwpgHJ7CA57WU7KTSoaVF2xM0v4Obv1HK2
	 cJ5nCc19utRQbs2MR+Ka6dBnGt2O9TfAVDWVPANk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6985cb8e543ea90ba8ee@syzkaller.appspotmail.com,
	Kohei Enju <kohei@enjuk.jp>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 593/776] vhost_net: fix sleeping with preempt-disabled in vhost_net_busy_poll()
Date: Sat, 30 May 2026 18:05:07 +0200
Message-ID: <20260530160255.378056937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7a6892cfa3c5e..9d454da419955 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -545,7 +545,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	busyloop_timeout = poll_rx ? rvq->busyloop_timeout:
 				     tvq->busyloop_timeout;
 
-	preempt_disable();
+	migrate_disable();
 	endtime = busy_clock() + busyloop_timeout;
 
 	while (vhost_can_busy_poll(endtime)) {
@@ -562,7 +562,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 		cpu_relax();
 	}
 
-	preempt_enable();
+	migrate_enable();
 
 	if (poll_rx || sock_has_rx_data(sock))
 		vhost_net_busy_poll_try_queue(net, vq);
-- 
2.53.0



