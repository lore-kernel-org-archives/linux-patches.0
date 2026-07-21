Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE8D32B132;
	Tue, 21 Jul 2026 19:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662041; cv=none; b=aHtTLhBelDTBmHfB7VlVIy7uCtjNRhjHtTWjjELmIDJkk9SCq7lsdX7keJxUrTXSK8MeWp0+OAAqI+u9L6XKinf5O2C/TDdFdK7nYSPrLfTuOwuuXTx2D6HAVeHcn+VEi/4qBqugztpwrVtukHAydM07QrtAOYusph0ZVUwiMvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662041; c=relaxed/simple;
	bh=qNZQpOtiniP5GX5wznFdzAxu2JE8db4WjFxQBZNojx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVkYcEW3Kbut1zaONXb+A7Z8FV4Wl+yohbK4+jwxxWkXlWajq98tuI5zlAjGu9iQZXSehqUoWQpPP441BKdILYnRZEReUs8J93kzodWklYpeCpv7xq3/ynrhqER+XQQQfF8VzTHwBy5JyqRes4urLcZG896/1AJgRzXkEdRTYAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfV03Pkx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfV03Pkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F8E1F000E9;
	Tue, 21 Jul 2026 19:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662040;
	bh=BDirkB6C7gTv/+1yS937ApkhadjHbrhtc8PAzkgZubI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfV03PkxxOdZq8L93Ix0Wbg5jdqk546q+SkiWb8/4TA5aCgQvKvkpYwL5lo1WvQrt
	 yXFAcvJcuv5kQ7fzCPckVlzbSCxSRFqaz60AVKeiZG9Pvitk3SoQqGcpf7oe0jTPlz
	 8o/VyDaxOS9pWooNX1jRcgz4sSdQidrngw77W558=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0294/1276] IB/mlx4: Fill in the access_flags if IB_MR_REREG_ACCESS is not specified
Date: Tue, 21 Jul 2026 17:12:17 +0200
Message-ID: <20260721152452.667327909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b52bceff7d9708..09c4066fa16032 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -137,6 +137,7 @@ struct mlx4_ib_mr {
 	dma_addr_t		page_map;
 	u32			npages;
 	u32			max_pages;
+	int			access_flags;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
 	size_t			page_map_size;
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index e331c04967df8d..1f2f924b5c30e4 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -439,6 +439,7 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err)
 		goto err_mr;
 
+	mr->access_flags = access_flags;
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.page_size = 1U << shift;
 
@@ -499,6 +500,8 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 
 		if (err)
 			goto release_mpt_entry;
+	} else {
+		mr_access_flags = mmr->access_flags;
 	}
 
 	if (flags & IB_MR_REREG_TRANS) {
@@ -540,8 +543,10 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
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



