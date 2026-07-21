Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FED46C4D2;
	Tue, 21 Jul 2026 17:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655950; cv=none; b=EgI8RWlUpC7/KSWGl5J+R4fDfE8BDnLSoNfKDZqH4t3YA99YT3ECSanyP8Sir5pO4v1wLObS+3YHwrDSElPk9UHan3R//6ZMjisDLFFmSab98HDvHIctbUKGE/igQ2z6yIj1mxQ14FVnXEw+QZo5w+clM842v0lB/TFXJYX0G9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655950; c=relaxed/simple;
	bh=DifWGEPSpHWs3+u0KEPFSkGHZN0FitikeL9ByfVPJ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VW/sgSRRAZV/tcu1qMZ8jW8dCB2sFTpxsqBG+b4Vo+hT6hmfWHTBCW/tepxS7JMFRXTybKrnmFeSY+u4hpOqvVx5aN2r03grd15dGikXBGZaaQKOmgy3HsWka46V9r7SCC5OyuIcZFk1HA0H34PJEWHASH9cXUNYQ6ElPgPn4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRFoyTMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRFoyTMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17B51F00A3D;
	Tue, 21 Jul 2026 17:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655948;
	bh=3ZGH0ZpAedWnXb3pmJPQvQX8tKD4lr6O/mnAd4EhW3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRFoyTMTCUBNoKNu5Tnu0ga9kQYGa+CeKugFkK+OqtS6HvOFw6UqgTq2NFne82Yam
	 2PI33O70tXPAXsam1iSdwfjeNvlh1myAddS+uDNJIg9GoIrkfELlMTKfdZ9TSA9DUm
	 5eWuwpiOEchtZC68/lmzBovWqy4juYW6qkESCjXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0203/1611] RDMA/mana_ib: Use ib_get_eth_speed for reporting port speed
Date: Tue, 21 Jul 2026 17:05:19 +0200
Message-ID: <20260721152519.522535735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit d28654518c8db5d06d27bd3211c0e9a70c18f7c2 ]

Replace hardcoded IB_WIDTH_4X/IB_SPEED_EDR with ib_get_eth_speed()
to report the actual link speed in mana_ib_query_port().

Fixes: 4bda1d5332ec ("RDMA/mana_ib: Implement port parameters")
Link: https://patch.msgid.link/r/20260512094056.264827-1-kotaranov@linux.microsoft.com
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 4143be70eea204..f5775900190ed0 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -633,8 +633,7 @@ int mana_ib_query_port(struct ib_device *ibdev, u32 port,
 		props->phys_state = IB_PORT_PHYS_STATE_DISABLED;
 	}
 
-	props->active_width = IB_WIDTH_4X;
-	props->active_speed = IB_SPEED_EDR;
+	ib_get_eth_speed(ibdev, port, &props->active_speed, &props->active_width);
 	props->pkey_tbl_len = 1;
 	if (mana_ib_is_rnic(dev)) {
 		props->gid_tbl_len = 16;
-- 
2.53.0



