Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093763EC805;
	Fri,  9 Oct 2026 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555850; cv=none; b=licUU3q4cFZLW+j+sbO1ILx1nmq70RsozqV9Lz7zyRFoQLVh+riO2xLRdgbV9aZT9AGV0x6jxnbZTClGc1GKq0tuACuIZxZlolCBrkKtWbidCjoWvsxrmoxpkPzt9DXCqfg7i8tKPIrE/ZpQnegR7Nh1QjYUWrORmQN1zs5UYcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555850; c=relaxed/simple;
	bh=LpHtPGAlInS5sRdB9z329Xt8fVgaBWLTIItFIhBCpoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpIIkv/bIMhSpYPwPQuMFKSej34ke1MIkfY6JbsbpntP8QGpfe/ClIQmsniqsL+u7ZR9YpMZ5WftRZYK+gW9aQIgJ3zgF7w9h3Dzueh1BOIb4oLeSuI+O5sffeu16cj21auHoTnG2m2jTm348uATwF/aaVlK9pUWYANde9FlKtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDhwTIXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDhwTIXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607741F00893;
	Fri,  9 Oct 2026 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555848;
	bh=CCjIxPDOWJ8D6bKX8LWpfSfw2YeMgDJz4LAYZiRLnJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDhwTIXc/2Ksi/B2VpmtvUpBZCJN5xciv27qwHyUX6pwHJHQH0CbP1gwi6xHqtWpv
	 j8YwATEmWW5cQK6JuTpjY11YGyqF5YAFQTkuc2vvl9K2oTeJ+IdMt759JHSmHXRWWL
	 dZc4Kiw9KCeQSqoL/Cc7+NzE6uLUDt085fi/F5OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/403] net/mlx5e: Fix AF_XDP TX timestamp teardown NULL dereference
Date: Fri,  9 Oct 2026 16:08:09 +0200
Message-ID: <20261009140955.071723714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
index 2f52e04b28de2..bc21e27b8bf63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -292,6 +292,9 @@ static u64 mlx5e_xsk_fill_timestamp(void *_priv)
 	struct mlx5e_xsk_tx_complete *priv = _priv;
 	u64 ts;
 
+	if (!priv->cqe)
+		return 0;
+
 	ts = get_cqe_ts(priv->cqe);
 
 	if (mlx5_is_real_time_rq(priv->cq->mdev) || mlx5_is_real_time_sq(priv->cq->mdev))
-- 
2.53.0



