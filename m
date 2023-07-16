Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225BC8F71
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F829C433C9;
	Sun, 16 Jul 2023 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537529;
	bh=IOrhnCHD4VyZgNbTtjriZbL9x3fnCuM+pZCbxX8fbAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOUVPGtvy8nnSSQy+vPkVwW1EMtDtY9VyPWqD8S98kqOEBK14AasR9qE6nOT5Umgw
	 x0f/MwW3DOBJqtV7bY6Rw9obWGTl3EJkTI3mm/tUh96odslfJt81inUmwnWj9iBsJc
	 ijCOZxXF01FowJsR8I4IJXFPbvFpk+q+oM+5GgDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 129/800] regulator: rk808: fix asynchronous probing
Date: Sun, 16 Jul 2023 21:39:42 +0200
Message-ID: <20230716194952.099043098@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 1b9e86d445a0f5c6d8dcbaf11508cb5dfb5848a8 ]

If the probe routine fails with -EPROBE_DEFER after taking over the
OF node from its parent driver, reprobing triggers pinctrl_bind_pins()
and that will fail. Fix this by setting of_node_reused, so that the
device does not try to setup pin muxing.

For me this always happens once the driver is marked to prefer async
probing and never happens without that flag.

Fixes: 259b93b21a9f ("regulator: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in 4.14")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20230504173618.142075-12-sebastian.reichel@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rk808-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 3637e81654a8e..80ba782d89239 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -1336,6 +1336,7 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 
 	config.dev = &pdev->dev;
 	config.dev->of_node = pdev->dev.parent->of_node;
+	config.dev->of_node_reused = true;
 	config.driver_data = pdata;
 	config.regmap = regmap;
 
-- 
2.39.2



