Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4C224B12;
	Mon,  2 Jun 2025 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873695; cv=none; b=rAZ6r86ViCjERRaBZqIyf7uH7HFXw/w9Yc3cmytrzsli11c4LCOtBAwhvxcH51SPCYdFx9BosP81AvIWgqCss9k4FuSIpIaIiLcLiC9JDHS7PWUNCBPx+xiJjxkyuj2bbahcf3/EjdpS2tmq2bM1K/ca2ORCWLhNCRJrb2Ko7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873695; c=relaxed/simple;
	bh=Alq2pf5ZE2fuCsuXOqS4hiIAMlZKUPdNCoTFhsea6dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZYkTUgGIaEBsAKkbdmfqL55ylD4txTXSTaiwm550Rp9ADGIWGr0OWWOHCJR65PaAegjbZ2QY21l/Ur3Ltebfr47kGOkAkT9jv1zgdbz98Y49bTjuTv0qf644+PZfPISqbz/sG2TRTeD6329um0qTuTsoz25ekBGRQakSuk92PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNZfxk2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNZfxk2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A921C4CEEB;
	Mon,  2 Jun 2025 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873695;
	bh=Alq2pf5ZE2fuCsuXOqS4hiIAMlZKUPdNCoTFhsea6dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNZfxk2k4J9l5WVsvqPedAPxQiNMNzimEPnuTZdwpeWAHHgPCBu4PAFdDv26yVx/Q
	 FWd3FyymWJuyj23tWRgw75ZbyNXOkRMJSDzAfXUxvIHXXAiS4INPdn0M7Oa6p2+pBr
	 bhXfKtQDuSylgEeYb0JhlWLn/sUN9yUFS8Dr2HvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/444] net/mlx5: Apply rate-limiting to high temperature warning
Date: Mon,  2 Jun 2025 15:44:46 +0200
Message-ID: <20250602134349.918156173@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f4763dab5d25..e7143d32b2211 100644
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



