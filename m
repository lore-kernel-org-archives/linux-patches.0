Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79A33D3309;
	Thu, 15 Jan 2026 17:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499822; cv=none; b=HAwk9rvgncBsaJTP4kGiqtI2XkOAj4Jc508IhZ4nmHogcyjL8WNn6us1031wiiboyiMs33boFHHXKlEf7QON2CpLl+rhw8QAalUMNKJIJryDCpO5ofpbdACri0GFmK9mM7C7II7R/inb0KcMW+GRQ0tnLpsSyC9Cv5TxPGM0pj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499822; c=relaxed/simple;
	bh=EmV5Ci7qBAt3PgL8rsCiB5qpRaZ98m3P7ww/xp/156A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQDLWQblwuRYBvJamnY8CZ/O6Uga2AnntYo/vxMcNALoW/3tWAA72mcspDYFUU9eZFhVGL3n2Z52fSrMrTAq1ltLd0U2e7i+XEgFqN1XRrzH4kfbzPe9avhkwL3rSk3tbCdaNco2v9hLIbXnbIm4Ur+2jo4rFzPQM+YSbE8KNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XK/WijTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XK/WijTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A63C116D0;
	Thu, 15 Jan 2026 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499822;
	bh=EmV5Ci7qBAt3PgL8rsCiB5qpRaZ98m3P7ww/xp/156A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XK/WijTYnOqhA2UpwI+WJFcRsQ+vVyu+UE+SE+Ah7fUsqoMKZGqi6vGAG+OdTMxNz
	 6XBubuEmhDfeQqpWfSpy22mnVUrgOZWTHjRTTp8OQjFKsiSnDe3Qx1INtigVy19GdB
	 Nz7qikNxNQfVydHaYjmcEFM5xi9Qa7X2FABCXIrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/451] f2fs: fix to propagate error from f2fs_enable_checkpoint()
Date: Thu, 15 Jan 2026 17:49:22 +0100
Message-ID: <20260115164243.964884121@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit be112e7449a6e1b54aa9feac618825d154b3a5c7 ]

In order to let userspace detect such error rather than suffering
silent failure.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ adapted error handling to use restore_gc ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1836,9 +1836,10 @@ restore_flag:
 	return err;
 }
 
-static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
+static int f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
 	int retry = DEFAULT_RETRY_IO_COUNT;
+	int ret;
 
 	/* we should flush all the data to keep data consistency */
 	do {
@@ -1857,7 +1858,11 @@ static void f2fs_enable_checkpoint(struc
 	set_sbi_flag(sbi, SBI_IS_DIRTY);
 	up_write(&sbi->gc_lock);
 
-	f2fs_sync_fs(sbi->sb, 1);
+	ret = f2fs_sync_fs(sbi->sb, 1);
+	if (ret)
+		f2fs_err(sbi, "%s sync_fs failed, ret: %d", __func__, ret);
+
+	return ret;
 }
 
 static int f2fs_remount(struct super_block *sb, int *flags, char *data)
@@ -2005,7 +2010,9 @@ static int f2fs_remount(struct super_blo
 			if (err)
 				goto restore_gc;
 		} else {
-			f2fs_enable_checkpoint(sbi);
+			err = f2fs_enable_checkpoint(sbi);
+			if (err)
+				goto restore_gc;
 		}
 	}
 
@@ -3933,13 +3940,12 @@ reset_checkpoint:
 	/* f2fs_recover_fsync_data() cleared this already */
 	clear_sbi_flag(sbi, SBI_POR_DOING);
 
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


