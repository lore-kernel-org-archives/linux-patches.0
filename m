Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F24B3D7D94;
	Wed, 30 Sep 2026 19:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795834; cv=none; b=kKpSpj6V+4Ar20Ge/NsNSOpInVRUmRfrqKWs6RtQ70pZH5j2ucr7nMjNQKMOhTUypH3xvonhyool5bPH8j1yLt/ev7Sz4sONKxgtJwzJBO2R5X371PJohVMm5iqvR5VKrMu0bBudB1NF4dz/VajA5+1bA9EMY0VAKdH6iXiDe00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795834; c=relaxed/simple;
	bh=c1SjCgeKZB4gJawrbsby2lrcCSK4hjbRCnntEzFfAHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFJZRr+bVbmt4a2lR1xYxyfL3mCHxxrcn/4ccPurUmi6UaczaAKme7Kj0el3bS0hR2re2zCqaNNRd0SG8Mg3li5hoF0XCvBqU7GsFri6RBD58pNX54uHKgadU/pgmI7cTCjRyvUdH5VfEpMGc49dbgSphtT6L3ts73iodR9EfLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TvaPhq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TvaPhq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B580C1F00898;
	Wed, 30 Sep 2026 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795833;
	bh=vr/O2UIX5bCkYVmQ00LfvA4oh8vCcLpBPHtLKZguDoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TvaPhq/Wfyra1yNy8+tqx+Iw1UdYvupQ9jHJN1gO1KULRWu7CrCewVL1UoZt8agR
	 SzeMldV1GTq2qVyalmID4XOD9flgpKXnJ6drfN8Jw16fBWBh+7B8Mj9JHDNuEpZ5Hj
	 5FJc745EP7pgpe9dHXMTZJIZY7ndFO27oxbdgU+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0699/1193] net: appletalk: fix NULL pointer dereference in aarp_send_ddp()
Date: Wed, 30 Sep 2026 17:23:03 +0200
Message-ID: <20260930152449.781587190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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


