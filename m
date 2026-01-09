Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AD31946C8;
	Fri,  9 Jan 2026 12:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960292; cv=none; b=EQJWVPk7NH1UfUXZojU6BKqcj08yKC44yKWBPYuTH3aMpUCMYlmUyZg8HJe770/SN4YhVb+1JshDKG53fwqfqFNFzgFPEbMnLWelgB0Ux1MvfOP1MNNGH2QL/cimdjFl6C6U/Thord/uGUJkVBgVxDAhfP03VEMlRTHHO4d0pk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960292; c=relaxed/simple;
	bh=oz2c9diQSf4cMvTS1NYwN2qLolIa3iuP+2hNQbfN67M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeokHObRiLIveMD3h3r6frCp+8OvcP1wqX9yQBxodsNDVxPFgfswusBuetYpK7ZsYs+iYAJ18JMLzhxLjkw3Xk96zt+krlxPz5Tq5SKPd7ntQ+7x8PgAuwmCEk/M73KohIO84LfroscNNtVtIOqsNHVE82Tfrgw/LZvXwLXgCUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Evy+mKA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Evy+mKA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F22C4CEF1;
	Fri,  9 Jan 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960291;
	bh=oz2c9diQSf4cMvTS1NYwN2qLolIa3iuP+2hNQbfN67M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Evy+mKA4X23I1cnvcAdu8jhLei8U6xYC5sRNJxw/mEvF8eBXbNcotHvBahkuySr9T
	 SDiKzmhDtg3LpK5LwgaUGtKW7ukKYa2poe6xdI7xmPTj0JQoSvScLBa/hbe6y4RZyZ
	 YArMsuAGBXZZGdKkFr95kJmw2ZaVXa6ITarYnIT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/737] net/mlx5: Drain firmware reset in shutdown callback
Date: Fri,  9 Jan 2026 12:38:10 +0100
Message-ID: <20260109112147.190743216@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8a11e410f7c13..df6eeb0f57bcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2164,6 +2164,7 @@ static void shutdown(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "Shutdown was called\n");
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_drain_fw_reset(dev);
 	mlx5_drain_health_wq(dev);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
-- 
2.51.0



