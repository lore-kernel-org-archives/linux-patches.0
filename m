Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AFC2135B8;
	Tue, 16 Dec 2025 11:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885442; cv=none; b=dZyvwB3/0e9fMZp7Jo81G/QkDTdXr9GDjQOokBEqaY6udwv3wVDzfwsINPGxDp3qvcczl1Py/XLblUG8KNce26QYIbZOpuft+3nKg1Jr8lriKJGOtnem7O8GLtDdKCRatCLHj6ogYZd61XeGq7/XR7ZWTKFqnrYcXx0HY8Djnu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885442; c=relaxed/simple;
	bh=gEgUT6PJpv4kmGxyUUoScG0zLUHJ/HBtwPlaGm2aNC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSojgxHQ+FmgcsR3+h5aXL0hQI4u4eTHaq6M9JoMrVaVRxPeitD+CJ3gq+E64dgw92Y8oGP1Vq/B+hiVm+bGRARNVzkQEah3oP8UYCoIGOhG09Ny1e859y4nY5J5XROv7Tm0iJFRkSrZaXLfe6PgFzzXhe5Fy3bSopxqN8zGu+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiCvhOxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiCvhOxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79D9C4CEF1;
	Tue, 16 Dec 2025 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885442;
	bh=gEgUT6PJpv4kmGxyUUoScG0zLUHJ/HBtwPlaGm2aNC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiCvhOxw8K0LWHebZKYnXq2f28kveFtgFdIIGQ35bP3Rj54gzG8D5Ud/qzMQFgH5u
	 u3cYqFN1+VQhg5bCwTXkxr9B8+i8czBzlybsx+8BhEaT7pWqiPjkh6fK+r6z6+/gUs
	 CjSZlVUwEYqd5pcwaF7ld7UtWLiTcp7Z2VfYWw/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 133/507] i3c: fix refcount inconsistency in i3c_master_register
Date: Tue, 16 Dec 2025 12:09:34 +0100
Message-ID: <20251216111350.348475759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 67a18e437f831..08caaad195d59 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2811,10 +2811,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i2c);
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
-	ret = i3c_bus_init(i3cbus, master->dev.of_node);
-	if (ret)
-		return ret;
-
 	device_initialize(&master->dev);
 	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
@@ -2822,6 +2818,10 @@ int i3c_master_register(struct i3c_master_controller *master,
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



