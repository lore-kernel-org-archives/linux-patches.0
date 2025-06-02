Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6738722540B;
	Mon,  2 Jun 2025 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873661; cv=none; b=KrF79Tr/Fg1hvnL52KHMgokfeC12wEeZb4ewybI0NYrFlT5nK1j124IZK7hZUpE5QTDuyi1UxS4R+dRxbym4CpRqCGcEuGfQagmBqXZWjPSCmaFfilbulL+tTRvQIKsDstDheL2B4tA2tPZq58P28dzZFaDJrcW8XRRo26l9KOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873661; c=relaxed/simple;
	bh=isqQ/Gncie7Zc39yqJxlb4Ulqunw+Vry8V9+eIyfsJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZabQ3Ml7atZnThtGsxPSHLBor2iLgYJEor4Ou1HbZe8xVJsjWaM2yQzw7e205cKeOiSET+Lh1D4u4O45dAzma1MJjKioN6O45jgfE5vpKn8GVvdBeI5tl/2xD3I6JLjQ7lMcR1H0JPatUquqsKdxPtTQD6pJVvEJFKZXIBnLWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbyHrMzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbyHrMzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D73C4CEEB;
	Mon,  2 Jun 2025 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873660;
	bh=isqQ/Gncie7Zc39yqJxlb4Ulqunw+Vry8V9+eIyfsJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbyHrMzg1cyaOVwrgrf6xri6UIWofr21YyeHMVjKy2VDOY15psxQOjEM+ReSLjk7J
	 BzXJv0/RTdO6OgY7N2OrZ1/b6C0Zcg+yGaG0VFNpK3uySR1l+YWnZ7uQ61oHDg8tt4
	 TJM7bH81J4jgeFwZ3cdhW8qdHRcrX+pGvIUItTlA=
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
Subject: [PATCH 6.6 172/444] net/mlx5: Avoid report two health errors on same syndrome
Date: Mon,  2 Jun 2025 15:43:56 +0200
Message-ID: <20250602134347.881362217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index d798834c4e755..3ac8043f76dac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -833,6 +833,7 @@ static void poll_health(struct timer_list *t)
 	health->prev = count;
 	if (health->miss_counter == MAX_MISSES) {
 		mlx5_core_err(dev, "device's health compromised - reached miss count\n");
+		health->synd = ioread8(&h->synd);
 		print_health_info(dev);
 		queue_work(health->wq, &health->report_work);
 	}
-- 
2.39.5



