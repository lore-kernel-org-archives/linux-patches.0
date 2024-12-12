Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32B8215F48;
	Thu, 12 Dec 2024 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015884; cv=none; b=JMaxB09NxmXsftwq+kF6lU1KSsIrDt1HsN14LJAE4p/N1BgEGJY/CaTKbgZeOPlCJz93A3Z9Mwh6Jug/5t/e0VU7rQjJWUplo93CBLR6Uetmglr2gyktT4sukU5puJK7cI9U6vPfsfKi1zSYey2RdxLjlJve58gOWGlh9uxbUbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015884; c=relaxed/simple;
	bh=reMvQwYreeWJHLr+lVtCy2dc+ESramFRt7bdEHMDVCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7LWH7gozluZweK5S0gceUry3Nj16PCs7j/zHrKsmKNaKmGAR4BlOODx5MkkxrtA+BBgmAUTtLZNbnXs5frgwMG2ndE8ogFTUOVks9ZhqcG/CuVOJej0xvJudv3m4DReQDEa6P9R0xJSPh1WUuMHC1dFNLgtJoqsbfzWJRZxvm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muNI2+gU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muNI2+gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0D6C4CECE;
	Thu, 12 Dec 2024 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015884;
	bh=reMvQwYreeWJHLr+lVtCy2dc+ESramFRt7bdEHMDVCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muNI2+gUhq1muczs58lNP4yASRpmnfVZSLBgDZdqkPQnBtAZCKh18jOgxPXhKfuwM
	 JSItrY2eOhodoh2FZ564OIXGAy+HcS0dizbCiORkEX287LeFzemM+86gvYLIf17qg9
	 xpVBQuarJNOjq4McF83A8mYypJ2dLd1TB1u2X+XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shin Kawamura <kawasin@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/466] zram: clear IDLE flag in mark_idle()
Date: Thu, 12 Dec 2024 15:54:00 +0100
Message-ID: <20241212144309.620164800@linuxfoundation.org>
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

[ Upstream commit d37da422edb0664a2037e6d7d42fe6d339aae78a ]

If entry does not fulfill current mark_idle() parameters, e.g.  cutoff
time, then we should clear its ZRAM_IDLE from previous mark_idle()
invocations.

Consider the following case:
- mark_idle() cutoff time 8h
- mark_idle() cutoff time 4h
- writeback() idle - will writeback entries with cutoff time 8h,
  while it should only pick entries with cutoff time 4h

The bug was reported by Shin Kawamura.

Link: https://lkml.kernel.org/r/20241028153629.1479791-3-senozhatsky@chromium.org
Fixes: 755804d16965 ("zram: introduce an aged idle interface")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d7f7cc31aaa69..d0432b1707ceb 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -320,6 +320,8 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 #endif
 		if (is_idle)
 			zram_set_flag(zram, index, ZRAM_IDLE);
+		else
+			zram_clear_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
 	}
 }
-- 
2.43.0



