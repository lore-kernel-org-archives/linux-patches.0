Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306243D9DC0;
	Sat, 12 Sep 2026 11:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211606; cv=none; b=XlFLX+qVzm9prtDj6eKERzMTybQym+HKZks4KzL3aUrnzmE6ENYzl3vacJdcGRq/PTU8ITzQpufLWvPq1Ug8Pg7QF3SbLwTGye4+J95nPorbRGjreSz3+l4ERJwIJIk6U6FvXhttHroutH3RFIP6c+QWmPTg9IjqMavx6gEQZuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211606; c=relaxed/simple;
	bh=SKzhZYdZhB9MGn7W/Hp0XRz0y6QE1+GoMP80HFVOzf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLNsU2d2ZphW97nyH2Ov+JXDp5TUWjyKBo/fH5A+CO9sZwMVU/0+WYqJNfTHmqgaS77KmCHpIhkmaZS6PZBmkaqLAqZN779xUeT87XTW5QcGyRWiMLgDcDuTAuEzYKG/CVb6Xrah//OShcouyG5rwRjt5yPkcOrge0/oQZDM3iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4HhTcNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4HhTcNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67BC1F000FF;
	Sat, 12 Sep 2026 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211604;
	bh=pGlJj9dAkwTvVblyiYmOt8xaRCZJadnW/80UpuV7Fw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4HhTcNrKyvvCEZNffrba0gi8k4F75W1C6NPJJU5TTgd3Enj9FhbaHrFdppxfYQT0
	 9+XbL9pVqD3tFZ5BfbHc+Z5MWy50Nnc1NDuin998cHGk09EL7TXyXootRiNkXWUIqx
	 he4PeZPgTR6L9MggiquBhVihISvK5B1rUshDmnPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liujinbao1 <liujinbao1@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1265/1518] f2fs:Fix incomplete search range in f2fs_get_victim when f2fs_need_rand_seg is enabled
Date: Sat, 12 Sep 2026 08:57:14 +0200
Message-ID: <20260912065652.126461527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liujinbao1 <liujinbao1@xiaomi.com>

[ Upstream commit 5604129b6504c2d6dfbc02515c43e6186a1285e7 ]

During the f2fs_get_victim process, when the f2fs_need_rand_seg is enabled in select_policy,
p->offset is a random value, and the search range is from p->offset to MAIN_SECS.
When segno >= last_segment, the loop breaks and exits directly without searching
the range from 0 to p->offset.This results in an incomplete search when the random
offset is not zero.

Signed-off-by: liujinbao1 <liujinbao1@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 0a1703eba237 ("f2fs: fix to avoid pinfile fragment on fragment:{block, segment} mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 429fc5bd4ae0d..16e656681a1d8 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -312,10 +312,11 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 		p->max_search = sbi->max_victim_search;
 
 	/* let's select beginning hot/small space first. */
-	if (f2fs_need_rand_seg(sbi))
+	if (f2fs_need_rand_seg(sbi)) {
 		p->offset = get_random_u32_below(MAIN_SECS(sbi) *
 						SEGS_PER_SEC(sbi));
-	else if (type == CURSEG_HOT_DATA || IS_NODESEG(type))
+		SIT_I(sbi)->last_victim[p->gc_mode] = p->offset;
+	} else if (type == CURSEG_HOT_DATA || IS_NODESEG(type))
 		p->offset = 0;
 	else
 		p->offset = SIT_I(sbi)->last_victim[p->gc_mode];
-- 
2.53.0



