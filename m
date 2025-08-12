Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC36D20E023;
	Tue, 12 Aug 2025 19:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026245; cv=none; b=tNh4cpug9r1/fnojCSppXsgngB/uDZlhau9N+PIZYXSg5wCX+cYmwBVMICjTQdljk/ad8BMS/XBKy+xg+VoQWwd4AEqep6ChhUvf8MQrzWJreUD1D32VqUhb2oZmoee34kSLBepvDUYXC/fJTce/ZshgXES2X6LtezVShBNuUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026245; c=relaxed/simple;
	bh=o+zNCEPtDF0MH79kWCahc3bKsBDq31IStl6db49GtHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhzGih36qu0qEf3wzsON4pq5mVvtwiAaMOHA70Fl32AIkByeZ4yVq+coXrek8XfD6KDpGQBmtnpFnXRVWcSMb5vAWK2/Pggu6nCYiKDnSsqWxm26dAPzU/4OPA/hqdT6FRjgKJl2vJyuH6O3atmvPwAN7q6rzxZv5RGrTdrAxMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLF1EzU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLF1EzU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22335C4CEF0;
	Tue, 12 Aug 2025 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026245;
	bh=o+zNCEPtDF0MH79kWCahc3bKsBDq31IStl6db49GtHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLF1EzU9wOMrSkbrqEgcJzXR+RoVJfjERFqfRpgbBaRteZLLBljqzyfKG10exVpTS
	 3Cg3h9p8cff/fpXJHHnOwGQdXF/9DnzjHMJcOUfY6UhNlrc2LKDjTuMVh9hLMQoj5E
	 AQlZkrHHzZPrHt69XnxTCO7iGW8ThJnt8jlOT6qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 280/480] RDMA/mana_ib: Fix DSCP value in modify QP
Date: Tue, 12 Aug 2025 19:48:08 +0200
Message-ID: <20250812174408.984167984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit 62de0e67328e9503459a24b9343c3358937cdeef ]

Convert the traffic_class in GRH to a DSCP value as required by the HW.

Fixes: e095405b45bb ("RDMA/mana_ib: Modify QP state")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1752143085-4169-1-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index c928af58f38b..456d78c6fcb8 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -773,7 +773,7 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		req.ah_attr.dest_port = ROCE_V2_UDP_DPORT;
 		req.ah_attr.src_port = rdma_get_udp_sport(attr->ah_attr.grh.flow_label,
 							  ibqp->qp_num, attr->dest_qp_num);
-		req.ah_attr.traffic_class = attr->ah_attr.grh.traffic_class;
+		req.ah_attr.traffic_class = attr->ah_attr.grh.traffic_class >> 2;
 		req.ah_attr.hop_limit = attr->ah_attr.grh.hop_limit;
 	}
 
-- 
2.39.5



