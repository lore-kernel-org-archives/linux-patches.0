Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019C92BF3E2;
	Tue, 10 Mar 2026 11:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141149; cv=none; b=HSCnvDNd8CbemSXUPDhSdIRruwTQr6/C1R77L/NcTOiMLYMRg0RRQVJde8mbVkDAETRgsJVLiSyCtnZq2/WwQQRPemsy0jLqSXcpsasIrjs+PCW/MEu6wwvc0UbtzfEF+gEO8vFnP0YiBDDc4XSvOM4f6O7ibJHXw2Ny5rdRM/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141149; c=relaxed/simple;
	bh=1bangbAQX2AqFoYs24wOW40X/eOC4NEEtJpSmSVC4mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfFIuvFarXB+/Anol/gFG5X26HbTUijh37nWwe1q2yraEXHRXTJFsdTZ5LAX+UJeA2eGTMPTgS2oUL+JabYLwOqF02mt4LDJTtwwMOT4MAnrAB67g44isr84cGQ/1HQ9ya+LGST/MEJTcWAPCg0cL4BtTKD/YiqTOabr+cC0yEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbTi7XLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbTi7XLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2036EC2BCB0;
	Tue, 10 Mar 2026 11:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141148;
	bh=1bangbAQX2AqFoYs24wOW40X/eOC4NEEtJpSmSVC4mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbTi7XLPKnOLBW9F4N90hPg03qJeYfhlQnIidCisOEcrgTfepl/0+SnnBiLSBHy/9
	 t6J0a1LZZC71s5V8WV2LOa8Bmf5+yBmrHVFi9epEi7XrgAE/sOYRVTJ1C+lkXwFqSJ
	 vTpZHIFUwwCAU0RtI2uNEsd8Tf3Aauvw23UJbb0NONRwr388+YFQIn87841j5v7j9n
	 FMcmqAAtPFZhNzgPGtbTNwtBppoFjTAtLDMcw1XtrU+AN9qRmfVnsyjowHpoCc0ibt
	 aTYWgpo/hcZF1rUeESx/jJXC6gC+YgUc4afPTnhda7rQGc8yNYO6KXHG8zpU0BJcvh
	 49wwIbXeaO1Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 151/311] Squashfs: check metadata block offset is within range
Date: Tue, 10 Mar 2026 07:03:18 -0400
Message-ID: <73298f44d80b9c8638852fef783531642fbc3a72.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Phillip Lougher <phillip@squashfs.org.uk>

commit fdb24a820a5832ec4532273282cbd4f22c291a0d upstream.

Syzkaller reports a "general protection fault in squashfs_copy_data"

This is ultimately caused by a corrupted index look-up table, which
produces a negative metadata block offset.

This is subsequently passed to squashfs_copy_data (via
squashfs_read_metadata) where the negative offset causes an out of bounds
access.

The fix is to check that the offset is within range in
squashfs_read_metadata.  This will trap this and other cases.

Link: https://lkml.kernel.org/r/20260217050955.138351-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Reported-by: syzbot+a9747fe1c35a5b115d3f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/699234e2.a70a0220.2c38d7.00e2.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 181260e72680c..92fb857d2c761 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -344,6 +344,9 @@ int squashfs_read_metadata(struct super_block *sb, void *buffer,
 	if (unlikely(length < 0))
 		return -EIO;
 
+	if (unlikely(*offset < 0 || *offset >= SQUASHFS_METADATA_SIZE))
+		return -EIO;
+
 	while (length) {
 		entry = squashfs_cache_get(sb, msblk->block_cache, *block, 0);
 		if (entry->error) {
-- 
2.51.0

