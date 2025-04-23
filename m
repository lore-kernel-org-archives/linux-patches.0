Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4919F28152D;
	Wed, 23 Apr 2025 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421158; cv=none; b=BpFi5EadGvSbTJsPrmGrPAkTdR2q2Z74Civ2lmXd72YZfw+5ce4rVvgpniVxLuHYEfXiGSOXsKL2nLbYLn3WYbMm+QlfJqTTJtw1MG57bWbV5AXx8tr3pBjlVd0a8oz1hDNcbW6OwGjzE4otQW9ahCoJTqNuo6I+rg5md7lnW4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421158; c=relaxed/simple;
	bh=6MHOHScinRARKFVntfatXqsHC172GgZwMVINWbYE1RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhmZa2HhoFPN2Iq33j85v/cAN4lZ7mxIOacSbepmvTdYh8IuR2eK7NlGHN2k2oEpE5SGMOlFPSvRc8TND5GImriMA507yQ2p4Fnu3r1DnrqVtY3MXrne09PC3gP2/7gz5X22TiSDT5UOSaKjDnmv0z+j5j9PWlUsMFfHVwuj+o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+Ihi0Xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+Ihi0Xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3BBC4CEE2;
	Wed, 23 Apr 2025 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421157;
	bh=6MHOHScinRARKFVntfatXqsHC172GgZwMVINWbYE1RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+Ihi0XyFc1vddo6142iRxmplLNN+LYI71Fd5jRLTNwWvzi6DjT8dQikTh/jAbvE/
	 ntoiMjuuLR20ar9eIcD5wIe6zXDU3huKFXGOqmU42tlAdaex+n4xWjKDub08MCs1kp
	 stM3fOm5OnOOcvNn64f/3BTAvJJYcQGYz8X5rkl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 113/291] ext4: fix off-by-one error in do_split
Date: Wed, 23 Apr 2025 16:41:42 +0200
Message-ID: <20250423142628.992168468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2041,7 +2041,7 @@ static struct ext4_dir_entry_2 *do_split
 	 * split it in half by count; each resulting block will have at least
 	 * half the space free.
 	 */
-	if (i > 0)
+	if (i >= 0)
 		split = count - move;
 	else
 		split = count/2;


