Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C03A48E4;
	Sat, 17 Oct 2026 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259847; cv=none; b=Cvu4csGrbgw76jetGSA48CD6dTQMxu5usMcbMXeJ2FeuVUvJbWXDVDUxyrJH+gRp54MJ6DhraSg5GbuEiKxJN2e91LOSf2/07xzh92x1Xuo1TN98CJTHgw7GUX3qCq9YHELDexfl6HrKcrHC17PLYXxLJCagMyPflBWmlZo0o/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259847; c=relaxed/simple;
	bh=lPe/ona86cOoM8U1dQXDa3oDh7IodugNV3/eGHMT+gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE5z12PSH+sx529XAOM9vK4u+sRWA6LYJ6QxobC99ed6550k7ylmmsLZEVeirixn4ZKFHHVj1BitsOpWi2KCcAB0b3oFZoYoC7cXHltuUqO+a/RDFoDQdslYj9bcR3+HUWYzmkmyPDwu5ydtpQF3QnKm11CTQ/N/mHb4GZVlnk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBEpmMBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBEpmMBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CF91F000C4;
	Sat, 17 Oct 2026 17:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259846;
	bh=UW8ryABCkYS8BuHsm0R7g5qlNFr75JqffILL5rUYckM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBEpmMBUvaMeAh4qV8G12RTD7IqD3Pas/1JEOPmRMye4bBZzVfmv4Rh8rW0hdR6hd
	 PJCHp3nVcFM3es1wVZCVI+1nXeQyjp10vtNfiytq5Xuc6WTx6Ds6OIuSI2a14FqyPP
	 ERNQHKDRJjNmZJtQY3e2KEU6TivwHGRo+5LsjJgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1349/1674] f2fs: fix to migrate all curseg types during free_segment_range
Date: Sat, 17 Oct 2026 18:00:21 +0200
Message-ID: <20261017160505.787419506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 8ec06f50ddd8d201bd7e55b896ae28ed9d4cb7d1 ]

In free_segment_range(), the curseg evacuation loop only iterates up to
NR_CURSEG_PERSIST_TYPE (0..5), missing non-persistent in-memory curseg
types such as CURSEG_COLD_DATA_PINNED and CURSEG_ALL_DATA_ATGC.

Even though these in-memory curseg types are not saved in the on-disk
checkpoint header, they still occupy active physical segments at runtime.
If an active in-memory curseg happens to be allocated within the segment
range being truncated during filesystem shrink, failing to evacuate it
will cause subsequent writes to the curseg attempting out-of-bounds I/O
on the truncated storage range.

Fix this by expanding the curseg evacuation loop upper bound to
NR_CURSEG_TYPE to ensure all active curseg types are safely migrated
out of the target range.

Fixes: d0b9e42ab615 ("f2fs: introduce inmem curseg")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b8dd61cf584c9..7cb41593462b2 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2113,7 +2113,7 @@ static int free_segment_range(struct f2fs_sb_info *sbi,
 	mutex_unlock(&DIRTY_I(sbi)->seglist_lock);
 
 	/* Move out cursegs from the target range */
-	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_PERSIST_TYPE; type++)
+	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_TYPE; type++)
 		f2fs_allocate_segment_for_resize(sbi, type, start, end);
 
 	/* do GC to move out valid blocks in the range */
-- 
2.53.0



