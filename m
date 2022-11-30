Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495F879C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95987C433D6;
	Wed, 30 Nov 2022 18:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834037;
	bh=58VhntbweTWsIryvu2HAcruVX0w5sRK6/prRhQR3Yag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fu84hhH2Yojeg38g3cIgVCUBCemTJzIcYOkG777+/+vydFv/Q0X01Li1vQvxTQ0/
	 cUXBtiPEGmf8zAmxNVXJqA/2UiOiO+ZsyI6hKTnTruP+Oo7kGniFEhCDqJIC/6XSSE
	 OLvqdnhfJdIHYC2kfjQcmNudooeau6VaemCZFXKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Feras Daoud <ferasda@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 105/289] net/mlx5: Fix FW tracer timestamp calculation
Date: Wed, 30 Nov 2022 19:21:30 +0100
Message-Id: <20221130180546.519537713@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 61db3d7b99a367416e489ccf764cc5f9b00d62a1 ]

Fix a bug in calculation of FW tracer timestamp. Decreasing one in the
calculation should effect only bits 52_7 and not effect bits 6_0 of the
timestamp, otherwise bits 6_0 are always set in this calculation.

Fixes: 70dd6fdb8987 ("net/mlx5: FW tracer, parse traces and kernel tracing support")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Feras Daoud <ferasda@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 978a2bb8e122..21831386b26e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -638,7 +638,7 @@ static void mlx5_tracer_handle_timestamp_trace(struct mlx5_fw_tracer *tracer,
 			trace_timestamp = (timestamp_event.timestamp & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 		else
-			trace_timestamp = ((timestamp_event.timestamp & MASK_52_7) - 1) |
+			trace_timestamp = ((timestamp_event.timestamp - 1) & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 
 		mlx5_tracer_print_trace(str_frmt, dev, trace_timestamp);
-- 
2.35.1



