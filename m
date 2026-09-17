Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4291A4E780A;
	Thu, 17 Sep 2026 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666874; cv=none; b=fjei+0CQU6BRaTMqHJZnHI9gNHYvkRyJcj0TjPtc0nJUfnv2TFuxNaKntCaSDqVC4pF5mIUwoExtWczNrD/94o3YPW6pflV4nr4zOyAagTeUqu9GvixTt4M4Woaba36/t9j7tuGjec3tpUhZd2SrWyYPm0wE1K5fRSg6S6mwa98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666874; c=relaxed/simple;
	bh=cPxKISqMryPI8SEM16QYuNp3+kh6DuS3YqCsFP+ECYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiF9KRaylAJB9u7At8qu2+2QuMAZ1FvFQiwMxgwC7baqaM+blVz0f+isP2/NFKSnSM4D2LyLDAlrR3JHF74QrIHngHn/vnMGnhNW80AGFCjgfE1mmH1Wd6mnhGuNttibJ0QpI60BuW9V3hnJlh2B1tFxgvGeXYb0zm8HComKv2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4dLnJzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4dLnJzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D8A1F000FF;
	Thu, 17 Sep 2026 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666873;
	bh=1SjKvI3wcWxGKjW91Tjm3/7oTOL9NdfnAT/iXD/CP+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4dLnJzWJvHbWCGG4CMWqIe1EKkYc1rp2nKc/gCjLd7oVc3mqnECOI5aMaOYwDkkS
	 PD7xrQRCqam/axwa5HnQIm0p70uMKw6m9HvBhaYH73JEvp9zpJmVkk3enZ3KWjbkEh
	 9hfl8X45bKG0slqvAAsmpwKNEwUgqc7cijsAgO50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1154/1250] net: appletalk: fix NULL pointer dereference in aarp_send_ddp()
Date: Thu, 17 Sep 2026 16:15:49 +0100
Message-ID: <20260917151623.543169211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -542,6 +542,11 @@ int aarp_send_ddp(struct net_device *dev
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


