Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81D74EA39A;
	Wed, 30 Sep 2026 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783561; cv=none; b=tJcin+LRmwY/pEPDxfacVXdMBZWay1pqpqgjhPtSH17Aa2vO/HlJ2tE+G6fIzOXb+encFxwFAx6ZmD0KYWPKNPfzwVq9OX1lf/NrUln756qK1823G9xt4a3jD8uOBPY7GgOxmn0t3N68ah47xoU6wutcTSONKwfYHljmACMKviM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783561; c=relaxed/simple;
	bh=ESx0v9AgawtOoXG75vhkOiZWT3ZcuqgGO5+Ob4zaH/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKMk0omxpMvg8sGhxJuzgO1h/Y/8hE1CCg83FYnI8OBNea8sGAwovqOKpjYPySWrVc2VxXokjenZ/4yV+xWDXL/8evxxNarAQ1Kgm9SA4LyYIA1ojGUhuBJHBo/K00HOdpMbOQ9Qn75dNzovD03YaAfqlwpQBNccJWrOJT6Q1dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rldd8JRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rldd8JRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A4D1F000FF;
	Wed, 30 Sep 2026 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783557;
	bh=p6Psze/djEFTD1n/j6h+uLj+2LJa2w7USzWO6lcuMpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rldd8JREFYjzGj/kwkvrYAUbqrQFpRqTm0msLg9ZuhYzrYsB9RrV5lYJU9GJf+SKW
	 UM4LvFNeQvSrppiyyE5osvYcsZJCN35KoicrPEvN/qoHGuBbU+A2J5vREaTy98PYtG
	 sAHTO6tuTg33dfl5FKZKSy3SnTptFMEyPlGJFq24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.10 439/595] IB/mlx4: Fix use-after-free on pkey sysfs registration failure
Date: Wed, 30 Sep 2026 17:25:32 +0200
Message-ID: <20260930152357.122830608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 1af874e9f4ce22ccf8b10ab5462f32c70d3be21a upstream.

register_pkey_tree() ignores errors from register_one_pkey_tree() and
continues registering the remaining slaves. The per-slave error path has
already released the pkey parent kobjects, but their pointers remain
stored in the device. A later device cleanup therefore passes the stale
pointers to kobject_put(), causing a use-after-free.

Clear the parent pointers after releasing a failed slave tree and skip
unregistered trees during device cleanup. This preserves the existing
best-effort registration behavior while preventing a second cleanup of
the failed tree.

Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260816044510.3848996-1-shuangpeng.kernel@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -763,11 +763,13 @@ err_add:
 		kobject_put(p);
 	}
 	kobject_put(dev->dev_ports_parent[slave]);
+	dev->dev_ports_parent[slave] = NULL;
 
 err_ports:
 	kobject_put(dev->pkeys.device_parent[slave]);
 	/* extra put for the device_parent create_and_add */
 	kobject_put(dev->pkeys.device_parent[slave]);
+	dev->pkeys.device_parent[slave] = NULL;
 
 fail_dev:
 	kobject_put(dev->iov_parent);
@@ -797,6 +799,8 @@ static void unregister_pkey_tree(struct
 		return;
 
 	for (slave = device->dev->persist->num_vfs; slave >= 0; --slave) {
+		if (!device->pkeys.device_parent[slave])
+			continue;
 		list_for_each_entry_safe(p, t,
 					 &device->pkeys.pkey_port_list[slave],
 					 entry) {


