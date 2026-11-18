Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021685;
	b=nfGagOXXiqWwBwW69EnnU7inzM4G0twYKaxmd0M1Cn91P2t6WdlIwCvXwGoGHOo/1TSn
	 jdCUCejBLYyDyggj6OaSBfGi3SDDtZQvna8iCsIDh9KslEqbhZdvUAHpMGxk7JXqQQbnd
	 dDxTmrYrFrdAfJkuXhVsySqi9wklq0N9uFtz8dG0o2rgF6kA9kY8kE7cbpHWj6F1f8yWR
	 WyFf5s4BoffnmFe/zlaE2Xm/lqQpNY1FwuuwrrzeZitj2uSQmr0NzERoJ+1mx/QPVGHap
	 lKrOFfoXID6Jv9x343y4m14/5jh29/vGELDj+F5jC3iQnKee9j1rT+0a58aMVS5vlrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2wppm9aUwLj85jvlKvYz8pzsJ8b0/ObvgztuStADzRM=;
	b=yJp6JYuxg560ZEYcOKndetW2lnEo6g90MymNRs9YQKSkPMiKlbh1iynmdxz7Yz/8sBR+
	 RnyGsH00i9Gw6e8bdgUojrgcZx04Wr7ZnfSWMJkH/LaBvPaWMHuHdLEKxNepSW3sZ1S1+
	 S33nR0IY+BbsmWn71CXesiyuWwPujDg6Ql6FYnoY+BczZQw7+SG0wCVup3QC3nQJH7p/Y
	 9/IovmUKDGp0T1oghT4VwwHEC3niUkz26XdN8hESGAdo3yMM0fpJ59Zk3R4oTgfqeccPq
	 TaZR1h+JnhuDcuM126cL1JAgnbWI2SlzmFCnLLF1zQPI2xjpWvQcBBOzWnOmS4ZgwLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYEfHPR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1664C606A320;
	Wed, 18 Nov 2026 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYEfHPR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763391F000C5;
	Wed, 18 Nov 2026 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021684;
	bh=2wppm9aUwLj85jvlKvYz8pzsJ8b0/ObvgztuStADzRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYEfHPR0vqGxp9+1fyIcDTHcBnPw6rs5XNzlTu5PL4QO62mU1nEi5P2GuDPEL3Yne
	 hEWS62SXPZq/nR5P+8zyK2dx7VL0JhjAIOQYngOVu2g8WkY7fGG3JWGKfnlEQeV/ZO
	 QDGrpVB9eQvk+ix9C+U70h1WJAxONbFiiA3A+ZlI=
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
Subject: [PATCH 7.3 2394/2651] kernel/reboot: avoid potential deadlocks during suspension
Date: Wed, 18 Nov 2026 16:00:34 +0100
Message-ID: <20261118150411.570775217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5b9691f45f5f0..bc2716677a6c5 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -813,8 +813,8 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
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



