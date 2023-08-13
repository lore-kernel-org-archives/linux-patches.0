Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239349443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E444C433C7;
	Sun, 13 Aug 2023 21:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962253;
	bh=+5UBt90uZKWy99kz7ljgCeWAQa8dEwQbUFKvaWUi+oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7ZgdgCrFkdiR4fOhil4ElMNB5m4BWA6Jz4cJLBNLY+uaXzyAoVzWD6tLyNYY/vRQ
	 Xm9zOpUX+Hr4W5AAssMQ8NpK6QMfvUTHbUIrti+DkLD8TSXZsDKqCswQtGfNIiTiZH
	 DI6lFV/NflCpw5VQ7oHDJTAvhSvEEWYbIJe21Gv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.4 169/206] net/mlx5: DR, Fix wrong allocation of modify hdr pattern
Date: Sun, 13 Aug 2023 23:18:59 +0200
Message-ID: <20230813211729.863088044@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

commit 8bfe1e19fb96d89fce14302e35cba0cd9f39d0a1 upstream.

Fixing wrong calculation of the modify hdr pattern size,
where the previously calculated number would not be enough
to accommodate the required number of actions.

Fixes: da5d0027d666 ("net/mlx5: DR, Add cache for modify header pattern")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
index d6947fe13d56..8ca534ef5d03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
@@ -82,7 +82,7 @@ dr_ptrn_alloc_pattern(struct mlx5dr_ptrn_mgr *mgr,
 	u32 chunk_size;
 	u32 index;
 
-	chunk_size = ilog2(num_of_actions);
+	chunk_size = ilog2(roundup_pow_of_two(num_of_actions));
 	/* HW modify action index granularity is at least 64B */
 	chunk_size = max_t(u32, chunk_size, DR_CHUNK_SIZE_8);
 
-- 
2.41.0



