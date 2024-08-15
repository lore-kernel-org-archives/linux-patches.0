Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E74D1B32CC;
	Thu, 15 Aug 2024 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730950; cv=none; b=dOWKh9y4OR+hGNuG5wsd/uBH0iVz7mbQN2/axYjuZ5DulPJ4q0X0QSGu0NkP5WgosclwfH9Gj97GKMIb9KWcS9X7XjnDH8ClHaNR9TJ5Bo0Jq9mEVzu1k565UuCQpDla99lFvu2D3YtU6Lh1jol/pUTORUdGC865Ey7eF3pW3dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730950; c=relaxed/simple;
	bh=0mMiLw0YFV2JxaVl9+l2SjQdhHznQ8rqy3Okee10wFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uc5LPGHuz0VFhXZSeI14RQDeXLeu5tLATVLx+r4H16+evlVDp7ML2snthxD91uk2i9qXX2+rcFdEg6HyvPKFs3H0OrrLbmvmu1BkzgrOKuVoY6UNjHKO/QHelnC3twLwdyutjRTGUjyse2XOw9Bm01yfbR/aYXZMgvLwXFbsZTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKNpGQmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKNpGQmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87380C4AF0C;
	Thu, 15 Aug 2024 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730949;
	bh=0mMiLw0YFV2JxaVl9+l2SjQdhHznQ8rqy3Okee10wFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKNpGQmw/XVH1VjIEEH6kWItEILDpvmelfKiYadAlX2vbSEaGGU2vsx6qE61y+V3B
	 NC5P3l4lR19TFnhyp+Hco7vjWVzVCUMFZUJR7x72aPTsSPoRvN4SVngKWkznkFzk1x
	 xebOruJQBQ1WwJZ+XRFUZ3iCuSQgp05ioaUY88cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 43/67] mISDN: fix MISDN_TIME_STAMP handling
Date: Thu, 15 Aug 2024 15:25:57 +0200
Message-ID: <20240815131839.971205627@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 138b787804f4a10417618e8d1e6e2700539fd88c ]

syzbot reports one unsafe call to copy_from_sockptr() [1]

Use copy_safe_from_sockptr() instead.

[1]

 BUG: KASAN: slab-out-of-bounds in copy_from_sockptr_offset include/linux/sockptr.h:49 [inline]
 BUG: KASAN: slab-out-of-bounds in copy_from_sockptr include/linux/sockptr.h:55 [inline]
 BUG: KASAN: slab-out-of-bounds in data_sock_setsockopt+0x46c/0x4cc drivers/isdn/mISDN/socket.c:417
Read of size 4 at addr ffff0000c6d54083 by task syz-executor406/6167

CPU: 1 PID: 6167 Comm: syz-executor406 Not tainted 6.8.0-rc7-syzkaller-g707081b61156 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call trace:
  dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:291
  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:298
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0xd0/0x124 lib/dump_stack.c:106
  print_address_description mm/kasan/report.c:377 [inline]
  print_report+0x178/0x518 mm/kasan/report.c:488
  kasan_report+0xd8/0x138 mm/kasan/report.c:601
  __asan_report_load_n_noabort+0x1c/0x28 mm/kasan/report_generic.c:391
  copy_from_sockptr_offset include/linux/sockptr.h:49 [inline]
  copy_from_sockptr include/linux/sockptr.h:55 [inline]
  data_sock_setsockopt+0x46c/0x4cc drivers/isdn/mISDN/socket.c:417
  do_sock_setsockopt+0x2a0/0x4e0 net/socket.c:2311
  __sys_setsockopt+0x128/0x1a8 net/socket.c:2334
  __do_sys_setsockopt net/socket.c:2343 [inline]
  __se_sys_setsockopt net/socket.c:2340 [inline]
  __arm64_sys_setsockopt+0xb8/0xd4 net/socket.c:2340
  __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
  el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

Fixes: 1b2b03f8e514 ("Add mISDN core files")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Link: https://lore.kernel.org/r/20240408082845.3957374-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/socket.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 2776ca5fc33f3..b215b28cad7b7 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -401,23 +401,23 @@ data_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 }
 
 static int data_sock_setsockopt(struct socket *sock, int level, int optname,
-				sockptr_t optval, unsigned int len)
+				sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
 	int err = 0, opt = 0;
 
 	if (*debug & DEBUG_SOCKET)
 		printk(KERN_DEBUG "%s(%p, %d, %x, optval, %d)\n", __func__, sock,
-		       level, optname, len);
+		       level, optname, optlen);
 
 	lock_sock(sk);
 
 	switch (optname) {
 	case MISDN_TIME_STAMP:
-		if (copy_from_sockptr(&opt, optval, sizeof(int))) {
-			err = -EFAULT;
+		err = copy_safe_from_sockptr(&opt, sizeof(opt),
+					     optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			_pms(sk)->cmask |= MISDN_TIME_STAMP;
-- 
2.43.0



