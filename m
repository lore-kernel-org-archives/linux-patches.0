Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EBA189BAF;
	Mon, 28 Oct 2024 06:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097631; cv=none; b=oVo3uweQKeQa+pe6MC/ZmfGaY4mwb+oNhdAdYgIi5z3fi4aznID6UcjUIlOIW+hGL854MK22ysfNgypLlYpHzYp01LLawZJm64zi41bt32sPM5sMN1IyEOYoBQ1gFpPxJj0/iqbQF/lZ4Nt0Bu/cy762PbzLuSqUM7ALjdg89AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097631; c=relaxed/simple;
	bh=OgPhzGkxjLRTANBLKJ1dk+BgRVRTgcfG8cn5/kq8Z8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5WXcRUv9SdTAkWtvOLamPL9+Bg/61MGrEgCt31KGPn6ot9bwzOEnzB7Lv6sOEYEFOgGJNc58VR7wmHcSBWViK+97emxdOodcBwL0PnVO4YCmgvhtqVcXrd3vkNTnzfm4NbRoVFCi9ZpKJ9oQYHyskM2fS2GrYg9KyTSGvnWBbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvOd/lus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvOd/lus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158A3C4CEC3;
	Mon, 28 Oct 2024 06:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097631;
	bh=OgPhzGkxjLRTANBLKJ1dk+BgRVRTgcfG8cn5/kq8Z8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvOd/lusQ0ib4AeD4h9Xm5QLweSwvFyFYFzpcONiAhWLBJwxPfUnL3sciZ3I0bYxk
	 lAqP5kNfg8MvGY94S1j/18Sd/RjaBbIXnTKS7J6zMTKtj1uXzSDQPMAIYfI4pBvT92
	 6k2WrNnqjm/BJPrwGhQpIVLmsPU7/CZhq6ONMQZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/208] net/mlx5: Check for invalid vector index on EQ creation
Date: Mon, 28 Oct 2024 07:24:19 +0100
Message-ID: <20241028062308.589496273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit d4f25be27e3ef7e23998fbd3dd4bff0602de7ae5 ]

Currently, mlx5 driver does not enforce vector index to be lower than
the maximum number of supported completion vectors when requesting a
new completion EQ. Thus, mlx5_comp_eqn_get() fails when trying to
acquire an IRQ with an improper vector index.

To prevent the case above, enforce that vector index value is
valid and lower than maximum in mlx5_comp_eqn_get() before handling the
request.

Fixes: f14c1a14e632 ("net/mlx5: Allocate completion EQs dynamically")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 40a6cb052a2da..07a0419549092 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1073,6 +1073,12 @@ int mlx5_comp_eqn_get(struct mlx5_core_dev *dev, u16 vecidx, int *eqn)
 	struct mlx5_eq_comp *eq;
 	int ret = 0;
 
+	if (vecidx >= table->max_comp_eqs) {
+		mlx5_core_dbg(dev, "Requested vector index %u should be less than %u",
+			      vecidx, table->max_comp_eqs);
+		return -EINVAL;
+	}
+
 	mutex_lock(&table->comp_lock);
 	eq = xa_load(&table->comp_eqs, vecidx);
 	if (eq) {
-- 
2.43.0



