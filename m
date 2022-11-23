Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57371C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142BDC433D7;
	Wed, 23 Nov 2022 09:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197073;
	bh=KmKB49GJz8EHtHKKI9mDkKv+O6ON21IldEClDjv7CyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsi3k1ZIwclbzc8kt8WpWeeJqR2j4mXfQ2+/9g6MgQfL9n0koBDz6HlO4tgPuQlTh
	 3YiFPl0hSMojh6AGPQUgzoi3+asRohnq4WNnL4LD6pKUy8kyKryQnlBWqWbbRFi584
	 aoprL+8D22OenJWmtT3qbMNhjUAUCE77YYH8TNbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 190/314] net: thunderbolt: Fix error handling in tbnet_init()
Date: Wed, 23 Nov 2022 09:50:35 +0100
Message-Id: <20221123084634.168202058@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

[ Upstream commit f524b7289bbb0c8ffaa2ba3c34c146e43da54fb2 ]

A problem about insmod thunderbolt-net failed is triggered with following
log given while lsmod does not show thunderbolt_net:

 insmod: ERROR: could not insert module thunderbolt-net.ko: File exists

The reason is that tbnet_init() returns tb_register_service_driver()
directly without checking its return value, if tb_register_service_driver()
failed, it returns without removing property directory, resulting the
property directory can never be created later.

 tbnet_init()
   tb_register_property_dir() # register property directory
   tb_register_service_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without remove property directory

Fix by remove property directory when tb_register_service_driver() returns
error.

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ab3f04562980..8391f8303499 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1379,12 +1379,21 @@ static int __init tbnet_init(void)
 				  TBNET_MATCH_FRAGS_ID | TBNET_64K_FRAMES);
 
 	ret = tb_register_property_dir("network", tbnet_dir);
-	if (ret) {
-		tb_property_free_dir(tbnet_dir);
-		return ret;
-	}
+	if (ret)
+		goto err_free_dir;
+
+	ret = tb_register_service_driver(&tbnet_driver);
+	if (ret)
+		goto err_unregister;
 
-	return tb_register_service_driver(&tbnet_driver);
+	return 0;
+
+err_unregister:
+	tb_unregister_property_dir("network", tbnet_dir);
+err_free_dir:
+	tb_property_free_dir(tbnet_dir);
+
+	return ret;
 }
 module_init(tbnet_init);
 
-- 
2.35.1



