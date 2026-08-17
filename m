Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FCA442FAE;
	Mon, 17 Aug 2026 13:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975063; cv=none; b=WRCWpWxovXZOIWQNklGQR6Zl9SqMH9nVJqiKaIlAjJS5iZMP9HfLu6ATxlZuubHDAgITA0gM66enkhZUUBs4h+vfa1UTRTk21Zq5CcQ+/NtKsgH53ONooGbKgS0kP0qKVf2PisKORaOti59eTslZW772667ypgoXPhQQ+gnBrKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975063; c=relaxed/simple;
	bh=RMHiL7B8BbxfKDmdRUE6FDMXSNhzB+feQve/eqFDHiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol/uZ8CRFSBGGd9XOa1vo41VDgHmgWjaX8XLZPhj60AG4vyzekXyjTXBZE5HIkIDYRpPKhZH3TC+HZ/Utml9Or9K0MLpmlC/UwQnUH4bS3KjC6BQeF48u67ZO9uQ4oXkD3MY3WwnMGNjerxlWId5vQkleWJj+QndJgSS+QpfPIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t01gtPwz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t01gtPwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2801F000E9;
	Mon, 17 Aug 2026 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975061;
	bh=eIhzfpZpYTPah1ei16W9eu3b0N6Gq5l1nDblJ5o1YCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t01gtPwzBnYAYpJ+8W7Nt6BFygdMlh2nj7xXJ/2KJSmY9wXVbiA8Zq7eugxgZBE89
	 6znDPRlqOHV7z559qb3i57ZMQviRRVvVd9kPXGIRgmtDlNQi6sEZako+C6k10nesFK
	 oZ/1HR+QfYkVm3RU3STjUGw0k6t5+BTtOO3I2eBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Liebold <simonlie@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/250] blk-mq: reinsert cached request to the list
Date: Mon, 17 Aug 2026 15:31:49 +0200
Message-ID: <20260817132542.594873339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b051bb6bf0a231117036aa607cadf55be8e63910 ]

A previous commit removed an optimization out of caution for a scenario
that turns out not to be real: all the "queue_exit" goto's are safe to
reinsert the request into the cached_rq's plug list as they are either
from a non-blocking path, or a successful merge that already holds the
queue reference. This optimization is most needed for small sequential
workloads that successfully merge into larger requests.

Fixes: dc278e9bf2b9 ("blk-mq: pop cached request if it is usable")
Suggested-by: Ming Lei <tom.leiming@gmail.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://patch.msgid.link/20260526153531.2365935-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 711d295d36db9..56158b70d0c72 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3224,7 +3224,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (!rq)
 		blk_queue_exit(q);
 	else
-		blk_mq_free_request(rq);
+		rq_list_add_head(&plug->cached_rqs, rq);
 }
 
 #ifdef CONFIG_BLK_MQ_STACKING
-- 
2.53.0



