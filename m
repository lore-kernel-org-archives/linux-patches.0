Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7FD49620;
	Mon, 13 Apr 2026 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097774; cv=none; b=Biob8dELH5fQUZkuaCBqmaCVe+XM9CFO0hz4JKsg3RnP51MeAgXul2+MARtZqhsEGHnJVCxZ7qiU3zGzlYWBLxj9wOkGKsoed5bxcPtCR/90CK8n1/urS5YW6fnn+5ADq8VR70NYzmF/FQazCwMhVGmSiwy2azLwKEDuMIn+kCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097774; c=relaxed/simple;
	bh=J/neOg0zgPoERi4NNFuHddwqsw1sE8putm1a74IdG5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEb8j6zdZEX5k+Bo0YhSXMcDIbzcrWyuPIQ9FM9jbfjYggqZk6KjrPo+wyNhJjXX0DYcozRC19HDAqJKIX17o8+kMelgwrJ3VVl7QEfCmtA8JkhRAWg+MYRDGpQh1tukRIKeADyofXRxZZo53Yr+Fz/Ndka7pcMXk4QOluCoOcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuDqFx9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuDqFx9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EFAC2BCAF;
	Mon, 13 Apr 2026 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097774;
	bh=J/neOg0zgPoERi4NNFuHddwqsw1sE8putm1a74IdG5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuDqFx9/hh+q+G+TBFazZJXtPo28jzlmu28raspGRhPsTzVlfwpJOVX95cu8tB2om
	 94F5bgHZ3N+wg6aNJnOcczDSZXLea7AYWo3zMeHbnd3uROe3SnT/AK3aqb6cuCNaoV
	 Oq2cOaFdhuXmVZlR4H6jrw9Awv42LNrLlnmEpuew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/570] RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()
Date: Mon, 13 Apr 2026 17:56:06 +0200
Message-ID: <20260413155839.267854421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@ziepe.ca>

[ Upstream commit 74586c6da9ea222a61c98394f2fc0a604748438c ]

struct irdma_create_ah_resp {  // 8 bytes, no padding
    __u32 ah_id;               // offset 0 - SET (uresp.ah_id = ah->sc_ah.ah_info.ah_idx)
    __u8  rsvd[4];             // offset 4 - NEVER SET <- LEAK
};

rsvd[4]: 4 bytes of stack memory leaked unconditionally. Only ah_id is assigned before ib_respond_udata().

The reserved members of the structure were not zeroed.

Cc: stable@vger.kernel.org
Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/3-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ adapted fix to combined irdma_create_ah() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4170,7 +4170,7 @@ static int irdma_create_ah(struct ib_ah
 	struct irdma_sc_ah *sc_ah;
 	u32 ah_id = 0;
 	struct irdma_ah_info *ah_info;
-	struct irdma_create_ah_resp uresp;
+	struct irdma_create_ah_resp uresp = {};
 	union {
 		struct sockaddr saddr;
 		struct sockaddr_in saddr_in;


