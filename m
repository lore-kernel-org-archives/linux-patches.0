Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4856F335BBF;
	Mon, 18 Aug 2025 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525018; cv=none; b=eQm6Pc9l9hjZr5Eo80H+yiDuVBOQ7XIKsI66MvYsGW+STJh/POTLlE5K2KtT+BMgrKi33tXgEU49qlLAALdgrhbZ/w2h9INKEFEgzlTG+jMrSXThSsPBdQbmQod4PuCsp/icUh4uklySQg6FEC63QOu+FSxvFANT/46tN0Opht4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525018; c=relaxed/simple;
	bh=ykJA7gqkuM67f6ZdJIwTgaoPZOj/GBAfR/hALw+DiP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OykFSlO98oBNr9+VchkpbcJrCgZ5n4euRM4L5/uDfsNRHyXhdB6MrK9rD+MfbBbnFqiU6FEOhnBqwg4Y6PUTHZTEGoXzfJbwzsVcA4uC+TDPQwawN+Vy07UxQojfQvrcLsGkZGmyDZRkRL0M2hVuoAH1sAnsCl0pj6Ov61UTeyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OazPkfxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OazPkfxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEDFC4CEEB;
	Mon, 18 Aug 2025 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525018;
	bh=ykJA7gqkuM67f6ZdJIwTgaoPZOj/GBAfR/hALw+DiP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OazPkfxn/pkLOTSUEdddQMTZ0WC8/EoClQyPafM9fdZ9vUvsz/ypl0Z0We24wV8nC
	 UjWMk4rRURVfifygNzOJxmht2S/LsrtLP74ycOrdn5vmSVySrBd2TSr1CSHeX/eUnm
	 qm15UE2BhxqnJCTJfv3o++9coti2h0G2gqzA2OPg=
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
Subject: [PATCH 6.16 102/570] md/raid10: set chunk_sectors limit
Date: Mon, 18 Aug 2025 14:41:29 +0200
Message-ID: <20250818124509.740415706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d2b237652d7e..95dc354a86a0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4009,6 +4009,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.39.5



