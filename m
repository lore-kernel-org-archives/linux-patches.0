Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D903497B76;
	Wed, 23 Sep 2026 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174168; cv=none; b=e7B86NuuvANvDGQ2vrmrVFniVK8eUVjOf3qh1al6Usw5eFmneR/GDrbDlrbknDNQwHevJ7DVe6JJycIFogx768XGT60RtOLdrIxKutgRf2EVh8m0UUKFjBEl+zyiDKOOKf7lfmfgZ3z37oZn1lrnOhposJpHbP7a4atn7VJnFKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174168; c=relaxed/simple;
	bh=BU/9+9K7Z1RZ/KE1XBYRoT0f3zJLcYY6iGVim+P4Y74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNyxVIW4KYjVb8dhHQ27Iqd8XvSVbY5+WTfYI4IVPcan3/PtYG1bXaLvTlT+3sGiatTMv6cDO/g5xGZtZ8ywz5WQstPoK7q0WkjTxLl0Ka8+syvwvhbdJE76el9NUO6yzSrBiZBGJY2M88LR5xp1HkrGcYd4HGQkb5YRmYGhI1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01vu3C92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01vu3C92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B031F000FF;
	Wed, 23 Sep 2026 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174166;
	bh=8jfwsv9Sk1Vfva3SwH7gkowSP7KlIKlymuQUzLxAY3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01vu3C92R0/aozETd2Zay7CMnZH5Qr+Z8TxiNtn9tvtVDc6QP/M+rujYFXZR6zGsY
	 VAzBqPsrIxVACUiQh56d7cywnLHb3Eaw9ch4tYJ1jYmeBodTWn9AI+X6sOVDOiH+vN
	 fbWxexEvJye5fjwb/rkY+Mu4lbU/hXOrdRQuZ0Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/398] RDMA/mlx5: Remove warn on missing representor in query_port_speed
Date: Wed, 23 Sep 2026 16:01:45 +0200
Message-ID: <20260923140644.235508872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index c6b0bb786739d..3dd100cd91565 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1669,11 +1669,8 @@ static int mlx5_ib_query_port_speed_rep(struct mlx5_ib_dev *dev, u32 port_num,
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



