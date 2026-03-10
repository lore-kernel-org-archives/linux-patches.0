Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE292BF3E2;
	Tue, 10 Mar 2026 11:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141176; cv=none; b=jXMgElRVhrKxkFgRxtjccBZQC2j66BkU/xgoIty7i3B2h0hi6qkTbeFQ8DPGr9aLB2MyNf2UlfNH0k1lgcbe3b+559tkYUAIS3EqIfUCS5600daLDzv5k2WK/+epPwCgilYC2USH5CELPBREdR7mmQZqp9GxRvGkoP8Gk+qGNwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141176; c=relaxed/simple;
	bh=5hp4d0IrKTGxDfCEc1npvmCtsztniXVnIfz7lvKm1uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuJqnCFerpcDGbYDBrOTQ89UTMWAIfof3jsrP93fzhFKMisFGx3iN0xcbLfMZsurXu7ykznJ+2lqtHRGGav9dVYLO3RWKbzO4ATMc4D5a5eIEDZsdD5tpoZWDDTbJzFutJEe1LZadWPqgUfA3ou2P96RSfRFYJQUquD564ucJXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhNXiBTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhNXiBTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCD4C19423;
	Tue, 10 Mar 2026 11:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141176;
	bh=5hp4d0IrKTGxDfCEc1npvmCtsztniXVnIfz7lvKm1uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhNXiBTDZ8rKGwSF6QkQdMCPfVN7U2vujCaz71SLZrKdqjs/2GHoUZ3iyZJE96A7F
	 tgpNKGaPRw1lMSwgapp9pRyH0SoimWMu8ke7bgOPdF9wM0jQn0VjQI3ClKdF7Rkhln
	 Yg4eYcLti95dLBJi+9n7r4FfNBJdacAeGRfLeHwNHk31c+VKfX9NyKknCaqu9JhhU3
	 xgc6LIr5PEfL4xRhJ5K8VCytfgJtl8AM0tRfiBJ+AM7G39UQy6EB46qoOu3cFCZ5k4
	 dB9aEFFTmsCXD9ILOZF9WkQI6iw0k97g+Mkbv4v602i3XzNC8GDrUXIVPlArQnxkjH
	 M98KuQB9BMKcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Yi Zhang <yi.zhang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 177/311] nvme: fix admin queue leak on controller reset
Date: Tue, 10 Mar 2026 07:03:44 -0400
Message-ID: <074c904577b441255c435bca66e3e0f146d3e632.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b84bb7bd913d8ca2f976ee6faf4a174f91c02b8d ]

When nvme_alloc_admin_tag_set() is called during a controller reset,
a previous admin queue may still exist. Release it properly before
allocating a new one to avoid orphaning the old queue.

This fixes a regression introduced by commit 03b3bcd319b3 ("nvme: fix
admin request_queue lifetime").

Cc: Keith Busch <kbusch@kernel.org>
Fixes: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime").
Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-block/CAHj4cs9wv3SdPo+N01Fw2SHBYDs9tj2M_e1-GdQOkRy=DsBB1w@mail.gmail.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7bf228df6001f..3fdcd73b95468 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4864,6 +4864,13 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 	if (ret)
 		return ret;
 
+	/*
+	 * If a previous admin queue exists (e.g., from before a reset),
+	 * put it now before allocating a new one to avoid orphaning it.
+	 */
+	if (ctrl->admin_q)
+		blk_put_queue(ctrl->admin_q);
+
 	ctrl->admin_q = blk_mq_alloc_queue(set, &lim, NULL);
 	if (IS_ERR(ctrl->admin_q)) {
 		ret = PTR_ERR(ctrl->admin_q);
-- 
2.51.0

