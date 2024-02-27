Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510F813B797;
	Tue, 27 Feb 2024 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043987; cv=none; b=flC1qZPD0BKfdrwQag/LTmqqkp+taNTPuOWgFRJPlDjpK+1X15VAoVGRd/0mH2SdjbRPCxeayUQ18utbcMY5PXzRLC9SMfCvstBdsrEo8p7IEeo1Ido3it5fQFbQu7vHsJDq/xc0QC2pRrU56Ho2T29Zt/uS+Q/adertzErQJtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043987; c=relaxed/simple;
	bh=ARCzzac8ZyaJmK920P1lCLO9xOzZgzEEKxLgqGaM2s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypqjkn1MIFlzaIElrMpz2hp76c7dQWYxnGeuIWTIUPh1TuXsWnHU8NV1jMtnrVizEjl3v6mbnbphdjL8dCY7jkDbmoJvEbS9Fc3W1AwI1+dSUZfCBkhTAODDqNsPIJVcIybVx8ALdLflpmX3PGDCEOzLmd5HAfHVnR8PjcnJxeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZ7YGycb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ7YGycb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64D4C433C7;
	Tue, 27 Feb 2024 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043987;
	bh=ARCzzac8ZyaJmK920P1lCLO9xOzZgzEEKxLgqGaM2s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZ7YGycbcBSdtBpdcKobPf7qddzHq0zG6GvxcFQm3UhdQYzL2W0fSdeQB0iTHI9Wc
	 3wKVV2Vf+louZOpCKWfJ6x1CdVfBAF52R9Zx51rUOvVpeOBXj/u3bUexr6iYe3hEbV
	 CgUepc8jaZC6rgM3snAUV4MeGQCFS7wDASnDLuJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/122] ext4: avoid allocating blocks from corrupted group in ext4_mb_try_best_found()
Date: Tue, 27 Feb 2024 14:26:23 +0100
Message-ID: <20240227131559.432907393@linuxfoundation.org>
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

[ Upstream commit 4530b3660d396a646aad91a787b6ab37cf604b53 ]

Determine if the group block bitmap is corrupted before using ac_b_ex in
ext4_mb_try_best_found() to avoid allocating blocks from a group with a
corrupted block bitmap in the following concurrency and making the
situation worse.

ext4_mb_regular_allocator
  ext4_lock_group(sb, group)
  ext4_mb_good_group
   // check if the group bbitmap is corrupted
  ext4_mb_complex_scan_group
   // Scan group gets ac_b_ex but doesn't use it
  ext4_unlock_group(sb, group)
                           ext4_mark_group_bitmap_corrupted(group)
                           // The block bitmap was corrupted during
                           // the group unlock gap.
  ext4_mb_try_best_found
    ext4_lock_group(ac->ac_sb, group)
    ext4_mb_use_best_found
      mb_mark_used
      // Allocating blocks in block bitmap corrupted group

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-7-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9bec75847b856..ebb79f10330a8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1854,6 +1854,9 @@ int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 		return err;
 
 	ext4_lock_group(ac->ac_sb, group);
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		goto out;
+
 	max = mb_find_extent(e4b, ex.fe_start, ex.fe_len, &ex);
 
 	if (max > 0) {
@@ -1861,6 +1864,7 @@ int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 		ext4_mb_use_best_found(ac, e4b);
 	}
 
+out:
 	ext4_unlock_group(ac->ac_sb, group);
 	ext4_mb_unload_buddy(e4b);
 
-- 
2.43.0



