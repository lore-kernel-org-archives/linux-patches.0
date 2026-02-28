Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9511345736
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301858; cv=none; b=PSa+q8MqZA0KUBJ7nHTGV1MIrx1K60U8d0pr/XtnvQRDQBKIc9duOSwLIAUCe3Lvj267IIxNvKuGR2odmr3GHa43DM7kpgTBYk7BdOMaPSJvM8Kker8ioMQJ+1PhqI/RwFyjzr+n1A0szy29rZkHG2fKZk8c7SltyfsEUAfVnmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301858; c=relaxed/simple;
	bh=s5l/zBY5Mo/SRLrtXsJHcrDW4OE/a9Mrq9RvuE48f1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDqQTwPrPphfECRQ2ZhwQr7w4cX+iyAifQ7BFEy4NWaiii3skIvi2YfiOdZBKrFQ+ApxVDD7qqqcBOlx6d5gUCoKhnardGO09RZTKW+gTLcXOt2urQhM/dk+XnzmW6DvXnb/wQ7e0I22EIFvqRzfY2G0K5nEb330lm5mgW911HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYpYRtzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYpYRtzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B9AC116D0;
	Sat, 28 Feb 2026 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301858;
	bh=s5l/zBY5Mo/SRLrtXsJHcrDW4OE/a9Mrq9RvuE48f1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYpYRtzYEy8lzmQ62sdLpmbf5cTEO16WGjJi1fNV+bBgnJYfgs0swj3Bz53U0hyUL
	 DED1dBboIqyNWDaWUwR2jBod5XvdLlmwZgLwAa32xTBfuxoVz2sfwrEUyqCQ81Ywev
	 MpMClL+umDgGjy3uCt6EDb/8cqVcRCgPRJUdHPFICdsnT4PVX4l22D7Mv2Jc6jQ9oU
	 EekrFgPta1uBdsTJ24gu9+HiUBmGUhK4ACLp57jGzFtzgQHhUvaJ6Jo1hy0XV48/z1
	 KrGmuGZPuNuVNvTgF7qfRDXuvV05WJtARCQZsZWdbadu9xdEYKSNNoeHiFDEGOIVpU
	 Tc5nTO/2XWFqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/385] RDMA/mlx5: Fix memory leak in GET_DATA_DIRECT_SYSFS_PATH handler
Date: Sat, 28 Feb 2026 12:58:22 -0500
Message-ID: <20260228180011.1568201-280-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 9b9d253908478f504297ac283c514e5953ddafa6 ]

The UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH) function
allocates memory for the device path using kobject_get_path(). If the
length of the device path exceeds the output buffer length, the function
returns -ENOSPC but does not free the allocated memory, resulting in a
memory leak.

Add a kfree() call to the error path to ensure the allocated memory is
properly freed.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: ec7ad6530909 ("RDMA/mlx5: Introduce GET_DATA_DIRECT_SYSFS_PATH ioctl")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260126074801.627898-1-zilin@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/std_types.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index bdb568411091c..d0137ab7c645c 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -214,7 +214,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH)(
 	int out_len = uverbs_attr_get_len(attrs,
 			MLX5_IB_ATTR_GET_DATA_DIRECT_SYSFS_PATH);
 	u32 dev_path_len;
-	char *dev_path;
+	char *dev_path = NULL;
 	int ret;
 
 	c = to_mucontext(ib_uverbs_get_ucontext(attrs));
@@ -242,9 +242,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH)(
 
 	ret = uverbs_copy_to(attrs, MLX5_IB_ATTR_GET_DATA_DIRECT_SYSFS_PATH, dev_path,
 			     dev_path_len);
-	kfree(dev_path);
 
 end:
+	kfree(dev_path);
 	mutex_unlock(&dev->data_direct_lock);
 	return ret;
 }
-- 
2.51.0

