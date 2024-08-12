Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBBB134AC;
	Mon, 12 Aug 2024 16:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479947; cv=none; b=JjpXVr9RrkOPJ927Wm5cAMGQXbDYuAfw0PRcagh/g+I4l+OKgK4mEZvSxiLB+DaoOLvN1xMLa0EhZKhkdu9rUMSCPaR7N3e7yTKHi4grBqpRZjT+zMllCijc8f/NQvHhlulyQW/8XdR1oHILWx5bX7E3AkllbCvb+IM1BuqxLdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479947; c=relaxed/simple;
	bh=haMIGhqyWg0CeX3Q5fcHHTUrl+5IytjpotXO/8VBmMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF6YJ6z7Bq1eMec0kSvs7U9b5IufZISOPFWVPlAV7yVEWDOsJ+YBVUX6Mo+6omyFiInWhXjCVx5P/GVokyBd0fiw+VQy6bkQmJUQY9BdZ0Dw6G2jLDhPnOGIVO/XfVL9xYd82JfqtxHGircm571Kgr09ThnaqzkDWZ5cr+UGHp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ei2Ke148; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ei2Ke148"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A670FC32782;
	Mon, 12 Aug 2024 16:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479947;
	bh=haMIGhqyWg0CeX3Q5fcHHTUrl+5IytjpotXO/8VBmMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ei2Ke148Rw4r8NCD/J7QO6/A31qAkFSXsLlmseEvJMLVFBcQPcsu64xMrABqxGJzZ
	 7CUdCj+qA8k56OsHmu/sOLg0ExScGE1n/LL29txxuF9SjQMljwW4nvjjZQ8tEIFHXS
	 L2y8Bg/+36oxRuWRiI3XpczZXdFr+Kr4zX58yuvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raymond Hackley <raymondhackley@protonmail.com>,
	Nikita Travkin <nikita@trvn.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 018/263] power: supply: rt5033: Bring back i2c_set_clientdata
Date: Mon, 12 Aug 2024 18:00:19 +0200
Message-ID: <20240812160147.239673088@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit d3911f1639e67fc7b12aae0efa5a540976d7443b ]

Commit 3a93da231c12 ("power: supply: rt5033: Use devm_power_supply_register() helper")
reworked the driver to use devm. While at it, the i2c_set_clientdata
was dropped along with the remove callback. Unfortunately other parts
of the driver also rely on i2c clientdata so this causes kernel oops.

Bring the call back to fix the driver.

Fixes: 3a93da231c12 ("power: supply: rt5033: Use devm_power_supply_register() helper")
Tested-by: Raymond Hackley <raymondhackley@protonmail.com>
Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Link: https://lore.kernel.org/r/20240605-rt5033-null-clientdata-v1-1-558d710eeb4d@trvn.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt5033_battery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/rt5033_battery.c b/drivers/power/supply/rt5033_battery.c
index 32eafe2c00af5..7a27b262fb84a 100644
--- a/drivers/power/supply/rt5033_battery.c
+++ b/drivers/power/supply/rt5033_battery.c
@@ -159,6 +159,7 @@ static int rt5033_battery_probe(struct i2c_client *client)
 		return -EINVAL;
 	}
 
+	i2c_set_clientdata(client, battery);
 	psy_cfg.of_node = client->dev.of_node;
 	psy_cfg.drv_data = battery;
 
-- 
2.43.0



