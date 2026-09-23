Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841B13B388E;
	Wed, 23 Sep 2026 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172668; cv=none; b=qXRLE+Uz2LqqnGUl3mQG87qQWAN9FH6YSpMzKb0kOFKkl9YnkaMFwXCh18VxCMvV6/tVtGDc8yueBmjL6k2bY9a7vVlxL2EeCHg5AljS2owkPpWF6wv9iGjMFbUEseIBfyuvTnBeTFZXMpilQvRi1vzFZL933H4RNbWrU8SqR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172668; c=relaxed/simple;
	bh=fjHO8o/8re+4Ii59siJujMts34EsQFJmRd3qLqp0isU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ+n/+PPw79ZeYUYIa/NKUW8101gxQf6lRrtdiH9+4K78VJ9KIDjf5HbuG9wCDZSPCx4PsPbcaKrGgVMH0oq3ZxkjnlvA/Ag9CBkEt4farsZSMf2bc8WeRXIRXAA36CBZY+MA1mwlg/FPPrH6tqb3Dk89XhgjMIMwxOIpNo8rr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dZVQgCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dZVQgCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609EB1F000FF;
	Wed, 23 Sep 2026 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172666;
	bh=+9QHsuaCcyWFNiwHHDfZ9pvUmpiiMXHNvUi9gLLuEDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dZVQgCPTCLoX+5wy7KfYNQ2LHvZnLWoICtzH67JJIkRJLQu8fjTQWhc6vCAlpu65
	 dF6hnHCggRFhoIhB92khwRbTljLeep5awq+GsmlNARkm5RVXPxsLmWHwvgfPg5V8wF
	 BoSroqHMPq8etBUN+ywlhKRTVBfz6074BOF0vGrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 026/438] RDMA/mlx5: Remove warn on missing representor in query_port_speed
Date: Wed, 23 Sep 2026 16:00:47 +0200
Message-ID: <20260923140645.455950543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 2be77295316c2dff0a33c0dc3a65abdab4ccf796 ]

The representor ib_device's phys_port_cnt is set to the total vport
count when the uplink vport rep loads. Individual port[i].rep entries
are populated only as each VF/SF vport rep registers. A NULL .rep for
a given port index is therefore expected while VF reps are still
loading or haven't been enabled yet.

Tools like ibstat and ibv_devinfo iterate over all ports of all RDMA
devices. Some ports may not have an eswitch representor, causing
repeated dmesg warnings when these tools run without a device argument.
This causes dmesg to be flooded with this message on every ibstat
invocation.

Remove the warning and return -ENODEV when no representor exists for
the queried port.

Fixes: aaecff5e13cd ("RDMA/mlx5: Implement query_port_speed callback")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260811-remove-warn-on-miss-rep-v1-1-eccf399bc6af@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c283a902ea7e4..05985395fca00 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1684,11 +1684,8 @@ static int mlx5_ib_query_port_speed_rep(struct mlx5_ib_dev *dev, u32 port_num,
 	struct mlx5_core_dev *mdev;
 	u16 op_mod;
 
-	if (!dev->port[port_num - 1].rep) {
-		mlx5_ib_warn(dev, "Representor doesn't exist for port %u\n",
-			     port_num);
-		return -EINVAL;
-	}
+	if (!dev->port[port_num - 1].rep)
+		return -ENODEV;
 
 	rep = dev->port[port_num - 1].rep;
 	mdev = mlx5_eswitch_get_core_dev(rep->esw);
-- 
2.53.0



