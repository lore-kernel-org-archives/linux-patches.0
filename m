Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81B21F3D56;
	Tue, 21 Jul 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653735; cv=none; b=u/P7rfdYmManUFGhcqJKgCE0i4XtyjumFdFOeGLbSj7a2dSf1XHGtzN3hPWBEo0oHYkyrGB+Fhho1HmCpwVLfB82TmJx7dkdUFxgXPSZkXCLSt6KwXCq/I8UOUMRzGd5kNmBgOBO/n0EhUBz9Ini0u4CSWwfrqsmOEfRiJG9RUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653735; c=relaxed/simple;
	bh=uC5+m1rP7LREcg/rb0h+QEOfAZIcPARQ3A8+WSB9vdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMXwwGEQgCJeX0ooI5uFel71lzL3dJ1ZINN0Qk26TuptsbfCYS2ix7iq9g0FyQ3NyZhmruAYITeN5vgfkQJkry1aQkpT4Xog6SoH0S2UWWzocRkj/48xBLP72LDb6K7+nSJ6nBAJ4iuqQVRS/n7TOxr/ozCaC7NQxqrdv8WZWjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VxcyWUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VxcyWUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1856C1F000E9;
	Tue, 21 Jul 2026 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653734;
	bh=ULAzkH1wx1PnJIXH0btJ9lTITahGOEygEpfS8Cqj+KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VxcyWUieXelJ3Brk4omuzXGQ7h9EKrYNlOlVzhwmUZXxax7tBuxdFPERuyNiGIhn
	 acJ1f6dqoTtMu6VvRKCLitagM5UWcI3FLCA86wLWgLZJSApiEh3axstpCFx5DAZBr3
	 ocJgM1oc1N9ldI1+aPGFJWkmU8IFbOTd6CCA88qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1440/2077] net/mlx5e: TC, skip peer flow cleanup when LAG seq is unavailable
Date: Tue, 21 Jul 2026 17:18:33 +0200
Message-ID: <20260721152626.769434006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 7bed4af0ced82948d660205efecd551ef8bc3912 ]

mlx5_lag_get_dev_seq() will return error when the peer isn't in the LAG
or when no device is marked as master. Result bad memory access and kernel
crash[1].

Hence, skip the peer when lookup fails.

Note: In case there are peer flows, they are cleaned before LAG cleared
the master mark.

[1]
RIP: 0010:mlx5e_tc_del_fdb_peers_flow+0x3d/0x350 [mlx5_core]
Call Trace:
 <TASK>
 mlx5e_tc_clean_fdb_peer_flows+0xc1/0x130 [mlx5_core]
 mlx5_esw_offloads_unpair+0x3a/0x400 [mlx5_core]
 mlx5_esw_offloads_devcom_event+0xee/0x360 [mlx5_core]
 mlx5_devcom_send_event+0x7a/0x140 [mlx5_core]
 mlx5_esw_offloads_devcom_cleanup+0x2f/0x90 [mlx5_core]
 mlx5e_tc_esw_cleanup+0x28/0xf0 [mlx5_core]
 mlx5e_rep_tc_cleanup+0x19/0x30 [mlx5_core]
 mlx5e_cleanup_uplink_rep_tx+0x36/0x40 [mlx5_core]
 mlx5e_cleanup_rep_tx+0x55/0x60 [mlx5_core]
 mlx5e_detach_netdev+0x96/0xf0 [mlx5_core]
 mlx5e_netdev_change_profile+0x5b/0x120 [mlx5_core]
 mlx5e_netdev_attach_nic_profile+0x1b/0x30 [mlx5_core]
 mlx5e_vport_rep_unload+0xdd/0x110 [mlx5_core]
 __esw_offloads_unload_rep+0x81/0xb0 [mlx5_core]
 mlx5_eswitch_unregister_vport_reps+0x1d7/0x220 [mlx5_core]
 mlx5e_rep_remove+0x22/0x30 [mlx5_core]
 device_release_driver_internal+0x194/0x1f0
 bus_remove_device+0xe8/0x1b0
 device_del+0x159/0x3c0
 mlx5_rescan_drivers_locked+0xbc/0x2d0 [mlx5_core]
 mlx5_unregister_device+0x54/0x80 [mlx5_core]
 mlx5_uninit_one+0x73/0x130 [mlx5_core]
 remove_one+0x78/0xe0 [mlx5_core]
 pci_device_remove+0x39/0xa0

Fixes: 971b28accc09 ("net/mlx5: LAG, replace mlx5_get_dev_index with LAG sequence number")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260630112917.698313-4-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a9001d1c902ff1..8b5a421a22a37a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5526,6 +5526,9 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw)
 
 	mlx5_devcom_for_each_peer_entry(devcom, peer_esw, pos) {
 		i = mlx5_lag_get_dev_seq(peer_esw->dev);
+		if (i < 0)
+			continue;
+
 		list_for_each_entry_safe(flow, tmp, &esw->offloads.peer_flows[i], peer[i])
 			mlx5e_tc_del_fdb_peers_flow(flow);
 	}
-- 
2.53.0



