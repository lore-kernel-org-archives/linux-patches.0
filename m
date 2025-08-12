Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8932F2C21F6;
	Tue, 12 Aug 2025 18:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024485; cv=none; b=ZlzVxttkKfrm4DAibEpKDyQghS5TP38BjKZFIXQfdqvLKVXWU+xAzzhq0CULOg/B4oafW73upS6+xkcNDRSbkQ8RWX6JITHcQ9brcz5N+Tg/vqvN9dhUIOEBfRRa63tciBlZnIToo2pGAByZLLaMr7EuLnejYR0brktY/mBerxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024485; c=relaxed/simple;
	bh=3IOnPuYEwQ1+mdwC0mErO8wqSyzzpEmsylPtKeA7aF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utGleFNP2T4afNzRcMMLCuax1W+BPYL+2hKhJtZYnOfeu9T7TGZV3aa+2Ih1VckeF4vIXngeivL/01GkI+3Nnw2ZFU6O1lECYUijf12lE0PL/CbvhKNp2MCc2hjk9hEsoZu0p9qAfFBcoFAm7AVFV9yP3FNyLqfvyTBbBEdC8Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5dP06ZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5dP06ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8ACC4CEF0;
	Tue, 12 Aug 2025 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024485;
	bh=3IOnPuYEwQ1+mdwC0mErO8wqSyzzpEmsylPtKeA7aF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5dP06ZOdEpNhXkmn+6ZJaUpDToNPjD4sIqXsVfE3tUwW+zalrLsCMYpQueB+TVrQ
	 EApdw/t18I9pucaKFSVpOUeTx5ejnZa/SNvWtlAgoHbxCXz9imsyBrHWP7TbtIyUpX
	 HXBX7gugAutgCaWToTNZd6youSPB8uWf1nHwktAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 344/627] RDMA/mlx5: Check CAP_NET_RAW in user namespace for anchor create
Date: Tue, 12 Aug 2025 19:30:39 +0200
Message-ID: <20250812173432.369412273@linuxfoundation.org>
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

[ Upstream commit 14957e8125e767bfd40a3ac61b1d6b8e62ee0a98 ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails. Due to this
when a process is running using Podman, it fails to create
the anchor.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: 0c6ab0ca9a66 ("RDMA/mlx5: Expose steering anchor to userspace")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/c2376ca75e7658e2cbd1f619cf28fbe98c906419.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index de8114ba9c1f..eabc37f2ac19 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2989,7 +2989,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	u32 ft_id;
 	int err;
 
-	if (!capable(CAP_NET_RAW))
+	if (!rdma_dev_has_raw_cap(&dev->ib_dev))
 		return -EPERM;
 
 	err = uverbs_get_const(&ib_uapi_ft_type, attrs,
-- 
2.39.5



