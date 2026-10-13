Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5DD466B58;
	Tue, 13 Oct 2026 12:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894930; cv=none; b=kmlL5TPI72DcEnk/VroBdsdsBslZG0F0Ii/52NsWAvHIBxlC2+wUOo2aIU/x2A5H2OJ+carCvC4pMtQXvN8R8TYoXZ9M0Y/qcNwDrIDDuchzH0y+B0DVVbJk973yzvDJ5oMIQePfr4ts7aeWHthN19o3V82RFcBO/v9iFdYI0eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894930; c=relaxed/simple;
	bh=PB5VyAAV9pJXasxCUhBrsu92il/j7sEVxKd8AO4gTXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0+MR/qLZ2ssvW6ib3VeVD12XGSi/SGHy+1q0k552jxPgj/bL6RzvGwPNvCGcIZjFH1H4J/i6Q+NTL+MnxGfNUU858FZFKv42LE4uq9K2LdSnfXvUD0B3ec7IjzBzD8SwSs49qVeJlDh46ez+XLJCjvDAXS6N90x+LNn40LTKGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6J/LuWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6J/LuWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8732E1F000FF;
	Tue, 13 Oct 2026 12:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894929;
	bh=I5M96RAln+Z4R62yCBaByMeGEQ7zIl6KTfsJvpGZ9SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6J/LuWEDftB0oJJIijTfeVl/KhCD2Po1E4wQVRDITdLteVi11bpZ3niu7fWR/11Y
	 Jl5ZHFozkQuaq/vjwU7nzyA/p/6w5Eyx3iIkhcUOgKYv1VVYDaGsIFrMxtMwJdaF51
	 0DQIanU/5+hd6uhvs3t+B1GJ/gjaO18xfcwFdQII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/497] net/mlx5e: Fix AF_XDP TX timestamp teardown NULL dereference
Date: Tue, 13 Oct 2026 13:34:31 +0200
Message-ID: <20261013112910.359352634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d4d2de017a504..1f56141616233 100644
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



