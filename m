Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6A337112;
	Fri, 17 Oct 2025 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713429; cv=none; b=bhPNTEz2Zd1qHdml5NwfCXJDbZxehzHYeeDKbAj7nIEX+B6x8GwPi4pKVtpf13XxWmd8HKO8AlhIog0Bm2SR35aDTzFod9xLiG9xmNRdHy5FVa1Aho5VZ0vm10wwcnScwy1BQftGG7PKm7y2N30KZsIv3/vKeKD1ky2rMXaa5JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713429; c=relaxed/simple;
	bh=0vtEGiGWf2RPW0PRVYilbQBrSFKicYnuPgNrwSIXDaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+CfW3leYNRYdsDLwARwnUlK4Rsl0OxVQDk7uxghl7FQ5zcsIuDZqZvi5MepWoueyak+EKf7UaUV7dk29xTLyZhp4r8avJtICzPpwP6Sg3KqKfbSJ++sCF2OdlLJC8uShdSHiC8qKnAdaAY0AR/kT/zGvV1smNrVvR5GlIdy8KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWv8cU6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWv8cU6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C37C4CEE7;
	Fri, 17 Oct 2025 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713428;
	bh=0vtEGiGWf2RPW0PRVYilbQBrSFKicYnuPgNrwSIXDaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWv8cU6Df/h2SnX3ba/8dOpUaIKJg0oj4pHQtlQNpdTWx1rKkcrH/w0mrDB7K1Eo6
	 YHyMqhhJ07tqcPb0dmL8oTsxhXLcvEcOmoR5SFvHdcyy4kmVHmn20k1WvBcvbu9s3c
	 SIhlueuh9s4eQUj7XG2iGiCqyiLwgi2DAyXcpfu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0b92850d68d9b12934f5@syzkaller.appspotmail.com,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 129/168] ext4: verify orphan file size is not too big
Date: Fri, 17 Oct 2025 16:53:28 +0200
Message-ID: <20251017145133.778223878@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -584,9 +584,20 @@ int ext4_init_orphan_info(struct super_b
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


