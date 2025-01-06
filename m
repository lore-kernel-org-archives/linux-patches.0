Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5881DDC3C;
	Mon,  6 Jan 2025 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177817; cv=none; b=NamtAm5NUwhdc8UwZ1OBwlqokQOfY4+kXpSwc8oBSx+wUekTl79XTSDdNqebYnDjWAd3RY6SSAVwiZH8zf+pMycOVgq0MVTuUoKVivPiqzmoG/14ebMBIFc/vzCAICYVPSF+rDPSWzP/hdMP+M3e3hDzuFqOQSdNUPXbx0NGKoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177817; c=relaxed/simple;
	bh=gGaorNxwJWy2Xa/x8l9H4YUG6WiKCF0B8TOMAleaHtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0upuSInqU2mIbprP4hBm5MfurjVWkwCGSguCLkmbUoSQCu5lgBM9S/r52qD+biclJWkxkQO0M4IE9+RfvUuRsh7s5B5oNYHOdfsURdcEEhd2zaEMRYYZ2oARizdcqw+NvPCsPHUSFN4zrlbhB7ugBM0B3Ya4bUaFPZCYJ+8SrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQGJ/a1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQGJ/a1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B89C4CEE2;
	Mon,  6 Jan 2025 15:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177816;
	bh=gGaorNxwJWy2Xa/x8l9H4YUG6WiKCF0B8TOMAleaHtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQGJ/a1spKpsBuazJafhMPR5eVeqRmDsAw2tMlmfeUvsRLDD1ZXiS/8jSbZuEgFE6
	 rBhZO7ZTG7L8eC8GDwhgYftTxgTztNRFc9F39wxUsGelnZpAZEu64g2FrJ7uEi+krV
	 y7Pc8SrWfXTQA1kOPykdJXtZ/ricErYiTALvk9YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/156] net/mlx5: DR, select MSIX vector 0 for completion queue creation
Date: Mon,  6 Jan 2025 16:15:35 +0100
Message-ID: <20250106151143.581665628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 050a4c011b0dfeb91664a5d7bd3647ff38db08ce ]

When creating a software steering completion queue (CQ), an arbitrary
MSIX vector n is selected. This results in the CQ sharing the same
Ethernet traffic channel n associated with the chosen vector. However,
the value of n is often unpredictable, which can introduce complications
for interrupt monitoring and verification tools.

Moreover, SW steering uses polling rather than event-driven interrupts.
Therefore, there is no need to select any MSIX vector other than the
existing vector 0 for CQ creation.

In light of these factors, and to enhance predictability, we modify the
code to consistently select MSIX vector 0 for CQ creation.

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241220081505.1286093-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 6fa06ba2d346..f57c84e5128b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -1067,7 +1067,6 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	int inlen, err, eqn;
 	void *cqc, *in;
 	__be64 *pas;
-	int vector;
 	u32 i;
 
 	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
@@ -1096,8 +1095,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	if (!in)
 		goto err_cqwq;
 
-	vector = raw_smp_processor_id() % mlx5_comp_vectors_max(mdev);
-	err = mlx5_comp_eqn_get(mdev, vector, &eqn);
+	err = mlx5_comp_eqn_get(mdev, 0, &eqn);
 	if (err) {
 		kvfree(in);
 		goto err_cqwq;
-- 
2.39.5



