Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E0A13A26F;
	Tue, 27 Feb 2024 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043990; cv=none; b=pf6omH8cVq584wMOgsFLgVqRKDLOhiK3nFaIXkG3O2/jwrofE2vANL7yBm39mUZncgAOhVToM4GZJsTbOgQaQj5eSjMFY/Jg0BZnfcr4siQgnpb+sH/ppxKKJh5ZtnKHqGfZxxTU3pjiL8Y8jksKUlD2lbtN55h/gSnPyVHkxY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043990; c=relaxed/simple;
	bh=/K8PtxwRJnZos5yUVoJIrDi/K4af27OabRlWscLjW+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lai0a5JSKr7KoVPVcaYy18+Wy7XvhZDAhGMHT8OzZ2iOwb5huRTxFERV9EJPJoi0ut67sNnkZNE96v1EIjTWpJen04DBpgIMq6mC9B3xkrLO6W5crnxuYDlqv0C9rfqlJnCcCSSp8xfibl6uWvD5s4hW3XGHZTRohqrM/0MW3Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RS29MQm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RS29MQm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9356FC43390;
	Tue, 27 Feb 2024 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043989;
	bh=/K8PtxwRJnZos5yUVoJIrDi/K4af27OabRlWscLjW+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RS29MQm8HqRfxbcVDo++8M7OdUmAfOfyBZuc9dq8FViOUHN6C2GKNNlnib6KtHrpb
	 b83UvYHt/kJRWmB7Xlqdjtus3CphUIFPWIgtveBazNRhsgptJJMEkjJY7spOB7YZjz
	 39DY4rLTBWhdYqE61yIf2TxAKgXKX/Fns0MKIjkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/122] ext4: avoid allocating blocks from corrupted group in ext4_mb_find_by_goal()
Date: Tue, 27 Feb 2024 14:26:24 +0100
Message-ID: <20240227131559.464791257@linuxfoundation.org>
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

[ Upstream commit 832698373a25950942c04a512daa652c18a9b513 ]

Places the logic for checking if the group's block bitmap is corrupt under
the protection of the group lock to avoid allocating blocks from the group
with a corrupted block bitmap.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-8-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ebb79f10330a8..46da6845c3072 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1893,12 +1893,10 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	if (err)
 		return err;
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) {
-		ext4_mb_unload_buddy(e4b);
-		return 0;
-	}
-
 	ext4_lock_group(ac->ac_sb, group);
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		goto out;
+
 	max = mb_find_extent(e4b, ac->ac_g_ex.fe_start,
 			     ac->ac_g_ex.fe_len, &ex);
 	ex.fe_logical = 0xDEADFA11; /* debug value */
@@ -1931,6 +1929,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 		ac->ac_b_ex = ex;
 		ext4_mb_use_best_found(ac, e4b);
 	}
+out:
 	ext4_unlock_group(ac->ac_sb, group);
 	ext4_mb_unload_buddy(e4b);
 
-- 
2.43.0



