Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B50F330643;
	Mon, 29 Dec 2025 16:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025098; cv=none; b=jgb86y7w2Brz8vhlTtfe+UEUENnjYob7nqDYzyC0M8QV6BxvJABut6KtMHUEh9OJL3fTaE370obleLZW4mlmapgIx7qZxPbptLTmHtuvu4UVG6JSLLpJawiJlc3bW2wTjzCyVmo52yZjXvYFeQoMSK8ogisU//TiIrKQcAJRs/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025098; c=relaxed/simple;
	bh=RR/denx28nJCd2N/YGQmwUDdx0J2o8hpiwuoBD55uT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNZj10zuOP8TjUDs7yWP6Z3GuOm0bnOmKfQ5NF79lN1ZcaKO9Mlc1XeOo7d2KAxZ7bRbLC9I3sl1Yw8w2yqwrGRxNZAwt6tdJlfsPW8bkWvoVrlqkXEgEdY3NwoTuDQAmlJsEMJC7lSfi1MCnvhgNwbsKKDXTe1y7WZc9bA5DMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWGLq3nE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWGLq3nE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07419C116C6;
	Mon, 29 Dec 2025 16:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025098;
	bh=RR/denx28nJCd2N/YGQmwUDdx0J2o8hpiwuoBD55uT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWGLq3nExzSkKB67LmYAnJAcXjIJkp6jSPVxCVfBibzapHXmKTIHy/ZSePuOqeEvw
	 6HjeQWEXGI3s/WG+kPpSgNjYx77nIzakotzlj98NOJz20Iu5/BAZAkt5kMjZTVVFgu
	 jll68KWV9JJCOLoV9DqUuyAUZsnNc6glZLnd/DX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/430] net/mlx5: fw reset, clear reset requested on drain_fw_reset
Date: Mon, 29 Dec 2025 17:08:14 +0100
Message-ID: <20251229160727.747521536@linuxfoundation.org>
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
index 89e399606877b..33df0418e5754 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -843,7 +843,8 @@ void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
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



