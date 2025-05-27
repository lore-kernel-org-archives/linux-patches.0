Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B78086347;
	Tue, 27 May 2025 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367582; cv=none; b=iJdL0Qxwe+CLpmUKT+yBTvw/+N77FTIPOg1OULNjEL76ZX9kWD0HreCfjIEl0GERE+7NN7HYWHQaaXR7WZWzPJUuq4RhFFiHpVGqeJT9l5sVdgTJa5RQfMzk8e2QB/Bu9DFJlgW9N+3wVyrQdrNzjaFwu5pmElsRp2F+IJXW/iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367582; c=relaxed/simple;
	bh=H+dE/llipfgAZoe5Ie+5vbpMk/M5X7Bx+TVYV8dueLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+64Qy/uN0dMd8jkkZe1oNYnNj8bn7mG+KjDNhJB2RnFSp50mIBgGEi/5eW1KM9lLjEdO7oaFvynBBsd7wyqDP3jNBvIsBxCVGuX45HthK1YpHlr3UVrjQcI4xFXkDUtKA2UE0bx4YpAzELkxWvcniP2lJp89u5x4QA3RJG3AGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAw0KXit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAw0KXit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEFAC4CEE9;
	Tue, 27 May 2025 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367582;
	bh=H+dE/llipfgAZoe5Ie+5vbpMk/M5X7Bx+TVYV8dueLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAw0KXitWUlivrAnDAO0lnRu+cdPlCjDFqakwsUBUPA45gh/EpSw9zFe7MvmKl7y2
	 rGqSqYTcRQyOO/e+uk1uFLufMzgu5zHXj8+wJ/wIx42jzb9FnoPBSWsAmbGbIGpzzK
	 mYi0qZ0849eCAEyg7SFtt5YeYsj+lUIikpbD+774=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 433/783] net/mlx5: Apply rate-limiting to high temperature warning
Date: Tue, 27 May 2025 18:23:50 +0200
Message-ID: <20250527162530.759070902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 9dd3d5d258aceb37bdf09c8b91fa448f58ea81f0 ]

Wrap the high temperature warning in a temperature event with
a call to net_ratelimit() to prevent flooding the kernel log
with repeated warning messages when temperature exceeds the
threshold multiple times within a short duration.

Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Link: https://patch.msgid.link/20250213094641.226501-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index cd8d107f7d9e3..fc6e56305cbbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -169,9 +169,10 @@ static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
 	value_lsb &= 0x1;
 	value_msb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_msb);
 
-	mlx5_core_warn(events->dev,
-		       "High temperature on sensors with bit set %llx %llx",
-		       value_msb, value_lsb);
+	if (net_ratelimit())
+		mlx5_core_warn(events->dev,
+			       "High temperature on sensors with bit set %llx %llx",
+			       value_msb, value_lsb);
 
 	return NOTIFY_OK;
 }
-- 
2.39.5



