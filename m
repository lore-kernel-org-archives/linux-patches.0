Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0746133A9DA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302434; cv=none; b=P2kfL7sgSevzcLJBfVcq1SvpMrRy/1xLCH1UbbJw8votP0942q/xDfYeWc+bPG1ekUkpVAyCWoB2efzUv7xuwvpsGJOVpurygsh8IJh0ohwyYqPr6GV2hT7YJrc0E/L+DQ0pFJMVfgxAw6lGzWGkIS3v4g8Tbkh+RsNxCY13Ugw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302434; c=relaxed/simple;
	bh=KE0f7HYcDm0UjSa74GFNW/ssrO+KTdyNmnQN3aXDofw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWJ+uTqJ7yt47OXCYHbwcwdGaQJkXhOQB90rXt2Gozq1aTLJTmWHtIS9uDz3DFd9SBePXXZTlZvx29y4m0INuz9Bi1BZAk2jt7OWaHeGQhzvWkOqt/J/hg3/56A5C9p3G03Z74FO1FuHRRyaSd6z2KZJbGRw/kC4hSPM/iPC4pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eT+wBI7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eT+wBI7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A620C116D0;
	Sat, 28 Feb 2026 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302433;
	bh=KE0f7HYcDm0UjSa74GFNW/ssrO+KTdyNmnQN3aXDofw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eT+wBI7S+KxsaSH6RyjAKsHtJ6PIqV7LkRwXJptpX93komRpugEBclvxAUtxOIF7V
	 oNHVgHzNBP9LXRo+HCDiIeC2CnqjfYdpbUMJamu49wJF64YCuZsw+cp0IoUZgYYACE
	 ovgxI5wcEVxBZ19CCxnNWvqVJ+AoUhpgxRU3CoSwMCwLovaDy5Kk2zyzzmujmCvj6R
	 u/nEpTrSGKTpYkKeGPbytkWNQ20BbMDjYNGiLMUI4mKfjIdb+xMtwAEvV0JF+TRsho
	 oPmqOQmm3cC7c/ye4hnAeQfg4W2fVtu2pRF0y2yGxg/2Zv/u0YMApZadLguM1S8KlK
	 MqBDXMHQZnbGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Ts'o <tytso@mit.edu>,
	stable@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 171/232] ext4: fix memory leak in ext4_ext_shift_extents()
Date: Sat, 28 Feb 2026 13:10:24 -0500
Message-ID: <20260228181127.1592657-171-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

commit ca81109d4a8f192dc1cbad4a1ee25246363c2833 upstream.

In ext4_ext_shift_extents(), if the extent is NULL in the while loop, the
function returns immediately without releasing the path obtained via
ext4_find_extent(), leading to a memory leak.

Fix this by jumping to the out label to ensure the path is properly
released.

Fixes: a18ed359bdddc ("ext4: always check ext4_ext_find_extent result")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20251225084800.905701-1-zilin@seu.edu.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1398da08fd5a3..1df7174774694 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5262,7 +5262,8 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 		if (!extent) {
 			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
 					 (unsigned long) *iterator);
-			return -EFSCORRUPTED;
+			ret = -EFSCORRUPTED;
+			goto out;
 		}
 		if (SHIFT == SHIFT_LEFT && *iterator >
 		    le32_to_cpu(extent->ee_block)) {
-- 
2.51.0

