Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2491863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28C1C433D2;
	Wed, 28 Dec 2022 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241767;
	bh=FJr7Qy6UAckxYkNj6qvKzPCNqrHNbkRtmUoYUAUJpF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2/i9EkZbiUNhiQmgOkypNri5wfFbC4Uk1WCI4jigqDJdbEI9iSaNOMGqgAlh9YxD
	 onw7zvOZoQLGmk+fCOG0GSHPW+ONczi70J9dk7lIAqN39dSgdSFkOVESc3D2Pv4o96
	 bVEfUC1HBYPhu0ntFqqBHsHsV3mZXTV7WNgxSKgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 520/731] power: supply: ab8500: Fix error handling in ab8500_charger_init()
Date: Wed, 28 Dec 2022 15:40:27 +0100
Message-Id: <20221228144311.620231854@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 15eadaf46f14..a4f766fc7c9d 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3726,7 +3726,14 @@ static int __init ab8500_charger_init(void)
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



