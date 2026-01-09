Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50D233CE9A;
	Fri,  9 Jan 2026 12:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960289; cv=none; b=CsUEqH+Mcm7NfLpgLzy7zxOt6nQsMnasIPggXk8SHFpFk/xRdFfeCxOdzFdPlV/hd5kdPdbkmzQaz2lbyCqzdc1sdwm7mwVWIxZotZ+WMqJOkWhFGITEb2Qhlx0k2p/PAixwFAGsAVHnExy+MaPqFHZFK0z4ixv1jZenORL4Pac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960289; c=relaxed/simple;
	bh=z4hrqoHNXA2Ipb1x/qC3fdLJcO2Maj9G/mvBmku1vt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNJp4ZrLQCMAW6PVtTw48Jj+jkNp93lsaNY2fPWkK/2El9XTd0gXqmLWs88o6QvpuV2AfXQrx28LHmwejmF/HHKKosqYZSsvgwD2WECQXBq0iWuEzz2TKkBFOWvZgX3W6JzdInlVudpPPOMN2bFWGiHxCpHMjJShMwzWcOMx+x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zi8XLwos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zi8XLwos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65247C4CEF1;
	Fri,  9 Jan 2026 12:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960288;
	bh=z4hrqoHNXA2Ipb1x/qC3fdLJcO2Maj9G/mvBmku1vt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zi8XLwosRe8o7rnQ1BFgDddGWeye7nIQBtLlhT0AfNqGvR5H7u6x1eoJEB6X9tmf9
	 Av3yezhOqVTFmGRJ8L6YJxSVtKzw6rGNc1UAhFmAW8X5pc1IstdBEA88X/ZAEN9Nlq
	 lRlcttE5Jsh6eVuDcNHSAMgN0+OSqIeugGfVDN4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 350/737] net/mlx5: fw reset, clear reset requested on drain_fw_reset
Date: Fri,  9 Jan 2026 12:38:09 +0100
Message-ID: <20260109112147.152988099@linuxfoundation.org>
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
index 4d64d179b5dd7..dc7afc9e7777d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -804,7 +804,8 @@ void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
 	cancel_work_sync(&fw_reset->reset_reload_work);
 	cancel_work_sync(&fw_reset->reset_now_work);
 	cancel_work_sync(&fw_reset->reset_abort_work);
-	cancel_delayed_work(&fw_reset->reset_timeout_work);
+	if (test_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags))
+		mlx5_sync_reset_clear_reset_requested(dev, true);
 }
 
 static const struct devlink_param mlx5_fw_reset_devlink_params[] = {
-- 
2.51.0



