Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E874E77F9;
	Thu, 17 Sep 2026 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660554; cv=none; b=JaXZbz4VJcnqjYZ4p81jvjd3ig4I3tKidNVDZl3A25NSVx8hCTGD7WSV+RVEmYtZA3jU9GCDZn8xmxeWG6uiiN7D4YJP2BpjhQlJGV8RVFLXZxc7HsF6dyQ3yXbdD68YmHwcupbwZMTjHOoh/oMp08Q4U0lJ10A0QtPO6lHz2f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660554; c=relaxed/simple;
	bh=4z5mezTW6dXv11ZoTjt3l8VGyrvFCL0a7INEkhldDWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pX+oY2ON/CVK7h+LB5jSE0nuDMVlXe9omA41yUTkWYYmKBFBQ/hLxmty3d/DNM70vDYh28CeNUadEIg0tjAXa1SW8HEYFLY1Kae1M2ofoSK5tCWEzAMnVoU/Dt8JWTqlH0tAXnT9FDeD+RitZiNxN8/XShMRMjcHALxEk4PfplE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeXP6hLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeXP6hLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56101F000FF;
	Thu, 17 Sep 2026 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660552;
	bh=ox5Lf7gKsVef5GICEydezIv7KRye6rhyK5ae6XeVPJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeXP6hLf05MWHTJ+x1KOf/XkjYe6qtLM4AnrQTO7/Wdtnr6DVVz9KWUb+rPIfiKOw
	 SvY/VsaaVjuQML65MlrFZjTV2E6+VeBdjiWQRtDAqgnuPdAcZugSXlNsJptOsVfIux
	 nG/GWSL6nP6cMG9v2WY/ZmpS9ENIbNDO/eWNg47M=
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
Subject: [PATCH 7.2 631/733] smb: client: fix one-byte OOB read in smb2_parse_native_symlink()
Date: Thu, 17 Sep 2026 16:15:39 +0100
Message-ID: <20260917151408.291454996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -971,7 +971,8 @@ globalroot:
 			linux_target[i*3 + 1] = '.';
 			linux_target[i*3 + 2] = sep;
 		}
-		memcpy(linux_target + levels*3, smb_target+1, smb_target_len); /* +1 to skip leading sep */
+		/* +1 to skip leading sep */
+		memcpy(linux_target + levels*3, smb_target+1, smb_target_len-1);
 	} else {
 		/*
 		 * This is either an absolute symlink in POSIX-style format


