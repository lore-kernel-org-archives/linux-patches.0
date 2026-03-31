Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D47423A62;
	Tue, 31 Mar 2026 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976352; cv=none; b=svlp+Nek+fEqqUHuOGCLdNuTRUCpiVH5D73fdff8Hmz5v4H4+leq6nDFa08D177FabOZfLycCD0ZvWZinMMZfWWy/+6P7NpMvqb0frvZCllumKxHHZifOM0BOMhYLXzpmmDNqwQv35qB3WUnuPvXPWQwfQgJeVMJSkoyndCno1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976352; c=relaxed/simple;
	bh=6uAgjEFg+lsDv/awMLBO5u8962OMz+SUWEodQnZa6qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPYja27JAZgzT4ZakEwhRP6e/mhCT1uvd4PVXRr2KJUc3cLyxfUC09Vkzkqo9rQ9wEHBhbpldba8Qb3pJkhkcLMLpIq3UW20+UySCwrocZDwbqyx6S67QYMYFo9vcHC+WdK9wTKUTBIj6IiTEqSDVPkBBUF+wXfH7DKi/PgAQjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5UvP2MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5UvP2MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C87BC19423;
	Tue, 31 Mar 2026 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976351;
	bh=6uAgjEFg+lsDv/awMLBO5u8962OMz+SUWEodQnZa6qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5UvP2MGfpyZmTSaftQWvjYhWw6vJGWV8VNQksFFipg2WUqH7D7+m6kGNdqHIbdg3
	 //TWn5RJQ5es1cfYMLH+rwZRUEZ3yJZUaH2HtLgJr9TAKUMWMFQPX+qerVLA520x1x
	 QllQg4ev5Oq1mwiFkebrfAazKhdS3+sXWOgXZ5Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/309] nvme-pci: ensure were polling a polled queue
Date: Tue, 31 Mar 2026 18:18:49 +0200
Message-ID: <20260331161754.441504634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

[ Upstream commit 166e31d7dbf6aa44829b98aa446bda5c9580f12a ]

A user can change the polled queue count at run time. There's a brief
window during a reset where a hipri task may try to poll that queue
before the block layer has updated the queue maps, which would race with
the now interrupt driven queue and may cause double completions.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4459687eb7bb6..a64b4b4a18a19 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1430,7 +1430,8 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 	bool found;
 
-	if (!nvme_cqe_pending(nvmeq))
+	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+	    !nvme_cqe_pending(nvmeq))
 		return 0;
 
 	spin_lock(&nvmeq->cq_poll_lock);
-- 
2.51.0



