Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C9612B176;
	Tue, 30 Apr 2024 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474862; cv=none; b=WfaPpYeH/A2nwyNP24hlnDHHHyYik1hqrBQ7O9UwbAXcgm3y9QOy09GhN9YN9eMa8f6lACcDINX95T2CuZ4Nm+VIh8SHdGdPJwRzd611kpUL9gyIKv+pKQFspgTnDPdM6lTm2Ua+ttw7inyRETujLh6B916Gr7KQScGfoRv6b0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474862; c=relaxed/simple;
	bh=PdM/WTM7iqD/NOl6qdLfS8YM/N4KlEChcK//CIvC31Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMPBdoA/I3vOXPa9nfypP5rcXe9UBJTfxaxROh268EABDpgDeEj5V6ifD7NMor73BrrVPMj2/6MVFsOBkQ2hdEmgpDMoVhGK+vNpbhZ6hA0HPuUfZWJgHW8P6y9ZqNvMuXySasjJgjZDcFB4OXxwC7k+jwW9ZFWX7a+CoC9IrGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy2XYFUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy2XYFUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3826C2BBFC;
	Tue, 30 Apr 2024 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474862;
	bh=PdM/WTM7iqD/NOl6qdLfS8YM/N4KlEChcK//CIvC31Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iy2XYFUOHtFym14mwFIJQEBuVViWmwutwGFjsFS/Qimd71si2FlM0w6+pe/yO9r59
	 OQ75K40raDexD+eUI+A7Ye1aV0P2aCSMXeuOIyosAas3UylzOU/PhTGhvf35VQrnel
	 bgQQ/Dv/gRNMBQf271EuwPif5g0pgEDmo2IRHZ7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/138] RDMA/mlx5: Fix port number for counter query in multi-port configuration
Date: Tue, 30 Apr 2024 12:38:46 +0200
Message-ID: <20240430103050.641426534@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cca7a4a6bd82d..7f12a9b05c872 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -166,7 +166,8 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
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



