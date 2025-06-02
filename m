Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7908722A4DB;
	Mon,  2 Jun 2025 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876236; cv=none; b=J/W0ADamYKmBoIcVq4iZoJm8C2yNqutI8D9IbpA2sUs/mZ1QcCa1RTv2uEsGZuxmL9Ev+fcBH3GGXWGxbmCYfGoIS83uiD9POHLlaboY/R+okPgWo/W9Fs91hfRg8t6fJy9XOXhUmMXmdAR8TRXL7/YHr7Ke8Tj3F8DVVl4Cd2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876236; c=relaxed/simple;
	bh=JQjrdA5C2LW4ISRB5v4+22A7F7w0VUflTtaofTX3/CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBfe6zqdy0EaCzCDulIn4Csn55cWguXLrIpuWvxVS6bAslk/sAuA3kMd0o/MIN3VCvbF59+uT5tb+7TyskG6NS4HIyIIbVLUBp05HKuWcu1R1Mf7a2EYnPIt7wXudzOewlkYahvXd/2IAbCp1+IObb+teYr3+bHWrahBhOZoFLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPwsigIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPwsigIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA84C4CEEB;
	Mon,  2 Jun 2025 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876236;
	bh=JQjrdA5C2LW4ISRB5v4+22A7F7w0VUflTtaofTX3/CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPwsigIKizuDpB/ZOZB+mktOLYyWCssRzIr9Ab5+xVdD590hyZmjHu787MHh0NuvR
	 ZVZMPPt9qA7FkAXp/lRI4IBx9HVrVdWz2u+/je+YjLugIrPAA/29Vag23872pTBA9Q
	 Tk24ScdErWSbsy5sbrqWdCOqRZa8TmAxok1BGAds=
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
Subject: [PATCH 5.15 087/207] net/mlx5: Avoid report two health errors on same syndrome
Date: Mon,  2 Jun 2025 15:47:39 +0200
Message-ID: <20250602134302.142084611@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1504856fafde4..2a0b111fbcd3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -737,6 +737,7 @@ static void poll_health(struct timer_list *t)
 	health->prev = count;
 	if (health->miss_counter == MAX_MISSES) {
 		mlx5_core_err(dev, "device's health compromised - reached miss count\n");
+		health->synd = ioread8(&h->synd);
 		print_health_info(dev);
 		queue_work(health->wq, &health->report_work);
 	}
-- 
2.39.5



