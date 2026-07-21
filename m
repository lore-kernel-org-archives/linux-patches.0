Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62BE29CE9;
	Tue, 21 Jul 2026 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669065; cv=none; b=DBKZB9y0RPsOJn5t00EC7lucJ2vkoq4PnlvxLUMEa3M04bnPBfppoLQGWHnZ+ej89N3a+JcKWbBJnfQlYgmr4XnezhkBEZ7wC5+s3xOMhLvV8KY335FFxVfDEvsWSaW9T90H1ko1ggoUWIbSD07SnRjt9/2sPMdvTcn4aoKMGig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669065; c=relaxed/simple;
	bh=/U+ZDXMIeAg8W3eWE/srwUO6BcdH/Td1WEgX6Z4hCfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0NYv0Lg7erB3Dm7SLEgLtyx3XRYEzMcn77caHzwQ3nJqCpPsONQW8xkHNoNaNu1GZcZFdhYRwOkGOSgBF3zYOhbvs3GrGgiAmLjilQvQDP6qQJozyVGYBYt5QDahhsl2B30k1y+A6w2J64ROakjfi6j1FxK8kIf0j7dBsg7nBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JICVEfIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JICVEfIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5361F000E9;
	Tue, 21 Jul 2026 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669063;
	bh=ySKvYUes1ipmDMtPlnCgHlwsWycGZP9oLWcchOcciiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JICVEfIJGjX/t09UKZjKPYb25Z+gPbEeVVU3+G6EsDDxmkSfl2K7w91ZsXlfm8rjf
	 Diqtz2jSdrCKMCAt/bcrfQT7e6xnek3iTaMbvbODxhpIPL8wcrrbp9dUtjhDdRqgIv
	 7yAQtkdoUeHOjOzXvbcz9mF4Q873QbCmeXid46RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0412/1067] IB/mlx4: Fill in the access_flags if IB_MR_REREG_ACCESS is not specified
Date: Tue, 21 Jul 2026 17:16:53 +0200
Message-ID: <20260721152433.845676111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit bade9a3150d44ed20b8c6484c4c8a943b7289abb ]

Sashiko noticed mlx4 was using whatever random access flags were provided
when IB_MR_REREG_ACCESS is not used. Since IB_MR_REREG_TRANS needs
access_flags it used the random ones which means it doesn't work sensibly
if userspace provides only IB_MR_REREG_TRANS.

Keep track of the current access_flag of the MR and use it if the user
does not specify one.

Also fixup a little confusion around mmr.access, it is the HW access flags
so the convert_access() was missing. But nothing reads this by the time
rereg_mr can happen.

Fixes: 9376932d0c26 ("IB/mlx4_ib: Add support for user MR re-registration")
Link: https://patch.msgid.link/r/0-v1-29ca7a402625+ddd6-mlx4_rereg_flags_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h | 1 +
 drivers/infiniband/hw/mlx4/mr.c      | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 6a3b0f121045e1..110083471f4dc4 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -136,6 +136,7 @@ struct mlx4_ib_mr {
 	dma_addr_t		page_map;
 	u32			npages;
 	u32			max_pages;
+	int			access_flags;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
 	size_t			page_map_size;
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 004311925dbf9b..db3cd0a9c7ec87 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -439,6 +439,7 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err)
 		goto err_mr;
 
+	mr->access_flags = access_flags;
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.page_size = 1U << shift;
 
@@ -495,6 +496,8 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 
 		if (err)
 			goto release_mpt_entry;
+	} else {
+		mr_access_flags = mmr->access_flags;
 	}
 
 	if (flags & IB_MR_REREG_TRANS) {
@@ -536,8 +539,10 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 	 * return a failure. But dereg_mr will free the resources.
 	 */
 	err = mlx4_mr_hw_write_mpt(dev->dev, &mmr->mmr, pmpt_entry);
-	if (!err && flags & IB_MR_REREG_ACCESS)
-		mmr->mmr.access = mr_access_flags;
+	if (!err && flags & IB_MR_REREG_ACCESS) {
+		mmr->access_flags = mr_access_flags;
+		mmr->mmr.access = convert_access(mr_access_flags);
+	}
 
 release_mpt_entry:
 	mlx4_mr_hw_put_mpt(dev->dev, pmpt_entry);
-- 
2.53.0



