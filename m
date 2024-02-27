Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268413EFE4;
	Tue, 27 Feb 2024 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043146; cv=none; b=FuoF8fXXPB0iuq+W8Ep49F2PaQNZdJQm8Tf9nKQ7wK1LbEBbXGF6Tj3FrY/3Fytnf0PI61L7i2rQyIuuX8ZlVX2x6LgM+Vctp2fxjp9ws5Ebvp7HZGX23nSULzNvh8vz+b/gnedVTh5+MVOFQX/9n1HGCTg2yAfzLbiLwkzZ8Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043146; c=relaxed/simple;
	bh=WDXfQrS5jfCQwWmjyaN8yOf28Z3EidPI/6R/TDWbt+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA5pSMZiMBVGZJwaXSr6yz6kBb+2ri0AjiQASC8MnU5TCs29QTsOqe9boPJQDqeUREdYrkJJW9xlZtMBpNMXFFM7Z3QAPhQ3GdBRfVWNpzAyNszHxQ1kaft0t1Ukc3hBSyyko4P1JDgtkHDcVAzeKXJy/ZPoEhbYHZ1Q0Oud5bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fR+qDAlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fR+qDAlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0871C433C7;
	Tue, 27 Feb 2024 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043146;
	bh=WDXfQrS5jfCQwWmjyaN8yOf28Z3EidPI/6R/TDWbt+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fR+qDAltpLwa5vYWCFqVTSACqjyOWoBRsooaQPGVu0yWg/5mDJwFRPE7MtMK+yPoP
	 d+Hmn8pnkwXQL05OOrSMNCacri1Gu7XJ67WDLHZyJev/zJ85gN7PduPxcNi87FxqDk
	 o+PUv309jWUqOMNw3QyWXBl93xGvJHUFJhjaJiV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 243/245] ext4: regenerate buddy after block freeing failed if under fc replay
Date: Tue, 27 Feb 2024 14:27:11 +0100
Message-ID: <20240227131623.053867690@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1168,6 +1168,24 @@ void ext4_mb_generate_buddy(struct super
 	mb_update_avg_fragment_size(sb, grp);
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
@@ -1846,6 +1864,8 @@ static void mb_free_blocks(struct inode
 			ext4_mark_group_bitmap_corrupted(
 				sb, e4b->bd_group,
 				EXT4_GROUP_INFO_BBITMAP_CORRUPT);
+		} else {
+			mb_regenerate_buddy(e4b);
 		}
 		goto done;
 	}


