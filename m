Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895935B137;
	Fri,  9 Jan 2026 12:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962149; cv=none; b=h64JxY9/ZXEfwVFgrmNzVmA6g0MChoU33hOWb96oXs+OD67TpDvEXMwLtmM9xeREOu4KR9ayEhZL5xl2njM9RRM+rhUdwyHkaROvdykCjGT7ggGSHMRwli3TgYUhpPydq3UunguMOW1XwPH6h5/evrVYWO1uC7+j3BHVtIEFouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962149; c=relaxed/simple;
	bh=eIP2TFBITNFk3J4yy4aglw/crnNTpdrGpxkfo0k/5kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5o/N1Bui+gErjR/iIXzT54Mro2rdbZzE0wSmsz2PoW012rc/ufmrk3OIb8XdP4tZzhbN7N1+9xICQ4h+3Zx8ZfmzS2WGpwCZ8Kd3laHZYLGQICid0rBPjYtCIqtayXu2xilimvzIQ09HELwCBcmwT1Fobk1VzKFVNHbTUYqtho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhCLBkFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhCLBkFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2884C4CEF1;
	Fri,  9 Jan 2026 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962149;
	bh=eIP2TFBITNFk3J4yy4aglw/crnNTpdrGpxkfo0k/5kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhCLBkFFY691gLotJbmL0XqESy/fpZ0f9iUQJBzWhR74coUQkVZFw1Ity4X2sEp1j
	 K8Eh7TVpBSBWO+ts+G0iy+ZvwKuSV8NOdm/5iTy8Tm2N2iYx8uqZM5mjaIeULP0Mwm
	 LSeoCMM9qWtBHlrFitoFVSWbXwTCDxXoGZUifU9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/634] net/mlx5: fw reset, clear reset requested on drain_fw_reset
Date: Fri,  9 Jan 2026 12:39:01 +0100
Message-ID: <20260109112127.433870577@linuxfoundation.org>
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

[ Upstream commit 89a898d63f6f588acf5c104c65c94a38b68c69a6 ]

drain_fw_reset() waits for ongoing firmware reset events and blocks new
event handling, but does not clear the reset requested flag, and may
keep sync reset polling.

To fix it, call mlx5_sync_reset_clear_reset_requested() to clear the
flag, stop sync reset polling, and resume health polling, ensuring
health issues are still detected after the firmware reset drain.

Fixes: 16d42d313350 ("net/mlx5: Drain fw_reset when removing device")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index de130c75de64e..bb62dad48b306 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -534,7 +534,8 @@ void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
 	cancel_work_sync(&fw_reset->reset_reload_work);
 	cancel_work_sync(&fw_reset->reset_now_work);
 	cancel_work_sync(&fw_reset->reset_abort_work);
-	cancel_delayed_work(&fw_reset->reset_timeout_work);
+	if (test_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags))
+		mlx5_sync_reset_clear_reset_requested(dev, true);
 }
 
 int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
-- 
2.51.0



