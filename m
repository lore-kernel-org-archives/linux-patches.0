Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD9037647B;
	Tue, 21 Jul 2026 20:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665770; cv=none; b=dbQ+HOjZeYRwmPeA9ipxM08rXsLa78Igb1T7milpIuJnE8h5j7vJhu0ei0TzjqLdChpFt9BIXS8AJysei3X6yEMDtkB/KotUdXLLXQ3TiskIpP8lHwp4ZmNts9k8I9oaskUCt26zCG9ZqYORGHOLURTQjIoGreGJhcQotebcb2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665770; c=relaxed/simple;
	bh=TeZxd8PtcLDtm9NdEsPYxe2ukQrsXnLJ+9jUubQKVKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FA7YexyxLvnheegspu3fSZMdeMRcFMzZkf2xFMErx60n2mrltOKsS1jR8MTrKI260R1xdQAi9qhZFlxuh6BSOs6P5T9mcSdg79oqnvrXuB04cNKe0jHMu9pzq6dB5sxtitp76HPDL8Y4/fbPmSo1RybsG00KJEaqg1bkoozrEoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMOx7qtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMOx7qtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D3B1F000E9;
	Tue, 21 Jul 2026 20:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665769;
	bh=BL9AUsru0nF/SnrZgIWkVb664Ils3CUbKuSY0jO8250=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMOx7qtYn7X7JJOTofR6Wtr6p8lV9zc/LfztHFb5jBmB18mzXdLztXpfQbE5yp+Kw
	 m1tkyqtxdtTXJtoFbItlKFTGJ4OJwKiPrTOsXRUkntLovmDtbFBQ26wCV/Up+X2V6N
	 sYiITJZtUzaF9l/yoEPzsLuCs54DYe9Z0e6i5pZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0430/1266] IB/mlx4: Fix refcount leak in add_port() error path
Date: Tue, 21 Jul 2026 17:14:27 +0200
Message-ID: <20260721152451.463763413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 9a8826fdfbcd7ed2ccf745f5d54208358d939def ]

After kobject_init_and_add(), the lifetime of the embedded struct
kobject is expected to be managed through the kobject core reference
counting.

In add_port(), failure paths after kobject_init_and_add() must not free
struct mlx4_port directly, because the embedded kobject is then managed
by the kobject core. Freeing it directly leaves the kobject reference
counting unbalanced and can lead to incorrect lifetime handling.

Allocate the pkey and gid attribute arrays before kobject_init_and_add(),
so failures before kobject initialization can be handled by directly
freeing the allocated memory. Once kobject_init_and_add() has been
called, unwind later failures by removing any successfully created sysfs
groups, calling kobject_del(), and then releasing the embedded kobject
with kobject_put().

Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
Link: https://patch.msgid.link/r/20260518021910.972900-1-lgs201920130244@gmail.com
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/sysfs.c | 45 ++++++++++++++++++------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 88f534cf690e92..1676f819c2f760 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -638,12 +638,6 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 	p->port_num = port_num;
 	p->slave = slave;
 
-	ret = kobject_init_and_add(&p->kobj, &port_type,
-				   kobject_get(dev->dev_ports_parent[slave]),
-				   "%d", port_num);
-	if (ret)
-		goto err_alloc;
-
 	p->pkey_group.name  = "pkey_idx";
 	p->pkey_group.attrs =
 		alloc_group_attrs(show_port_pkey,
@@ -651,13 +645,9 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 				  dev->dev->caps.pkey_table_len[port_num]);
 	if (!p->pkey_group.attrs) {
 		ret = -ENOMEM;
-		goto err_alloc;
+		goto err_free_port;
 	}
 
-	ret = sysfs_create_group(&p->kobj, &p->pkey_group);
-	if (ret)
-		goto err_free_pkey;
-
 	p->gid_group.name  = "gid_idx";
 	p->gid_group.attrs = alloc_group_attrs(show_port_gid_idx, NULL, 1);
 	if (!p->gid_group.attrs) {
@@ -665,28 +655,47 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 		goto err_free_pkey;
 	}
 
+	ret = kobject_init_and_add(&p->kobj, &port_type,
+				   kobject_get(dev->dev_ports_parent[slave]),
+				   "%d", port_num);
+	if (ret)
+		goto err_put;
+
+	ret = sysfs_create_group(&p->kobj, &p->pkey_group);
+	if (ret)
+		goto err_del;
+
 	ret = sysfs_create_group(&p->kobj, &p->gid_group);
 	if (ret)
-		goto err_free_gid;
+		goto err_remove_pkey;
 
 	ret = add_vf_smi_entries(p);
 	if (ret)
-		goto err_free_gid;
+		goto err_remove_gid;
 
 	list_add_tail(&p->kobj.entry, &dev->pkeys.pkey_port_list[slave]);
 	return 0;
 
-err_free_gid:
-	kfree(p->gid_group.attrs[0]);
-	kfree(p->gid_group.attrs);
+err_remove_gid:
+	sysfs_remove_group(&p->kobj, &p->gid_group);
+
+err_remove_pkey:
+	sysfs_remove_group(&p->kobj, &p->pkey_group);
+
+err_del:
+	kobject_del(&p->kobj);
+
+err_put:
+	kobject_put(dev->dev_ports_parent[slave]);
+	kobject_put(&p->kobj);
+	return ret;
 
 err_free_pkey:
 	for (i = 0; i < dev->dev->caps.pkey_table_len[port_num]; ++i)
 		kfree(p->pkey_group.attrs[i]);
 	kfree(p->pkey_group.attrs);
 
-err_alloc:
-	kobject_put(dev->dev_ports_parent[slave]);
+err_free_port:
 	kfree(p);
 	return ret;
 }
-- 
2.53.0



