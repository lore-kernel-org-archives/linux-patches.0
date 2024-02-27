Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7AC54BFE;
	Tue, 27 Feb 2024 14:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044267; cv=none; b=OAJA6DcvKFQnsSY2qxEbFH+CnaV9oK1nDdRsW6/3dD2nw6iET/t4AXXcfZC5cjvpfgJVEgzz8cw42Bd8KDXpX136h1bKtCuXxDpXDeFx5R9Zodq3pYyUkGtsLyCf5PQx0BpwvtKzcUW2ZrYpid+YJKkzyXs+CJtK6/yZoaJRjBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044267; c=relaxed/simple;
	bh=VC4FH3+AUmDp3YCXUK0PT5dkmEz4IMhHYeIzFaS/EqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K15V6IHdqAAer9Xp0ibligGRlp8IbDBZnQhridbBjb88srjn8sO51JuVKXNaGnUzHN78mKy1hsUBBuOk+nduKLCZEqsc91cRaRjyoghPluWmVYPaPXI6acNWqO8Omno29nwzHx6mZrRGeHIUxywwGLOFNLEDd0DRuPDfkpHjTVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+G2oMEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+G2oMEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5408C433C7;
	Tue, 27 Feb 2024 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044267;
	bh=VC4FH3+AUmDp3YCXUK0PT5dkmEz4IMhHYeIzFaS/EqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+G2oMECTareVErcyaWduUu6CsBaq7+vuZZmLUe/hrrDEjcV7tGlllrAKktYdfQI1
	 X5HBMQk7Q7IOc2GIDnUgp50F9DPzxy0DMulWuXWq6w9duqRbyfBHtdebeXvgnESPnX
	 jw66lAL/pt9pvpJdsafU2a33vdhCy+n5iGeZHkxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 122/122] ext4: regenerate buddy after block freeing failed if under fc replay
Date: Tue, 27 Feb 2024 14:28:03 +0100
Message-ID: <20240227131602.695436866@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Baokun Li <libaokun1@huawei.com>

commit c9b528c35795b711331ed36dc3dbee90d5812d4e upstream.

This mostly reverts commit 6bd97bf273bd ("ext4: remove redundant
mb_regenerate_buddy()") and reintroduces mb_regenerate_buddy(). Based on
code in mb_free_blocks(), fast commit replay can end up marking as free
blocks that are already marked as such. This causes corruption of the
buddy bitmap so we need to regenerate it in that case.

Reported-by: Jan Kara <jack@suse.cz>
Fixes: 6bd97bf273bd ("ext4: remove redundant mb_regenerate_buddy()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -823,6 +823,24 @@ void ext4_mb_generate_buddy(struct super
 	atomic64_add(period, &sbi->s_mb_generation_time);
 }
 
+static void mb_regenerate_buddy(struct ext4_buddy *e4b)
+{
+	int count;
+	int order = 1;
+	void *buddy;
+
+	while ((buddy = mb_find_buddy(e4b, order++, &count)))
+		ext4_set_bits(buddy, 0, count);
+
+	e4b->bd_info->bb_fragments = 0;
+	memset(e4b->bd_info->bb_counters, 0,
+		sizeof(*e4b->bd_info->bb_counters) *
+		(e4b->bd_sb->s_blocksize_bits + 2));
+
+	ext4_mb_generate_buddy(e4b->bd_sb, e4b->bd_buddy,
+		e4b->bd_bitmap, e4b->bd_group, e4b->bd_info);
+}
+
 /* The buddy information is attached the buddy cache inode
  * for convenience. The information regarding each group
  * is loaded via ext4_mb_load_buddy. The information involve
@@ -1505,6 +1523,8 @@ static void mb_free_blocks(struct inode
 			ext4_mark_group_bitmap_corrupted(
 				sb, e4b->bd_group,
 				EXT4_GROUP_INFO_BBITMAP_CORRUPT);
+		} else {
+			mb_regenerate_buddy(e4b);
 		}
 		goto done;
 	}


