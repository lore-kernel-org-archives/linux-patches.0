Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC4B3043B4;
	Sat, 25 Oct 2025 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408616; cv=none; b=MBv16j7gjmUwIP8qcJtkBNpnrv8XumbCu9YeU8yilbbau/BIo9IejSVVEHV9WAdgb0jbSMGqgeTglQI8IcR628sgP6e42pAZTIZb7a6fPz9bMYIC8G3Ifo4IbJA4bW+xMifJzRahwh2KxeywX8yE828xUJBTXmpUnPPPfQ8tH1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408616; c=relaxed/simple;
	bh=ZB6MMGsHom3hrtuy3Yx15fuq2M6wnBgRV0eXr75fs5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agMcwdiTD4lSJ3rvT0hsD3vBLMCbmT7fM9hpCUDxk9vKg9nlxfQSeuK84uw5zpZVyVrjxn6RzIMwnjVEy3oBZiFEiYywnmzadgMeg5BmCAvroeNpwuhAkWqKQzSjoJIZaQIN9H+gwqs1qBhS14zHrWtSJssf8/kruGxAW33X/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZkoNMyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZkoNMyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9193DC4CEF5;
	Sat, 25 Oct 2025 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408616;
	bh=ZB6MMGsHom3hrtuy3Yx15fuq2M6wnBgRV0eXr75fs5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZkoNMyDINbtGdhrrmgJMXe62Zt1KTNnGhRRW+S9195uK9jtAb4JfIjV+Jw9Gx22b
	 uoSa2fPFN0H6bB+lDFKtl1QcWwXuXG9g+O8VSJYwVsx1FDp6WUm+7HIUshoMwOj9DQ
	 2Q6mqSojWktRCYwZfY4799Ss2gU4yEFPtvltESwMdWoszkfpbGkj0bb/lLnYc3qPmF
	 cDM6hwiGw9jdZDcMnu0A31OmzvInNPSPc3h9L+yjFWNkYt7kWipmHBM08FPHVqCcWW
	 ISy1XQEi/e3gGv+Sj1re4WC+5z6/Gbwz09Wg7InKJACGok2jXduZoD19jDc/CvOxtM
	 uxGY4llyPHQ2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: wangzijie <wangzijie1@honor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.17-6.6] f2fs: fix infinite loop in __insert_extent_tree()
Date: Sat, 25 Oct 2025 11:54:17 -0400
Message-ID: <20251025160905.3857885-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wangzijie <wangzijie1@honor.com>

[ Upstream commit 23361bd54966b437e1ed3eb1a704572f4b279e58 ]

When we get wrong extent info data, and look up extent_node in rb tree,
it will cause infinite loop (CONFIG_F2FS_CHECK_FS=n). Avoiding this by
return NULL and print some kernel messages in that case.

Signed-off-by: wangzijie <wangzijie1@honor.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `fs/f2fs/extent_cache.c:601-613` now detects overlapping/ext corrupt
  extents while walking the rb-tree, reports the corruption with
  `f2fs_err_ratelimited`, and returns `NULL` instead of spinning
  forever; without this fix, the loop never advances when
  `f2fs_bug_on()` only warns (see `fs/f2fs/f2fs.h:34-41`), so
  CONFIG_F2FS_CHECK_FS=n kernels hit a hard hang.
- The new error path still raises `f2fs_bug_on()` so debug builds keep
  the existing BUG_ON crash semantics, but production builds finally
  break out and mark the filesystem dirty, preventing a livelock while
  still flagging the corruption for fsck—meeting stable’s “serious user-
  visible bug” criterion.
- Callers already cope with a `NULL` return from
  `__insert_extent_tree()` (e.g. `fs/f2fs/extent_cache.c:744-763`,
  817-830), because allocation failures had to be tolerated before; the
  change therefore carries minimal regression risk and stays confined to
  extent-cache error handling rather than touching normal fast paths.

Given the severe hang it eliminates and the very localized, low-risk
fix, this is a solid candidate for backporting to the stable trees.

 fs/f2fs/extent_cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 199c1e7a83ef3..ba0a07bfd3463 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -604,7 +604,13 @@ static struct extent_node *__insert_extent_tree(struct f2fs_sb_info *sbi,
 			p = &(*p)->rb_right;
 			leftmost = false;
 		} else {
+			f2fs_err_ratelimited(sbi, "%s: corrupted extent, type: %d, "
+				"extent node in rb tree [%u, %u, %u], age [%llu, %llu], "
+				"extent node to insert [%u, %u, %u], age [%llu, %llu]",
+				__func__, et->type, en->ei.fofs, en->ei.blk, en->ei.len, en->ei.age,
+				en->ei.last_blocks, ei->fofs, ei->blk, ei->len, ei->age, ei->last_blocks);
 			f2fs_bug_on(sbi, 1);
+			return NULL;
 		}
 	}
 
-- 
2.51.0

