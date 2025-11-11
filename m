Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E973342CA9;
	Tue, 11 Nov 2025 01:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824076; cv=none; b=icBeZpfr9cVCvi1pMsxWMU93NC0rsS2afL9cplQlMxwJHO5ycoi28q7tnPTNQi0q/j9XF2oLFZHlceB97Pd+dc4VDhj49BVon02JyLApxXZNA9USdQax4CT9sX7uhzC37YUH0hYLl41batkPzpTJaSLVjX9Ksqv+Qu2/1OIHEaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824076; c=relaxed/simple;
	bh=9TL6bp5v3KwUkLsavePNwzxOVN0TUhm1Uv0na+YW/oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RS3g/PnvF9XnxOmGG7xVuX4chbfaKcD6zb2Hv+0Nl5+TceOR9lSaG0RvPa2IMT37wEYm8r0WZXJmomJeppeKrO2ItQ9Uw7ns/A7Sgme6nahtHzX84xWOM4BAiCc2mnEUd0uoojR38HbRjNCshKiNUOZPflQBG0MVhSmcFTv9yJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE/iOjs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE/iOjs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9573C4CEF5;
	Tue, 11 Nov 2025 01:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824076;
	bh=9TL6bp5v3KwUkLsavePNwzxOVN0TUhm1Uv0na+YW/oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE/iOjs86r0Pqhk4GGpjnadoXmxlPGvUc4v4SJ9U5TQwlLLy9LkVB8PxanVEHrRNm
	 HTXBXy7+0SRanouMn2IbtWHBCzi3i2XK+vlZOMZLlQBFReYb5zuD9JWF02HOhGqR52
	 7cgDzki3q/djmZQK2GASXfwYt69wuimy9Gn0yZjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/565] f2fs: fix infinite loop in __insert_extent_tree()
Date: Tue, 11 Nov 2025 09:43:59 +0900
Message-ID: <20251111004535.486124435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 fs/f2fs/extent_cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 2ccc868750994..fe5e91c6e910d 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -561,7 +561,13 @@ static struct extent_node *__insert_extent_tree(struct f2fs_sb_info *sbi,
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



