Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CE43C5DA1;
	Wed, 30 Sep 2026 19:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795863; cv=none; b=lifVIv0JznkL90D/pp2wk1DoJIU3QipNLGXPeKSTtquzw7F/5zm/VrgkKX3gvD6/XZ9dTS+suRoBFL/6eSvSOdNhJUWr0jkbwI7rZuyARSqpEWThhAvx7wVQeQqoKyDIi7xBJdpJL68ylU0+0UxePfrScoSAb/EqkF7wWHrmfgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795863; c=relaxed/simple;
	bh=SxWwCGYUc6rVjuxHpZkOdamlelus6d7GdENtr+9H19E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8yOHeijUFwRj7gYbuGZ/sDfbaH2/rw12hgTKzU/1l0FclkP9X3kO9nAMRGE1zXd+yKrjnllU+eotw7VeXH4qZTJ3yySGcLe9NyrcsI8jjmdoRFu77xMeR5Gq/8/K7Il8le0fzx984lsODd4YpaPFgvhhn9ALgOAWbE8eHFGptk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSWDvU4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSWDvU4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9571F000FF;
	Wed, 30 Sep 2026 19:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795861;
	bh=xi7ss8o4nBlIVmG1nFLAiCYPPCHFv1mc70myQqKCKiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSWDvU4XJpsf5YU7ezf9v1679Dc2VI8xo1624hNesTjTJUvwmTMSb8tbMTP9dMgHZ
	 TMhcTV72OrigDqtvZZR+Hryf1ik+ir9iXka5KYF0duW2MK9uaNKVxNmi7SAM1Z8dxN
	 PmiJxzfjGH7NoWe/IMgG9hma+1B8UrbyBRTQciik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Pali Rohar <pali@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.6 0665/1193] smb: client: fix one-byte OOB read in smb2_parse_native_symlink()
Date: Wed, 30 Sep 2026 17:22:29 +0200
Message-ID: <20260930152449.012620861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit cb26524ef4ac28fcfa554c0656e8dc412c38a8ff upstream.

When parsing a share-root relative native symlink, memcpy copies
smb_target+1 (skipping the leading separator) but uses
strlen(smb_target)+1 as the length, reading one byte past the
allocated buffer.

This fixes the following KASAN splat when accessing an SMB symlink
with a target of '\a\b':

  BUG: KASAN: slab-out-of-bounds in smb2_parse_native_symlink+0x4f5/0xca0
  Read of size 5 at addr ffff88800878fe21 by task netfsfuzz-execu/1
  CPU: 1 UID: 0 PID: 1 Comm: netfsfuzz-execu Tainted: G N
  7.2.0-11943-g2709dd5ae32f-dirty #1 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
  1996)
  Call Trace:
   <TASK>
   dump_stack_lvl+0x7b/0xa0
   print_report+0xd0/0x630
   kasan_report+0xe5/0x120
   kasan_check_range+0x105/0x1b0
   __asan_memcpy+0x23/0x60
   smb2_parse_native_symlink+0x4f5/0xca0
   parse_reparse_point+0x68a/0x1530
   reparse_info_to_fattr+0x752/0xa20
   cifs_get_fattr+0x873/0x15b0
   cifs_get_inode_info+0xc0/0x310
   cifs_lookup+0x308/0xa70
   __lookup_slow+0x122/0x2b0
   lookup_slow+0x50/0x70
   path_lookupat+0x525/0xaf0
   filename_lookup+0x1f2/0x550
   vfs_statx+0xd1/0x1a0
   vfs_fstatat+0x65/0xc0
   __do_sys_newfstatat+0x9a/0x120
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Fixes: 723f4ef90452 ("cifs: Fix parsing native symlinks relative to the export")
Suggested-by: Pali Rohar <pali@kernel.org>
Reviewed-by: Pali Rohar <pali@kernel.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -580,7 +580,8 @@ int smb2_parse_native_symlink(char **tar
 			linux_target[i*3 + 1] = '.';
 			linux_target[i*3 + 2] = sep;
 		}
-		memcpy(linux_target + levels*3, smb_target+1, smb_target_len); /* +1 to skip leading sep */
+		/* +1 to skip leading sep */
+		memcpy(linux_target + levels*3, smb_target+1, smb_target_len-1);
 	} else {
 		linux_target = smb_target;
 		smb_target = NULL;


