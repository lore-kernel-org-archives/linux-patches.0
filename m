Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDAF33C53A;
	Fri,  9 Jan 2026 12:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962155; cv=none; b=nUJjgye32YyrSq4543LLaLUGQ/48DPXWzx+rGf08wNIaxFkIjBCUSJ04n9PWFAc6m0Vy/KfayKJpJ8hh1HBhWbSkXUEUQ4HNC9Kg8kXFFyRLVUe6OsTbAsQR92/GOno+jNUwmC9Y/z06gjanE4x+GBtgk5yQWotLfN4K5phZKo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962155; c=relaxed/simple;
	bh=Varq3nnLcprmDOEjtFUNVrbpK6t2eUNB5Sbru8ep770=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMkIiCQZMBshGxit/R5ShCJ577IuA+a7TyXCB/0N4NSXGt3Cp+GjhTxmU4Rc6Z1NPeELgrid2KMvf1DViBLOCgRXOpLn7V6AglAXJytc+rUK1gQM7jz54neeoAjhkis1TgLmpR1OgcybkL0EDGUNWtOuN5M0bEwE++LLf6i3D3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3QkeMU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3QkeMU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F6CC4CEF1;
	Fri,  9 Jan 2026 12:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962155;
	bh=Varq3nnLcprmDOEjtFUNVrbpK6t2eUNB5Sbru8ep770=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3QkeMU4/UNlHyqEwUk84DI9iU6AuXSG69rnWJNHcSUVj3Cik+w88FyK+fmp9e6V1
	 kRgRFMByfyfnVcQHzHIgZ7PBySGKfLOklV9Ndt3uaF3wiL6+OpxBenOZ3u1g//WRZB
	 ARBwh4L/+J2j0vATZEWbxylaScfhwlmsI2a1zkA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/634] net/mlx5: Drain firmware reset in shutdown callback
Date: Fri,  9 Jan 2026 12:39:03 +0100
Message-ID: <20260109112127.508221826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 891b625a6dc71..2b89bbd95f9af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1999,6 +1999,7 @@ static void shutdown(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "Shutdown was called\n");
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_drain_fw_reset(dev);
 	mlx5_drain_health_wq(dev);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
-- 
2.51.0



