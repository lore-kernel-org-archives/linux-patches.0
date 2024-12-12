Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2907421577F;
	Thu, 12 Dec 2024 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015821; cv=none; b=oICDqC3QBtlpzJB3ZlGjx6FAICCdMDt16WxiFrF7WQnh+iPLbSjAMbhzrA8LZT5WahkL+pTfJegMy2EdNbzdAjJII7WtrNJNz8kYJEjjzgwSGGYK0bfMTQfkqo4aAhZO3OqJzlOVFROwqfFVkC2Xjaaio0PjyL/uLHCc7y9mtpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015821; c=relaxed/simple;
	bh=7qEq2dG1K3N5jLXrGZ8nqCqeOYUnuL9mLQAUC0sff8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psC6xlCFgDA0SjqZpUCz6QeQ7r80ZKJu12pvv3LWRFJ5YZ8avnVjYH2j5D8hjnj+yJ6rmTXDJoHkQSBdntWElEvMYKxZY4HuOkpZJtNrYVmyb9Quk7SyKCoG3wZUV1lwNcUZT9AGxdRYRzKWmiaBHe2vgiddHgyz6kuF0Sa3zcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHMueygL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHMueygL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89882C4CECE;
	Thu, 12 Dec 2024 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015821;
	bh=7qEq2dG1K3N5jLXrGZ8nqCqeOYUnuL9mLQAUC0sff8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHMueygLtZRcM7orvdFaGA3WUuGLCnQg7Zg9C3QOCNaIAA5QPExsTtj/gXRpbTWHn
	 OtZZc4ltyAzcFF9POJxSzRzmsrn/xbQxAtx9qjhlontMrpd6ULbwbj5w/kNYrUJS2D
	 /EI5taW243EZILUCS3TWXRFtNxxySsxg37qSXud0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/466] net/mlx5: HWS: Fix memory leak in mlx5hws_definer_calc_layout
Date: Thu, 12 Dec 2024 15:53:43 +0100
Message-ID: <20241212144308.954799722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 530b69a26952c95ffc9e6dcd1cff6f249032780a ]

It allocates a match template, which creates a compressed definer fc
struct, but that is not deallocated.

This commit fixes that.

Fixes: 74a778b4a63f ("net/mlx5: HWS, added definers handling")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241203204920.232744-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/mlx5hws_bwc_complex.c       | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc_complex.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc_complex.c
index 601fad5fc54a3..ee4058bafe119 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc_complex.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc_complex.c
@@ -39,6 +39,8 @@ bool mlx5hws_bwc_match_params_is_complex(struct mlx5hws_context *ctx,
 		} else {
 			mlx5hws_err(ctx, "Failed to calculate matcher definer layout\n");
 		}
+	} else {
+		kfree(mt->fc);
 	}
 
 	mlx5hws_match_template_destroy(mt);
-- 
2.43.0



