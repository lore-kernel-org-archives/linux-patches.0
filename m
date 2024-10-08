Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382E6EEC8;
	Tue,  8 Oct 2024 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390426; cv=none; b=nG6B9U7XVqRIaYoICP3d/9CWXisYdw+/tMbDWogE//TG5YjZ94qFodUZQ1jf3HFE/QKyjImd5L5GZ65+cjA/XQYZtRkw6dXdOeymleSm//YTjAR3TC6mBk6yRS12wCjpsAe8XLU2U9OoMNHDD/guUjkEpuo6P/t/q7I0K+6fmgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390426; c=relaxed/simple;
	bh=qX5dZH03xGSgwz6is5o6uPqUDsbB6IgP3+WXIcvl1MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F85io4EAT2mCD6mliTQNY4VZBr+b6BkXncOM8c1/3+dhfdbwby7H90o+M7goc8EGGHL/tyDLKX07zwgZW9EYyKFBioT0bqdjCtwwpBU5DGRsUhh9aOmvCom/0Bb+NmvqmdyoORHMqD+FMpDWzk5e6B1B6CELYTH2RkCorrjCRWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbPBiHvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbPBiHvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1238C4CEC7;
	Tue,  8 Oct 2024 12:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390426;
	bh=qX5dZH03xGSgwz6is5o6uPqUDsbB6IgP3+WXIcvl1MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbPBiHvyhMSzHs93lCmgVWFiiCZwp3ttKX1aZwlLa238VLjVs6H/CL3tn2aMK12UM
	 ruSVDVrXUUZeZIZCMEMgyYD4Llnh//6yiJxZ+6ctVc8RIH5K5CT54kMzuijuLsEQgZ
	 jJEQHUWek91h8U5SoORO3VRB8seLs+xuINj2TAnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 285/482] f2fs: increase BG GC migration window granularity when boosted for zoned devices
Date: Tue,  8 Oct 2024 14:05:48 +0200
Message-ID: <20241008115659.495014349@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0605f87d1aca4..e59a87dc5130b 100644
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



