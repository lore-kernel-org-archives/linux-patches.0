Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB02839EF1F;
	Sat, 12 Sep 2026 18:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238515; cv=none; b=s348aFsCwrdzi30UBCezh35EM6ryUiKY3ys31QtCykVAA4Lz9lJMFcw8H8EqIc1PmqK8boFRgyTcWu8C5Ta7RMvQc5Gmyuaxr9u5IM+HHL3PrGpFC8rBdd+gX8HLIiYme4Imz9mXscFUdzXsyTVMITM8cYC68p5JQ20C93wacEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238515; c=relaxed/simple;
	bh=iixoTwLN/PfEK9rDKom2+pxCg+0+q66kEobI8P1oQhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyReBYMLeRp2JwIyKfv2La/vZyXpgnwp0tJW2IYl86w9Jes/4hmBgigJSI9+/OqLRtHxpRuJIQ8mv+NIIoiVdeXNdqrmA5V3zjn1wMBh66v7bd357UzQpoJS1ZhfLWLN3OL9em2D5ySWSljkcikHHICnhvLDeUrhqHrTabBYk1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4B2vHpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4B2vHpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E8B1F000FF;
	Sat, 12 Sep 2026 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238513;
	bh=T+8Et5a79Qv88Aggg6HiuiPxMaUYZF9M5DPia4am7rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4B2vHpbtorF4TFNabaXyDyVvh4K6hOKItzllqZoYl3FCbQ2S3zrW9+Kedn6iMIqI
	 8X+R7c0hGqSIsDtbNyVKCNOYs0AO/63aba6mtaaP2b3jYW1eHYeQP6pegyVC9Xxof7
	 E5QacRBB03efXkjIZ9SmSzKLOn9QdOwkFzbORPpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0306b38d9ed6ef71467d@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/935] udf: Mark LVID buffer as uptodate before marking it dirty
Date: Sat, 12 Sep 2026 08:58:26 +0200
Message-ID: <20260912065537.743495882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c6ce8c1344bd..afdc0f50a5f00 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2059,6 +2059,17 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
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
@@ -2094,7 +2105,7 @@ static void udf_open_lvid(struct super_block *sb)
 		UDF_SET_FLAG(sb, UDF_FLAG_INCONSISTENT);
 
 	udf_finalize_lvid(lvid);
-	mark_buffer_dirty(bh);
+	udf_mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	/* Make opening of filesystem visible on the media immediately */
@@ -2127,14 +2138,8 @@ static void udf_close_lvid(struct super_block *sb)
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
@@ -2427,7 +2432,7 @@ static int udf_sync_fs(struct super_block *sb, int wait)
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



