Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B7827B330;
	Mon, 18 Aug 2025 12:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521623; cv=none; b=SFDf2I6CEuJg5IPw8YVicMaxwbgNAiev686+Rd6p+i89Pjx1I9EgUvwFVodt1H2O7mzo81SVS5gOBTo1QmguWhEmlV1dT7EGGrJnzfbGJTEw43C+a1mbqw+JvBCKL1WDvcVJ8iNs1aaUOQjg85N5cap0uBSmfRjgLintPwQtdGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521623; c=relaxed/simple;
	bh=1ABijm6baDJbTKOhp4Gid9mEwq2stuc0hCEzlyFkxCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSMj5Ze5DAsuZouNnUTsXV0+RfOpVKJbwjKZoxy/4TvMP8ADbNUKe6P6nTgyrlFSliRm5On/MsZr4oCqHpJXJLL1ZNElJln89El7m+1RZQHK+7cTATa4D61ULmPKC9pf1oJF71MU/sRjeA1zhui12FcXPUSLNWmJ0SvoZ0TAyQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVx91Y9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVx91Y9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ACAC4CEEB;
	Mon, 18 Aug 2025 12:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521622;
	bh=1ABijm6baDJbTKOhp4Gid9mEwq2stuc0hCEzlyFkxCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVx91Y9h7QlhSQ4SgU1wAHmHlSwp5SzWdRlm5vv90oUPEkyMHV+JJviGqJI10Q5fj
	 lDLoRyx7gGHbBFCpD9PUwdGF8dJsVdRk8z2tfKtWkRDretsSgsj7YuUgE63IdWNMiR
	 TG7ziqtM+doMMOTwxpr7gvX5++OkSrBYbR+4DQSE=
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
Subject: [PATCH 6.12 074/444] md/raid10: set chunk_sectors limit
Date: Mon, 18 Aug 2025 14:41:40 +0200
Message-ID: <20250818124451.730891328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5cdc599fcad3..7515a98001ca 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3968,6 +3968,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.39.5



