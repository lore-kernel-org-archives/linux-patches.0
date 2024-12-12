Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4314F213E97;
	Thu, 12 Dec 2024 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015881; cv=none; b=JSrJwG+dTUsBLpuO+cntTH2UyVr2DCHcn9UaWVJ4Vg4/P5Lp/fYTUGJgIZjxWvg2njbZz/DCna6DMLuIipaOOA0GsSpygN+Focok7vYJTgIVDw5udpQ/KGmopoSJM3lk86cUypUyFzj/ZaQ8uQcDzx/3v5+YwZtwzgr9depSUAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015881; c=relaxed/simple;
	bh=/5WVnATKEVUg7AZiCStoIux6c/7yxVjExw9MdyjMcAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bcjp+d2GQ5bHp9FKdN+J7YHgpo1NsGgMCYGmFGp3ZtUvMfHbDQOHoSZcVzLgO536Xzr+vcQwMUGnTrDPkdffr9T8tRmXr9T94Pfv2k6CQ5T6AJI4dihDZBy758wLwzgk53WBSIGs1ok4SYGK7YomhB6OyAW+od5LZGnzoaBgY+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYEhkQuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYEhkQuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725C0C4CECE;
	Thu, 12 Dec 2024 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015881;
	bh=/5WVnATKEVUg7AZiCStoIux6c/7yxVjExw9MdyjMcAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYEhkQuAIyrMJf6GVbdcf4MnD/g9Fn3r3UwBYIf3AecVbijKOPQkTz+gvhgsTuomN
	 xSYNyV68tfT5zT9uE9D2th4SiK2/x9yhMm8iOs6n5dawLgFWZBBGvyBRf9LMGQGRJE
	 NplUfiscPTC/d8dz0kJ3nsbdxiTXWSnqWHvB/qxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/466] zram: do not mark idle slots that cannot be idle
Date: Thu, 12 Dec 2024 15:53:59 +0100
Message-ID: <20241212144309.581555754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit b967fa1ba72b5da2b6d9bf95f0b13420a59e0701 ]

ZRAM_SAME slots cannot be post-processed (writeback or recompress) so do
not mark them ZRAM_IDLE.  Same with ZRAM_WB slots, they cannot be
ZRAM_IDLE because they are not in zsmalloc pool anymore.

Link: https://lkml.kernel.org/r/20240917021020.883356-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: d37da422edb0 ("zram: clear IDLE flag in mark_idle()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d6a1ba969266a..d7f7cc31aaa69 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -298,17 +298,28 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 		/*
 		 * Do not mark ZRAM_UNDER_WB slot as ZRAM_IDLE to close race.
 		 * See the comment in writeback_store.
+		 *
+		 * Also do not mark ZRAM_SAME slots as ZRAM_IDLE, because no
+		 * post-processing (recompress, writeback) happens to the
+		 * ZRAM_SAME slot.
+		 *
+		 * And ZRAM_WB slots simply cannot be ZRAM_IDLE.
 		 */
 		zram_slot_lock(zram, index);
-		if (zram_allocated(zram, index) &&
-				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
+		if (!zram_allocated(zram, index) ||
+		    zram_test_flag(zram, index, ZRAM_WB) ||
+		    zram_test_flag(zram, index, ZRAM_UNDER_WB) ||
+		    zram_test_flag(zram, index, ZRAM_SAME)) {
+			zram_slot_unlock(zram, index);
+			continue;
+		}
+
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-			is_idle = !cutoff || ktime_after(cutoff,
-							 zram->table[index].ac_time);
+		is_idle = !cutoff ||
+			ktime_after(cutoff, zram->table[index].ac_time);
 #endif
-			if (is_idle)
-				zram_set_flag(zram, index, ZRAM_IDLE);
-		}
+		if (is_idle)
+			zram_set_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
 	}
 }
-- 
2.43.0



