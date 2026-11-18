Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062055;
	b=NNMQvE/2TZC3dg9A7L19XGe0+U+bvIN+lz1qZ/UUa1EsRf+Zu9eY0ywzth5RejCH7vh2
	 SO0t+AzUds4k9bU/Xbk+3AmsVwFITxFVxZ2v+FNHBttdmHWDNOpv2RtEomVynHEIvisyB
	 Y9mjzeWvtpG5czEyJm0dbrTxs3qAV94WnB8LCrieoJ5I5El+54tacv8RoigNuPmE4/OwM
	 oprz4uT2mJvQWUlHQKBxHexCe1haOxAPCuhzS1ynZGr5r2Khn4kxb+LrtVhgSzEc9dPnq
	 raRYWfmnsHxL+F22B5nWNhwAqHHKEWGFdJngTBqHRMBWXuz7rxlrZOnw2MUVWJsspzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5IypgxDIq2vt//a86t2tDQ0SroAdnmbPUmQmG+5SXVo=;
	b=QYECeK/iL9zTCkABo84O6yYQDRZoSNZxhpc7gxwwKVsZRAhJVn80/LqiyyUvMehHp9ux
	 G/qAD/5YZpFyTkqfx49Au2JRdi0Qjj/q+n4Jvg4KG/X5TafLbuDYIqvyFF0N9c9PB5b4O
	 pTwyj6B/vfy6ev4K9Np39M4mDMltO3nJlIPPtp1J9V75tjE3Y+LErLhyfjvH2zSoxFqZd
	 l4xzbDsvE07wtsV+KgmXNMl7PI9YmcLnooQdMh2NHtBrMAyU/LKHipow8XjIqvI+FVxjs
	 a7KTrIZFNE6NFe5ESgxBPO679jA+3OiSsa3q2ewSgrjvQ3auwN2QH4cAqfA66DeMyyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dh2bEnpo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A21606A320;
	Thu, 19 Nov 2026 04:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dh2bEnpo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490621F000C4;
	Thu, 19 Nov 2026 04:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062054;
	bh=5IypgxDIq2vt//a86t2tDQ0SroAdnmbPUmQmG+5SXVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dh2bEnpovHbCa5cTrZtbC3aWHnANBQMfhmYjUfEUkqLs1i//r3XJopGnOhvMPhwj2
	 YcmWCfnQ/O6TdZSHOvLbsa+aiMlZer48YbH326/JBvUBtBefwV/Xtd7tB6vakt+nmy
	 ubhGV014FpgGLHHdMAt2j51dwZ/O/WwLIMs5Jt70=
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
Subject: [PATCH 5.10 1771/1848] kernel/reboot: avoid potential deadlocks during suspension
Date: Wed, 18 Nov 2026 16:03:29 +0100
Message-ID: <20261118150033.537806916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e297b35fc6521..e5ec0d6838ad9 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -385,8 +385,8 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
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



