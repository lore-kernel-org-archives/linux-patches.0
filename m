Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FD33B2FF0;
	Mon, 23 Mar 2026 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279180; cv=none; b=SEWjJbIS55QI2F0uRWPv+qWlxkUF2bAyrQHgeAsTyIWDD7tgwkQZ60aC6DKZp6+8O22dloTl0DbWGIb3VUGufRSbfZ12LXTNo4XBkA28i8CSi7+sIAVwk7oIDF64EiNMOWfay5H3jHu0x5v0Ujc+c8EDLxn8tHcw5Y2+qIlScu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279180; c=relaxed/simple;
	bh=aifukaDpDMkc/+iIEv9Af1Tw7OqRHsQdaZ5S8m5fUys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbxhGKhqPRnCRm0wlY7RswK3M4it8MS/wBJdTwB8atLTNNRA6UszjxIbzNuqSJCSs6GnSg2yayqMnhmVnDACRq59j9m5Exl7gwMOGwVltTnayspMKs73W/GB8C2SNWz5pFKhL/tpJn3mjAM7Bl6Z0mZ1xj/BS8QygbF//BH9UvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVhjet64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVhjet64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E05DC4CEF7;
	Mon, 23 Mar 2026 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279180;
	bh=aifukaDpDMkc/+iIEv9Af1Tw7OqRHsQdaZ5S8m5fUys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVhjet64NoO6yjI+cVEcbzCgS6x1pAUZa617+xoUQinH39ngpes+/H6DCysLkhA7q
	 wzV+PGdXT8w4LXSOJGRlQwRlh3BGBBOGIbACZxzex0JIqkFnRy+64VL3tN8AyNoVFb
	 UKVCHtvKkIFi0vSM8iSAdt/Ej0uAwn+la0P+loKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+feb9ce36a95341bb47a4@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 500/567] wifi: mac80211: Fix static_branch_dec() underflow for aql_disable.
Date: Mon, 23 Mar 2026 14:47:00 +0100
Message-ID: <20260323134546.394567865@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit b94ae8e0d5fe1bdbbfdc3854ff6ce98f6876a828 ]

syzbot reported static_branch_dec() underflow in aql_enable_write(). [0]

The problem is that aql_enable_write() does not serialise concurrent
write()s to the debugfs.

aql_enable_write() checks static_key_false(&aql_disable.key) and
later calls static_branch_inc() or static_branch_dec(), but the
state may change between the two calls.

aql_disable does not need to track inc/dec.

Let's use static_branch_enable() and static_branch_disable().

[0]:
val == 0
WARNING: kernel/jump_label.c:311 at __static_key_slow_dec_cpuslocked.part.0+0x107/0x120 kernel/jump_label.c:311, CPU#0: syz.1.3155/20288
Modules linked in:
CPU: 0 UID: 0 PID: 20288 Comm: syz.1.3155 Tainted: G     U       L      syzkaller #0 PREEMPT(full)
Tainted: [U]=USER, [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
RIP: 0010:__static_key_slow_dec_cpuslocked.part.0+0x107/0x120 kernel/jump_label.c:311
Code: f2 c9 ff 5b 5d c3 cc cc cc cc e8 54 f2 c9 ff 48 89 df e8 ac f9 ff ff eb ad e8 45 f2 c9 ff 90 0f 0b 90 eb a2 e8 3a f2 c9 ff 90 <0f> 0b 90 eb 97 48 89 df e8 5c 4b 33 00 e9 36 ff ff ff 0f 1f 80 00
RSP: 0018:ffffc9000b9f7c10 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffff9b3e5d40 RCX: ffffffff823c57b4
RDX: ffff8880285a0000 RSI: ffffffff823c5846 RDI: ffff8880285a0000
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000000a
R13: 1ffff9200173ef88 R14: 0000000000000001 R15: ffffc9000b9f7e98
FS:  00007f530dd726c0(0000) GS:ffff8881245e3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001140 CR3: 000000007cc4a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __static_key_slow_dec_cpuslocked kernel/jump_label.c:297 [inline]
 __static_key_slow_dec kernel/jump_label.c:321 [inline]
 static_key_slow_dec+0x7c/0xc0 kernel/jump_label.c:336
 aql_enable_write+0x2b2/0x310 net/mac80211/debugfs.c:343
 short_proxy_write+0x133/0x1a0 fs/debugfs/file.c:383
 vfs_write+0x2aa/0x1070 fs/read_write.c:684
 ksys_pwrite64 fs/read_write.c:793 [inline]
 __do_sys_pwrite64 fs/read_write.c:801 [inline]
 __se_sys_pwrite64 fs/read_write.c:798 [inline]
 __x64_sys_pwrite64+0x1eb/0x250 fs/read_write.c:798
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f530cf9aeb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f530dd72028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f530d215fa0 RCX: 00007f530cf9aeb9
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000010
RBP: 00007f530d008c1f R08: 0000000000000000 R09: 0000000000000000
R10: 4200000000000005 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f530d216038 R14: 00007f530d215fa0 R15: 00007ffde89fb978
 </TASK>

Fixes: e908435e402a ("mac80211: introduce aql_enable node in debugfs")
Reported-by: syzbot+feb9ce36a95341bb47a4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69a8979e.a70a0220.b118c.0025.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260306072405.3649474-1-kuniyu@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 207f772bd8ce2..bd7c5dfeaa8c5 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -326,7 +326,6 @@ static ssize_t aql_enable_read(struct file *file, char __user *user_buf,
 static ssize_t aql_enable_write(struct file *file, const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
-	bool aql_disabled = static_key_false(&aql_disable.key);
 	char buf[3];
 	size_t len;
 
@@ -341,15 +340,12 @@ static ssize_t aql_enable_write(struct file *file, const char __user *user_buf,
 	if (len > 0 && buf[len - 1] == '\n')
 		buf[len - 1] = 0;
 
-	if (buf[0] == '0' && buf[1] == '\0') {
-		if (!aql_disabled)
-			static_branch_inc(&aql_disable);
-	} else if (buf[0] == '1' && buf[1] == '\0') {
-		if (aql_disabled)
-			static_branch_dec(&aql_disable);
-	} else {
+	if (buf[0] == '0' && buf[1] == '\0')
+		static_branch_enable(&aql_disable);
+	else if (buf[0] == '1' && buf[1] == '\0')
+		static_branch_disable(&aql_disable);
+	else
 		return -EINVAL;
-	}
 
 	return count;
 }
-- 
2.51.0



