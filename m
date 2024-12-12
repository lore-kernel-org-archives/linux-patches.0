Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75151547F0;
	Thu, 12 Dec 2024 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017706; cv=none; b=Svgq3eag/CzrCIEbQSn5xACpCQ6CzqEoxPHtMogSzjwwxCMJQ8jH1/G3D56wNkpJSu8Y9Wpp/Ncg32f4YxMF6TRinaM/pHt3k+JDqgBIO89hNlGlRtvq6JqOT4zcvc4JTdUN3Bo2nshGta+TEJNivYFe5p1wHjg6yM5L9EN/SJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017706; c=relaxed/simple;
	bh=CDWXQDml3CSwaQwj397TCJgzB7w06Cj2SnUiB2di6Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhrcH/1/Na+HO6iPvyTjf/ynSrngnqBPbslbSb/GuRhM5z5biXonLhlHsKNkHbd2Ecu5LCikUTslAnOeTBug6cApE/S0npQepgiHgKSccpmMUvRiokWCyslLZRllBZyeJekqg2F5+ii++0fSS1l41HHjVXKpl8vFUJwRn0Fp6Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tx549aak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tx549aak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4541CC4CED0;
	Thu, 12 Dec 2024 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017706;
	bh=CDWXQDml3CSwaQwj397TCJgzB7w06Cj2SnUiB2di6Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tx549aakeAgZOWEg2A4enleobx3Z9+pDeoTXKPTEXdvbS/5DIkIu9yc7vd9kcatuJ
	 ULP9FX8kDEtIA6Tv41LI4eR+SQcKjrmfg1WbjHpUKSP7RP+RrMPdDKDle2bMjqNWxp
	 r3wziIdnS/H4BNSVHWf7xKq+JHbPl8+qXinSMPBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/356] zram: do not mark idle slots that cannot be idle
Date: Thu, 12 Dec 2024 15:56:47 +0100
Message-ID: <20241212144248.097151129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 582df13bfde94..e05eace18cc47 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -297,17 +297,28 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
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



