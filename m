Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD0439FC6;
	Fri, 24 Nov 2023 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbdgbp+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEEEC433C7;
	Fri, 24 Nov 2023 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849446;
	bh=2RJUMDGp/35m/6HICiS7PxAqvDjqFNffyeGzCGn6xao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbdgbp+u2s5wbTQUdXeFcO4EP2yg4u9/ITKOmsaiRaSf1hlR/ZvwkcNBvFIOEbLBq
	 WjWCt0IfwYSNyEe8srnWmjuW52QduYL6KIDkPC8kk7RR/BzwyrYjqmDXI6wMTMcywf
	 kTgyGpEN4WcepVjTccUO8bbUs1xzZI6LtFdX8jbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/530] tty: Fix uninit-value access in ppp_sync_receive()
Date: Fri, 24 Nov 2023 17:45:50 +0000
Message-ID: <20231124172033.679243724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 719639853d88071dfdfd8d9971eca9c283ff314c ]

KMSAN reported the following uninit-value access issue:

=====================================================
BUG: KMSAN: uninit-value in ppp_sync_input drivers/net/ppp/ppp_synctty.c:690 [inline]
BUG: KMSAN: uninit-value in ppp_sync_receive+0xdc9/0xe70 drivers/net/ppp/ppp_synctty.c:334
 ppp_sync_input drivers/net/ppp/ppp_synctty.c:690 [inline]
 ppp_sync_receive+0xdc9/0xe70 drivers/net/ppp/ppp_synctty.c:334
 tiocsti+0x328/0x450 drivers/tty/tty_io.c:2295
 tty_ioctl+0x808/0x1920 drivers/tty/tty_io.c:2694
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:871 [inline]
 __se_sys_ioctl+0x211/0x400 fs/ioctl.c:857
 __x64_sys_ioctl+0x97/0xe0 fs/ioctl.c:857
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 __alloc_pages+0x75d/0xe80 mm/page_alloc.c:4591
 __alloc_pages_node include/linux/gfp.h:238 [inline]
 alloc_pages_node include/linux/gfp.h:261 [inline]
 __page_frag_cache_refill+0x9a/0x2c0 mm/page_alloc.c:4691
 page_frag_alloc_align+0x91/0x5d0 mm/page_alloc.c:4722
 page_frag_alloc include/linux/gfp.h:322 [inline]
 __netdev_alloc_skb+0x215/0x6d0 net/core/skbuff.c:728
 netdev_alloc_skb include/linux/skbuff.h:3225 [inline]
 dev_alloc_skb include/linux/skbuff.h:3238 [inline]
 ppp_sync_input drivers/net/ppp/ppp_synctty.c:669 [inline]
 ppp_sync_receive+0x237/0xe70 drivers/net/ppp/ppp_synctty.c:334
 tiocsti+0x328/0x450 drivers/tty/tty_io.c:2295
 tty_ioctl+0x808/0x1920 drivers/tty/tty_io.c:2694
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:871 [inline]
 __se_sys_ioctl+0x211/0x400 fs/ioctl.c:857
 __x64_sys_ioctl+0x97/0xe0 fs/ioctl.c:857
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

CPU: 0 PID: 12950 Comm: syz-executor.1 Not tainted 6.6.0-14500-g1c41041124bd #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
=====================================================

ppp_sync_input() checks the first 2 bytes of the data are PPP_ALLSTATIONS
and PPP_UI. However, if the data length is 1 and the first byte is
PPP_ALLSTATIONS, an access to an uninitialized value occurs when checking
PPP_UI. This patch resolves this issue by checking the data length.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_synctty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index ebcdffdf4f0e0..ea261a628786b 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -687,7 +687,7 @@ ppp_sync_input(struct syncppp *ap, const u8 *buf, const u8 *flags, int count)
 
 	/* strip address/control field if present */
 	p = skb->data;
-	if (p[0] == PPP_ALLSTATIONS && p[1] == PPP_UI) {
+	if (skb->len >= 2 && p[0] == PPP_ALLSTATIONS && p[1] == PPP_UI) {
 		/* chop off address/control */
 		if (skb->len < 3)
 			goto err;
-- 
2.42.0



