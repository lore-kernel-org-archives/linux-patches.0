Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A922FE19;
	Mon,  2 Jun 2025 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873355; cv=none; b=EO+0EwerkoyE9E57s05euA4Ty1EvvtsSAaHAMXnqQZll8G3UhqnMqpdjYRk8XtmZaE/ejcqoHPBJlhcC/k7Yj6himXpYsSXnK3FOL/q4IweHQMLoDIVJjCjEq/0kY2vnpjgV8yCHL03prKIH//nd3Iw8DocnR/XiAuNlZuI1eso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873355; c=relaxed/simple;
	bh=x1pFILoOoh9WhUwZTO8g/Ml1dls8aS5Hv3MSSENAllU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/LhMkaSQwh9r8AVgWhuX+wbegoavbVHVd80HwD39hrUssJcZ68jlZwaVDZOwjINxI66+vpSxkD9mhhKLf/nc40fSbUy/to6sdiSiNZvxA/vkDCfagbLpDU88G+13as7ykshh0YJzttkuAbtwIWg68XazCUNwkNv+kQ2YRKmXQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouStv+oY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouStv+oY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B886C4CEF7;
	Mon,  2 Jun 2025 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873355;
	bh=x1pFILoOoh9WhUwZTO8g/Ml1dls8aS5Hv3MSSENAllU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouStv+oYXg/FE4inRslUh1njhwdPwBkZdnFD0g3AZ+s3U72NdptfQi9gwLl9KDtLs
	 2zLxCWimnZAsEqm2ZFCUSVszjD/IN+Cu1hCKF6s5nYpW8X9y2V8UpCgrzv/NNW6QLE
	 gHLDfnqcPPrNutj+7QVk7Bb5oQWA831i7hza18Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/444] ext4: reject the data_err=abort option in nojournal mode
Date: Mon,  2 Jun 2025 15:42:52 +0200
Message-ID: <20250602134345.281532758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3dcaf06ada364..d2b58f940aab5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2821,6 +2821,13 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
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
@@ -5421,6 +5428,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
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



