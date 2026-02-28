Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4450E375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302577; cv=none; b=QXi9EMd/HP2W7KIXjHcClltDvoNy+r+9rcho251nr+u2P4Inc2f11DxSEXXahYNccGNcsqJh4s2VNUQ3MgYqkxbs3WhV719DhJE7A6ZtZ0AGgPVmKoBcn3F2qTcAhUGon64R3kZ6gEKyN9LY2BbhAw5LmnOU2FoDKx0bbV8goTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302577; c=relaxed/simple;
	bh=YRV7HOKooWDvUn32rj/J6D9SnJW4VBGvnPsIloOZKN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RewHNDdU3BHmlisCAK40N1FS0fs+IaPHMg8DgsylYx9XZu56+0BLcxwepYJjFnA2cZsw29NhPBjYlZsGvKUfbopXz6JldSyiyLlxfNY16PFlT7mOWS4ycbkRo9hyvWXHasQqFiGKkaGHEcuxCYTMzm1U0ADPsBNelb+4dVFptWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ij8XkAHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ij8XkAHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B42DC116D0;
	Sat, 28 Feb 2026 18:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302577;
	bh=YRV7HOKooWDvUn32rj/J6D9SnJW4VBGvnPsIloOZKN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij8XkAHKS7r0zQkbD2Thz66gxm0qOVBlKd5nnMJY6gk8pg/HE6wp3WDGe8YbV3sGM
	 zzaG4a0MsdGQUtWR1xXelX9xDHNcuSMiO2lZIXzgrQ99hlHwz1TRz63ImTkSkRczJn
	 OnFGYXNqiqXcD+b2nlx/CyKzw4/hJE+fcystoKw/ZSNcSbxFDaGjdcpa6/Iz1e3+nG
	 8YIkL0UzM09RPgLZkY7Fe0/hJjltZ4Jyoekbpay2Kg3TMyh1RQxGmYTEECqjqcVcnT
	 AoYHvnp4WbFSAhYvotq9RPpcID6/RGN1mn3fRSOzuFZCripWGoz1EdldDsB/9qAEl+
	 mdNn+qiwA2XCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/164] net: hns3: fix double free issue for tx spare buffer
Date: Sat, 28 Feb 2026 13:13:44 -0500
Message-ID: <20260228181505.1600663-85-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index ac5d7ea206bb2..309593ae2d073 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1041,13 +1041,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	int order;
 
 	if (!alloc_size)
-		return;
+		goto not_init;
 
 	order = get_order(alloc_size);
 	if (order >= MAX_ORDER) {
 		if (net_ratelimit())
 			dev_warn(ring_to_dev(ring), "failed to allocate tx spare buffer, exceed to max order\n");
-		return;
+		goto not_init;
 	}
 
 	tx_spare = devm_kzalloc(ring_to_dev(ring), sizeof(*tx_spare),
@@ -1084,6 +1084,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
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

