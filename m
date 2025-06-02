Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906D22F177;
	Mon,  2 Jun 2025 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876962; cv=none; b=iMV6fGFej69HE2OgomflqPgkHScjgIZC9zVZ79QRJJBJuarIA3TAy7FmB+Hoxlp16DBqFAxVzSdJEu3cvog8RanPeoM3sKZTD9MvtYLm4ALcMR/6cJdV0TfphM2EFMAfNf+2emTXJNg4ZDwBcbjuACbOTKEN5zkoeotNhRo2gfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876962; c=relaxed/simple;
	bh=MH0Gvv3gr+YHo00V6Yx8+CdcucdP+AD1lHQHGZa15xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbXL0fMPABTtFPyjkJLFjighm2KdrKHqoKxqBcbo0qDhIMRe66scF3Dd1gP72LvLUtFf2yrJmmnoacWln35x3Bg6OXvyODqO32OhW4RZU8dRO5iKpPcAFyVNRlosFIDhoC8r8ZNPNDcezZL0JLKKHfwdX5FokbCMD/ECKU3wq6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsXlFuha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsXlFuha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1EDC4CEF2;
	Mon,  2 Jun 2025 15:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876962;
	bh=MH0Gvv3gr+YHo00V6Yx8+CdcucdP+AD1lHQHGZa15xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsXlFuhag2+PYbtAd+i+W0QOtju/kqKRapDS5mF6M97ihB9l4OP14ATr4ru2/WO5A
	 a/MPadE7tfsIzzRDIwv0VkpY7SWellcmxxnvtrff2QMZb4ydlEut9Jr9oDODplLnlX
	 2kyS0m/9c8n3DobwnqP/agkUid/ARuCpULWi7srE=
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
Subject: [PATCH 6.1 128/325] net/mlx5: Avoid report two health errors on same syndrome
Date: Mon,  2 Jun 2025 15:46:44 +0200
Message-ID: <20250602134325.005772304@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 65483dab90573..b4faac12789d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -850,6 +850,7 @@ static void poll_health(struct timer_list *t)
 	health->prev = count;
 	if (health->miss_counter == MAX_MISSES) {
 		mlx5_core_err(dev, "device's health compromised - reached miss count\n");
+		health->synd = ioread8(&h->synd);
 		print_health_info(dev);
 		queue_work(health->wq, &health->report_work);
 	}
-- 
2.39.5



