Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7D312CDBA;
	Tue, 30 Apr 2024 10:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473848; cv=none; b=mb8Ni3wNwWgGAL3o026qMaPHpWPYrV2bq2HN5xZdnkILva1WIML4417Y+aP4di2K2LYqRgnsm7Ioo2TxomhIk5VID9EpHHY0XvPbgKod6tGrGgUmiQg9bLS1BFY9BxNsxZhehzzvSG8f7g6hfrugaJadBYTD+un2uLFIRv4KXes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473848; c=relaxed/simple;
	bh=FZJAR/BLOlfsEe05P7PU9qtQ4shl0I9WrYoFPsr9B9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxeWwmppXYlWp7mxL/fAHFF41PHjDVhqXoLb2B9sjrdKoIx89KzXFBD7Tz2xRcAghGJ0ZR0Db/6w0eiMn5QMgdfcKYmNKZZ3D8OOZ4bTFzlqlaqWObbQZKqYeTCGFUdNFqrpiXiPGpyYmq5UkJE1ybuS1y2Q8uERSyDxj27cmTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJxq2BiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJxq2BiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB5FC2BBFC;
	Tue, 30 Apr 2024 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473847;
	bh=FZJAR/BLOlfsEe05P7PU9qtQ4shl0I9WrYoFPsr9B9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJxq2BiG5aB9+QA9dqwKJ01BZXgDGWwuVCTzbbK7tbkkgdBOfE0xlzm8DwAGT2M3K
	 EgLZupNpm8E4Xm6ZLd4WoEEmRlHVUv6bGtaguWfTBUjVC0z2QZR9nP/s4ZfM4miLiU
	 ErWXnE2xgOFVAgUrvkcOwOY/TTNDSg8vP/zGqrsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/77] RDMA/mlx5: Fix port number for counter query in multi-port configuration
Date: Tue, 30 Apr 2024 12:38:59 +0200
Message-ID: <20240430103041.723830473@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index fb6dcd12db254..a7b20db03901c 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -216,7 +216,8 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
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



