Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EAB22F77B;
	Fri,  9 Jan 2026 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959590; cv=none; b=lSD72837hfZvQjl1jMay9NpMkWmcNv147pNxXUIqsA5nzOcbtDN9yMje5o+yfw5kXGj/21pu/pjtBGvNXjV6wrGB5xfDwVRKE17t+QS30ojAckUvp/4jKg6HJj8RixCLOECZFrpNrZU1FHEGP1nP91U2mUKwoUHtv4vGjAZSHCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959590; c=relaxed/simple;
	bh=b1lQfZ53zLKlURLMVqcoGctWEvnyijKLbU4JvHyQXoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVY13Q7KbLbFlHKhkfmCa6YOquKgbL+ygzSd+jsTCGdNSZN1GfaysCZYYBCbh7fI/8g3wQ9Zxsvb04zU2+70PxcISIJV1fHnW/aLwVad8qQYkOjwyfOfIys1J0f7vu7GwrTUZfGrYsWBG7voO8DG4GH98LcGAqLAKzjTTi1koVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQiXEf1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQiXEf1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B31C16AAE;
	Fri,  9 Jan 2026 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959590;
	bh=b1lQfZ53zLKlURLMVqcoGctWEvnyijKLbU4JvHyQXoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQiXEf1wLIq0gHpB3gG56YvmybEBakT2fzIcBwKD2KWyeQISFbe9urJlpaD7+pass
	 88ggO18cqvw/mIPSYFwzg0UroE69eIk8UijovSxxrcZpaVoWaJIwomJ065fMtD3Gek
	 Hv8iGGnP7yWFqdKcFNkDQ45/4o8z/n5yVwXvbwTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/737] i3c: fix refcount inconsistency in i3c_master_register
Date: Fri,  9 Jan 2026 12:34:03 +0100
Message-ID: <20260109112137.914361516@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 29e591bcc0646..060f70e4d52d7 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2768,10 +2768,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i2c);
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
-	ret = i3c_bus_init(i3cbus, master->dev.of_node);
-	if (ret)
-		return ret;
-
 	device_initialize(&master->dev);
 	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
@@ -2779,6 +2775,10 @@ int i3c_master_register(struct i3c_master_controller *master,
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



