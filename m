Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C9F2E041C;
	Tue,  8 Jul 2025 16:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992674; cv=none; b=RQq4Ujj5mAJAinDIY72lG3F/21Ua4yvL4kC5qgIUdWB0lzBKPy/E4/zLH3tqlceS1FCb9rEoEv/RC2m5JVT/QC1yRCBn5SkO1cjwlg+R7KhJ8XKgM8MTPT5pDnCse/I6K+Da22erDPKuHZDeuucPmFF0aujxsCNIsW/5Pi4FlvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992674; c=relaxed/simple;
	bh=F6hGe9seLl6QziEXPQ+D4nEpWxY7ttxIK1JSfu9pTxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSXSdMmSQfyeTtegj6kC9GW579oH965vGNi+X3zxy3ZiYsZt/0JzDclRN0P/tSE4QdW3q1WpCprOHhkSr6W1kYX+LN2geMdJXxcKUcqgXhmLhnSi63QiW+ifERya9ZbF6uBZnBGNgpXJNPoN/5OJ1gExfHlnaRCnpurrVRNUeZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6emaWeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6emaWeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6C1C4CEED;
	Tue,  8 Jul 2025 16:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992673;
	bh=F6hGe9seLl6QziEXPQ+D4nEpWxY7ttxIK1JSfu9pTxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6emaWeOEqijvDHcQophkrHdRvOTwc05gO+UB9BIRZ0kbo8sttCHj2hrceHKYbbIw
	 EKIRI6WmwDmuoPmOw2VJ8OXNlWPPZhCA7aUzyqt2FeRTPFqAOi+20K6A3Aqy/+MH1L
	 3b4Ldl4oUDx6tlE7kLW+R7vpSs5xYqEOEZ3+GJ1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/232] RDMA/mlx5: Fix CC counters query for MPV
Date: Tue,  8 Jul 2025 18:20:38 +0200
Message-ID: <20250708162242.536327297@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit acd245b1e33fc4b9d0f2e3372021d632f7ee0652 ]

In case, CC counters are querying for the second port use the correct
core device for the query instead of always using the master core device.

Fixes: aac4492ef23a ("IB/mlx5: Update counter implementation for dual port RoCE")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/9cace74dcf106116118bebfa9146d40d4166c6b0.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index fbabc5ac9ef27..ad6c195d077bb 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -411,7 +411,7 @@ static int do_get_hw_stats(struct ib_device *ibdev,
 			 */
 			goto done;
 		}
-		ret = mlx5_lag_query_cong_counters(dev->mdev,
+		ret = mlx5_lag_query_cong_counters(mdev,
 						   stats->value +
 						   cnts->num_q_counters,
 						   cnts->num_cong_counters,
-- 
2.39.5



