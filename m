Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDF7258EEE;
	Mon, 18 Aug 2025 13:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523163; cv=none; b=DMehm+UjOtrJPRKeCds5/xI8SL8Uz62LuxyxvA8JW50Pk2x9NFK0pN34rP6r60iIg1GTWOvBRUp9yoL633Djm/tlkoJTyb5OX+6G6BJ+gH0a6k0PVub8UppTLDd7BrLKAmkAqkjhoRQEIemHDQoZkK8HEcGwfJj/CdHFPFA675E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523163; c=relaxed/simple;
	bh=HaxSj4MjrGDlj36cHGK4LnvOL85sukE9oS03vH3aF2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDO8cO3pw9IsljwwqBvtwKqUN+YniTqPCcst9cLmvCLnnraakewf8pyDYdyWRasXb0OnCRXNH8Ml2gRc2N9vnZ0FVOMt+LzR/q/Wsj+bFez7olxjIs7ejeHPJd59s/fnAaV+0EuQRmeSLlYh0M6JwcEDTflz2mFdg3vtGWolxts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5E2i7yP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5E2i7yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7DCC4CEEB;
	Mon, 18 Aug 2025 13:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523162;
	bh=HaxSj4MjrGDlj36cHGK4LnvOL85sukE9oS03vH3aF2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5E2i7yPOcHXlcquxFSizVZMAaDShf+eBpeag2J3oQD31bTDEUEF62vYMYPx5IwLG
	 Z7fpMAlGo6vstdr+6Ssnqjo0Y1pPTurlQBH1JF4BGwXvfC2JlpT9AkKO7x0+Pln77z
	 AdVjNG8fnU1Y38DT5rSQFbtjrngiV39hkDuzz948=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Yu Kuai <yukuai3@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 090/515] md/raid10: set chunk_sectors limit
Date: Mon, 18 Aug 2025 14:41:16 +0200
Message-ID: <20250818124501.838639599@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 7ef50c4c6a9c36fa3ea6f1681a80c0bf9a797345 ]

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250711105258.3135198-5-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6a55374a6ba3..e946abe62084 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4019,6 +4019,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.39.5



