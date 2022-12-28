Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D821C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7411DC433D2;
	Wed, 28 Dec 2022 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244662;
	bh=0wxqIuC41VHbvzGNAJLK3kvZBi15ChrR6wbomyFkiaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgjslxlJCZ9ulOFqPx0X01novNn1a8mLik2RbY8RxHo0fpCVP5FN7yrE8DQa6o1it
	 8LAUHbVjXz5byeQ3aPNbiWXkhSpt4e7CcdekEB7a1e3sSGSf9MTXhcG/6/vdqvqkDV
	 glB64bJvTmElvB7cIJ241GYWG8Avt+JBH44U0CWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0750/1073] power: supply: ab8500: Fix error handling in ab8500_charger_init()
Date: Wed, 28 Dec 2022 15:38:58 +0100
Message-Id: <20221228144348.392706285@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit c4d33381b134da188ccd1084aef21e2b8c3c422e ]

The ab8500_charger_init() returns the platform_driver_register() directly
without checking its return value, if platform_driver_register() failed,
all ab8500_charger_component_drivers are not unregistered.

Fix by unregister ab8500_charger_component_drivers when
platform_driver_register() failed.

Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index c19c50442761..58757a5799f8 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3719,7 +3719,14 @@ static int __init ab8500_charger_init(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&ab8500_charger_driver);
+	ret = platform_driver_register(&ab8500_charger_driver);
+	if (ret) {
+		platform_unregister_drivers(ab8500_charger_component_drivers,
+				ARRAY_SIZE(ab8500_charger_component_drivers));
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit ab8500_charger_exit(void)
-- 
2.35.1



