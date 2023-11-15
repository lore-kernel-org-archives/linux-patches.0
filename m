Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870A24121C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frUlDTB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EF7C433C7;
	Wed, 15 Nov 2023 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076479;
	bh=qM/ZgcBPJoWJf3t8WUV8oiUEPlcw5f4ufCbSqSRO+rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frUlDTB7GH++erMMQezX7ZIVcK5PFjoqJjngZY7fMdNHfSymtZenOi+tc3c6KO+Oq
	 D3NWYqlT/DgvJemzJHY/Vp9A/w9TuRw/vImAboRUze6gkVq0r4xmCY0dG0MDkT8lS0
	 AWlng25M8rXrfwvPK+bvD4bN+eHXAclXcj9mAd04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 315/550] RDMA/core: Use size_{add,sub,mul}() in calls to struct_size()
Date: Wed, 15 Nov 2023 14:14:59 -0500
Message-ID: <20231115191622.648469376@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 81760bedc65194ff38e1e4faefd5f9f0c95c19a4 ]

If, for any reason, the open-coded arithmetic causes a wraparound,
the protection that `struct_size()` provides against potential integer
overflows is defeated. Fix this by hardening calls to `struct_size()`
with `size_add()`, `size_sub()` and `size_mul()`.

Fixes: 467f432a521a ("RDMA/core: Split port and device counter sysfs attributes")
Fixes: a4676388e2e2 ("RDMA/core: Simplify how the gid_attrs sysfs is created")
Fixes: e9dd5daf884c ("IB/umad: Refactor code to use cdev_device_add()")
Fixes: 324e227ea7c9 ("RDMA/device: Add ib_device_get_by_netdev()")
Fixes: 5aad26a7eac5 ("IB/core: Use struct_size() in kzalloc()")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/ZQdt4NsJFwwOYxUR@work
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c   |  2 +-
 drivers/infiniband/core/sa_query.c |  4 +++-
 drivers/infiniband/core/sysfs.c    | 10 +++++-----
 drivers/infiniband/core/user_mad.c |  4 +++-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a666847bd7143..010718738d04c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -804,7 +804,7 @@ static int alloc_port_data(struct ib_device *device)
 	 * empty slots at the beginning.
 	 */
 	pdata_rcu = kzalloc(struct_size(pdata_rcu, pdata,
-					rdma_end_port(device) + 1),
+					size_add(rdma_end_port(device), 1)),
 			    GFP_KERNEL);
 	if (!pdata_rcu)
 		return -ENOMEM;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 59179cfc20ef9..8175dde60b0a8 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -2159,7 +2159,9 @@ static int ib_sa_add_one(struct ib_device *device)
 	s = rdma_start_port(device);
 	e = rdma_end_port(device);
 
-	sa_dev = kzalloc(struct_size(sa_dev, port, e - s + 1), GFP_KERNEL);
+	sa_dev = kzalloc(struct_size(sa_dev, port,
+				     size_add(size_sub(e, s), 1)),
+			 GFP_KERNEL);
 	if (!sa_dev)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index ee59d73915689..ec5efdc166601 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -903,7 +903,7 @@ alloc_hw_stats_device(struct ib_device *ibdev)
 	 * Two extra attribue elements here, one for the lifespan entry and
 	 * one to NULL terminate the list for the sysfs core code
 	 */
-	data = kzalloc(struct_size(data, attrs, stats->num_counters + 1),
+	data = kzalloc(struct_size(data, attrs, size_add(stats->num_counters, 1)),
 		       GFP_KERNEL);
 	if (!data)
 		goto err_free_stats;
@@ -1009,7 +1009,7 @@ alloc_hw_stats_port(struct ib_port *port, struct attribute_group *group)
 	 * Two extra attribue elements here, one for the lifespan entry and
 	 * one to NULL terminate the list for the sysfs core code
 	 */
-	data = kzalloc(struct_size(data, attrs, stats->num_counters + 1),
+	data = kzalloc(struct_size(data, attrs, size_add(stats->num_counters, 1)),
 		       GFP_KERNEL);
 	if (!data)
 		goto err_free_stats;
@@ -1140,7 +1140,7 @@ static int setup_gid_attrs(struct ib_port *port,
 	int ret;
 
 	gid_attr_group = kzalloc(struct_size(gid_attr_group, attrs_list,
-					     attr->gid_tbl_len * 2),
+					     size_mul(attr->gid_tbl_len, 2)),
 				 GFP_KERNEL);
 	if (!gid_attr_group)
 		return -ENOMEM;
@@ -1205,8 +1205,8 @@ static struct ib_port *setup_port(struct ib_core_device *coredev, int port_num,
 	int ret;
 
 	p = kvzalloc(struct_size(p, attrs_list,
-				attr->gid_tbl_len + attr->pkey_tbl_len),
-		    GFP_KERNEL);
+				size_add(attr->gid_tbl_len, attr->pkey_tbl_len)),
+		     GFP_KERNEL);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 	p->ibdev = device;
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 7e5c33aad1619..f5feca7fa9b9c 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1378,7 +1378,9 @@ static int ib_umad_add_one(struct ib_device *device)
 	s = rdma_start_port(device);
 	e = rdma_end_port(device);
 
-	umad_dev = kzalloc(struct_size(umad_dev, ports, e - s + 1), GFP_KERNEL);
+	umad_dev = kzalloc(struct_size(umad_dev, ports,
+				       size_add(size_sub(e, s), 1)),
+			   GFP_KERNEL);
 	if (!umad_dev)
 		return -ENOMEM;
 
-- 
2.42.0



