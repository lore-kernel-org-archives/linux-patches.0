Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FA8226CF3;
	Mon,  2 Jun 2025 14:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874764; cv=none; b=MfZQyqxbTi70g0S4MgUXhLMkLpkN/mMisolokKjL42mo1WfTNBhDMliKNgfJt0Pfa/J7taaMD/xLv8t9xC1KXY80aRV+HFtGRaFPoddXfVfyNMzoGhVJlXojFnsQap/bturi+793piXyoHmkKG3XdswC45RqffmtIW6Oevkd4wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874764; c=relaxed/simple;
	bh=lY2TFMZeUpyFzo57wBuNiAp7wttc+iRUhUn6mFcvqe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnx18sytPI4qRVCW2DmPO1N0Xqk7818nig9z4CnLNd32hAqXeB63qtjqK+L3rto9vx8qzKYm1d3SCBq8eq/GkO8zUmhA5pW6LXVSb3OauCILsFh0dt2WRhTZwKx698VZItjNLnlJBPLtl9dfT7F3HrlsyXCFj3cxFgHbcjHrNXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkGYKwuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkGYKwuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107DDC4CEEB;
	Mon,  2 Jun 2025 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874763;
	bh=lY2TFMZeUpyFzo57wBuNiAp7wttc+iRUhUn6mFcvqe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkGYKwuTdXX+Q5t8jkpA/UF0/0dhguF77Hs0nIsack0tLH8/ugwD5gjTE2PV6ha7q
	 zTD04fQ5HonHpe8sj0RzY0y0WSxlntgX7uqw1ZjBfJ53CJyAA3Y5USa5bDQdAfV+Zt
	 /NNtLzIPyF4RwY6hgSFhhDkZ0q3WLSCiftSHpIn0=
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
Subject: [PATCH 5.4 128/204] net/mlx5: Avoid report two health errors on same syndrome
Date: Mon,  2 Jun 2025 15:47:41 +0200
Message-ID: <20250602134300.673804261@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d4ad0e4192bbe..44e3f8cfecacb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -736,6 +736,7 @@ static void poll_health(struct timer_list *t)
 	health->prev = count;
 	if (health->miss_counter == MAX_MISSES) {
 		mlx5_core_err(dev, "device's health compromised - reached miss count\n");
+		health->synd = ioread8(&h->synd);
 		print_health_info(dev);
 		queue_work(health->wq, &health->report_work);
 	}
-- 
2.39.5



