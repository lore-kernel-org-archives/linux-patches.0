Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032826;
	b=bIHUfe069s0SRzuAKvdu4qKDGwOGBstnrUugba2DY3PXg4jKqjAOCObk5oI7UnA30KKu
	 SNqTYq2PnlT+pg0W6TZkUhZFwt8us0/Xi2F8qAwcvgsh43TQv9XKQ/VxhvIAScrg+BM7v
	 /TMBnK3JXtXhaeafnMdxioHmIhpv7bjhjryU580m3ZR65C3K2/UWxV4SS1J5MHYrEm36j
	 stTCBnH4RRngQFm6QaAgcKzc4FjpFFUwHSpqJg9Vg2/W+wFm9bcVVEv3Z3iKZeBaudNVB
	 cjBdzibJbF0wJVg2hyw0iz6ZBSp6gGozIxOftaMml0jSgHlvBc56mqXNjwtrt45ZIYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=isTq87MqFWUHv28GLA3YK/6lnERNAiIBjo36gWizJiI=;
	b=5mOPwlJlnKmhBEV0w6fymX5dW618zt1cRpUIDgBPNquOR4/RZcT6iNb6FLC5bTqDixuU
	 QZ5s8yizi9dw+hw09ZKVrE+bjvRT9Dr8t16qgvGNQMd1lhj0IwivP6p3uzdZV+3i95Ygl
	 H99dZ829TiHjJYweInDLG98UUZnppnYIrljCaqqYU3Su52dNUHjXJfeHK854MG/bfJRwu
	 8X0W65np0Xpt1uw9ABjEB/1o7fOlXkLUTRYLtJ56U8AmF4PAJAiNTmBqTBYjnwnwP0mnl
	 QgA7Vtt5PN6v57gwDJvsjHdQfSijf1nMy1TYU8ZAE1o7ejm3tZVEsZNY8cgwV0Qt1Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lnk848g6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40A9606A31C;
	Wed, 18 Nov 2026 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lnk848g6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CE21F000C5;
	Wed, 18 Nov 2026 20:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032825;
	bh=isTq87MqFWUHv28GLA3YK/6lnERNAiIBjo36gWizJiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lnk848g6niUdczPDZxXG6LcEw7Qq28EdGW7SjksZo+CtLJC4CIc59xkKJF99a0d5P
	 bAJ21IWDTMAJ2Pznip0y1uSlno8iT+9dVQA7Gt4agoiBwQxz6Ing5QAVI/8Rhcpv6P
	 h+NlyU2axSWipEk7Q9ch/4jiprp2W/LF5040DlAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@sina.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+1f0fbc2561b3e5d51b91@syzkaller.appspotmail.com,
	Bradley Morgan <brads@mainlining.org>,
	Pingfan Liu <kernelfans@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1548/1756] kernel/reboot: avoid potential deadlocks during suspension
Date: Wed, 18 Nov 2026 16:01:15 +0100
Message-ID: <20261118150110.576670237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@sina.com>

[ Upstream commit 66644b992f25f6a33775788c8b69a8bb3d41ad67 ]

Invoking reboot with LINUX_REBOOT_CMD_SW_SUSPEND causes kernel/reboot.c
to acquire system_transition_mutex and invoke hibernate(). hibernate()
calls lock_system_sleep(), which sets PF_NOFREEZE on current and attempts
to acquire system_transition_mutex again, potentially hitting:

WARNING: possible recursive locking detected
--------------------------------------------
syz.3.5755/5950 is trying to acquire lock:
ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: lock_system_sleep+0x49/0x70 kernel/power/main.c:71

but task is already holding lock:
ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot kernel/reboot.c:774 [inline]
ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __se_sys_reboot+0x223/0x460 kernel/reboot.c:738

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(system_transition_mutex);
  lock(system_transition_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

locks held by syz.3.5755/5950: 1, last CPU#0:
 #0: ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot kernel/reboot.c:774 [inline]
 #0: ffffffff8fc04760 (system_transition_mutex){+.+.}-{4:4}, at: __se_sys_reboot+0x223/0x460 kernel/reboot.c:738

Call Trace:
 lock_system_sleep+0x49/0x70 kernel/power/main.c:71
 hibernate+0x162/0x680 kernel/power/hibernate.c:784
 __do_sys_reboot kernel/reboot.c:816 [inline]

Move the suspension operation outside the scope protected by lock
system_transition_mutex.

Link: https://lore.kernel.org/20261020010559.23031-1-eadavis@sina.com
Fixes: 55f2503c3b69 ("PM / reboot: Eliminate race between reboot and suspend")
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+1f0fbc2561b3e5d51b91@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1f0fbc2561b3e5d51b91
Tested-by: <syzbot+1f0fbc2561b3e5d51b91@syzkaller.appspotmail.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/reboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index caab5c86c6e29..788aaa4c5be76 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -801,8 +801,8 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 #ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
-		ret = hibernate();
-		break;
+		mutex_unlock(&system_transition_mutex);
+		return hibernate();
 #endif
 
 	default:
-- 
2.53.0



