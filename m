Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE9D143889;
	Tue, 23 Apr 2024 21:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908598; cv=none; b=p/+BsPheyqpfGqhRN6iqGC4yVFNK7xxZwfGMlRdra5+E28OL1EMgSMxGIHvWuuI7Ait32uQTUYkX1toXWRuhtbfe2cmTX/Zu0aFT1q5x03JkGuONZ1L7GglkF7/Zfq9SeB/tI1ebvwzTGhGvx+MNVkAz26PG9sbNegCAr6zqzIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908598; c=relaxed/simple;
	bh=x4IQ3c/OBECZFFxzoz5UwSpSL2zdwUefhNbH8aybjUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtlcJzi5AchZEUDP7wCdrjKGr9X34OvuQAn+a1R5RvtxLrH6+EOxXZgNTLN08Mq8vCgWf4+FB7fkhwQaE0XbUvhKscPib4uZZloBqcoud/I5kGiLJvaMEoFyOjd3d2eog1Huafh6QPiS/CJUJuxM/nBMcfA1RIMZaxiitVHY+98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaktHDod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaktHDod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F37C32786;
	Tue, 23 Apr 2024 21:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908598;
	bh=x4IQ3c/OBECZFFxzoz5UwSpSL2zdwUefhNbH8aybjUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaktHDodfjynH3cT/XuM9U+aXE8b2MTnYFCmVy0NpgCQCVWxjKKt1TZNFrSO858a3
	 MD9yGlI788SGW1qiXil3cL97C8JJIEPDj1x+QpNsg1lwcHDpQXMWgtpmmCVkBJb9gS
	 g19X8Ks6XXo/gkjNhFtteJIDfYYt1y8Qb7WC+mKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/158] RDMA/mlx5: Fix port number for counter query in multi-port configuration
Date: Tue, 23 Apr 2024 14:38:19 -0700
Message-ID: <20240423213857.787382617@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit be121ffb384f53e966ee7299ffccc6eeb61bc73d ]

Set the correct port when querying PPCNT in multi-port configuration.
Distinguish between cases where switchdev mode was enabled to multi-port
configuration and don't overwrite the queried port to 1 in multi-port
case.

Fixes: 74b30b3ad5ce ("RDMA/mlx5: Set local port to one when accessing counters")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/9bfcc8ade958b760a51408c3ad654a01b11f7d76.1712134988.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 8102ef113b7e0..64dae68c43e62 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -188,7 +188,8 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 		mdev = dev->mdev;
 		mdev_port_num = 1;
 	}
-	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1) {
+	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1 &&
+	    !mlx5_core_mp_enabled(mdev)) {
 		/* set local port to one for Function-Per-Port HCA. */
 		mdev = dev->mdev;
 		mdev_port_num = 1;
-- 
2.43.0



