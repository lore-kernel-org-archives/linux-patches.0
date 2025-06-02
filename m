Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CD0221D94;
	Mon,  2 Jun 2025 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875568; cv=none; b=MDmRI4P5JO7t6IexB1Jns1B1UIaPtcyJiFQ8vsA3YmL7n1tg5BgQzeL4ghdoVUW4ocAwN2b0ZhJe4SXXRgI+XuoxrWTarxAE6BcCV95GXr5beFyvG+QJ4x3guwz196JXDw7C0KM4TpOGlIR3ihsQ+Jfy7DlKzqvmw7bO5esWQYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875568; c=relaxed/simple;
	bh=G5dZ8eVWadFBNb5HJnHBKAE8vDm24XNCQLyfIgHUkPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8WQNj4nnoLRaTZ+598WsN6TeceBQjcOrNZsr8WMQVibCtOuPXh9+mZByIM1ZmUOx9it+WtcPuCkVIo7o7OR86ecQGGWSkkXYDOgyzXc+CNzhvQi2d9koKtj8PIWr60hXmNbhbJc6dOPFtcpxEeOIxJUYcz7zwf17mn3RJIXIw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ya+L7zcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ya+L7zcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825C7C4CEF0;
	Mon,  2 Jun 2025 14:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875568;
	bh=G5dZ8eVWadFBNb5HJnHBKAE8vDm24XNCQLyfIgHUkPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya+L7zcQ5HkL9qaGpiX2U6DrphLBD2qWLX5cwwZe9N8stop0KSMMvOZCks8g+dTff
	 1vs4v1hwNZ5qI+o+2OuEV9KBO2ewu7UGmyAGDiUK3/s7c/Iu+e2v5E6wi5Thi3Eta/
	 RzWy1PG3mZo7JSMb+bAkLIYP/FwlrBvxZ22H+dhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/270] net/mlx5: Avoid report two health errors on same syndrome
Date: Mon,  2 Jun 2025 15:47:41 +0200
Message-ID: <20250602134314.411621320@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit b5d7b2f04ebcff740f44ef4d295b3401aeb029f4 ]

In case health counter has not increased for few polling intervals, miss
counter will reach max misses threshold and health report will be
triggered for FW health reporter. In case syndrome found on same health
poll another health report will be triggered.

Avoid two health reports on same syndrome by marking this syndrome as
already known.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index f42e118f32901..d48912d7afe54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -733,6 +733,7 @@ static void poll_health(struct timer_list *t)
 	health->prev = count;
 	if (health->miss_counter == MAX_MISSES) {
 		mlx5_core_err(dev, "device's health compromised - reached miss count\n");
+		health->synd = ioread8(&h->synd);
 		print_health_info(dev);
 		queue_work(health->wq, &health->report_work);
 	}
-- 
2.39.5



