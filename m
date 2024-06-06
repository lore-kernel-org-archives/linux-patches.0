Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E9E19B3C7;
	Thu,  6 Jun 2024 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683054; cv=none; b=A3BTlguLa/uNHhkKNu+UgKaDdZ6bfxGEVcgIHoGfBXP8Iqobmv+VvitrMnAM8ngY5KJirImFeQ8L55WYIcX7YI+Q+2oUuW7wghLVeiGi7qbfuUy1KuL3tb1xZBMjhE/RR8enPIFBjwfC5MxiZF139Gu2c7DsXFOyuRizfZ1O6EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683054; c=relaxed/simple;
	bh=YLFFq32AxL9oTWGPrAtChmBeDBxB5Ik70MdqWYoAUPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4IZBzlq/yIvjJuJ4Qk3AIPAteH/KVZxuA+l9LoB1zmGYfnXK3V3IXT9uEdyXdY7GwKNshoQHIv4JgOI81XrQl6QI1pRt0UNhC+iGybREunxIO8m5FpdNOVWynmomfyM6dnmzeXljuCzvS1zB8m2SY0mZMgMBxPzAOqM+Vo4nx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKsmBbSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKsmBbSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8335C2BD10;
	Thu,  6 Jun 2024 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683054;
	bh=YLFFq32AxL9oTWGPrAtChmBeDBxB5Ik70MdqWYoAUPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKsmBbSZWN4qWuAFND5visWSeiCJ95GqTWEaHzs3lQnFgHZE9H0b9hEfajKDX4OEm
	 AfMehAv0J/n/KlDR7e/9nvNfKQ5IIaLeg2tZoWaGua1TFF5tT2N9Ddz/B3DP/Nd0uB
	 5t+eRobJeYke3MW3Yw/h8I6EU6I1M6xR5W0CPHj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 297/374] net/mlx5: Do not query MPIR on embedded CPU function
Date: Thu,  6 Jun 2024 16:04:36 +0200
Message-ID: <20240606131701.816562955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit fca3b4791850b7e2181f0b3195b66d53df83151b ]

A proper query to MPIR needs to set the correct value in the depth field.
On embedded CPU this value is not necessarily zero. As there is no real
use case for multi-PF netdev on the embedded CPU of the smart NIC, block
this option.

This fixes the following failure:
ACCESS_REG(0x805) op_mod(0x1) failed, status bad system state(0x4), syndrome (0x685f19), err(-5)

Fixes: 678eb448055a ("net/mlx5: SD, Implement basic query and instantiation")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
index dd5d186dc6148..f6deb5a3f8202 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
@@ -100,10 +100,6 @@ static bool ft_create_alias_supported(struct mlx5_core_dev *dev)
 
 static bool mlx5_sd_is_supported(struct mlx5_core_dev *dev, u8 host_buses)
 {
-	/* Feature is currently implemented for PFs only */
-	if (!mlx5_core_is_pf(dev))
-		return false;
-
 	/* Honor the SW implementation limit */
 	if (host_buses > MLX5_SD_MAX_GROUP_SZ)
 		return false;
@@ -162,6 +158,14 @@ static int sd_init(struct mlx5_core_dev *dev)
 	bool sdm;
 	int err;
 
+	/* Feature is currently implemented for PFs only */
+	if (!mlx5_core_is_pf(dev))
+		return 0;
+
+	/* Block on embedded CPU PFs */
+	if (mlx5_core_is_ecpf(dev))
+		return 0;
+
 	if (!MLX5_CAP_MCAM_REG(dev, mpir))
 		return 0;
 
-- 
2.43.0



