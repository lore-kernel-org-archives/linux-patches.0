Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DD826FD9B;
	Mon, 29 Dec 2025 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025219; cv=none; b=ZvUxcP3jWnmhpT5gVUaO9dRBwKItKlMg0ea42Z7S8GcqDrTjMLJfnOY7z21UE3mboAmnEcJB7U3ZcIxv1Nyw1/wE/9Jua6f9s7GS7Oz2Pz4Y/etNuEq3Spd+QMWX/Afd9dunSxxq2JHZuLKDPnFp/M/IDtf+TrPJAv+RLwgjjyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025219; c=relaxed/simple;
	bh=teULfeoLpIk4/Qmtly32JmE4ZY49cXkm4Vlw78lt1QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjhWLyQS7UiC4DhDwkfmngc3oZiBgHlkA7xCO3mnpES7CiJXrgfZfA5uHkB264rOYorlpNOa2+HmoIhzoUdVx4gbD8pdN+0U2eARJijpTaq+ohWV6JkW1DkrEnVZzn6VHUSHIqh7KVsdISwBWouQPV2vpH3uUzEkm74+Z+IoaPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sb86t0B9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sb86t0B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409CEC4CEF7;
	Mon, 29 Dec 2025 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025219;
	bh=teULfeoLpIk4/Qmtly32JmE4ZY49cXkm4Vlw78lt1QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sb86t0B958EW0hHcYliKVGGSz8eiZfpphlS+pZcfs8L4y0faFmPJVyBF53W71nfDH
	 NgQKfLwK2QRaxff8pYZ6xwC55If9vKkDTpulRL+evDmlDMJCu6uSocd8l3E62X1G9z
	 NQpJFLxGFM9Qxr2DuXFberSfioIysBdwgZKsZ4zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/430] net/mlx5: Drain firmware reset in shutdown callback
Date: Mon, 29 Dec 2025 17:08:15 +0100
Message-ID: <20251229160727.784316999@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 5846a365fc6476b02d6766963cf0985520f0385f ]

Invoke drain_fw_reset() in the shutdown callback to ensure all
firmware reset handling is completed before shutdown proceeds.

Fixes: 16d42d313350 ("net/mlx5: Drain fw_reset when removing device")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 70c156591b0ba..9e0c9e6266a47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2189,6 +2189,7 @@ static void shutdown(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "Shutdown was called\n");
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_drain_fw_reset(dev);
 	mlx5_drain_health_wq(dev);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
-- 
2.51.0



