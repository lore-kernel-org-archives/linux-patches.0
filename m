Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD681A23B1;
	Mon, 23 Mar 2026 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277986; cv=none; b=UAuK1uTD1jYIT9R5/8GhRfjVqg88g0Yl6pQerZ28LjK865d3pjtX4JtKapew/PfFLJPGTIORhNgou1GYrtLqAZxKpTiD0OhmLbVYaDfajZUA9dufHyrpno1xKlkxs7F9voqO5n0k+hudQSQlHF8ROasOZ9DvPaBGVobip+0Uc0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277986; c=relaxed/simple;
	bh=yc1T2Dv0fZZ+Cen+F2mDBvverlCdwLpnh/9u03OE+1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AW//6N+/uKtcqkLnNEzVc1iZ24IKWBKciVVbAoGiQXOHhsAIPjw+rwVySFjjVgyXZuB05BWD0s6gTZgHOjz0K9ybwDvF8exrgep8+LPs12tSwPrsrL+L2jxHYjuWXUURvo60ApeRDOKtZhZTCS0P8RnsrYUkJbApg1aNW8z8kkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPEoi4Fz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPEoi4Fz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5283EC4CEF7;
	Mon, 23 Mar 2026 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277986;
	bh=yc1T2Dv0fZZ+Cen+F2mDBvverlCdwLpnh/9u03OE+1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPEoi4FzIEsd9Ulg90T3WY2hbasusmPVDuewvrmEVslWV/G7lXDFLB8PaZe1m8jD0
	 al03LAKmDug+hP7RD6ELAS6tWLk3pf1L2D7ppSZEl8gUDqWOj6SuBwZ2b6bXCflGdU
	 CAE8cWCsatrrpUlNVWGkRHNFGBzRCa+i2gtI7JMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/567] nvme: reject invalid pr_read_keys() num_keys values
Date: Mon, 23 Mar 2026 14:41:25 +0100
Message-ID: <20260323134537.905170809@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Stefan Hajnoczi <stefanha@redhat.com>

[ Upstream commit 38ec8469f39e0e96e7dd9b76f05e0f8eb78be681 ]

The pr_read_keys() interface has a u32 num_keys parameter. The NVMe
Reservation Report command has a u32 maximum length. Reject num_keys
values that are too large to fit.

This will become important when pr_read_keys() is exposed to untrusted
userspace via an <linux/pr.h> ioctl.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c3320153769f ("nvme: fix memory allocation in nvme_pr_read_keys()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 803efc97fd1ea..0636fa4d6f77b 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -203,7 +203,8 @@ static int nvme_pr_resv_report(struct block_device *bdev, void *data,
 static int nvme_pr_read_keys(struct block_device *bdev,
 		struct pr_keys *keys_info)
 {
-	u32 rse_len, num_keys = keys_info->num_keys;
+	size_t rse_len;
+	u32 num_keys = keys_info->num_keys;
 	struct nvme_reservation_status_ext *rse;
 	int ret, i;
 	bool eds;
@@ -213,6 +214,9 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	 * enough to get enough keys to fill the return keys buffer.
 	 */
 	rse_len = struct_size(rse, regctl_eds, num_keys);
+	if (rse_len > U32_MAX)
+		return -EINVAL;
+
 	rse = kzalloc(rse_len, GFP_KERNEL);
 	if (!rse)
 		return -ENOMEM;
-- 
2.51.0



