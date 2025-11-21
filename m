Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506163491D0;
	Fri, 21 Nov 2025 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732802; cv=none; b=GdllafyobhD43w5OKSpoqq+NKSra4H9z2J/YLEN+R2soHNATofG3eqkqP/UPLoBiMBFiadQojFNWGEiEjqn634w6nXMHX4wuYw3FFEMY9Ltdd+7E7m8cEVr1+sULrOg5NqeLbQRpzdYgNlY3yBsHonP5Y0h/7Mv3XgupQ2ZbaE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732802; c=relaxed/simple;
	bh=pth6rVsianPMNP2D9Hon0JCbgtPYTw/WrEfrkWWu/0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txWXbegNnLxoDNFj+wLKNW/BBJkNsAIjm3v8Ubvdndo77lUt0B9xIkMOC20595U3ybDkS1duYiS5gHErz0nEBk1rauRthdcfLRhDZrPi2F29dyAzS58jb7vSw40QAJaVu/mP2c9UwC5q+UYAiVzyLdeCxa0vdCbnNImtdd6d0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXdzLG3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXdzLG3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1FFC4CEF1;
	Fri, 21 Nov 2025 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732802;
	bh=pth6rVsianPMNP2D9Hon0JCbgtPYTw/WrEfrkWWu/0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXdzLG3jfBCzgJf6WIiJ9VyruM4RB6khFWj57+BIJJoASZVCZi3O5KGFqE05Z4qZb
	 EnuAeYH1UeD7xasjhPC9dh0FHiys9TZHVuvE7ElnsRzml/5rXqIQXPiz+WXo/eid5F
	 NT3dZVF/9sdyfCegCZbTDGlARWjVy2MP1+hhGj7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/529] f2fs: fix infinite loop in __insert_extent_tree()
Date: Fri, 21 Nov 2025 14:09:08 +0100
Message-ID: <20251121130239.877131195@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6a77581106a9e..79d07c786f6ae 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -562,7 +562,13 @@ static struct extent_node *__insert_extent_tree(struct f2fs_sb_info *sbi,
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



