Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A72022F384;
	Mon,  2 Jun 2025 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874913; cv=none; b=cpPdNoc/O4xQQ/NRpix6XM5WfPt6BzyGJ+Wku15dUoxmd3dFyTAq7lQCtlAg100w4CvtXSE44VvL0oO08tzWJbp61JzZg8nhDNmzxVwZFDmqOlxe1vv1+YLMxEJwzvxzcUAhYug0WsKTS2+kfyi4rm+XpZMYx4tf9ZpIVnXgG1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874913; c=relaxed/simple;
	bh=kLlPayZcd4sPh4PsUNeszn0yi5JuDyKgs09dswKNtxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRnmk8p3YZS/uFYu+znIl07WgQPj4gpXoR8mg3QHeTyBV8DvJ1dHM0HTAbkRnIRCOiM1TTtZ0xp8cq6dFUBtgz6n9Ns94Eycmv5spDCXAWjk1JCEyOImLYDLlePDbAxs8vbcOEp6WTNRIdq+2zlXre2ZpGFp2LmrO/ThQfbYn7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fl4pEZyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fl4pEZyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F75C4CEEB;
	Mon,  2 Jun 2025 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874913;
	bh=kLlPayZcd4sPh4PsUNeszn0yi5JuDyKgs09dswKNtxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fl4pEZyJxQKYWZC1dEHcHog0CnUQNSAKMmbVr2bubux3jhY1KRtcNexZdQg2Gj7xT
	 7F/jfJDGHmiAn/TUJdFyWFnOV/Ka2i3sWUPyA4hWCr13ayQvG1AZcXomXaGFlg5ceZ
	 mkZGq4rzvBGkYUhFVAKMMgelE2WtjdjjfLMm3wAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/204] net/mlx5: Apply rate-limiting to high temperature warning
Date: Mon,  2 Jun 2025 15:47:56 +0200
Message-ID: <20250602134301.264221721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9d7b0a4cc48a9..5e8db7a6185a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -162,9 +162,10 @@ static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
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



