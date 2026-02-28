Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6EC38D017
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302154; cv=none; b=Ky7MKmYtoeqHDwxTofPIWZxahmB8faXZsTj3a9jKWp0HmDxFd5cntBUt3NAhtcNbxgtb3AqqDEyAQ5/rYNAdrRZJ+Ja2X6LqFPA78ImP8uPP1c4cE3DlSepyz6f9KUje+choCgkrFB2OgbSMyMbGO1W8jiUA6l2KTlzTS5xbigU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302154; c=relaxed/simple;
	bh=LlGOq97jJgWQlImjYiWvicZdxeg0RSESWxrE+ZkeZag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjeNQu6oAgpAoET3sP7Noahn5C4tLF+4WO4JpM5ObRugFo3bN7Dx1Ra4bvAWyrZWu9F3ub6R0TAeHfqW9DXhmVt2n3WQQ1ZyVnsX1pj7JIFDfbE2uyLbdwOXyIbsLK1GwJATS60gfPHdqa4OTkbwUn4Sg4dYHJy1V2PJxRadSsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGzEq5Am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGzEq5Am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40742C116D0;
	Sat, 28 Feb 2026 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302153;
	bh=LlGOq97jJgWQlImjYiWvicZdxeg0RSESWxrE+ZkeZag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGzEq5AmXQY/PMR5Hh1T9D1VIosCwI7uKViPCyqpGgW8mcfsnDQ4vrMaVc1d+1q+S
	 sU85pFU4DleAOSAq1ZyQUxYRT0UjZMiheucOyl4xsJmjQbvOh0XoiX0ljaGXMCV89H
	 11D6kqAskGU/Wa0Z9MsvkoWikzX1wg22EdSsbU4BMoeAUNrpkpW5va1JZBZ6qAXUgc
	 TvEBK5MysDF06b9i7yaZpCHXKGPafrLkTljlp0zVYWXBfUuqvQJFS611fWQVvpC+u0
	 3xoMg2WLFB0y0Y8WLvDGLM0VXoCTpFFPFDdRV3kK6NtdBiTnccH2tcS1cB8ZNWtwj2
	 I8MupHVDcTIuA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/283] net: hns3: fix double free issue for tx spare buffer
Date: Sat, 28 Feb 2026 13:04:51 -0500
Message-ID: <20260228180709.1583486-149-sashal@kernel.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 6d2f142b1e4b203387a92519d9d2e34752a79dbb ]

In hns3_set_ringparam(), a temporary copy (tmp_rings) of the ring structure
is created for rollback. However, the tx_spare pointer in the original
ring handle is incorrectly left pointing to the old backup memory.

Later, if memory allocation fails in hns3_init_all_ring() during the setup,
the error path attempts to free all newly allocated rings. Since tx_spare
contains a stale (non-NULL) pointer from the backup, it is mistaken for
a newly allocated buffer and is erroneously freed, leading to a double-free
of the backup memory.

The root cause is that the tx_spare field was not cleared after its value
was saved in tmp_rings, leaving a dangling pointer.

Fix this by setting tx_spare to NULL in the original ring structure
when the creation of the new `tx_spare` fails. This ensures the
error cleanup path only frees genuinely newly allocated buffers.

Fixes: 907676b130711 ("net: hns3: use tx bounce buffer for small packets")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260205121719.3285730-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 34627de2e311e..107e692e8c87a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1048,13 +1048,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	int order;
 
 	if (!alloc_size)
-		return;
+		goto not_init;
 
 	order = get_order(alloc_size);
 	if (order > MAX_ORDER) {
 		if (net_ratelimit())
 			dev_warn(ring_to_dev(ring), "failed to allocate tx spare buffer, exceed to max order\n");
-		return;
+		goto not_init;
 	}
 
 	tx_spare = devm_kzalloc(ring_to_dev(ring), sizeof(*tx_spare),
@@ -1092,6 +1092,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	devm_kfree(ring_to_dev(ring), tx_spare);
 devm_kzalloc_error:
 	ring->tqp->handle->kinfo.tx_spare_buf_size = 0;
+not_init:
+	/* When driver init or reset_init, the ring->tx_spare is always NULL;
+	 * but when called from hns3_set_ringparam, it's usually not NULL, and
+	 * will be restored if hns3_init_all_ring() failed. So it's safe to set
+	 * ring->tx_spare to NULL here.
+	 */
+	ring->tx_spare = NULL;
 }
 
 /* Use hns3_tx_spare_space() to make sure there is enough buffer
-- 
2.51.0

