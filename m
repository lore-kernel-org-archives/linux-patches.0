Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7012676C0;
	Tue,  8 Apr 2025 11:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110751; cv=none; b=cHilOrk/QXLXjMjPVCc87FGuWb9JPaJDprSXuwPae3hoFn36HJdIj+899CLKUNM4Kw9YjmlKysyMRi64Yn8dh4Meo1bTIgwBQoa0SBPfJ3gGk61swg+FNX2SQR5DxzcrBpNB/3QjTsIjftehGXEyqFSN9a4k81brSogC0Bf5rTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110751; c=relaxed/simple;
	bh=LW2a2HaqRDhkKzW/X+vQ31APcY1n6EWonJuTVpAvG84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXEslrkoAtyFeb1HwNR8vjXVoxLug+oP+mLgi6b3VKPE87b4r4TkBdeK6i6roXrHdg2SEHGbva+0f15jkAAF8lzexzkIY04T51VTJsBA2NOJ7ind9CzZJ53JlamHnkDofyifpu2y0nGwlJeVUGIKwlqHpQ5Mtiq+rdDWL/7A9xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZGaWlRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZGaWlRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4392C4CEE5;
	Tue,  8 Apr 2025 11:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110751;
	bh=LW2a2HaqRDhkKzW/X+vQ31APcY1n6EWonJuTVpAvG84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZGaWlRMvD+ZzZGESvaIKEE9O4cFgOCCTWLWFtFR4hkkfhjp4LrVE5mELYl9KQHhe
	 7dIr7cPWKeLPk0WM/xEtEu3xUFPtZ7q0W42JfJXJh/ukDKI0aRfUbo8QReDO23t5tV
	 PEb6VLT3ESbbSuG/JhG0Pv4hUq6cepBys2tbcZAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 181/731] ext4: correct behavior under errors=remount-ro mode
Date: Tue,  8 Apr 2025 12:41:18 +0200
Message-ID: <20250408104918.488110524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 8f984530c242c569bafecfa35bce969a9b8fb0dd ]

And after commit 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag") in
v6.6-rc1, the EXT4_FLAGS_SHUTDOWN bit is set in ext4_handle_error() under
errors=remount-ro mode. This causes the read to fail even when the error
is triggered in errors=remount-ro mode.

To correct the behavior under errors=remount-ro, EXT4_FLAGS_SHUTDOWN is
replaced by the newly introduced EXT4_FLAGS_EMERGENCY_RO. This new flag
only prevents writes, matching the previous behavior with SB_RDONLY.

Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
Closes: https://lore.kernel.org/all/22d652f6-cb3c-43f5-b2fe-0a4bb6516a04@huawei.com/
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250122114130.229709-6-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a50e5c31b9378..0ff0c3d0a3c08 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -707,11 +707,8 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 	if (test_opt(sb, WARN_ON_ERROR))
 		WARN_ON_ONCE(1);
 
-	if (!continue_fs && !sb_rdonly(sb)) {
-		set_bit(EXT4_FLAGS_SHUTDOWN, &EXT4_SB(sb)->s_ext4_flags);
-		if (journal)
-			jbd2_journal_abort(journal, -EIO);
-	}
+	if (!continue_fs && !ext4_emergency_ro(sb) && journal)
+		jbd2_journal_abort(journal, -EIO);
 
 	if (!bdev_read_only(sb->s_bdev)) {
 		save_error_info(sb, error, ino, block, func, line);
@@ -737,17 +734,17 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 			sb->s_id);
 	}
 
-	if (sb_rdonly(sb) || continue_fs)
+	if (ext4_emergency_ro(sb) || continue_fs)
 		return;
 
 	ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 	/*
-	 * EXT4_FLAGS_SHUTDOWN was set which stops all filesystem
-	 * modifications. We don't set SB_RDONLY because that requires
-	 * sb->s_umount semaphore and setting it without proper remount
-	 * procedure is confusing code such as freeze_super() leading to
-	 * deadlocks and other problems.
+	 * We don't set SB_RDONLY because that requires sb->s_umount
+	 * semaphore and setting it without proper remount procedure is
+	 * confusing code such as freeze_super() leading to deadlocks
+	 * and other problems.
 	 */
+	set_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
 }
 
 static void update_super_work(struct work_struct *work)
-- 
2.39.5



