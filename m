Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027856;
	b=lPXV36DgkD4+h+/mnqZgBQaCCZGK/xADna1BlzEeWJg+oH96Y/CNaS2nPTFrZO7vjjN9
	 wP7LJhZ3gS0gNSjxlvwltYqVxDTDK0/SuGe4LqMHDdriPUp6u9IqljkqGKad89oF+7mXt
	 qCXwPlD7eUCgckPbnyc1wRmn73tuqlEebF/CBYFMCg/nt+7ACU8ReNubQyfyLmMrHs7uM
	 b6nY0/JXpaWQY9HFYPJdAUQ1siFgsNQ/Yd4zBl0JCnRB/4ChO8Y2D3ll/QtGiRO8rH3yv
	 C+HvWXp0EoXd2WnFCs/h0AIIEOpv0bh0lfpc7Tdzx+yJg8xwiyQlKRGJWSr8Ot6TuNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=doz3ErrmEbJceP3TnpR+gxxR2RcjxTsbEBeioXyHXpY=;
	b=P8qiOHA0PXEd+SPFFjG4gelPJZMNhBU7iDu32RQUgRW7u4m+JfCdev4ZFMTJUWaxXuRR
	 SYakmdpfJjJPiY7rRKqLNpfGL0Y4HkydLIthlaNU4P+u0EsjVZmYdezA83qteGdwMkSgo
	 Cz7zESb3BXQvjtt8OGM7gvWvqx2pXmfAv6QJNvmcpZqwIB00cfQX1bpDTCeoRkrMlSnx+
	 iNc+kUha7MS6Z329XttSUK4Xvq5amXcqjT6kjtYhCLHJyhZB+jfmGJBw1LWJtCQoXGfF3
	 +TsHVHlGCGqznh8pap+LRsPXEck7oMyQB8g+w2FxfK7tvpYdj5T0DkFQeulSIDPOlyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEI8XpOU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED663606A320;
	Wed, 18 Nov 2026 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEI8XpOU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2E61F000C4;
	Wed, 18 Nov 2026 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027855;
	bh=doz3ErrmEbJceP3TnpR+gxxR2RcjxTsbEBeioXyHXpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEI8XpOUWvq0BsUPcCgf87yYqwC/i9WAb+s3hsmhl/pFJV8jvz9M9d4sO5Yrg0FMD
	 RB7iS9GuQZQvNuDWXOrzHb2YPUPJDYiy5BylX/IcDhA1tsEpHB+MGqENnbW5wLAyjY
	 1aua+/m96IB6f1n1W2atSerGzOIFuoPjz9MUYLzg=
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
Subject: [PATCH 6.18 1937/2151] kernel/reboot: avoid potential deadlocks during suspension
Date: Wed, 18 Nov 2026 16:01:12 +0100
Message-ID: <20261118150232.334817118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 665a25684c70a..eb514a35e2360 100644
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



