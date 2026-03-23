Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C5E3AC0D3;
	Mon, 23 Mar 2026 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282245; cv=none; b=m2GpmluKY1A7IuF+MszGADbQJpSRxYpO2m2kvVLNPZtyHc6nE6gfH5+OZx8pJMpVHZln0S71eeoZlFqCl9v9nNbhHWxjcxcp5d/TydEw1pp0w5lsIsJVp+csXU2etXHfz7Hqw8xGtE0iVMuV30sIsV3DP3H2noxePKJdl4/1vPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282245; c=relaxed/simple;
	bh=zdManzZpe2MUMLbbh7v5Gethcb/9etrvOKevD3uaBkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ml+lWktLnuIVo801cEO4pgMngMw/k5NuvDRq1gf0cwYs6Aw6a/cg1jbNjHPErV6HXSG/HGFvtFInguFSI7dFKEUFBsmmhJpohFwAtBW/aZnOY6cceLFecj9xnhO6V6+sIxwd0N46K/D8h7XcJ2w5mAGivQAXfvj25biTICCH+t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKjKRstf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKjKRstf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E0FC4CEF7;
	Mon, 23 Mar 2026 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282245;
	bh=zdManzZpe2MUMLbbh7v5Gethcb/9etrvOKevD3uaBkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKjKRstf7e14pZSW2UTq9XyM6PpNkf0VtMg+SsCLHTjX674GVYXsfJ+83sEJ7FNOp
	 cT3Oh0P6X77PhV4YbkNRcRTcn4RtSSTIXjVgE76qZIc6XhLCSvVVsez911yXWQb0k5
	 NBXR2Bsh3pxtoNvBkfHl5buaVa+R/SqqUfO5uWis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/481] ext4: remove unnecessary e4b->bd_buddy_page check in ext4_mb_load_buddy_gfp
Date: Mon, 23 Mar 2026 14:40:30 +0100
Message-ID: <20260323134526.402114313@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 285164b80175157c18a06425cf25591c9f942b1a ]

e4b->bd_buddy_page is only set if we initialize ext4_buddy successfully. So
e4b->bd_buddy_page is always NULL in error handle branch. Just remove the
dead check.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230303172120.3800725-11-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: bdc56a9c46b2 ("ext4: fix e4b bitmap inconsistency reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 71e15007ffdf4..7431ff97a68c8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1599,8 +1599,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 		put_page(page);
 	if (e4b->bd_bitmap_page)
 		put_page(e4b->bd_bitmap_page);
-	if (e4b->bd_buddy_page)
-		put_page(e4b->bd_buddy_page);
+
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
 	return ret;
-- 
2.51.0



