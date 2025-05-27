Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D3A19E967;
	Tue, 27 May 2025 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366510; cv=none; b=O80a7DdpUQbUyL+0tdV5g2EG96Gctwetkjze82dm9FL3f9ILv47wplRdip8h4BEfp8wzIbO1538SoDmxnVD1y6xaKoCmyfzqkDuLdLl4VZKiPZIYsjh+w0nizE0IAv8VOpnX0vFr9geDk+wQQ3+P/ySR/B/ryOWmPaXu8+lPGH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366510; c=relaxed/simple;
	bh=Wzoiv3RP90uJvH6AGK+31yvV4PtCid4ZJ69/UOWtuFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUVSlQYMA1Kk6ubfFBxTh40jTaWI7U/PzeH/VHq8vuq4OeOoe2Yuz4hh6+k2QEPKFCn/jtQeIwhX8fgOnHbtULEg8ZAapJCxZPdaPqM2seOZ4GHXnlaUPvTuymVO70W8hM/TObI0VxKqOELpbr+kBkXUN6ZR0VMyLLedEA1hO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhNihbkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhNihbkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D503EC4CEEA;
	Tue, 27 May 2025 17:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366510;
	bh=Wzoiv3RP90uJvH6AGK+31yvV4PtCid4ZJ69/UOWtuFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhNihbkAyynZhYj8T3e71Uezf6kU97rZ1NFnkXszpKZbhKfAqiyH14OHbAXd6mKap
	 RjkoCJEE9NBj/u2nBz0uwIYGDDsb/faUYJNivbOb9jy5rRAxnhMj7YRVDi0e05TT7d
	 M4dHG2Ws0hE73ZPOkAw8c+KJCNI596HgWEKYh7Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 092/783] net/mlx5e: Use right API to free bitmap memory
Date: Tue, 27 May 2025 18:18:09 +0200
Message-ID: <20250527162516.888277446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit cac48eb6d383ee4f037e320608efa5dec029e26a ]

Use bitmap_free() to free memory allocated with bitmap_zalloc_node().
This fixes memtrack error:
  mtl rsc inconsistency: memtrack_free: .../drivers/net/ethernet/mellanox/mlx5/core/en_main.c::466: kfree for unknown address=0xFFFF0000CA3619E8, device=0x0

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/1742412199-159596-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 01f6a60308cb7..5c5168bdacb90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -359,7 +359,7 @@ static int mlx5e_rq_shampo_hd_info_alloc(struct mlx5e_rq *rq, int node)
 	return 0;
 
 err_nomem:
-	kvfree(shampo->bitmap);
+	bitmap_free(shampo->bitmap);
 	kvfree(shampo->pages);
 
 	return -ENOMEM;
@@ -367,7 +367,7 @@ static int mlx5e_rq_shampo_hd_info_alloc(struct mlx5e_rq *rq, int node)
 
 static void mlx5e_rq_shampo_hd_info_free(struct mlx5e_rq *rq)
 {
-	kvfree(rq->mpwqe.shampo->bitmap);
+	bitmap_free(rq->mpwqe.shampo->bitmap);
 	kvfree(rq->mpwqe.shampo->pages);
 }
 
-- 
2.39.5



