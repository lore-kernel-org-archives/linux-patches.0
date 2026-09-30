Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D814BD786;
	Wed, 30 Sep 2026 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783226; cv=none; b=ScE4j6HJpA/wqm2H9YGv+zwQuzIAwSjKeELi2Z09S23iWqMEZzzV1zN6q2M7PnghnXwT2eEMJoZo7wXlv+5VzpU4Lw/JkK3AZdj23+fOXMml9lsxN17Kwg8kGkuGw2Iver7EFQGxDp7nRgJxkS2AMTNGCqnkfWpm098swrul3D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783226; c=relaxed/simple;
	bh=L5qYHbVIP9fXVVZIHivyG+3QHWL4eL4olodHg9mZ1us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sebS9I8a0v36lG+PBZU/gneDnPh28sNy7mWAhPb6jeIltkVFqaAM2WlOO9nTyhoVGdgbME0GgEDypPECv3FMl8yiejMhRhwK56NbFLBZxgsPGUEk1i/Z1L6IOuzElLchTvET9XQGXV/Ag5GokoTGddnTlW2wWIrJq9dWJ3zcUVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7lTpOu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7lTpOu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFF51F000FF;
	Wed, 30 Sep 2026 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783222;
	bh=8uxP0yJ36iirmMmPDnPSS1Zj1QFMjH2EwHOKLckpNg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7lTpOu8pM/MJ+EPAG64jARJA9VAmFphxQMY9P96CIxaS9+28EGuxpHSJoRPI1aJY
	 CRjIRn6+P3YFwqB2Lwja5qYsjY6ZbjZj8p/mQ7llgkhAcdlL2hsqsM+oRIx4H1hqoI
	 NLvMGLiwTloqvuAApt3sn4y+E7joj+mrCmzwDT1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 323/595] net: appletalk: fix NULL pointer dereference in aarp_send_ddp()
Date: Wed, 30 Sep 2026 17:23:36 +0200
Message-ID: <20260930152354.631964261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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


