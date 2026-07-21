Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E02646A60E;
	Tue, 21 Jul 2026 19:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661660; cv=none; b=tc5vr2KIZu0Q+WwuSCruwMFLuMpWp64JtrZz6CoHO1TOnlmX1bF7leciKUsu8BPPk4hFsr9mrrH5CnRadDo8RKM8iY6cUy7Zs45SCfvrRdefY0ZtwMpYOADSbhJ4pIpIACqBpb8aHnTzcR1KcbIN/pdTIwXyILkBuRazxSMHL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661660; c=relaxed/simple;
	bh=o+MR3BbDRGPtLS+hP6+HyN8Pelctdn9DugmdykcL39Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpFTwSMGyaMCSArwdx6z0wRumu+KR7bTAtNba5iolYlSN0IlL1toZDSerwCRIe13i+O0vgtMIiA3EHzkU1Y7Uy5ixBp4OZxhXxzCj0/b36G+Z+lSq8WLokvndnJ2uvdotOk+6/8mpz7s5qZcYy2eaQmXQPHYJLUmkrpuynNv+7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4/KAWmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4/KAWmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5A51F000E9;
	Tue, 21 Jul 2026 19:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661659;
	bh=Bhl0XG5fCbkotGDH5MJmuQ4HmIJPrr6IL/CP4W+uTPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4/KAWmvGy/izxmW6+fXn5RW6Q0ojGBCeVzB5vNSP1Os7CIiQOenrZDXeiYEi8En5
	 89r89f4TnCzHmJDkMjrNoK4gtA2DssxhXLFEsv/wRUmWMnDpBaXnp+7dsAu3Iphe21
	 HdxtKye21ucIeWD3asgbwQft0dKtQpTo623/zU/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0151/1276] RDMA/mana_ib: Use ib_get_eth_speed for reporting port speed
Date: Tue, 21 Jul 2026 17:09:54 +0200
Message-ID: <20260721152449.480992577@linuxfoundation.org>
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
index f6bf289041bfe3..ebc9648ca0acf5 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -592,8 +592,7 @@ int mana_ib_query_port(struct ib_device *ibdev, u32 port,
 		props->phys_state = IB_PORT_PHYS_STATE_DISABLED;
 	}
 
-	props->active_width = IB_WIDTH_4X;
-	props->active_speed = IB_SPEED_EDR;
+	ib_get_eth_speed(ibdev, port, &props->active_speed, &props->active_width);
 	props->pkey_tbl_len = 1;
 	if (port == 1)
 		props->gid_tbl_len = 16;
-- 
2.53.0



