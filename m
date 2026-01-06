Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F7E34A789;
	Tue,  6 Jan 2026 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719936; cv=none; b=YHmUNplkYBjdOsektsYuHbmmtaMLPYnwLNv8KlaxkO2ArxiXeIvWbLsNv0hGa3UQoRclTjrnLQvp9IWwOFfwtjCYDv4UgWE8fVOFscHTXo2dYR/u3uAoJNdo0CQulaU4CLC2/WPfXbfxU2cOSLGipUfefkx98l/2x3zxRRSZIg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719936; c=relaxed/simple;
	bh=JDaLb8lgKcJqbtyFq18/gG7IkVuFA4LLcOxdrDQZMQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aC3w3TnRVQne9TIE8AgzMzllivWMAAINyWqkJ+HzuqdWp+lwsnz3qPN/3vlpRfGOP26/t+1Qt5+6GhHPBhHkc9esmOOOhYVB7KlEvuKYHyQB2xk/NiaFundqwdsTdstOJU7wwH+hKun1UH6eSGq7fbHuXHuIE8gzv4z00BsRQK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA3umiGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA3umiGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2053C116C6;
	Tue,  6 Jan 2026 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719936;
	bh=JDaLb8lgKcJqbtyFq18/gG7IkVuFA4LLcOxdrDQZMQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wA3umiGFVrBU2lS/TGLy7SQYNME3o7Ktb4Ef71X99Bo+N9mR6zeKhdito+4m2ThzN
	 0AUCU+x80JR03S52ymDiYdLiL5sn6rUuBYrv3JpXcXHlI5KlmKMnBO2diPkasKvnHR
	 CftPYKltBBUCcRLSEP8cz/ezlI8mErdGjuyTOf4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/567] net/mlx5: fw reset, clear reset requested on drain_fw_reset
Date: Tue,  6 Jan 2026 17:57:30 +0100
Message-ID: <20260106170453.851863957@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 35d2fe08c0fb5..ad4d17a243de9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -832,7 +832,8 @@ void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
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



