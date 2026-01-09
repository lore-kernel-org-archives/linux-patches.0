Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B8D224D6;
	Fri,  9 Jan 2026 12:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961105; cv=none; b=gXOT3xzBKDhnh2Tw0ojVwYzrgBiguXtYG5w5EVHZNs4Vv96Mr5NazsOXZ6tcBC7TOWHiy8QvAGZOZ6IioyKfwpXNJ7IksVyb6LLlwsLZ6cVxvvFBYfjoYxG0ECa/pqv9Xo8tdgykIoB9C+cgl4RVQEx3Q30nhoENqJfnMTOXZMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961105; c=relaxed/simple;
	bh=ATxUhTEYOe4TmbjMJ5YYjzr6H6/3/WASFlT5XYdcbXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVy1widsmdq+ITZHFzitZpYh/WZDOgDsrNlOauWBeCUMffZd2Q3whw8GLWZMG+YU4SUtZxJa0yDqOpLtIH4g9etF2I19dVZ3OsrMWdEBT0kTciDV2JI+aA0hET9VLcr+1cFyqOGvjFCe9S8fKGHuJB4MeP3UxzJBigq/2EODb1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yk4gZj6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yk4gZj6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8565C4CEF1;
	Fri,  9 Jan 2026 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961105;
	bh=ATxUhTEYOe4TmbjMJ5YYjzr6H6/3/WASFlT5XYdcbXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yk4gZj6dtOCAarv675ZvxQVxJgd6tv1M1MG0nwxoV32So3kqTufthZi1Ax8LkM62S
	 MdB7WRbcQduNulH0rRTVIzdD6LWs3DWnOTAzQn7AuvVJaVoC5RnR7/44w6ruKAp6Cw
	 yRv8j3SlOOhkuFMDaNfWrWOFVYhUdWqg3ipOuLIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 635/737] ext4: fix string copying in parse_apply_sb_mount_options()
Date: Fri,  9 Jan 2026 12:42:54 +0100
Message-ID: <20260109112157.896008066@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit ee5a977b4e771cc181f39d504426dbd31ed701cc ]

strscpy_pad() can't be used to copy a non-NUL-term string into a NUL-term
string of possibly bigger size.  Commit 0efc5990bca5 ("string.h: Introduce
memtostr() and memtostr_pad()") provides additional information in that
regard.  So if this happens, the following warning is observed:

strnlen: detected buffer overflow: 65 byte read of buffer size 64
WARNING: CPU: 0 PID: 28655 at lib/string_helpers.c:1032 __fortify_report+0x96/0xc0 lib/string_helpers.c:1032
Modules linked in:
CPU: 0 UID: 0 PID: 28655 Comm: syz-executor.3 Not tainted 6.12.54-syzkaller-00144-g5f0270f1ba00 #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__fortify_report+0x96/0xc0 lib/string_helpers.c:1032
Call Trace:
 <TASK>
 __fortify_panic+0x1f/0x30 lib/string_helpers.c:1039
 strnlen include/linux/fortify-string.h:235 [inline]
 sized_strscpy include/linux/fortify-string.h:309 [inline]
 parse_apply_sb_mount_options fs/ext4/super.c:2504 [inline]
 __ext4_fill_super fs/ext4/super.c:5261 [inline]
 ext4_fill_super+0x3c35/0xad00 fs/ext4/super.c:5706
 get_tree_bdev_flags+0x387/0x620 fs/super.c:1636
 vfs_get_tree+0x93/0x380 fs/super.c:1814
 do_new_mount fs/namespace.c:3553 [inline]
 path_mount+0x6ae/0x1f70 fs/namespace.c:3880
 do_mount fs/namespace.c:3893 [inline]
 __do_sys_mount fs/namespace.c:4103 [inline]
 __se_sys_mount fs/namespace.c:4080 [inline]
 __x64_sys_mount+0x280/0x300 fs/namespace.c:4080
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x64/0x140 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Since userspace is expected to provide s_mount_opts field to be at most 63
characters long with the ending byte being NUL-term, use a 64-byte buffer
which matches the size of s_mount_opts, so that strscpy_pad() does its job
properly.  Return with error if the user still managed to provide a
non-NUL-term string here.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 8ecb790ea8c3 ("ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251101160430.222297-1-pchelkin@ispras.ru>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ adapted 2-argument strscpy_pad() call to 3-argument form with explicit sizeof() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2507,7 +2507,7 @@ static int parse_apply_sb_mount_options(
 					struct ext4_fs_context *m_ctx)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	char s_mount_opts[65];
+	char s_mount_opts[64];
 	struct ext4_fs_context *s_ctx = NULL;
 	struct fs_context *fc = NULL;
 	int ret = -ENOMEM;
@@ -2515,7 +2515,8 @@ static int parse_apply_sb_mount_options(
 	if (!sbi->s_es->s_mount_opts[0])
 		return 0;
 
-	strscpy_pad(s_mount_opts, sbi->s_es->s_mount_opts, sizeof(s_mount_opts));
+	if (strscpy_pad(s_mount_opts, sbi->s_es->s_mount_opts, sizeof(s_mount_opts)) < 0)
+		return -E2BIG;
 
 	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL);
 	if (!fc)


