Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC0353162E;
	Wed, 23 Sep 2026 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173768; cv=none; b=BTjQKVXuT046CO0JeA24xo1JSG9Q4vehe3NoCSEZg0OLAJPHb1cjb5r40UtSoGcx0yGjJq7F1rQ5GZbj5QstefIB7h0iFiSKTj30+bS6pfawVDh1l6gZ5BiG/zQH5p0EzfTHec2wqduo6n0zh+vEYeq8r5bYb4vWBW8+nFdULd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173768; c=relaxed/simple;
	bh=Hsw6NE/w08Eao3lyKus/f+1u1xJGdgX/V3OMcURV868=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JS356KSFl8130RYg+uVY4BpDjj5gMbPO+Dem4WSA19vPi56ilv1W2iHD/zYDjaFBVgvRko7TKadPHHY1wQmqaldawuWHLLt1fwY1Zyz+9aTuYVjOjNTJHwNDdEwG9DyT4Veln0emp2trMnvJWwnG+5jZ06TqKUVaa9LbhM77R4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTxxvDt/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTxxvDt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2034C1F000FF;
	Wed, 23 Sep 2026 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173767;
	bh=5NvU9vgRcSkly440AIYzcTk2dZGSQhDgQE6iQp9plEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTxxvDt/IIMnKM269bVosoCM+rVmp/CuX/fcLqPOCXHG8MFpQHTMmuJk1aNf+P9k7
	 awz4VylM0KGzWjdmEnK7K8//O2oXFDd9BEFxN5EBUx+35D1V0yfY1M6hNUxMXm5irZ
	 fvRHyD2IhCwYwVwwZkWs6WVYTnhm/5vmJXSc+fNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 7.2 330/438] IB/mlx4: Fix use-after-free on pkey sysfs registration failure
Date: Wed, 23 Sep 2026 16:05:51 +0200
Message-ID: <20260923140653.364048414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -751,11 +751,13 @@ err_add:
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
@@ -785,6 +787,8 @@ static void unregister_pkey_tree(struct
 		return;
 
 	for (slave = device->dev->persist->num_vfs; slave >= 0; --slave) {
+		if (!device->pkeys.device_parent[slave])
+			continue;
 		list_for_each_entry_safe(p, t,
 					 &device->pkeys.pkey_port_list[slave],
 					 entry) {


