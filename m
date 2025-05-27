Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F051DB34C;
	Tue, 27 May 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364775; cv=none; b=X2gqABvt+dP8fiDOCowlR4Qk4YizgyhygGaaMbF0EVPdNFH0oDX3t6Pkg5swffbPRVLMrzXTCU2+eQVkZ6vrTq0WO8kQkxONwSiHYVt/KuysG0r5hjZk9yBlam7D1OU+WyFVcDVZriwZlWzqN94uoFsgq1Ayj/vYP7UrjHehkQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364775; c=relaxed/simple;
	bh=wRs0eb7KIZyE8JEPg4N8M+e5Bdzf0JzhYWEXecix5ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLl/UqP8C/EDm/qKLBHwDonT+K6s3I1j0LgTAiH09vekfZDgUtXI/daaC79rCZzVLZ2LXMmtP4Z69GHpt5G1Xz5969DFA4KuQVS2PuHSJ9pw2OfYZzTkJ5OHtQ3HS/Q2drU3738aXToefsqzX+ZWnwYIZXSs98RGCwLRRTtfhHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlUArTv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlUArTv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB27EC4CEE9;
	Tue, 27 May 2025 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364775;
	bh=wRs0eb7KIZyE8JEPg4N8M+e5Bdzf0JzhYWEXecix5ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlUArTv3T56SRXvzupJX+sT4g8BSV4YkfxFqIw47BYe/FKfMfjutz1uxVLwh6tQu6
	 thdzrR1U05+7KDCzHTsDGFp4BfeuhRRhi5LYprtcp8xdBgslJHd0NHRUKYceGQ0GL3
	 FMxv2ZXZxdDb4J7hpX2+1w3G3/r2x9FDHCGWQfc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/626] ext4: reject the data_err=abort option in nojournal mode
Date: Tue, 27 May 2025 18:20:56 +0200
Message-ID: <20250527162451.649488258@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 26343ca0df715097065b02a6cddb4a029d5b9327 ]

data_err=abort aborts the journal on I/O errors. However, this option is
meaningless if journal is disabled, so it is rejected in nojournal mode
to reduce unnecessary checks. Also, this option is ignored upon remount.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250122110533.4116662-4-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 473909c4a3784..99117d1e1bdd5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2787,6 +2787,13 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
 	}
 
 	if (is_remount) {
+		if (!sbi->s_journal &&
+		    ctx_test_mount_opt(ctx, EXT4_MOUNT_DATA_ERR_ABORT)) {
+			ext4_msg(NULL, KERN_WARNING,
+				 "Remounting fs w/o journal so ignoring data_err option");
+			ctx_clear_mount_opt(ctx, EXT4_MOUNT_DATA_ERR_ABORT);
+		}
+
 		if (ctx_test_mount_opt(ctx, EXT4_MOUNT_DAX_ALWAYS) &&
 		    (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)) {
 			ext4_msg(NULL, KERN_ERR, "can't mount with "
@@ -5396,6 +5403,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 				 "data=, fs mounted w/o journal");
 			goto failed_mount3a;
 		}
+		if (test_opt(sb, DATA_ERR_ABORT)) {
+			ext4_msg(sb, KERN_ERR,
+				 "can't mount with data_err=abort, fs mounted w/o journal");
+			goto failed_mount3a;
+		}
 		sbi->s_def_mount_opt &= ~EXT4_MOUNT_JOURNAL_CHECKSUM;
 		clear_opt(sb, JOURNAL_CHECKSUM);
 		clear_opt(sb, DATA_FLAGS);
-- 
2.39.5



