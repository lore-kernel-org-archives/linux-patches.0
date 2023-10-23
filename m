Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ABF154A0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2vk2Bry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FFAC433C7;
	Mon, 23 Oct 2023 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060323;
	bh=jS8qe+hIdgTlGppTmRcrRtYyfwLYWm54Wv5ihO44/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2vk2BryH97/M/qwD1TwShZcYuLSsWNP57N92t+XasQ3K4VV83aEBlsetQuV7mqQF
	 jLFKWtiqnoKMjh1lK2Udqh3ZKGRg+LBGZG5RNvE+oevgoNFB/ZOy08Bymm4egcTwlN
	 v2KL/w1SmCOMamOu6iWE/hMsox1Y15J9uRcGLzC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/196] net/mlx5: Handle fw tracer change ownership event based on MTRC
Date: Mon, 23 Oct 2023 12:56:38 +0200
Message-ID: <20231023104832.251200557@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 92fd39634541eb0a11bf1bafbc8ba92d6ddb8dba ]

Currently, whenever fw issues a change ownership event, the PF that owns
the fw tracer drops its ownership directly and the other PFs try to pick
up the ownership via what MTRC register suggests.

In some cases, driver releases the ownership of the tracer and reacquires
it later on. Whenever the driver releases ownership of the tracer, fw
issues a change ownership event. This event can be delayed and come after
driver has reacquired ownership of the tracer. Thus the late event will
trigger the tracer owner PF to release the ownership again and lead to a
scenario where no PF is owning the tracer.

To prevent the scenario described above, when handling a change
ownership event, do not drop ownership of the tracer directly, instead
read the fw MTRC register to retrieve the up-to-date owner of the tracer
and set it accordingly in driver level.

Fixes: f53aaa31cce7 ("net/mlx5: FW tracer, implement tracer logic")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index c4e40834e3ff9..374c0011a127b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -821,7 +821,7 @@ static void mlx5_fw_tracer_ownership_change(struct work_struct *work)
 
 	mlx5_core_dbg(tracer->dev, "FWTracer: ownership changed, current=(%d)\n", tracer->owner);
 	if (tracer->owner) {
-		tracer->owner = false;
+		mlx5_fw_tracer_ownership_acquire(tracer);
 		return;
 	}
 
-- 
2.40.1



