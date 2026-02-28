Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841D5301EE2;
	Sat, 28 Feb 2026 17:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301402; cv=none; b=L+3dkW2WBbuSbsdDBeCEzANMV2IGxwQRuTs1ykVMYb+kTGmCQHY6wt9v3hWWQFHtyp2yL/q6dlhxp63BqMc/HcYg1DJCS/wW/KPaZZ+hboIeUJ/qH2Ids6Asfmi9UCpME5q3ZVN5WJQP1yaDD+iOLmgLAzHQDHtb76gpLvnxECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301402; c=relaxed/simple;
	bh=D69dLqnG4kE0GPvxaIQ4APaQPnLIBI7aapXZ5ZXWLI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUw48fRdSqfkL1N1kNF3t4PQoP3RLzJ7KS9Vx3pRmEzvd0fD71EbUT14Zi0tGWi2Scc6rbxmsPSFtPknhHWbcTBFQ14kH5qVSxGRMN7KjJtcoYWMN4mKGxWN312IBS9C4TMR5cYZqPewQilBBWm6s5SYiEp7kXLvwxdUrayCwjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sa5MazW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sa5MazW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23B7C116D0;
	Sat, 28 Feb 2026 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301402;
	bh=D69dLqnG4kE0GPvxaIQ4APaQPnLIBI7aapXZ5ZXWLI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sa5MazW1ig8DQVC1GygWjT9Yjzyy2dj3u+dTfOjXoYzoutCle3qfGjTzU2rEGe00j
	 3Iv1vwxNLE2nlrqvIPvLa6fKeA/bbujYnFcf69/97kiq4c854NBtHiUOSs3GjjucuF
	 TahmdcBb3GX8tKaZcFabedkx06hdCoss7CZlNBgEkGESUA87j+v8xkhwZGFKkwr1kp
	 niHTvd+rXuVF32Pt7cKibu6IovtDBTMSkmjjLoWuxGMRdKFT+DJsTg/QoRywsKEZ1D
	 XSgTcBcOjLec5jl0e4zObpjaFH5JgiBjv05q5aF5qblUcgTbykfL6/NBCKdp/G4c4a
	 Qp50cz5xlT9cw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Douglas Anderson <dianders@chromium.org>,
	stable@vger.kernel.org,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 591/752] mfd: core: Add locking around 'mfd_of_node_list'
Date: Sat, 28 Feb 2026 12:45:02 -0500
Message-ID: <20260228174750.1542406-591-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 20117c92bcf9c11afd64d7481d8f94fdf410726e ]

Manipulating a list in the kernel isn't safe without some sort of
mutual exclusion. Add a mutex any time we access / modify
'mfd_of_node_list' to prevent possible crashes.

Cc: stable@vger.kernel.org
Fixes: 466a62d7642f ("mfd: core: Make a best effort attempt to match devices with the correct of_nodes")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251210113002.1.I6ceaca2cfb7eb25737012b166671f516696be4fd@changeid
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 7d14a1e7631ee..c55223ce4327a 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -22,6 +22,7 @@
 #include <linux/regulator/consumer.h>
 
 static LIST_HEAD(mfd_of_node_list);
+static DEFINE_MUTEX(mfd_of_node_mutex);
 
 struct mfd_of_node_entry {
 	struct list_head list;
@@ -105,9 +106,11 @@ static int mfd_match_of_node_to_dev(struct platform_device *pdev,
 	u64 of_node_addr;
 
 	/* Skip if OF node has previously been allocated to a device */
-	list_for_each_entry(of_entry, &mfd_of_node_list, list)
-		if (of_entry->np == np)
-			return -EAGAIN;
+	scoped_guard(mutex, &mfd_of_node_mutex) {
+		list_for_each_entry(of_entry, &mfd_of_node_list, list)
+			if (of_entry->np == np)
+				return -EAGAIN;
+	}
 
 	if (!cell->use_of_reg)
 		/* No of_reg defined - allocate first free compatible match */
@@ -129,7 +132,8 @@ static int mfd_match_of_node_to_dev(struct platform_device *pdev,
 
 	of_entry->dev = &pdev->dev;
 	of_entry->np = np;
-	list_add_tail(&of_entry->list, &mfd_of_node_list);
+	scoped_guard(mutex, &mfd_of_node_mutex)
+		list_add_tail(&of_entry->list, &mfd_of_node_list);
 
 	of_node_get(np);
 	device_set_node(&pdev->dev, of_fwnode_handle(np));
@@ -286,11 +290,13 @@ static int mfd_add_device(struct device *parent, int id,
 	if (cell->swnode)
 		device_remove_software_node(&pdev->dev);
 fail_of_entry:
-	list_for_each_entry_safe(of_entry, tmp, &mfd_of_node_list, list)
-		if (of_entry->dev == &pdev->dev) {
-			list_del(&of_entry->list);
-			kfree(of_entry);
-		}
+	scoped_guard(mutex, &mfd_of_node_mutex) {
+		list_for_each_entry_safe(of_entry, tmp, &mfd_of_node_list, list)
+			if (of_entry->dev == &pdev->dev) {
+				list_del(&of_entry->list);
+				kfree(of_entry);
+			}
+	}
 fail_alias:
 	regulator_bulk_unregister_supply_alias(&pdev->dev,
 					       cell->parent_supplies,
@@ -360,11 +366,13 @@ static int mfd_remove_devices_fn(struct device *dev, void *data)
 	if (cell->swnode)
 		device_remove_software_node(&pdev->dev);
 
-	list_for_each_entry_safe(of_entry, tmp, &mfd_of_node_list, list)
-		if (of_entry->dev == &pdev->dev) {
-			list_del(&of_entry->list);
-			kfree(of_entry);
-		}
+	scoped_guard(mutex, &mfd_of_node_mutex) {
+		list_for_each_entry_safe(of_entry, tmp, &mfd_of_node_list, list)
+			if (of_entry->dev == &pdev->dev) {
+				list_del(&of_entry->list);
+				kfree(of_entry);
+			}
+	}
 
 	regulator_bulk_unregister_supply_alias(dev, cell->parent_supplies,
 					       cell->num_parent_supplies);
-- 
2.51.0

