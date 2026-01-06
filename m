Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE462EFD95;
	Tue,  6 Jan 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721364; cv=none; b=Zp6ps+r+EY3F5s1ZhedZyxOZwzBjicPx3efWTS0kvTasiyVVCqAdS0zJlzb0s4gwf2NyVa5OF3GwhvDBf8HLTMr/78nDZ3GpXedKx7m2IEEsy3kRm/bWWaSd8wAFVuL92tF8K4sZIgUX9Z2gu0G5yRvyaqB2jEch9PAtwh4RF3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721364; c=relaxed/simple;
	bh=JXFdKQraY6aCxwV9jqwiudGKrFeTKaqMhQ1PAIROh2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ylg1iDRFf4VOto1tTSjqqfNPXP6w98rBNidYfr7ux54O9auPYjhuceTb9sjxxzXbIkCs06pCcCpxH69ztsqCn7Fh8lMWz7AdZ+wEu3bcykTYZBzkMf4ARWSJ7Ym7kjT5cUiyO7nFBsQrJdHd4YYaPpsZhOMVO5kL9nRUZMPtgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFArCcqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFArCcqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6C7C116C6;
	Tue,  6 Jan 2026 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721363;
	bh=JXFdKQraY6aCxwV9jqwiudGKrFeTKaqMhQ1PAIROh2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFArCcqTyg5DrDkY9YF9KLEpCID8HUVcn7HvGDUchuwVWwDUbBymGpUwzFh6xoEn+
	 wOC1wnbKiFqIqOSm57KEnlx5VAgjmLBVSL+hJuRYo6dhduUfblzCFQI0sZs8dlUk85
	 hv5NBN7ToLxQxphZwcJjQbMoElPAJqBFpG0MnHvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 514/567] f2fs: dump more information for f2fs_{enable,disable}_checkpoint()
Date: Tue,  6 Jan 2026 18:04:56 +0100
Message-ID: <20260106170510.392108172@linuxfoundation.org>
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

[ Upstream commit 80b6d1d2535a343e43d658777a46f1ebce8f3413 ]

Changes as below:
- print more logs for f2fs_{enable,disable}_checkpoint()
- account and dump time stats for f2fs_enable_checkpoint()

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: be112e7449a6 ("f2fs: fix to propagate error from f2fs_enable_checkpoint()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2278,15 +2278,24 @@ out_unlock:
 restore_flag:
 	sbi->gc_mode = gc_mode;
 	sbi->sb->s_flags = s_flags;	/* Restore SB_RDONLY status */
+	f2fs_info(sbi, "f2fs_disable_checkpoint() finish, err:%d", err);
 	return err;
 }
 
 static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
 	unsigned int nr_pages = get_pages(sbi, F2FS_DIRTY_DATA) / 16;
+	long long start, writeback, end;
+
+	f2fs_info(sbi, "f2fs_enable_checkpoint() starts, meta: %lld, node: %lld, data: %lld",
+					get_pages(sbi, F2FS_DIRTY_META),
+					get_pages(sbi, F2FS_DIRTY_NODES),
+					get_pages(sbi, F2FS_DIRTY_DATA));
 
 	f2fs_update_time(sbi, ENABLE_TIME);
 
+	start = ktime_get();
+
 	/* we should flush all the data to keep data consistency */
 	while (get_pages(sbi, F2FS_DIRTY_DATA)) {
 		writeback_inodes_sb_nr(sbi->sb, nr_pages, WB_REASON_SYNC);
@@ -2295,6 +2304,7 @@ static void f2fs_enable_checkpoint(struc
 		if (f2fs_time_over(sbi, ENABLE_TIME))
 			break;
 	}
+	writeback = ktime_get();
 
 	sync_inodes_sb(sbi->sb);
 
@@ -2313,6 +2323,12 @@ static void f2fs_enable_checkpoint(struc
 
 	/* Let's ensure there's no pending checkpoint anymore */
 	f2fs_flush_ckpt_thread(sbi);
+
+	end = ktime_get();
+
+	f2fs_info(sbi, "f2fs_enable_checkpoint() finishes, writeback:%llu, sync:%llu",
+					ktime_ms_delta(writeback, start),
+					ktime_ms_delta(end, writeback));
 }
 
 static int f2fs_remount(struct super_block *sb, int *flags, char *data)


