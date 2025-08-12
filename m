Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1246C2FF14D;
	Tue, 12 Aug 2025 18:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025011; cv=none; b=LTrOF4s2O02ya41zJrb0v/NFFrYDMhILU5s4OtBP+qsSk6aCoLL3qXYyz0rDHatXUL4KZhF7z/uf57c/qu+MGpcym38dEXuGw22gGUpOo+b4tVtNQualN0LggxqA1xaMpy6J7DYeAydX16LHPRwnLRQFtxJ2lBkJT4Bu3XQ3W80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025011; c=relaxed/simple;
	bh=BEySytcCpf++PackOwRVJhWefsYbqXBi21vJgLJMcY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0wpDte7UN9Oyc0yfR+AWxLSjVexPWtnUTkWFXXMVNpwRxISucse9yjuxjJvM1iVqTnWfSy9Sfdh4FieItIvqYYwDycyxm/I1+lHu8E7XgrRTiKhTIxderoFcIgmAVj1fEkzoh1ygGi9+7wt8XnJLtzUrJ9v1VC7N2miMA0tswI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbjTU0bw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbjTU0bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CE6C4CEF1;
	Tue, 12 Aug 2025 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025010;
	bh=BEySytcCpf++PackOwRVJhWefsYbqXBi21vJgLJMcY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbjTU0bwyomajn+IWXN2Qn3Ea3IAqBqTvMFjLXfOkSSmbftRW7oT1m1A2n99xeBge
	 ALBJ+OP8YL983rssr7HX+Mcs/zaYCMaPt9+/71O/F5sA77YXwBGNlT93/P/TIwc52N
	 NrbUqoS5wfw3+DcEC0S86fSHGYKhlpNkp8cxEy8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 526/627] block: ensure discard_granularity is zero when discard is not supported
Date: Tue, 12 Aug 2025 19:33:41 +0200
Message-ID: <20250812173451.915212834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit fad6551fcf537375702b9af012508156a16a1ff7 ]

Documentation/ABI/stable/sysfs-block states:

  What: /sys/block/<disk>/queue/discard_granularity
  [...]
  A discard_granularity of 0 means that the device does not support
  discard functionality.

but this got broken when sorting out the block limits updates.  Fix this
by setting the discard_granularity limit to zero when the combined
max_discard_sectors is zero.

Fixes: 3c407dc723bb ("block: default the discard granularity to sector size")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250731152228.873923-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3425ae1b1f01..1a82980d52e9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -342,12 +342,19 @@ int blk_validate_limits(struct queue_limits *lim)
 	lim->max_discard_sectors =
 		min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors);
 
+	/*
+	 * When discard is not supported, discard_granularity should be reported
+	 * as 0 to userspace.
+	 */
+	if (lim->max_discard_sectors)
+		lim->discard_granularity =
+			max(lim->discard_granularity, lim->physical_block_size);
+	else
+		lim->discard_granularity = 0;
+
 	if (!lim->max_discard_segments)
 		lim->max_discard_segments = 1;
 
-	if (lim->discard_granularity < lim->physical_block_size)
-		lim->discard_granularity = lim->physical_block_size;
-
 	/*
 	 * By default there is no limit on the segment boundary alignment,
 	 * but if there is one it can't be smaller than the page size as
-- 
2.39.5



