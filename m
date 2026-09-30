Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63859509EFA;
	Wed, 30 Sep 2026 16:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785614; cv=none; b=j7bxBH4fCgqTKwcEGcHiRm6VZ9wu+aDoJ08n9Apx3FkoQNo28gWLvPYXmN34LE1ep8J5fWFyrrQG9C3shRqZHBDHpWuC3dNH9EMEnouLYUUiSQPdqKi2zMxQ4uhFg5FfSPkoqMxh0tCCxL85YJRLL0Kk3QG68chTCQMc2hDX5GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785614; c=relaxed/simple;
	bh=WHZ4xuGVYA/l5OxTtRdAv1syWmqIVQt5DCRGXBKM7W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHJ2Pcm163uHhf99cJTMbpc/1l55JoMP+nEwuYBj0R5vzV/JmAExmUDLm2YN9uXYa3n/UdQwiTjZPdmnXCOGqUkxNZTahERmeAWISyJyKY6HnjSx6QUtPSKn6NokIOK/uYxMKXK/TbBPle8axj4ilqoTvanSVB0wz1Gy9Cx+Vyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCvaSemN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCvaSemN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7B41F00899;
	Wed, 30 Sep 2026 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785605;
	bh=9FE45Te+U38HuP+WnVHSTymz/oZbokpvfXhli6wex8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCvaSemNq4Pa3qWL0qYR2wpTMClWPQy82xIQk/UTAzWjvNtMtAHwLvsIpUdiDD9wq
	 7U3dFr9Z125yb/g2V7bUQw/y31cSpomTPkq/7gBp3GKyTYytc+4XpKr/il47oVEFz1
	 /H1dHbb8Cb5yFS8P+oFrJEDZKp30DiDZDuResQpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 568/982] net: appletalk: fix NULL pointer dereference in aarp_send_ddp()
Date: Wed, 30 Sep 2026 17:21:44 +0200
Message-ID: <20260930152428.970085616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit 9e7f36ab5b7bf68463faa5f7b926fea8f35597bb upstream.

aarp_send_ddp() calls atalk_find_dev_addr(dev) in the LocalTalk fast
path without checking for NULL. When the device has no AppleTalk
interface configured (dev->atalk_ptr == NULL), this leads to a NULL
pointer dereference at the at->s_net access.

 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:aarp_send_ddp (net/appletalk/aarp.c:552 (discriminator 2))
 Call Trace:
  <TASK>
  atalk_sendmsg (net/appletalk/ddp.c:1715)
  __sys_sendto (net/socket.c:2265 (discriminator 1))
  __x64_sys_sendto (net/socket.c:2272)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Add a NULL check consistent with the other callers of
atalk_find_dev_addr().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260514123806.3085961-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/appletalk/aarp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -573,6 +573,11 @@ int aarp_send_ddp(struct net_device *dev
 		struct ddpehdr *ddp = (struct ddpehdr *)skb->data;
 		int ft = 2;
 
+		if (!at) {
+			kfree_skb(skb);
+			return NET_XMIT_DROP;
+		}
+
 		/*
 		 * Compressible ?
 		 *


