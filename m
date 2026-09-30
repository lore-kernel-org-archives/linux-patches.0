Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E22516157;
	Wed, 30 Sep 2026 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788816; cv=none; b=fnEZKl9dXtCclW4oGSRFZNcGgraF7DricKNsXt7DiJfWF4y6XcQTrdb2VYsD36olSrHeXCAKtAUVgcsQCdUQQ9t082wf00pPdgDC41xMAV520gLAu5v1ctR5h8ZeGiZy+B1J7rrsQ5NX14ekTm8En16LdKtwkMBQ4E6ONqu6VTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788816; c=relaxed/simple;
	bh=KEuESN9fY49yy0cdjCTSFcc+X/vMysBpgZz9158qiBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbKPf2NrO4SOwdcAuAXanvL9hqsg2y+d9MAxZypfokfyn/rWssUf0/amXOC2aqPm3umaID+D7ayoGxIXc0fdddAWU+Ut2ppUMr2S97xzB7WT0gwT3vxm7xnyUSrX16zvlTaKW9Yjh4Qn0NwqdBjvfWr0xje1nalWnJTBLpBjIEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k6d6iYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k6d6iYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B9C1F000FF;
	Wed, 30 Sep 2026 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788815;
	bh=521GeeUxWSXu6KPVYiOZmMBGH5M/5rQsiYPvVFyaRmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1k6d6iYC6OZ6C97k3Zfi2uCMJoPIc/A2tasB0s9HrknU9P94Eb5GCxK4sp68wfGlH
	 Vql+6+j0qP6n/F93bloLCpdTRolabhMO2Yh2+i+kIjUARSSo68ao1cSXnUbsLgVNgb
	 CSaQulc2TLZIozNXtTYH3864s7idykewxd0214Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.12 212/877] IB/mlx4: Fix use-after-free on pkey sysfs registration failure
Date: Wed, 30 Sep 2026 17:18:43 +0200
Message-ID: <20260930152419.303877716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


