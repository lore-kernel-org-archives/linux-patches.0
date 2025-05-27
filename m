Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380C1DC998;
	Tue, 27 May 2025 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365541; cv=none; b=KUOzYwvBX3nsbIZYqciK/07YSVBMjmhhcwV/f62nFbjFrCenOrc2iTgktSsrAPpAHtxhoiOum2YTmwxC/S0NkU9fSHwj7/4r9n2aTyFROSgLgTT9iauMGHz7BUjde2ZpOU+Z/3UP8YQ/aJG6NP9pwZAZXGOscVxXEMo8YvEujOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365541; c=relaxed/simple;
	bh=lftMYFIcCEeyqJeT3xVsLBDSAUsg9xhPiwNIO0jj4PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZI27U+QYQ35GRdQ7TdnEccq1HMbXfd4pvLxUlUtXK07gZPSfn4+t0ORtM4BTT/GwDAIAsfTo+VHucmiZhiZ8cZo/bAWTqDtp1vUyoOMfRFCyfnpRIKYruDZcqtSWeHT8jWdpeXk0Eb84HsrHeJpZT6dbPI4mQN9nKmq5QglwC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZEzlJaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZEzlJaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C05DC4CEE9;
	Tue, 27 May 2025 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365541;
	bh=lftMYFIcCEeyqJeT3xVsLBDSAUsg9xhPiwNIO0jj4PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZEzlJajRzQ3NCOAmtXi8iQBcQ039llpv2JwH/7mpVDAc09yQ4eCe0doJ6GIUBf1/
	 cLQHuf7pAwWazZNkXG9kv3QF2//mV13eypcCPKPoSzC9W/UMAZOWlDgoFUcETEpeuf
	 HxhXB/XpBAH36Q9lyxslRQ8qs/mfU8DPFS8rvRtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <witu@nvidia.com>,
	Bodong Wang <bodong@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 408/626] net/mlx5e: reduce rep rxq depth to 256 for ECPF
Date: Tue, 27 May 2025 18:25:01 +0200
Message-ID: <20250527162501.589659526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: William Tu <witu@nvidia.com>

[ Upstream commit b9cc8f9d700867aaa77aedddfea85e53d5e5d584 ]

By experiments, a single queue representor netdev consumes kernel
memory around 2.8MB, and 1.8MB out of the 2.8MB is due to page
pool for the RXQ. Scaling to a thousand representors consumes 2.8GB,
which becomes a memory pressure issue for embedded devices such as
BlueField-2 16GB / BlueField-3 32GB memory.

Since representor netdevs mostly handles miss traffic, and ideally,
most of the traffic will be offloaded, reduce the default non-uplink
rep netdev's RXQ default depth from 1024 to 256 if mdev is ecpf eswitch
manager. This saves around 1MB of memory per regular RQ,
(1024 - 256) * 2KB, allocated from page pool.

With rxq depth of 256, the netlink page pool tool reports
$./tools/net/ynl/cli.py --spec Documentation/netlink/specs/netdev.yaml \
	 --dump page-pool-get
 {'id': 277,
  'ifindex': 9,
  'inflight': 128,
  'inflight-mem': 786432,
  'napi-id': 775}]

This is due to mtu 1500 + headroom consumes half pages, so 256 rxq
entries consumes around 128 pages (thus create a page pool with
size 128), shown above at inflight.

Note that each netdev has multiple types of RQs, including
Regular RQ, XSK, PTP, Drop, Trap RQ. Since non-uplink representor
only supports regular rq, this patch only changes the regular RQ's
default depth.

Signed-off-by: William Tu <witu@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250209101716.112774-8-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index fd1f460b7be65..18ec392d17404 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -65,6 +65,7 @@
 #define MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE \
 	max(0x7, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE)
 #define MLX5E_REP_PARAMS_DEF_NUM_CHANNELS 1
+#define MLX5E_REP_PARAMS_DEF_LOG_RQ_SIZE 0x8
 
 static const char mlx5e_rep_driver_name[] = "mlx5e_rep";
 
@@ -854,6 +855,8 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 
 	/* RQ */
 	mlx5e_build_rq_params(mdev, params);
+	if (!mlx5e_is_uplink_rep(priv) && mlx5_core_is_ecpf(mdev))
+		params->log_rq_mtu_frames = MLX5E_REP_PARAMS_DEF_LOG_RQ_SIZE;
 
 	/* If netdev is already registered (e.g. move from nic profile to uplink,
 	 * RTNL lock must be held before triggering netdev notifiers.
-- 
2.39.5



