Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C882D73B4;
	Thu, 15 Jan 2026 17:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497487; cv=none; b=KaW+wgPiQcwQTwmQQqdLKobNWhnPrfXbIMReI7sgXwkeyzdPLHtJZIm3bHGxe3e2q1YCUNxJ78Q29Rd1ZC22hmpH2x22UDPNUvQNhLt2FVzKGnqEY1rw2Ad+g4Xqwi5g5/oqLUjW+h9WG+pNGnxC4PUE/zMCr2TDzg2KygRqZj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497487; c=relaxed/simple;
	bh=GvhIV7mpg8liD7bH9cPwzaVgVd6fl8lvT5ZXCNp+2BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMd8UHL+e8f4RUy495fFHMjYrU15FrdOXYqN4UknD6CRxh/gWhkYZgVtTnjsXbe+ors25iXPr3u1txQ4oSioJdX9CeeKU4gEerhR9XfsjLFcKG7S2/MzVwXBhBTJzUvn7rYNmjGO9d7UGMr4UiVhQX66CG8YRXCH9AmkI9qrHGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjTJ9Qe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjTJ9Qe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8225AC19422;
	Thu, 15 Jan 2026 17:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497486;
	bh=GvhIV7mpg8liD7bH9cPwzaVgVd6fl8lvT5ZXCNp+2BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjTJ9Qe4XY6fzMmvt+LJ99jpsspKRRpypQCqDFlIy855SxrecBUxuT6gIbkU9wlU5
	 dbDb16f261v9d9VT5vEuYlBKOal6GsYWgM0f+bJ3cl82P7wPZFgQDYKSvYbiBNV4Ix
	 H6J/9k97ZzYr9YG3ZkEPORT2GfEANGuzizTue22w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/554] i3c: fix refcount inconsistency in i3c_master_register
Date: Thu, 15 Jan 2026 17:42:12 +0100
Message-ID: <20260115164248.633608863@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 459399cd70da7..e5a282053e2a9 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2619,10 +2619,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i2c);
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
-	ret = i3c_bus_init(i3cbus, master->dev.of_node);
-	if (ret)
-		return ret;
-
 	device_initialize(&master->dev);
 	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
@@ -2630,6 +2626,10 @@ int i3c_master_register(struct i3c_master_controller *master,
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



