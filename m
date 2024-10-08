Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F3B1DE4CC;
	Tue,  8 Oct 2024 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392248; cv=none; b=C8KArFP1k3PocCxcmSAvvRKtWpMO42f68DyfgTnnJShJA8FevxwVGfJuqtGYSuQPXbnyw2x+SwOJFRYiUF60LhEcv4u6ElhzTCIopri8xyUgR49HS3ocQui53rnWwJWpuC6b0pcs51VNmJMQSOWzgQGohpgxze/gt3Bo6ydU5os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392248; c=relaxed/simple;
	bh=4DQbEMVRRPF007lTkKB4GeCHFAQn3/fJPVs9GPnaVvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbZ6DV/UpylYo4fP4xqNsLzCCoaoQhQvyIG8qVeytJeK9nmbXD3224SPJA1pbIkDmrpxcf+5/M9kUGS0ncMUvXXXj27fOhNSoZvSM6QyeWOaSR3RsddgRbtheq2RXR6RL8bu4ErndfJ0a107krdXmfWkzDKvv4OKfIXSh+Bq2Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrrfnZcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrrfnZcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A4FC4CEC7;
	Tue,  8 Oct 2024 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392248;
	bh=4DQbEMVRRPF007lTkKB4GeCHFAQn3/fJPVs9GPnaVvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrrfnZcqL3/5Gt1PdYrna0OwhD+xjjAT26PMs9cUdaKYCH++gkbpyQmlEXiMsWB5L
	 BHgKovAKH2AQm+LiLVwXtfAiJMQwqBLXwCrO3/wyIC0/HW9zXe/jG2dMUOKBN92k8U
	 Ddl3d6C9mtp+EUqKSUutTyDKRah+crq0rhvlulAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 342/558] f2fs: increase BG GC migration window granularity when boosted for zoned devices
Date: Tue,  8 Oct 2024 14:06:12 +0200
Message-ID: <20241008115715.760502054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 2223fe652f759649ae1d520e47e5f06727c0acbd ]

Need bigger BG GC migration window granularity when free section is
running low.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5cc69a27abfa ("f2fs: forcibly migrate to secure space for zoned device file pinning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 12 ++++++++++--
 fs/f2fs/gc.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 5cd316d2102de..9a3d3994cf2ba 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1728,10 +1728,18 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 			sec_end_segno -= SEGS_PER_SEC(sbi) -
 					f2fs_usable_segs_in_sec(sbi, segno);
 
-		if (gc_type == BG_GC)
-			end_segno = start_segno +
+		if (gc_type == BG_GC) {
+			unsigned int window_granularity =
 				sbi->migration_window_granularity;
 
+			if (f2fs_sb_has_blkzoned(sbi) &&
+					!has_enough_free_blocks(sbi,
+					LIMIT_BOOST_ZONED_GC))
+				window_granularity *= BOOST_GC_MULTIPLE;
+
+			end_segno = start_segno + window_granularity;
+		}
+
 		if (end_segno > sec_end_segno)
 			end_segno = sec_end_segno;
 	}
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 245f93663745a..78abeebd68b5e 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -33,6 +33,7 @@
 #define LIMIT_NO_ZONED_GC	60 /* percentage over total user space of no gc for zoned devices */
 #define LIMIT_BOOST_ZONED_GC	25 /* percentage over total user space of boosted gc for zoned devices */
 #define DEF_MIGRATION_WINDOW_GRANULARITY_ZONED	3
+#define BOOST_GC_MULTIPLE	5
 
 #define DEF_GC_FAILED_PINNED_FILES	2048
 #define MAX_GC_FAILED_PINNED_FILES	USHRT_MAX
-- 
2.43.0



