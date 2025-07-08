Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8CF1548C;
	Tue,  8 Jul 2025 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992244; cv=none; b=HCRjm8f3iTH9tgxiKNEdgXhFT7dvWzi138/HhWncoLv6MBgDOYM357JuHvg+ghh8trIZJ8pufzJBjz0IoohQmpI7E9DqPnuv04aeY+uJ0TO/XfCoxJdjmOzszEQnb2UytI9wpKTcy2RUhmlBt5U/548q9zlRk1uhpo7gjluylIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992244; c=relaxed/simple;
	bh=YPmgi0LUf0AvLLZF5cscqOIBwMX4FkhfFdGiJTg4bYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L80R04fNIz01/0NuuaMCfPQliumvQWz8enFX7Hqf/+bzbufcAwJmILhGIf7qmVHgoVBebBxj5VXx1kn3ouUZ8IK75wiRR3SUoOoR7a5lXjAS8GnWO1EtkObRVnaYHD406vPZCwNKN4cnyAuwFuPUcLcGfmZAZl9eq7wdoaR+XaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UO95fnwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UO95fnwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CC8C4CEED;
	Tue,  8 Jul 2025 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992243;
	bh=YPmgi0LUf0AvLLZF5cscqOIBwMX4FkhfFdGiJTg4bYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UO95fnwpB6hL7a0pLL0JAFZGhWjChTIQTlxsuTYOilxqK1o7srMxTf9DuVjniIpuL
	 EFTjtR8D5uMTE2X36rb/pgx+IGOmn6azBVAuHfLSf5AzxFsuCxfXook/51RaD56xaI
	 PsXIUM8zeLi6OlssmwDfNEzDi2lkDQUfXLawxcYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/132] RDMA/mlx5: Fix CC counters query for MPV
Date: Tue,  8 Jul 2025 18:22:18 +0200
Message-ID: <20250708162231.508458984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit acd245b1e33fc4b9d0f2e3372021d632f7ee0652 ]

In case, CC counters are querying for the second port use the correct
core device for the query instead of always using the master core device.

Fixes: aac4492ef23a ("IB/mlx5: Update counter implementation for dual port RoCE")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/9cace74dcf106116118bebfa9146d40d4166c6b0.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index f4aa72166cf35..d06128501ce4e 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -407,7 +407,7 @@ static int do_get_hw_stats(struct ib_device *ibdev,
 			 */
 			goto done;
 		}
-		ret = mlx5_lag_query_cong_counters(dev->mdev,
+		ret = mlx5_lag_query_cong_counters(mdev,
 						   stats->value +
 						   cnts->num_q_counters,
 						   cnts->num_cong_counters,
-- 
2.39.5



