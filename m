Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D6147127E;
	Tue, 21 Jul 2026 18:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659803; cv=none; b=sJ8RXcDV85Tqe7pT/1Ea8T92uSAt962FN7wjJO0B+i0PmJy0jeCOvJq+M/4grGGTIIsVmcr6bzrBlSrc0wH98EZPu9c+uTc/UsTl4+8yWw88fYvAAq6SZkoEuzO3v2/jgbefod873PhbYRkDRWaHhUstCxsQXt6PFdiEA+F97Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659803; c=relaxed/simple;
	bh=tM06ujHYvcH8XgvwezJ0c/YfSOkUaJcjJOeZ1H5enOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMl9lu6LV/sbyoh7T1wpxiWymb7Z6fBnqFff/yTUCIYjXQ4Ra8+tRnaRbGbRNOLtLfnQiIwOH+oyU7FaN96pShQMCdYnWfjZJiHtHZywKfFjz6hgc8aTgCLBKLYXx9/Cuh/aJZtw2zFx3LVnkfhnIX0n7EDIXnHtCycNKHE4zwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rn9i9zCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rn9i9zCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D03F1F000E9;
	Tue, 21 Jul 2026 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659802;
	bh=ICKKUZXdT28htTCMLm1pLVepmLwNMO4FHkXa6/hMthM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rn9i9zCc2odUusrrh3IiDb3DFtNnC6GSgdis/z3++O1YvyTuF1HEQtXLv8/R2kPAt
	 aUTkkImwWz/5KKvKr6MFtgJxqsri68mB6+0sCaLFT4n72+MfUDm+xD6b70vG7wZjXG
	 JjdwmNnO4PheoDskrKoBNsfML9mC4lRgaN4wie5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0686/2077] RDMA/mlx5: Fix mkey creation error flow rollback
Date: Tue, 21 Jul 2026 17:05:59 +0200
Message-ID: <20260721152608.975961572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit c70fcfa9881207659ad193ae10a3bd56b2ae3f8a ]

Fix the indices of mkeys destroyed in case of an error in batch mkey
creation.

Fixes: 36680ef7bceb ("RDMA/mlx5: Switch from MR cache to FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-2-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 41ca3b1a6db079..253545ae39fd53 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -294,7 +294,7 @@ static int mlx5r_create_mkeys(struct ib_device *device, struct ib_frmr_key *key,
 free_in:
 	kfree(in);
 	if (err)
-		for (; i > 0; i--)
+		for (i--; i >= 0; i--)
 			mlx5_core_destroy_mkey(dev->mdev, handles[i]);
 	return err;
 }
-- 
2.53.0



