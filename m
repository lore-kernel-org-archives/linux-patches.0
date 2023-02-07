Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE1D2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F391DC433D2;
	Tue,  7 Feb 2023 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775346;
	bh=v8W6lKawbX02aXyh5Ii27WaGmFM7B5LK3WHdhVQWnko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnk5WeaonPs06zl2CdnOHwqc8dUMSsAe1oW5IWNyMBkB+eoVNM3g7TA8Jg8ERbF/T
	 GlEnWeAlPweAqE0VX91dHEjWwWWVWgOeQUpAiqMmoUydtdIVTJkCFhuGqNl21I1Lsv
	 bAVIbVyXNa8p7RsnubtBIpYVmIj/AL4K+Id9x8rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/120] bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()
Date: Tue,  7 Feb 2023 13:56:13 +0100
Message-Id: <20230207125618.830828666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

[ Upstream commit f71eaf2708be7831428eacae7db25d8ec6b8b4c5 ]

The sunxi_rsb_init() returns the platform_driver_register() directly
without checking its return value, if platform_driver_register() failed,
the sunxi_rsb_bus is not unregistered.
Fix by unregister sunxi_rsb_bus when platform_driver_register() failed.

Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced Serial Bus")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221123094200.12036-1-yuancan@huawei.com
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 20ed77f2b949..fac8627b04e3 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -861,7 +861,13 @@ static int __init sunxi_rsb_init(void)
 		return ret;
 	}
 
-	return platform_driver_register(&sunxi_rsb_driver);
+	ret = platform_driver_register(&sunxi_rsb_driver);
+	if (ret) {
+		bus_unregister(&sunxi_rsb_bus);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(sunxi_rsb_init);
 
-- 
2.39.0



