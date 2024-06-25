Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E250147C7F;
	Tue, 25 Jun 2024 09:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309192; cv=none; b=cN+n5EeguA0PXQ5tAxV+HVv+E4PcmFm47LU5AtRKx/Is99CWS6Erae3JZTk5Ye91wxIuZ91TZMCQRh5Aj12luJtsD0gLgLBOfO9ypPPA0T28B1fzRMtT/p3UWvH9xphFrBJo5IWC7dSxXOlimyLhAk1b6Xc5l2SZ4kJV4xmDjJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309192; c=relaxed/simple;
	bh=NHyl5GF0nLj9y4ttuxC+lblakW9H3lvdl41ALdTiMl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io9th88YwiZktkEDBNNmjMVYr3uNqWiIs5haD7yhNs6HMXzkPPh+V/R6tyRcYWedz2p73T78pC4/30aqRnWZPzYpzloNkwdsEgrJPcmwtIPLMroIDao7VD8Hmc0ff141DXBbzGtUS2lqw72QZECZGwZOR4FsPD0s4pNJEIDFxDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odcBHYfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odcBHYfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A0FC32781;
	Tue, 25 Jun 2024 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309192;
	bh=NHyl5GF0nLj9y4ttuxC+lblakW9H3lvdl41ALdTiMl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odcBHYfGJYaWEih8iAvIYq9ivZSuAscnwCRlQvk7mbI/L5WSEvMszKabplsTt0cOS
	 m11x3j28QTvnJgoRwak2rVUyEJQN/KAaXG+Yh23tCdmFeySkRWpy8WWg1pvHdiVaCt
	 3zAXFUgp2+TP5QVlCO+REZi1MG8MNmoEOYVFvz9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/192] RDMA/mana_ib: Ignore optional access flags for MRs
Date: Tue, 25 Jun 2024 11:33:19 +0200
Message-ID: <20240625085542.039342379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 82a5cc783d49b86afd2f60e297ecd85223c39f88 ]

Ignore optional ib_access_flags when an MR is created.

Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://lore.kernel.org/r/1717575368-14879-1-git-send-email-kotaranov@linux.microsoft.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/mr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/mr.c
index 351207c60eb65..af79b6e3a5818 100644
--- a/drivers/infiniband/hw/mana/mr.c
+++ b/drivers/infiniband/hw/mana/mr.c
@@ -118,6 +118,7 @@ struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
 		  "start 0x%llx, iova 0x%llx length 0x%llx access_flags 0x%x",
 		  start, iova, length, access_flags);
 
+	access_flags &= ~IB_ACCESS_OPTIONAL;
 	if (access_flags & ~VALID_MR_FLAGS)
 		return ERR_PTR(-EINVAL);
 
-- 
2.43.0



