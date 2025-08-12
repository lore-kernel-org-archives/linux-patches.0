Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C992FD1B2;
	Tue, 12 Aug 2025 18:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024465; cv=none; b=GMde7rd39dGIeo9Y6HfqCTsv3adoTJhP8Ku2MKi3Ei86Luu7GucWneotaOHBTQ64ERk4DFfgmJ5MpijtoWBbJ+sND4KnEOjIkfvJZSo6ZA7Aoi97HbXW9QBR5lUdKF/VY9qGrF6xPn6NW2hGAX1h5RtDrqDInZTzMg3yA5C3hCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024465; c=relaxed/simple;
	bh=uzDP5oGy9ZwBK2wgt1KoqsDe1DYbdbGbbyYKxFMHv9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF9wzBy0GhGL9zZMsL/BHn1hFSUgH1n562RneQkKawpdEvN1Vpxkv8aptIRSEEASiQr7SWAoHj61kKY+xwrkJRRclMZJ//bRVL3flECvIs3yQnBtSHA9AYsmJWlrO/JK1bABOeWr/HKrwy3fvuaPOKedrf6OxyV4QPM5Fvd/W5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlEhjGBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlEhjGBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756E9C4CEF6;
	Tue, 12 Aug 2025 18:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024464;
	bh=uzDP5oGy9ZwBK2wgt1KoqsDe1DYbdbGbbyYKxFMHv9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlEhjGBs1JsGfSweXCc/tL0wAE7lgGc0O/BpObbKCBRnZZUtdjLadf7xEzGMnwFZb
	 tX+qFTT8DJFtdkBkIKBYI7zCW14mBSrw6RndNMNMaqOFe2+uvVDPi0YoxoAo8RfQbA
	 wlf7oTPlntCxkb1Z9JrvdlMvDix68fAF2kZNbCq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 348/627] RDMA/mlx5: Check CAP_NET_RAW in user namespace for devx create
Date: Tue, 12 Aug 2025 19:30:43 +0200
Message-ID: <20250812173432.525606824@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit bd82467f17e0940c6f6a5396278cda586c9cb6fd ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails. Due to this
when a process is running using Podman, it fails to create
the devx object.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: a8b92ca1b0e5 ("IB/mlx5: Introduce DEVX")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/36ee87e92defd81410c6a2b33f9d6c0d6dcfd64c.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 843dcd312242..c369fee33562 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -159,7 +159,7 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
 	uctx = MLX5_ADDR_OF(create_uctx_in, in, uctx);
 	if (is_user &&
 	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX) &&
-	    capable(CAP_NET_RAW))
+	    rdma_dev_has_raw_cap(&dev->ib_dev))
 		cap |= MLX5_UCTX_CAP_RAW_TX;
 	if (is_user &&
 	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) &
-- 
2.39.5



