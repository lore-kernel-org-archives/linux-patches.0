Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B76341645;
	Tue, 16 Dec 2025 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884114; cv=none; b=OWF08pzyt4CQy4ASYUMXugOUpd8l+cUoACN30Q7DlLs8SxjmU3/EnpVfJSOitZiqM1yOoF9BmqTa88TZj5o9wyk0o6uFKCcdygxwXmvtVSwRG9SDNvESV2mQUtQArXp3sWxkSVsLUAQnumGmzN5hJzXDaxOzDr/5wLpwkhMp56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884114; c=relaxed/simple;
	bh=WphDHT85EP62IXvxFq+5GOUjL8JVYB4bjuYPy8nZRJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO0GcHbJtOdqvxiEN/M/2ZMxJQ9XI2yptb85lxJG3aYAlKQFmij8ehnK0Esh57j4jG1wSZkZ8whd09gnyl/qpwy1LpDBd9bpvpVrOQ4FDUio7B9ZR/GCYf4OP1L888ryCdfHi3Todias9mQbbDZ9ExCUs3hkMMYmK4HkX6fnfc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Tbb8yQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Tbb8yQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E0FC19422;
	Tue, 16 Dec 2025 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884114;
	bh=WphDHT85EP62IXvxFq+5GOUjL8JVYB4bjuYPy8nZRJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Tbb8yQ9cNqhIqZPEJYOUgqbVKyPPhw7IYuwegnoFJ+8YB6GWJpoPyUjrGsX0aCxM
	 OhL6fVg6lUob62SJNa/Ik//q0/GctkQQIk87i2qEiloDY7FhAOpiVjp6psQw7WNNWS
	 efTBPYKrO83+9PmmXc5HxXWLaOQDZFWemWErdYDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/354] i3c: fix refcount inconsistency in i3c_master_register
Date: Tue, 16 Dec 2025 12:11:01 +0100
Message-ID: <20251216111324.327199934@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 9d4f219807d5ac11fb1d596e4ddb09336b040067 ]

In `i3c_master_register`, a possible refcount inconsistency has been
identified, causing possible resource leak.

Function `of_node_get` increases the refcount of `parent->of_node`. If
function `i3c_bus_init` fails, the function returns immediately without
a corresponding decrease, resulting in an inconsistent refcounter.

Move call i3c_bus_init() after device_initialize() to let callback
i3c_masterdev_release() release of_node.

Reported-by: Shuhao Fu <sfual@cse.ust.hk>
Closes: https://lore.kernel.org/linux-i3c/aO2tjp_FsV_WohPG@osx.local/T/#m2c05a982beeb14e7bf039c1d8db856734bf234c7
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251016143814.2551256-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index c8e5c9291ea43..6eb779affaba8 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2809,10 +2809,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i2c);
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
-	ret = i3c_bus_init(i3cbus, master->dev.of_node);
-	if (ret)
-		return ret;
-
 	device_initialize(&master->dev);
 	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
@@ -2820,6 +2816,10 @@ int i3c_master_register(struct i3c_master_controller *master,
 	master->dev.coherent_dma_mask = parent->coherent_dma_mask;
 	master->dev.dma_parms = parent->dma_parms;
 
+	ret = i3c_bus_init(i3cbus, master->dev.of_node);
+	if (ret)
+		goto err_put_dev;
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0



