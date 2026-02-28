Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49824346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302053; cv=none; b=dNZOGcbQodvwF3mUGRhuGmnDWIhOMVB+Pp78cH7EST63wiwTTfudOf6oEPm8zG+k50Tn+DvI1QgN+HbDgDovoxyMomQqIvA3lhQMIvlGkGpGgA9q11z2BzXgsu5QffUT0tF4MgiG0Uv4+QxryvObYBYAADCSu/1h178B+jLsMZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302053; c=relaxed/simple;
	bh=ndORs8QC2SjPfC5CI8YwB4pv0eNT7SXHR30TkvdMt4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihXSLL89GW8uDfxj7KB+5hrgucayrD2w7AuE4IQfMpBrR4WcApckT10sgOfqcQJvQkE889T+DnAB8wSJL6fXkh40g+Av/23QSROA5tHahqbMq/W0PTHKDVDnL0YGQhE4M2rdcVj5MxTmmGNnPAI4ZyghtkUCMzFiq/WUKryBdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7Lf+R0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7Lf+R0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970A9C19424;
	Sat, 28 Feb 2026 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302053;
	bh=ndORs8QC2SjPfC5CI8YwB4pv0eNT7SXHR30TkvdMt4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7Lf+R0Xa3nyGbtKIyMYkcJL5dHpLv1E3JyGT8PdHlU6uQOdMCaVX+F5XEe1MSdBU
	 tydU6sgzne5HrzCWntP0BCKtLhUlR4gwKLTL+Gewli99pQSwV6eN8NOtj75YepsrPp
	 NMRlzblwX56bZk645ufBHs1jq/Gnr28yNi29y+Gl1VSE4NHTQnayOQr7BgkIuwIY40
	 0ChY0iIrif4mc29QtHkQm19UXms6rveGayJq0OahqmAfik2V8l1QQnFgzPTbmW9fYr
	 o+ifrxFb0lq8a7cg64pgNngwkoLJwggzjaL6JKzAFzmeYfcyPrYJkGXgSwvyoSYF9W
	 F6l3uecgr1c/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/283] md/raid10: fix any_working flag handling in raid10_sync_request
Date: Sat, 28 Feb 2026 13:02:50 -0500
Message-ID: <20260228180709.1583486-28-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 99582edb3f62e8ee6c34512021368f53f9b091f2 ]

In raid10_sync_request(), 'any_working' indicates if any IO will
be submitted. When there's only one In_sync disk with badblocks,
'any_working' might be set to 1 but no IO is submitted. Fix it by
setting 'any_working' after badblock checks.

Link: https://lore.kernel.org/linux-raid/20260105110300.1442509-11-linan666@huaweicloud.com
Fixes: e875ecea266a ("md/raid10 record bad blocks as needed during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a75d090a7fa15..8546ef98bfa7e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3533,7 +3533,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
-				any_working = 1;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3548,6 +3547,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.51.0

