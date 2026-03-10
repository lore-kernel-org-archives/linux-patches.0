Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84368425CE1;
	Tue, 10 Mar 2026 11:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142186; cv=none; b=TH+gUAokdQw07gkDWW6eRYIMy0tuX/lKSuArmfUzPySogdU/c7ikguinizTeVz46HVA/IifT5rMUh6/txt+4FebIF/InPJF0rFN8NkVj57tBNMg0I29bSru8ytmdCifRtckZxdLoTin2dh+8KmSbCEfBr3mrx7+JyBsj+tlj6zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142186; c=relaxed/simple;
	bh=SSqM5fT6f6XfxbAZe2g4WzfsVDhomXBV9dQy8wEEOoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBo2S5jBCaAT91R4btyAYWP03psIXDMbLUDNpEqR59tw04aRALidm6bOo0jao23x9LnFB4LPa9G8fEf16PRG0a7d/IivVylJqxDwpTtugYI7aaTh2u/7Ye2x3z2psXdZMtNmC9tSR+JNQqh2qyBMkiF7jwBUUYGHQ4D4bkAFHtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEiPQ+Cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEiPQ+Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC55C19423;
	Tue, 10 Mar 2026 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142186;
	bh=SSqM5fT6f6XfxbAZe2g4WzfsVDhomXBV9dQy8wEEOoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEiPQ+Cgrkk4hAXseacBkiKB7peke3ROC8emwabU0XFuu/AL8e8yF6hXJ1P9bBfcT
	 vrtvNjleFwn2uXREDmEKdjUspuCq+qkcG0JkQHsqxV0AhZ1zkaipZ5xxdP7eCIbEYR
	 ClZD93fJtEcmBiGI5snjwZzeHWYWgEy09vlw8Jn/y2irJq1X/+5B2fxCoZo6lieTe1
	 r2c7oWPlLnUhsy81ZbAsOKbl6N3jFGCHXtoKw/z0ohUNKAVjwco6h/NEH91gL+Ls5H
	 +PPzqCr6fKsRkkZDVqyhybERIXxSL0+zAUoqimEEYaBHPBEKO8GMtaU1gjvj9RhC5x
	 G77MppSYGxpeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/314] nvme: reject invalid pr_read_keys() num_keys values
Date: Tue, 10 Mar 2026 07:18:54 -0400
Message-ID: <588dabd39c9f25f5a4f69c65678b8a88be562e5d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index ca6a74607b139..ad2ecc2f49a97 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -228,7 +228,8 @@ static int nvme_pr_resv_report(struct block_device *bdev, void *data,
 static int nvme_pr_read_keys(struct block_device *bdev,
 		struct pr_keys *keys_info)
 {
-	u32 rse_len, num_keys = keys_info->num_keys;
+	size_t rse_len;
+	u32 num_keys = keys_info->num_keys;
 	struct nvme_reservation_status_ext *rse;
 	int ret, i;
 	bool eds;
@@ -238,6 +239,9 @@ static int nvme_pr_read_keys(struct block_device *bdev,
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

