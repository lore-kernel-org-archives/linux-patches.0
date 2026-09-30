Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5791511E90;
	Wed, 30 Sep 2026 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792124; cv=none; b=kIBU7DBvgvyA45VQOaJ05TUTclC11BQ0j/+ccrxZB5mlYTHQ2dcYlBdJsNbZniR6dUtqB7BYs0ETo2ORs9Vz2YmEpl2S5ylHqSk01VVh5ksM5tTcJG/RapP4xts7ZE0Yol8oXUSZVyljaYuZdaaE3XxSgzccEwh0SEzIx3c3hLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792124; c=relaxed/simple;
	bh=E8XKkz/Itr1mKKW7YjMX/0NOoPumGe3foiyGiSFy+fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pfpk7B2sZWWiqALTEEQd/YtGytjg5SSMRUFULdWy0qPyUfLOHaQrruAlp3O6Wi4285jJFiQu9Wh7//Kydctv9K1AbvXxrY0DlRiV5XNkzpoFtxMhCIZnwWIga5xkDynkz0aOZaA7P3NF1Hqu/00wQlL+tSmShJB+cFzQJ2c4rqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQuYWqLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQuYWqLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565D61F000FF;
	Wed, 30 Sep 2026 18:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792123;
	bh=yXhsAW54E+2kvtGjnOHEFcZQ3yeIJDm62F50q4RZIxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQuYWqLSMD0HL8OyOn5raFMvqrN2Xa7ZVtO4hYHO+j2sYISRHofyExVNAfDk1La4W
	 5noFChvqRilUYeN6tEqqjEj7oACbqU2c1eqrEzMAHvrWO52JyRu+cLaWVN73f1ypZu
	 N5T/nm9Gj3EbjT5eRkfYh880DTWQRrJw9O46MzOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.15 543/752] IB/mlx4: Fix use-after-free on pkey sysfs registration failure
Date: Wed, 30 Sep 2026 17:26:53 +0200
Message-ID: <20260930152409.998168972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -753,11 +753,13 @@ err_add:
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
@@ -787,6 +789,8 @@ static void unregister_pkey_tree(struct
 		return;
 
 	for (slave = device->dev->persist->num_vfs; slave >= 0; --slave) {
+		if (!device->pkeys.device_parent[slave])
+			continue;
 		list_for_each_entry_safe(p, t,
 					 &device->pkeys.pkey_port_list[slave],
 					 entry) {


