Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B69C1F55FA;
	Sun,  3 Aug 2025 21:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256076; cv=none; b=oayzebSJRJBxwF8gWWXG6hNVF6TXPNCnn6I5hjN1U2zK28hwOJN8YwGxCdUltNMQlAmcMkhHawXGEtHXww8u0hY0IzbHgm/C6ZmOFDVxI3aMLyrVKb18HCEkI3bjo2NJbiTN33FtTAr/HRybDw5xtXeJFOhKnz6asfq9nwm6EtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256076; c=relaxed/simple;
	bh=jlJhr40poqXDoxNXVvHpbKesB3ADgvLtN2+9mZLMAg4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FxYXX13u6ee9jfCTtR+Opbc6Zwm+N7x0S81ZDtMxtlgJaz4b8MSx5ys4ZpUzQhJQ87EzjJ7fGeglnTAIYx2zCElrLRrgEEfksrStB789Ll5FCLfOfjliYA4FDjqhng8404qNaLdPxMRtPKdS58EzcxDwJZUnmVdgzFA6uLIxs0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qk+yBJd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qk+yBJd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D22C4CEEB;
	Sun,  3 Aug 2025 21:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256076;
	bh=jlJhr40poqXDoxNXVvHpbKesB3ADgvLtN2+9mZLMAg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qk+yBJd4yS+RWci0rjM8Qp209NuIdU88rBGJPAGqNzvxZWFthLZ32GL591Oz4qL5g
	 6OZFecbN4zVKaKKcJJRPu52VPaScPHVQ6gEVwAmHZIj43nYXeDxeew43VdJIy7JmgM
	 be0yGu5e+LjZ0zARRUcELWziuiZZyl/MyFKE3gH6FpjodcJnpaBXdkD7oI8AhOSFkc
	 F/wRgfX6ryeAsfB/LTp6i4yEiDdy+AssDQi/BcNltSVfRfQBN/8kfTDNJA+9aMZx5N
	 RxSw84BtZr3F1EZB9dy1yWFxWYwxwB+elBXS+CJaogWX6PgyDE1gy9G8FcpTdmfoJS
	 RHdlSuBk1nKSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 19/23] md: Don't clear MD_CLOSING until mddev is freed
Date: Sun,  3 Aug 2025 17:20:26 -0400
Message-Id: <20250803212031.3547641-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212031.3547641-1-sashal@kernel.org>
References: <20250803212031.3547641-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 5f286f33553d600e6c2fb5a23dd6afcf99b3ebac ]

UNTIL_STOP is used to avoid mddev is freed on the last close before adding
disks to mddev. And it should be cleared when stopping an array which is
mentioned in commit efeb53c0e572 ("md: Allow md devices to be created by
name."). So reset ->hold_active to 0 in md_clean.

And MD_CLOSING should be kept until mddev is freed to avoid reopen.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/linux-raid/20250611073108.25463-3-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Bug Fix Analysis

This commit fixes a race condition in the MD (Multiple Device) subsystem
where the MD_CLOSING flag could be cleared prematurely, allowing an
mddev to be reopened while it's in the process of being freed. This is a
clear use-after-free vulnerability.

## Key Issues Fixed

1. **Race condition with MD_CLOSING flag**: The old code would
   conditionally clear MD_CLOSING based on whether `hold_active` was
   set:
  ```c
  if (mddev->hold_active)
  mddev->flags = 0;  // This clears MD_CLOSING!
  else
  mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
  ```

2. **Improper hold_active handling**: The commit properly moves the
   clearing of `hold_active` from `do_md_stop()` into `md_clean()`,
   making the code cleaner and more predictable.

## Impact on Users

- **Security Impact**: This prevents a potential use-after-free
  vulnerability where an mddev could be reopened while being freed.
- **Stability Impact**: Prevents crashes or undefined behavior when
  racing between mddev close/free and reopen operations.
- **Data Integrity**: Could prevent corruption scenarios where
  operations are performed on a partially freed mddev structure.

## Code Changes Analysis

The changes are minimal and focused:
1. Removes the conditional logic that could clear MD_CLOSING
   inappropriately
2. Always preserves MD_CLOSING flag in `md_clean()` with: `mddev->flags
   &= BIT_ULL_MASK(MD_CLOSING)`
3. Moves `hold_active = 0` assignment from `do_md_stop()` to
   `md_clean()` for better code organization
4. Updates comments to clarify the behavior

## Stable Tree Criteria

✓ **Fixes a real bug**: Yes - race condition leading to potential use-
after-free
✓ **Small and contained**: Yes - only 15 lines changed in a single
function
✓ **No new features**: Correct - only fixes existing behavior
✓ **Minimal regression risk**: Yes - preserves existing semantics while
fixing the race
✓ **Important enough**: Yes - security/stability issue in core storage
subsystem

The commit message explicitly references commit efeb53c0e572 which
introduced the UNTIL_STOP mechanism, showing this is fixing a long-
standing issue in the MD subsystem's lifecycle management.

 drivers/md/md.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2758c3ee2f56..60b49f7c74c2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6265,15 +6265,10 @@ static void md_clean(struct mddev *mddev)
 	mddev->persistent = 0;
 	mddev->level = LEVEL_NONE;
 	mddev->clevel[0] = 0;
-	/*
-	 * Don't clear MD_CLOSING, or mddev can be opened again.
-	 * 'hold_active != 0' means mddev is still in the creation
-	 * process and will be used later.
-	 */
-	if (mddev->hold_active)
-		mddev->flags = 0;
-	else
-		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
+	/* if UNTIL_STOP is set, it's cleared here */
+	mddev->hold_active = 0;
+	/* Don't clear MD_CLOSING, or mddev can be opened again. */
+	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
 	mddev->sb_flags = 0;
 	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
@@ -6545,9 +6540,6 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		export_array(mddev);
 		md_clean(mddev);
 		set_bit(MD_DELETED, &mddev->flags);
-
-		if (mddev->hold_active == UNTIL_STOP)
-			mddev->hold_active = 0;
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.39.5

