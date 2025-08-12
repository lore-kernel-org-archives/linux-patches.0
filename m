Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3262E4248;
	Tue, 12 Aug 2025 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020777; cv=none; b=rNIXwCxvX/ynY/fG6GCbp8xsUHB0eZPizbZSXFeCJ3fGC6Xs6sMVDl35Xs05/WyrcW1cCi0HIoWYypvaVHFR3xvtGVjXvD71pQz6h/aUl0nrKZt4UGT1sY7GakKHZxrxbchcBZePvvyoIDJUZEBkAI6QZlPDochTHOFPcYJaiGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020777; c=relaxed/simple;
	bh=uyGG4bnGaHdcq6rhjU0vTf4OOPDGyKqWqxtzidw6AEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq1fsmE/DH8jvgJ9g08t4vZMIKRdKaTqkze2REulf0u+WkuTdInjmfHSdfJCM0cWvE+FByB8PHh7C0BHtQ5A1qA+T/tkBcQ+rdhapH/UjtRPmpD2RpwQ1IlDQtEpNTt8mHJaZLS+aaANqO+lgT6rRSdYy12IR7+LQTGaTN0LR7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaEt0nWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaEt0nWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD8BC4CEF0;
	Tue, 12 Aug 2025 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020775;
	bh=uyGG4bnGaHdcq6rhjU0vTf4OOPDGyKqWqxtzidw6AEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaEt0nWmNrZDp6hB5d7DxvvCUDi5V8btQhgbnDXh8bSVn99z8e2S0yEARwDe1hRmP
	 plvPNsZi8sKsQNY84qifwNrsD45t6ntIZGnB+2/HffSFsirhjelfReGKBgEkg+ZWPz
	 MC2/ZQBP4OCV6DVuTCZ5ISFgKmur02jLr7IHeQYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/262] ublk: use vmalloc for ublk_devices __queues
Date: Tue, 12 Aug 2025 19:26:37 +0200
Message-ID: <20250812172953.374234535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit c2f48453b7806d41f5a3270f206a5cd5640ed207 ]

struct ublk_device's __queues points to an allocation with up to
UBLK_MAX_NR_QUEUES (4096) queues, each of which have:
- struct ublk_queue (48 bytes)
- Tail array of up to UBLK_MAX_QUEUE_DEPTH (4096) struct ublk_io's,
  32 bytes each
This means the full allocation can exceed 512 MB, which may well be
impossible to service with contiguous physical pages. Switch to
kvcalloc() and kvfree(), since there is no need for physically
contiguous memory.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250620151008.3976463-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 8c873a8e39cd..ec6d7a08104d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2030,7 +2030,7 @@ static void ublk_deinit_queues(struct ublk_device *ub)
 
 	for (i = 0; i < nr_queues; i++)
 		ublk_deinit_queue(ub, i);
-	kfree(ub->__queues);
+	kvfree(ub->__queues);
 }
 
 static int ublk_init_queues(struct ublk_device *ub)
@@ -2041,7 +2041,7 @@ static int ublk_init_queues(struct ublk_device *ub)
 	int i, ret = -ENOMEM;
 
 	ub->queue_size = ubq_size;
-	ub->__queues = kcalloc(nr_queues, ubq_size, GFP_KERNEL);
+	ub->__queues = kvcalloc(nr_queues, ubq_size, GFP_KERNEL);
 	if (!ub->__queues)
 		return ret;
 
-- 
2.39.5



