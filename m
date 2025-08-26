Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0602F84F;
	Tue, 26 Aug 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215558; cv=none; b=QTuFPLWgSFCulDzWc9aspyCFbMQze+fQh61LYxtj56Hw5Xb4Zsl5AydXOGeFctJRHZI5NlVEzhfyrLrs+i2BhM5aoScIamTobs4iLZ9AbdAJIVdPrcv0DMbt6uxspe4kFGXgIRHRf6jQ0nD0/bo2evv0XqaePDVTGyDhUh7kFSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215558; c=relaxed/simple;
	bh=V9+JD3+j06wcGwlBj8645pvSeg5GtVg1ebUi3/xFIhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mn2lhDosxFmFrk7eWvz0ixkeG/9Ejq6WWJXYQnBJxHUCsrhQyngAkWn6onHWhYRLLlzCBA+f7guCJrO13MWO9EQ3qosMhEzTy7wi+UgoOpCZevcgFtdthMx3BN4C0jvXiG7IMZRtHYPnamvpMzQSH4yZ3fCJwtFEaNxcpkXZEJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RL1leGGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RL1leGGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F7BC113D0;
	Tue, 26 Aug 2025 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215556;
	bh=V9+JD3+j06wcGwlBj8645pvSeg5GtVg1ebUi3/xFIhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RL1leGGLz+au6qNzyGoejRgYTP6LaEjvd+xJwB1MAUjKItgAof4sRYhZLHEp8Lgl0
	 7ePJgMI+FhCYYCYWROD+nTmLnrTzRcgMxrt0g0tmMyjB/f1o3iWN0safK7v+7gk53z
	 8EB2VOVlZIqsAZy/GCMJiC2k1lBfEcqcufr4xrfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/644] RDMA/core: Rate limit GID cache warning messages
Date: Tue, 26 Aug 2025 13:02:49 +0200
Message-ID: <20250826110948.430098949@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 333e4d79316c9ed5877d7aac8b8ed22efc74e96d ]

The GID cache warning messages can flood the kernel log when there are
multiple failed attempts to add GIDs. This can happen when creating many
virtual interfaces without having enough space for their GIDs in the GID
table.

Change pr_warn to pr_warn_ratelimited to prevent log flooding while still
maintaining visibility of the issue.

Link: https://patch.msgid.link/r/fd45ed4a1078e743f498b234c3ae816610ba1b18.1750062357.git.leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index b534ef03168c6..91ee3e823a9fe 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -582,8 +582,8 @@ static int __ib_cache_gid_add(struct ib_device *ib_dev, u32 port,
 out_unlock:
 	mutex_unlock(&table->lock);
 	if (ret)
-		pr_warn("%s: unable to add gid %pI6 error=%d\n",
-			__func__, gid->raw, ret);
+		pr_warn_ratelimited("%s: unable to add gid %pI6 error=%d\n",
+				    __func__, gid->raw, ret);
 	return ret;
 }
 
-- 
2.39.5



