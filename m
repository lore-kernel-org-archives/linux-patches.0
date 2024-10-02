Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96BA19F411;
	Wed,  2 Oct 2024 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878341; cv=none; b=Jjp2u9Re8Mw1WyaUcMa2avrEgKu3TehwCz7h3Z8wWqK1asFTZw3f393PAOJlGAUMhuHlkcETbNQwZdrKGIHr3K6bB/BTI25i+WNmHqqF9g7fF3r79Vp+WmRMZWuJESGPSsb452zSEPkJfheJh3GJGBYg1kzx6f78mVbtG6YPZ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878341; c=relaxed/simple;
	bh=nZxdxLEio5xx2BZ0rJQI8PJAM/482J//CMA74UsKiuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTZ8xnKbqjr5pMXGD21aS94aInkdNCuvr1wXA/aOV5fIgyQilFT4+BzsTvS9C1kxHpq4i/4iYnQ6rOyU72Nxn3IrhZc7OFPZGkRJby73tOiGIAumc2Tmq4U/BRJOPDUoV3opeUfNfNhJuAPw94yeoVDIRtI46YdNf3UlTLIX2Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqP5L8nI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqP5L8nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C61C4CEC2;
	Wed,  2 Oct 2024 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878340;
	bh=nZxdxLEio5xx2BZ0rJQI8PJAM/482J//CMA74UsKiuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqP5L8nIVG/r6U/lxry66kUKP+fGlP3losk+XQil0+t8b1svl+R0aV9i0uYp8BNhU
	 RlfRFpq0humldbmwx5U8idXSdZ7ZnikvTPDnq+iQ+P8XBVjBGQR/1r2Po0MuvSR8nz
	 nUdNVW7irFQp3A7lxKg/QRX6CTHKajcw7kS5pVhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 381/634] RDMA/mlx5: Obtain upper net device only when needed
Date: Wed,  2 Oct 2024 14:58:01 +0200
Message-ID: <20241002125826.137996354@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 43660c831b22c..fdb0e62d805b9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -542,7 +542,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
 	if (!ndev)
 		goto out;
 
-	if (dev->lag_active) {
+	if (mlx5_lag_is_roce(mdev) || mlx5_lag_is_sriov(mdev)) {
 		rcu_read_lock();
 		upper = netdev_master_upper_dev_get_rcu(ndev);
 		if (upper) {
-- 
2.43.0



