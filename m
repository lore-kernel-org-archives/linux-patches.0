Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670F1189502;
	Tue, 30 Jul 2024 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358941; cv=none; b=GqAMVSjej8FPJ5qFwRhGCScZx8yi/2xnnwLNen8E1OF3qQzsZnICA2s2JwefutHg5M1avCUKSmGnDYxFeeGE+v0MU9AkPU8BuIBB5Zkf00zU/MRIvCOQh1S5TOEK28welAAhrmp21xL+ow0DnLB6Uw3ZVuwCFSe5iQTYu6hOom8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358941; c=relaxed/simple;
	bh=sf0F9ahjHV2G2OPa/iSiHi9TNOnxsznECkFNM/YRbO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQUZHma6xM0wFIZhCvG4j2FcEEK91aWK+FqP30ktHwVq/xTtyFI/LPJ4SXcoskJblOc4qmxCml0Xg+MwZPrDHkMr2/JtDm7JuxYsd/luS3xa/EU07tnWVjStEWjMSZNXNx4vZav9LyDzTEBCz4ywNQ82wrvEadUB3nbiVJpgMc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekmDgm0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekmDgm0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B43C32782;
	Tue, 30 Jul 2024 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358941;
	bh=sf0F9ahjHV2G2OPa/iSiHi9TNOnxsznECkFNM/YRbO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekmDgm0k5ijT7yuRC2vW7nsn9ojQm0MzIgs81BdV8wMpzfDl+HzbNunKD4Ilgj4Ni
	 JxW2P5SOyCvwF7/GOBooHz7fogi98AdOtF/iuPERF/b3EhHufR3J5rOk42KZe9xHNr
	 uKcIY+F9orzsWs9hT8aM1ULsOwuzLQ6xr5liWMn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 410/809] RDMA/cache: Release GID table even if leak is detected
Date: Tue, 30 Jul 2024 17:44:46 +0200
Message-ID: <20240730151740.883747285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit a92fbeac7e94a420b55570c10fe1b90e64da4025 ]

When the table is released, we nullify pointer to GID table, it means
that in case GID entry leak is detected, we will leak table too.

Delete code that prevents table destruction.

Fixes: b150c3862d21 ("IB/core: Introduce GID entry reference counts")
Link: https://lore.kernel.org/r/a62560af06ba82c88ef9194982bfa63d14768ff9.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index c02a96d3572a8..6791df64a5fe0 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -794,7 +794,6 @@ static struct ib_gid_table *alloc_gid_table(int sz)
 static void release_gid_table(struct ib_device *device,
 			      struct ib_gid_table *table)
 {
-	bool leak = false;
 	int i;
 
 	if (!table)
@@ -803,15 +802,12 @@ static void release_gid_table(struct ib_device *device,
 	for (i = 0; i < table->sz; i++) {
 		if (is_gid_entry_free(table->data_vec[i]))
 			continue;
-		if (kref_read(&table->data_vec[i]->kref) > 1) {
-			dev_err(&device->dev,
-				"GID entry ref leak for index %d ref=%u\n", i,
-				kref_read(&table->data_vec[i]->kref));
-			leak = true;
-		}
+
+		WARN_ONCE(true,
+			  "GID entry ref leak for dev %s index %d ref=%u\n",
+			  dev_name(&device->dev), i,
+			  kref_read(&table->data_vec[i]->kref));
 	}
-	if (leak)
-		return;
 
 	mutex_destroy(&table->lock);
 	kfree(table->data_vec);
-- 
2.43.0



