Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6DF20409A;
	Tue, 12 Aug 2025 18:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024342; cv=none; b=f8c1MNVOCjS4P8c4ziGUTP/nLq9iEmoO7iPNffyyyQmKBK6sdS5BzNsIzF7tvpd1pgkXDLJk9xeiw2Og+V0NY0ZXU0MN1KfRkaSzLVs68N4Rfm7NGfY3dHgKgDZXp0i+tYYOrEM4MxHl9yKcA1uqkuX9GZ8EH8A96RA7h38r3qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024342; c=relaxed/simple;
	bh=2eX1rRPDXGXwaW/LDnGCGfw4EmGdUlLlnyQUwbtXMTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLYOqjEK4BdbUF69nwGijZQP+Y9KdAonL2tb4q/504RHiDZCLoADLcTsZfAG+PGn1ptQRF2JRyyLF0qM2uUamMfUrYQN7OJlJlv0Lbb31UQiWRkApPyrSEg6UV0WZgbSMqpNWvB7fCYZyVeI/p2uqpGfgXrFHIAaN7IJPvPFbBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs7yPd3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs7yPd3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F6CC4CEF0;
	Tue, 12 Aug 2025 18:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024342;
	bh=2eX1rRPDXGXwaW/LDnGCGfw4EmGdUlLlnyQUwbtXMTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bs7yPd3CNML64mhzwx5IL8JjcXS2svQrzNX4gtjWk3QGiTbf1KwQlcwIv+YORGb1o
	 Z3X641ls/U+1/ArvEh0l6RwQIeQkAiM5szZKyIZjCC30NyhZyN5pXuXonrRxh1DKDk
	 4WyLMOrTgFQao6J7TDYtPaYZuh4gcsZAQ3O6mSvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 343/627] RDMA/mlx5: Check CAP_NET_RAW in user namespace for flow create
Date: Tue, 12 Aug 2025 19:30:38 +0200
Message-ID: <20250812173432.330183501@linuxfoundation.org>
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

[ Upstream commit 95a89ec304c38f7447cdbf271f2d1cbad4c3bf81 ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails. Due to this
when a process is running using Podman, it fails to create
the flow.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: 322694412400 ("IB/mlx5: Introduce driver create and destroy flow methods")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/a4dcd5e3ac6904ef50b19e56942ca6ab0728794c.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 680627f1de33..de8114ba9c1f 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2458,7 +2458,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	struct mlx5_ib_dev *dev;
 	u32 flags;
 
-	if (!capable(CAP_NET_RAW))
+	if (!rdma_uattrs_has_raw_cap(attrs))
 		return -EPERM;
 
 	fs_matcher = uverbs_attr_get_obj(attrs,
-- 
2.39.5



