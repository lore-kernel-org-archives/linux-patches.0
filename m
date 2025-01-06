Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87A01DE4CE;
	Mon,  6 Jan 2025 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177510; cv=none; b=qGf8oit75RtXbUF70sCau0Ercgpj73As7BdlBlSR9562mcrlTWuvvllttanl9gUuN6pJbU29dV6nsCMxqbbxju9qiYUdw6uWOeB0X+CDOmBwrNkRtban3eOvc6HHEkiCUsi74xMwY909yz9bFtea7W3zWcktdRCX5DBuTeT0EPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177510; c=relaxed/simple;
	bh=MgWgEq4N/mAxX16aLzmL35SK7niGilt96yhFTPKNXfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTQPUeOZf1dKCC99fTbuvq59myRLDUq7v6lZdROTRcGlwlU8Huha+2T80uSBl7SUaNXIdgEl28QN2Qx9+qHigjwEuTBw5wSC511Ho+FPQYqLY1WQs/3qbcv5z8r1jvoHLrzLoAGNYNsx37XMEcuCbo2kA31mdLjfwXw/ii00SrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7bcusvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7bcusvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09AAC4CED6;
	Mon,  6 Jan 2025 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177510;
	bh=MgWgEq4N/mAxX16aLzmL35SK7niGilt96yhFTPKNXfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7bcusvrbAzt1YHARMGA6MTxuzf2xxKIxIYtzGI+GrQ5NRFgILktXaBFY8rAOQAOa
	 pNKLsgcVJRjW0BLth4Ch6JSa7lzsxZKHEa0LblvETzhjP2QA/Muu+yyO+8q/siT0E7
	 UjoaV1qVi25TXo0uNcAh1Dp4oqxUXjQPce8yZVyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/222] net/mlx5: DR, select MSIX vector 0 for completion queue creation
Date: Mon,  6 Jan 2025 16:16:03 +0100
Message-ID: <20250106151156.780539220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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



