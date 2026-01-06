Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1372F9C3D;
	Tue,  6 Jan 2026 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721367; cv=none; b=QWe4b2rj8Wp3AZiiwjLhVUvMcHvHV0VI1JDP6BzLZaIhSb4RNYiUUmSf8xSCKllhpzZfPQZ5wgs8iFS21CJ1vfUKgcR58/NaNd+iiayXmguMocsMhEge3rr2aYSuZTBuaVukZI0pw99eX46NTKRcowniom7RV4zpKbi5gLq9nJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721367; c=relaxed/simple;
	bh=Si9HarTsBQilaJS9ihAFh2QifWIzCywOcJXDn7nznhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLBASfAmRYjYoX8A+vD+4H1tp9iwGGYZlD9bUsNdvu3T5cnLHtekJNuVyywJ0HUe/OIF/2WP52jaZAkKgZVlp4iESLjY+MGMaMhR7XHobdP1VIiDnWwePMfM3mhVLA2n1iEqAgVmUTBrSLfjs0nTDOxYRiUwQku/AZEZ9Mqp5Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=135aoue3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="135aoue3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98D6C116C6;
	Tue,  6 Jan 2026 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721367;
	bh=Si9HarTsBQilaJS9ihAFh2QifWIzCywOcJXDn7nznhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=135aoue3hxsYsPeXiT+3mWzu8cIVHd9jyNm0LOdbaIJOSr2ruC0ysSZcw3KpAjGmG
	 XpZffqUL02xKcfWYpA+4qmmCfTswEZyGui9Nq4BtBs131uq1TommHLzt3MzWS6wdfg
	 iOcmXIZKtSgDA6pA7E7Y4P1UF7d+TOi/9kb1p1xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 515/567] f2fs: fix to propagate error from f2fs_enable_checkpoint()
Date: Tue,  6 Jan 2026 18:04:57 +0100
Message-ID: <20260106170510.429170220@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit be112e7449a6e1b54aa9feac618825d154b3a5c7 ]

In order to let userspace detect such error rather than suffering
silent failure.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2282,10 +2282,11 @@ restore_flag:
 	return err;
 }
 
-static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
+static int f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
 	unsigned int nr_pages = get_pages(sbi, F2FS_DIRTY_DATA) / 16;
 	long long start, writeback, end;
+	int ret;
 
 	f2fs_info(sbi, "f2fs_enable_checkpoint() starts, meta: %lld, node: %lld, data: %lld",
 					get_pages(sbi, F2FS_DIRTY_META),
@@ -2319,7 +2320,9 @@ static void f2fs_enable_checkpoint(struc
 	set_sbi_flag(sbi, SBI_IS_DIRTY);
 	f2fs_up_write(&sbi->gc_lock);
 
-	f2fs_sync_fs(sbi->sb, 1);
+	ret = f2fs_sync_fs(sbi->sb, 1);
+	if (ret)
+		f2fs_err(sbi, "%s sync_fs failed, ret: %d", __func__, ret);
 
 	/* Let's ensure there's no pending checkpoint anymore */
 	f2fs_flush_ckpt_thread(sbi);
@@ -2329,6 +2332,7 @@ static void f2fs_enable_checkpoint(struc
 	f2fs_info(sbi, "f2fs_enable_checkpoint() finishes, writeback:%llu, sync:%llu",
 					ktime_ms_delta(writeback, start),
 					ktime_ms_delta(end, writeback));
+	return ret;
 }
 
 static int f2fs_remount(struct super_block *sb, int *flags, char *data)
@@ -2543,7 +2547,9 @@ static int f2fs_remount(struct super_blo
 				goto restore_discard;
 			need_enable_checkpoint = true;
 		} else {
-			f2fs_enable_checkpoint(sbi);
+			err = f2fs_enable_checkpoint(sbi);
+			if (err)
+				goto restore_discard;
 			need_disable_checkpoint = true;
 		}
 	}
@@ -2585,7 +2591,8 @@ skip:
 	return 0;
 restore_checkpoint:
 	if (need_enable_checkpoint) {
-		f2fs_enable_checkpoint(sbi);
+		if (f2fs_enable_checkpoint(sbi))
+			f2fs_warn(sbi, "checkpoint has not been enabled");
 	} else if (need_disable_checkpoint) {
 		if (f2fs_disable_checkpoint(sbi))
 			f2fs_warn(sbi, "checkpoint has not been disabled");
@@ -4836,13 +4843,12 @@ reset_checkpoint:
 	if (err)
 		goto sync_free_meta;
 
-	if (test_opt(sbi, DISABLE_CHECKPOINT)) {
+	if (test_opt(sbi, DISABLE_CHECKPOINT))
 		err = f2fs_disable_checkpoint(sbi);
-		if (err)
-			goto sync_free_meta;
-	} else if (is_set_ckpt_flags(sbi, CP_DISABLED_FLAG)) {
-		f2fs_enable_checkpoint(sbi);
-	}
+	else if (is_set_ckpt_flags(sbi, CP_DISABLED_FLAG))
+		err = f2fs_enable_checkpoint(sbi);
+	if (err)
+		goto sync_free_meta;
 
 	/*
 	 * If filesystem is not mounted as read-only then


