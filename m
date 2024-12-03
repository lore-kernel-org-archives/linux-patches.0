Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2131381B1;
	Tue,  3 Dec 2024 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241375; cv=none; b=iqegYm77ijHfTp3Japy8pWYaWXrpv92MYRnRu2G7yb6IbGsw/xazhydvU6iF/wLfXnAWUjmuiBTYkX08uQDvKMj+DQRYY6YSRqiuMcKE6YLCMy43ZAkRlJjuFvleE/3S7V1J8Nz5OmcqWiaRTK0C/NSfdnVBfi6jaQqU+b8rubE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241375; c=relaxed/simple;
	bh=uaYRdsTZgZ6+T3/uyECI12KQyiG411jzlva6IBZeoFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA1xVqFELhOLg6hzM+EMCATrGoA1rvteLH9ib9KEBb2zsZR8bS/BmhgoX6cRyGhlUIDjjdKo2vbVoV2x3tF0pAozwvzb5cFctRcjU9LVEdye97YZh1ZBDIww9fWgaTtt9tz59bgMXgFI4OXABySXH9muuYB1v9aHIhG+Fm2q0r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh6GbNd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh6GbNd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B81C4CECF;
	Tue,  3 Dec 2024 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241375;
	bh=uaYRdsTZgZ6+T3/uyECI12KQyiG411jzlva6IBZeoFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh6GbNd/8rTMS9HXj9C+UPmE7cO4EDKHfIFPh/2gcm/o65MXRMvmA2cLHZs555Fr0
	 89x/srfZh7XAq9N1BoWZPla1qOpXyix7PNGdw5K2DrA4PD3tQzYjZTLL39NhFws3TZ
	 hDDKShLY6SaeizpKCc1/6PGpVuW7DjhscPgdEvNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/826] RDMA/core: Implement RoCE GID port rescan and export delete function
Date: Tue,  3 Dec 2024 15:42:08 +0100
Message-ID: <20241203144759.403526678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit af7a35bf6c36a77624d3abe46b3830b7c2a5f20c ]

rdma_roce_rescan_port() scans all network devices in
the system and adds the gids if relevant to the RoCE device
port. When not in bonding mode it adds the GIDs of the
netdevice in this port. When in bonding mode it adds the
GIDs of both the port's netdevice and the bond master
netdevice.

Export roce_del_all_netdev_gids(), which  removes all GIDs
associated with a specific netdevice for a given port.

Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Link: https://patch.msgid.link/674d498da4637a1503ff1367e28bd09ff942fd5e.1730381292.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 0bd2c61df953 ("RDMA/mlx5: Ensure active slave attachment to the bond IB device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/roce_gid_mgmt.c | 30 +++++++++++++++++++++----
 include/rdma/ib_verbs.h                 |  3 +++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index d5131b3ba8ab0..a9f2c6b1b29ed 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -515,6 +515,27 @@ void rdma_roce_rescan_device(struct ib_device *ib_dev)
 }
 EXPORT_SYMBOL(rdma_roce_rescan_device);
 
+/**
+ * rdma_roce_rescan_port - Rescan all of the network devices in the system
+ * and add their gids if relevant to the port of the RoCE device.
+ *
+ * @ib_dev: IB device
+ * @port: Port number
+ */
+void rdma_roce_rescan_port(struct ib_device *ib_dev, u32 port)
+{
+	struct net_device *ndev = NULL;
+
+	if (rdma_protocol_roce(ib_dev, port)) {
+		ndev = ib_device_get_netdev(ib_dev, port);
+		if (!ndev)
+			return;
+		enum_all_gids_of_dev_cb(ib_dev, port, ndev, ndev);
+		dev_put(ndev);
+	}
+}
+EXPORT_SYMBOL(rdma_roce_rescan_port);
+
 static void callback_for_addr_gid_device_scan(struct ib_device *device,
 					      u32 port,
 					      struct net_device *rdma_ndev,
@@ -575,16 +596,17 @@ static void handle_netdev_upper(struct ib_device *ib_dev, u32 port,
 	}
 }
 
-static void _roce_del_all_netdev_gids(struct ib_device *ib_dev, u32 port,
-				      struct net_device *event_ndev)
+void roce_del_all_netdev_gids(struct ib_device *ib_dev,
+			      u32 port, struct net_device *ndev)
 {
-	ib_cache_gid_del_all_netdev_gids(ib_dev, port, event_ndev);
+	ib_cache_gid_del_all_netdev_gids(ib_dev, port, ndev);
 }
+EXPORT_SYMBOL(roce_del_all_netdev_gids);
 
 static void del_netdev_upper_ips(struct ib_device *ib_dev, u32 port,
 				 struct net_device *rdma_ndev, void *cookie)
 {
-	handle_netdev_upper(ib_dev, port, cookie, _roce_del_all_netdev_gids);
+	handle_netdev_upper(ib_dev, port, cookie, roce_del_all_netdev_gids);
 }
 
 static void add_netdev_upper_ips(struct ib_device *ib_dev, u32 port,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9cb8b5fe7eee4..67551133b5228 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4734,6 +4734,9 @@ ib_get_vector_affinity(struct ib_device *device, int comp_vector)
  * @device:         the rdma device
  */
 void rdma_roce_rescan_device(struct ib_device *ibdev);
+void rdma_roce_rescan_port(struct ib_device *ib_dev, u32 port);
+void roce_del_all_netdev_gids(struct ib_device *ib_dev,
+			      u32 port, struct net_device *ndev);
 
 struct ib_ucontext *ib_uverbs_get_ucontext_file(struct ib_uverbs_file *ufile);
 
-- 
2.43.0



