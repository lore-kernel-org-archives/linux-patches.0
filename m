Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F048359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302390; cv=none; b=midfQeHBnP+PwF7BX1q0Pqspcdh3wGRzHb7BciYxvFnirhXJhgdCPjJj8xx9jDlkYWc4lz/Gy/3G9PelMONXT8fGT4HYTtyiAHmHT3hSPPgsAsCVTCR+461jehnoBwlmTUW4wvkHjdx4h+reaoEsKXcphTl1/60uTePhzMWxgps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302390; c=relaxed/simple;
	bh=pBwBDAOc1/krHR6iEJP0OD4Q6I3LQAhOPb5EXHtiHrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqg937UzkRbOWWvEhsIV4/P/Ar3Uww9A017kc7oW5NSCiE3ur7am3XAPIjY0Va7Q/JknAtyGHF6gd9hi/lCxR5IFJ0jxjB1PuhETMGBifNe87xZPeWLiJx4N78L1yFTM9PddE6lujfk3tw8H8EVf9nk9F9wVTU7dvQRH1hFTTAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGhw3+NN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGhw3+NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C667FC116D0;
	Sat, 28 Feb 2026 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302390;
	bh=pBwBDAOc1/krHR6iEJP0OD4Q6I3LQAhOPb5EXHtiHrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGhw3+NNfdPtljJf683Nh0U2pXCmh/w5KXe4/i5Q7Xkz+VI3y0BHrgcgQq+wVJF3T
	 rBIVQHe77fJ1curlmzmd/kAup6vABughJXHMwb6VDJOYb4B4b9pUN3YT6Tr8xzEuIN
	 RXAD2NmRjAGQX/9BwRVlViWQPwB+NRV1ZajxEThMU8An8BWTKR5RTgBJDmfQsYAWPv
	 jEZALEueKo8hHow3SFFyPwshd+b/+m+MKYTdLznP3YmKGBPQHnLtsJGeFXPhR8ZdMa
	 3S/U/oKFU5GDHvu/Y+p8cwcut9JxOwot4z3dhWsIqUIoG7hoJ4xcTp0aeM1VWDHfKT
	 Krfko5XSjowzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/232] net: hns3: fix double free issue for tx spare buffer
Date: Sat, 28 Feb 2026 13:09:33 -0500
Message-ID: <20260228181127.1592657-120-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 9bcd03e1994f6..646cfce10d804 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1044,13 +1044,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
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
@@ -1087,6 +1087,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
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

