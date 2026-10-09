Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39134399CE9;
	Fri,  9 Oct 2026 14:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556298; cv=none; b=P3/NCuqFYP7DKvFopd0Kz3UBHilM/AVOfIfC5iXMkvl5XlGk1GTZ0itHJeqpumX0s9D1HEQhCEf3T3WlAT5vxEyIeM39GW9gvXCKB4B86D17O7tFXA7tm+rQrcDje8nOKnvzkILxK8J6bmrXLV8DwaLBfn65872l+okU0YIm13o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556298; c=relaxed/simple;
	bh=xyn36p62mZyHMUSLdEaz5rirnst5TGuGQ9aZJNc1AzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SotIT3a/Di0lQGcBvgufJ+GaKDs42QaPY9oLDX4/NWFSYrcqaDkSC8Qwgxu/LzxzvFgomHpixtVqk1bzwRbZmcOeq+CSF05iVe7JAmcg5CFbmvx6m75KzfvBkiI6HHZL9TjkIlEE240pAO0kVGAKy2FavRbAHl5U63DxVwYDt0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2Z4eo4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2Z4eo4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C8E1F000FF;
	Fri,  9 Oct 2026 14:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556296;
	bh=w2g6Ex6HNe6fkDobBEfP7JQ7lsKKzldBCbPNeNphKK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2Z4eo4q9P5LkHS6jRmNMGKy1kQ8zB3xphzQ0ziUpZzLqZEsZZhZA56He00+bJS5Y
	 h9JONCKaOSfc5eKN6xER547pqMStgOBEe39BnhqZpAi0JmDnjzPXJpgsKZWWZDbXlq
	 VdwNj5hD35W+QmE0eemNKTJV5f4PdEXwZP+BxcMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 154/428] net/mlx5e: Fix AF_XDP TX timestamp teardown NULL dereference
Date: Fri,  9 Oct 2026 16:08:11 +0200
Message-ID: <20261009140949.550098163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit 7b97273cbebe9dd4fddc457f0c4f2a124d0e3996 ]

During XSK TX queue teardown, outstanding descriptors are completed
without a CQE. If one requested a TX timestamp, the completion path
passes that NULL CQE to mlx5e_xsk_fill_timestamp(), which dereferences
it.

Return zero when no CQE is available, indicating that teardown did not
produce a TX timestamp.

Fixes: ec706a860eba ("net/mlx5e: Implement AF_XDP TX timestamp and checksum offload")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260926165402.5902-1-prathameshdeshpande7@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 77ea51bfbaae5..2cca20e1b9b78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -293,6 +293,9 @@ static u64 mlx5e_xsk_fill_timestamp(void *_priv)
 	struct mlx5e_xsk_tx_complete *priv = _priv;
 	u64 ts;
 
+	if (!priv->cqe)
+		return 0;
+
 	ts = get_cqe_ts(priv->cqe);
 
 	if (mlx5_is_real_time_rq(priv->cq->mdev) || mlx5_is_real_time_sq(priv->cq->mdev))
-- 
2.53.0



