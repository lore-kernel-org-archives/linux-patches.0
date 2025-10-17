Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3258732C92F;
	Fri, 17 Oct 2025 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715818; cv=none; b=SaTbgJaKk3/K583uGKQ1zvTQ2DRuDx/WpE+hWIdSjcFe8rAP9THCo0uddqfJ7FU9C5R41yAwF+YNnjJWWtauD1o8nEVpCT0JfelJRBiSAh4bt/9bBTEr+pCzR18jUdB+H/8O2f3dZnSHGJ4kr81q9obZsJKhtiEupYUjborsUIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715818; c=relaxed/simple;
	bh=3K6CGR82Lo/7/KfmD7Tc0Lz8YsmUaaqkEVgJLDB66iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKAxh5qSXyfgFmH9cYaKHpMxm+cL2stXxo+OF/q57l2eAPBIlND+JMhAWZnv2WW0G3tvx5vuaD4U5SB/cjP5TTA9XNW4dLDyK2nYvBLMGU9qjtPcKyhb0k4ZzZ6SrxhO4bsYMEHXyP26IeM7cXFM1+nG72BUWPEpr8yffYm3NB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+oHsthK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+oHsthK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DA0C4CEE7;
	Fri, 17 Oct 2025 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715817;
	bh=3K6CGR82Lo/7/KfmD7Tc0Lz8YsmUaaqkEVgJLDB66iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+oHsthKG0//RE0BIF6XUqbY2ZkNpPOvOaq6hLSeaBUw/VTsvukaNWlrIeODDo75Q
	 S1BH7M5oNfjaUhuBQ5+1sVi571LLsYaJOk+B4t3XhvToU95q7fmLaX0OieoVNYdLB2
	 S3J9HCo0jLBM3JNbTDXH9nT+hP3g51X94VHeCrrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.17 340/371] ext4: verify orphan file size is not too big
Date: Fri, 17 Oct 2025 16:55:15 +0200
Message-ID: <20251017145214.383092515@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 0a6ce20c156442a4ce2a404747bb0fb05d54eeb3 upstream.

In principle orphan file can be arbitrarily large. However orphan replay
needs to traverse it all and we also pin all its buffers in memory. Thus
filesystems with absurdly large orphan files can lead to big amounts of
memory consumed. Limit orphan file size to a sane value and also use
kvmalloc() for allocating array of block descriptor structures to avoid
large order allocations for sane but large orphan files.

Reported-by: syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com
Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Cc: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-ID: <20250909112206.10459-2-jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -583,9 +583,20 @@ int ext4_init_orphan_info(struct super_b
 		ext4_msg(sb, KERN_ERR, "get orphan inode failed");
 		return PTR_ERR(inode);
 	}
+	/*
+	 * This is just an artificial limit to prevent corrupted fs from
+	 * consuming absurd amounts of memory when pinning blocks of orphan
+	 * file in memory.
+	 */
+	if (inode->i_size > 8 << 20) {
+		ext4_msg(sb, KERN_ERR, "orphan file too big: %llu",
+			 (unsigned long long)inode->i_size);
+		ret = -EFSCORRUPTED;
+		goto out_put;
+	}
 	oi->of_blocks = inode->i_size >> sb->s_blocksize_bits;
 	oi->of_csum_seed = EXT4_I(inode)->i_csum_seed;
-	oi->of_binfo = kmalloc_array(oi->of_blocks,
+	oi->of_binfo = kvmalloc_array(oi->of_blocks,
 				     sizeof(struct ext4_orphan_block),
 				     GFP_KERNEL);
 	if (!oi->of_binfo) {


