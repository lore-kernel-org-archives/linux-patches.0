Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E4030DEA3;
	Sat, 12 Sep 2026 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222926; cv=none; b=Bn2eigYpjzNig8qEJycLu2HYRcZJrr+5y8PDIH6Vs9aFpeD2AIIiFCxaa9pGSH/zmzQgFdIhTVk5nXJh9NEcsOk43FbzcnfbP+uE+Q10mhdNUwmZGl7lII1zwpRpSHEVFLi/eYUAVlOAcPeDFsUtnOkdEpZYVzV1RP6jmE+18Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222926; c=relaxed/simple;
	bh=h90u4hSJs/6ifGqwJdDM/J37vHk68rax31oshMRgMc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJAtXKEAedbeLGncKuYyccstO6ZSsVyWs+NCnw/pcUlsLspd1nzRP2X3JZ4gjrVBBftLR/k07cTjBiiQafMSgdCWl4p+AFADMJJQRpS/fPmYG55sUVbmJxtm928Kh3txlti8BoCvQwiwlbHXlgSA0Y2rhUiaTLp/ebNedbwYPG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/DK+Ij7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/DK+Ij7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176D01F000FF;
	Sat, 12 Sep 2026 14:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222925;
	bh=tE9jUmAHi2u+ugLzSuPbNI7A9HKwbjCwJSXemOzwiO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/DK+Ij79dqMYBwCkhOct4SkypunrcxHi11qMFo1oyXNjU+deH0K5LMPTiW/5nBuJ
	 rLpPMf5pcIqfWeTrH8Jz2GwvRsZMKZ6JeyI30nsBiLfb8u40alYiBjiphNG+tb15Kt
	 4R+2Cu8tzhi0wKNIREfDiM326rsoNz/4rIpqkoRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0306b38d9ed6ef71467d@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0686/1424] udf: Mark LVID buffer as uptodate before marking it dirty
Date: Sat, 12 Sep 2026 08:51:58 +0200
Message-ID: <20260912065622.664755132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit fb0601134c7e51728bd098abc6909315de1e5d86 ]

When an I/O error occurs while writing the Logical Volume Integrity
Descriptor (LVID) buffer to the block device, the block layer's completion
handler (`end_buffer_write_sync()`) clears the `BH_Uptodate` flag on the
buffer. However, the buffer still contains valid LVID data in memory. If
the filesystem is subsequently remounted read-write or synced,
`udf_open_lvid()` or `udf_sync_fs()` will modify the LVID buffer and call
`mark_buffer_dirty()`. This triggers a spurious
`WARN_ON_ONCE(!buffer_uptodate(bh))` warning in `mark_buffer_dirty()`
because the buffer is not marked uptodate, even though its in-memory
contents are valid and are about to be overwritten.

To prevent this spurious warning, unconditionally set the `BH_Uptodate`
flag before calling `mark_buffer_dirty()` in `udf_open_lvid()` and
`udf_sync_fs()`. This acknowledges that the in-memory buffer is valid and
matches the workaround previously applied to `udf_close_lvid()` in commit
853a0c25baf9 ("udf: Mark LVID buffer as uptodate before marking it dirty").
Extending this workaround ensures consistent behavior across all LVID
updates.

Buffer I/O error on dev loop0, logical block 128, lost sync page write
------------[ cut here ]------------
!buffer_uptodate(bh)
WARNING: fs/buffer.c:1087 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:1087
...
Call Trace:
 <TASK>
 udf_open_lvid+0x369/0x5b0 fs/udf/super.c:2078
 udf_reconfigure+0x336/0x540 fs/udf/super.c:679
 reconfigure_super+0x232/0x8f0 fs/super.c:1080
 vfs_cmd_reconfigure fs/fsopen.c:268 [inline]
 vfs_fsconfig_locked+0x171/0x320 fs/fsopen.c:297
 __do_sys_fsconfig fs/fsopen.c:463 [inline]
 __se_sys_fsconfig+0x6b9/0x810 fs/fsopen.c:350
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 </TASK>

Fixes: 853a0c25baf9 ("udf: Mark LVID buffer as uptodate before marking it dirty")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+0306b38d9ed6ef71467d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0306b38d9ed6ef71467d
Link: https://syzkaller.appspot.com/ai_job?id=05f8e20f-f080-4c7f-a206-08dbc15cb4a1
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Link: https://patch.msgid.link/6ffb2ca8-e22f-4fd6-9f37-7202ec0878bd@mail.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 1debc30203b33..82a165c4dce3b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2011,6 +2011,17 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 	return 0;
 }
 
+static void udf_mark_buffer_dirty(struct buffer_head *bh)
+{
+	/*
+	 * We set buffer uptodate unconditionally here to avoid spurious
+	 * warnings from mark_buffer_dirty() when previous EIO has marked
+	 * the buffer as !uptodate
+	 */
+	set_buffer_uptodate(bh);
+	mark_buffer_dirty(bh);
+}
+
 static void udf_finalize_lvid(struct logicalVolIntegrityDesc *lvid)
 {
 	struct timespec64 ts;
@@ -2046,7 +2057,7 @@ static void udf_open_lvid(struct super_block *sb)
 		UDF_SET_FLAG(sb, UDF_FLAG_INCONSISTENT);
 
 	udf_finalize_lvid(lvid);
-	mark_buffer_dirty(bh);
+	udf_mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	/* Make opening of filesystem visible on the media immediately */
@@ -2079,14 +2090,8 @@ static void udf_close_lvid(struct super_block *sb)
 	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_INCONSISTENT))
 		lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
-	/*
-	 * We set buffer uptodate unconditionally here to avoid spurious
-	 * warnings from mark_buffer_dirty() when previous EIO has marked
-	 * the buffer as !uptodate
-	 */
-	set_buffer_uptodate(bh);
 	udf_finalize_lvid(lvid);
-	mark_buffer_dirty(bh);
+	udf_mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	/* Make closing of filesystem visible on the media immediately */
@@ -2379,7 +2384,7 @@ static int udf_sync_fs(struct super_block *sb, int wait)
 		 * Blockdevice will be synced later so we don't have to submit
 		 * the buffer for IO
 		 */
-		mark_buffer_dirty(bh);
+		udf_mark_buffer_dirty(bh);
 		sbi->s_lvid_dirty = 0;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
-- 
2.53.0



