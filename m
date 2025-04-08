Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB507265CAF;
	Tue,  8 Apr 2025 11:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110781; cv=none; b=pxn8O9szS/Pk35CKwxoxF4S/jlur2/S//dJoJdY87Hj7iAxTHH9/Y9JfGzkvsKODHlU1jlB6ajI0w/K64ddBZWeaIU0+yaPUsTilkMkt0UjO3PXgQEoQtNX0ypWI9CfgdQylI3T5055Sc0qSJ8wopuUp7IKwo2CfKbm47jhUzCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110781; c=relaxed/simple;
	bh=j4KxWrBWAlRi7dBxa7EW0doFiXC/x3NjQDF7ndIa9DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1oL/w8lYUROo+0JX7FvC9j8nTN1/F1nKtUKgebaNAEFztb70FYpkt3Ax5C1Y2+c4bKptbJxXCn4dbt4kEs0mn8otVYrJ8QRgL/xQhmoEMEIsx62jIYOXL0mv0v/ZDdJTBEmrfZ3pV6FxRpidtimmcXYhIMmPS3aS22/BfPqL8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnKsb+yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnKsb+yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19530C4CEE7;
	Tue,  8 Apr 2025 11:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110780;
	bh=j4KxWrBWAlRi7dBxa7EW0doFiXC/x3NjQDF7ndIa9DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnKsb+ycydJBL/74Yio/zJLvW6DRDk2qZs3sFN+vhsOjfQJ3N/nd6RsRnZruaXt1p
	 wleKdW9olHIBoLUwMXQ1fRymLG7gkdURkNZgiLQLXKze6iiB7GeUzv4jaqAdU3jqZj
	 NVYVVsUaS2deEZVHmgcqFbucILYNdNaj+ySHQ13Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 191/731] ext4: add missing brelse() for bh2 in ext4_dx_add_entry()
Date: Tue,  8 Apr 2025 12:41:28 +0200
Message-ID: <20250408104918.723509838@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit eb640af64db6d4702a85ab001b9cc7f4c5dd6abb ]

Add missing brelse() for bh2 in ext4_dx_add_entry().

Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250123162050.2114499-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 536d56d150726..8e49cb7118581 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2577,8 +2577,10 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, sb, frame->bh,
 						    EXT4_JTR_NONE);
-		if (err)
+		if (err) {
+			brelse(bh2);
 			goto journal_error;
+		}
 		if (!add_level) {
 			unsigned icount1 = icount/2, icount2 = icount - icount1;
 			unsigned hash2 = dx_get_hash(entries + icount1);
@@ -2589,8 +2591,10 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			err = ext4_journal_get_write_access(handle, sb,
 							    (frame - 1)->bh,
 							    EXT4_JTR_NONE);
-			if (err)
+			if (err) {
+				brelse(bh2);
 				goto journal_error;
+			}
 
 			memcpy((char *) entries2, (char *) (entries + icount1),
 			       icount2 * sizeof(struct dx_entry));
@@ -2609,8 +2613,10 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
 			err = ext4_handle_dirty_dx_node(handle, dir, bh2);
-			if (err)
+			if (err) {
+				brelse(bh2);
 				goto journal_error;
+			}
 			brelse (bh2);
 			err = ext4_handle_dirty_dx_node(handle, dir,
 						   (frame - 1)->bh);
@@ -2635,8 +2641,10 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 				       "Creating %d level index...\n",
 				       dxroot->info.indirect_levels));
 			err = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
-			if (err)
+			if (err) {
+				brelse(bh2);
 				goto journal_error;
+			}
 			err = ext4_handle_dirty_dx_node(handle, dir, bh2);
 			brelse(bh2);
 			restart = 1;
-- 
2.39.5



