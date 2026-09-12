Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B9647CC99;
	Sat, 12 Sep 2026 13:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218707; cv=none; b=gxRon/LtY4okRc2SdwEXc/kkbScf3PsgHLvHQXBqhPlPb0cwqo5UJopSHOfity+ezZu98WOsOKmFZM79ObTmDGaTOGhlK6lMBPIdyqY15WFv8yT7snsCMt66BYXh1gv8zUQwXD7t1WnKSrshvw4CepTDeY311jckofYNjKfB6X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218707; c=relaxed/simple;
	bh=xNGJrCov2mjRvSyZZBAtEghv8hwt7Ymo+pgKgX9jboE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGBhuKSPUTXgZ/f6xqIXa5Kv6MQnkYp7wHL28BnXNEelaYlaOd/wHdYvR9XMVqa84LVv9KuP9sow5expRHnuVwa8jJVel5g6J2q5vCNFlcjJ1DJ2KRy1FagAUegSBy6pwNsoUvBlIb7kvZujnuGXiVbWX4psL9xrMxot3loBaQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yP0IFIiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yP0IFIiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EE91F000FF;
	Sat, 12 Sep 2026 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218704;
	bh=bXfa5Z0WpnrJXRW7onSdy9JDPILLcf1P5g2168PWGoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yP0IFIiD/3EapctQ7Du4Q0/sgV7GtHAbrXii6gXpQape3bLcdRaocKFNB3uckSxQT
	 zLn4hAQlbJjT8AaoRYsvxLIxWbI/Q0l9wFSdEwOXis5nobP6S9mDqcxrYlY9P7g2kz
	 kzJLftBwFl0maXbSjaOnY3LYF1A398UhKe3p/Lt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liujinbao1 <liujinbao1@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1197/1376] f2fs:Fix incomplete search range in f2fs_get_victim when f2fs_need_rand_seg is enabled
Date: Sat, 12 Sep 2026 09:00:23 +0200
Message-ID: <20260912065634.226687982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index efab91076802d..d66f201dd4a88 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -317,10 +317,11 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
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



