Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2BD1EF1D;
	Wed,  2 Oct 2024 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880041; cv=none; b=V5WuUMajH/MsnxMkfAX3EFjbqt9bZpzw9/lmFfhFv28JpkuWpiEAYa/SKrEEZW9fk1FzH/QzkJXtrMTLKmzhDdUZ/47dbaR8j+Tc+tZtdH2cA8QiHULw+EiBouhU1YZaJ5ofWFdPBFuA2TLntzSh6oel39mooe6XeFGERBWmwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880041; c=relaxed/simple;
	bh=xI8GE7oOnOIL/ucuSGNAAxsatkYA9zALra0e6iPt2vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9ZuAdzPQEmnegrDTAnvtqXENKb1yZGa2uFjUF3OBdrB072r778+kDIamMUZgU9EgMx5AaddQyWEI6qP3DtwclgRRfSHKHPXjWmc08IV+p9mIYIzNzU7amIrSfjPjxVGof/l/rqM3GnYJSWi05jiacQunm1V7METZFC47STxmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxnnYeOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxnnYeOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5ACC4CEC2;
	Wed,  2 Oct 2024 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880041;
	bh=xI8GE7oOnOIL/ucuSGNAAxsatkYA9zALra0e6iPt2vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxnnYeOQOenZ6y81tEqO5jIih2Be/fBGCil+Eregwqal5UROczawdafKxBpOk1wsy
	 MyHRzlX86IiYPY4t6lnSw8TBWooXqiKuyVryy18s+q2M/L5Nq4TJgH8cbvNam8DNFN
	 9cEg2my3wW9pFITQQ1yW62ymIPm7k/cz2p2NyBq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 323/538] RDMA/mlx5: Obtain upper net device only when needed
Date: Wed,  2 Oct 2024 14:59:22 +0200
Message-ID: <20241002125805.178177774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 3ed7f9e239938a0cfaf3689e2f545229ecabec06 ]

Report the upper device's state as the RDMA port state only in RoCE LAG or
switchdev LAG.

Fixes: 27f9e0ccb6da ("net/mlx5: Lag, Add single RDMA device in multiport mode")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/20240909173025.30422-3-michaelgur@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2d179bc56ce60..296af7a5c2794 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -539,7 +539,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
 	if (!ndev)
 		goto out;
 
-	if (dev->lag_active) {
+	if (mlx5_lag_is_roce(mdev) || mlx5_lag_is_sriov(mdev)) {
 		rcu_read_lock();
 		upper = netdev_master_upper_dev_get_rcu(ndev);
 		if (upper) {
-- 
2.43.0



