Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D41DF756;
	Thu, 17 Apr 2025 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913337; cv=none; b=QSAMp8zT1HLT3aRX+uex3bj4sM8ekruRNf9OOxKICa0DEqKy9pypSjeUkmLh8n3ULs9K90smSxXN9/nl+6it4cflYwsbA0F0122CxC8UR8gDtS8c8NepBmJXv+KFlEHtyTzZLcwDYIpH71FYOx+83L/NSxvE7RKxewJMUPKPYpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913337; c=relaxed/simple;
	bh=UdAwudfvAm8WgSnK6LjgZd9+gt9p31oUIzjeQ/Ysqec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qq7AP8gF++cMbtLChPJDec2Tkf4q760wE5nBTjEhMU0utKumi01AoBSJxNpLvpRbm2EynRCna0vYbEQhYSyxsuWsb+NzR+XMmpywRHW3q/E3bMU0cCcMK8mgRH31R8FJ+LnoPud7gqvCDO3a+G8kRTVpNVSQR0pMUemtTkgxKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqExOJKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqExOJKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42B9C4CEE4;
	Thu, 17 Apr 2025 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913337;
	bh=UdAwudfvAm8WgSnK6LjgZd9+gt9p31oUIzjeQ/Ysqec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqExOJKZ77+VIEkglGe2LRbkj1/fzI+1Gt4v2k41xYcyURKOQKkVpHpzmi4FdexyB
	 2iGAP7baxGv9vA9LccPsXGpss3E8cQqGJT5DAD5ZvF84PO5o1/PA2ATd3BMHTNAK/J
	 b0rJs1O6Fk4SsiG0L5KZguZBlFApgRrcI5LDCGoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.14 306/449] ext4: fix off-by-one error in do_split
Date: Thu, 17 Apr 2025 19:49:54 +0200
Message-ID: <20250417175130.426597496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <a.sadovnikov@ispras.ru>

commit 94824ac9a8aaf2fb3c54b4bdde842db80ffa555d upstream.

Syzkaller detected a use-after-free issue in ext4_insert_dentry that was
caused by out-of-bounds access due to incorrect splitting in do_split.

BUG: KASAN: use-after-free in ext4_insert_dentry+0x36a/0x6d0 fs/ext4/namei.c:2109
Write of size 251 at addr ffff888074572f14 by task syz-executor335/5847

CPU: 0 UID: 0 PID: 5847 Comm: syz-executor335 Not tainted 6.12.0-rc6-syzkaller-00318-ga9cda7c0ffed #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 ext4_insert_dentry+0x36a/0x6d0 fs/ext4/namei.c:2109
 add_dirent_to_buf+0x3d9/0x750 fs/ext4/namei.c:2154
 make_indexed_dir+0xf98/0x1600 fs/ext4/namei.c:2351
 ext4_add_entry+0x222a/0x25d0 fs/ext4/namei.c:2455
 ext4_add_nondir+0x8d/0x290 fs/ext4/namei.c:2796
 ext4_symlink+0x920/0xb50 fs/ext4/namei.c:3431
 vfs_symlink+0x137/0x2e0 fs/namei.c:4615
 do_symlinkat+0x222/0x3a0 fs/namei.c:4641
 __do_sys_symlink fs/namei.c:4662 [inline]
 __se_sys_symlink fs/namei.c:4660 [inline]
 __x64_sys_symlink+0x7a/0x90 fs/namei.c:4660
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The following loop is located right above 'if' statement.

for (i = count-1; i >= 0; i--) {
	/* is more than half of this entry in 2nd half of the block? */
	if (size + map[i].size/2 > blocksize/2)
		break;
	size += map[i].size;
	move++;
}

'i' in this case could go down to -1, in which case sum of active entries
wouldn't exceed half the block size, but previous behaviour would also do
split in half if sum would exceed at the very last block, which in case of
having too many long name files in a single block could lead to
out-of-bounds access and following use-after-free.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Fixes: 5872331b3d91 ("ext4: fix potential negative array index in do_split()")
Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250404082804.2567-3-a.sadovnikov@ispras.ru
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1995,7 +1995,7 @@ static struct ext4_dir_entry_2 *do_split
 	 * split it in half by count; each resulting block will have at least
 	 * half the space free.
 	 */
-	if (i > 0)
+	if (i >= 0)
 		split = count - move;
 	else
 		split = count/2;


