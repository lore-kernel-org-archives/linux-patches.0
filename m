Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FEA3B19B9;
	Sat, 17 Oct 2026 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259907; cv=none; b=qf9qKrlCtuF8mJrGovIRkVVFli8snRHG50taYjmof6lSphfnzurkMZYIPVVbXjMDSzmiKTSPqS526b5J5FrrppAvUQ4gIom7dCyNtm5TuqcBJ72/KqOpj2xdxu70So9oRXcM5MQlQmOtDrpyUnMlWdDkDuOdMJHZsIP5s5Zzkx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259907; c=relaxed/simple;
	bh=SlIyxgxI+vES1ZmcUt7uAGEJ95zTLGu8Ud5XlpDhmqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibu1HwJcekpERBzRKhhASBpfSihWCiRuOF7yX6Ys1QT0l1A2OWW3MTlgwJjDS0djmuBEpO96Oc+Odg0NJIG5KatP/NLGKJDQamtQJk6lzTXCC1hAginPFOMoYcTLfaChgWE63qMF3s9qsiMhZmuVpxeKz9YtUGq4nQ6mQJ8YoTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIi4oq2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIi4oq2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DD11F000C4;
	Sat, 17 Oct 2026 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259905;
	bh=BXegAsxkUZ8MnAiP2Nygb55UUJkCIy+L+ArwLOM+55Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIi4oq2XQmVljV3mD1oYyuaSb+ff1k+aJk3RQ6fZGzLapDGOyhF0E/1uzQwkpcd/y
	 q+dtZ+rEbp1xJPuKTLG3bZdDAUEksC0OM02p9tETiAr5BIrlVqGuw2QF3r2Z3fLT4N
	 DMcvFIJVHWK3AaevY2PhC/9MoHjqvitgq/yPGwa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1328/1674] zram: set default primary compressor in zram_destroy_comps()
Date: Sat, 17 Oct 2026 18:00:00 +0200
Message-ID: <20261017160505.233402496@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit dde75313eed0b014c437f48dd75c0308b592cbf9 ]

Patch series "zram: fix zram issues reported by sashiko".

Sashiko drove by and reported [1] a couple of zram issues:
a possible BUG_ON() in zlib code due to missing winbits range
validation and one possible NULL-ptr dereference in zcomp.
Both are low risk yet still worth fixing.

This patch (of 2):

zram_destroy_comps() resets all compressors and leaves them set to NULL,
including the primary one, which is invalid device state, as now
comp_algorithm_show()->strcmp() can be called on a NULL compressor.  Set
default primary compressor in zram_destroy_comps().

Link: https://lore.kernel.org/20260729045745.775973-2-senozhatsky@chromium.org
Fixes: 486fd58af7ac ("zram: don't free statically defined names")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com [1]
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c83ef64521ee5..966cb1842343c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2023,6 +2023,8 @@ static void zram_destroy_comps(struct zram *zram)
 			kfree(zram->comp_algs[prio]);
 		zram->comp_algs[prio] = NULL;
 	}
+
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2040,8 +2042,6 @@ static void zram_reset_device(struct zram *zram)
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 	up_write(&zram->init_lock);
 }
 
-- 
2.53.0



