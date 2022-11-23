Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDBA1C2B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BEEC433D6;
	Wed, 23 Nov 2022 09:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195393;
	bh=u/C71WKa0rWw7B3bmiXCag6GJe12Zc4RVJBzcz8w+og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqkky5X8SomgIjzN5oR3Ja/6hmO4Mi5eJgYajTAgJpbbc/znC/6VGJ6k5c1Eeqiw2
	 qwItY4vR8dQ8Zgg7PZB8AsmN5ZoU01JHlPHQ9Uo1tY0LFPcuup7fL7gcraIdrq4C8S
	 7hpk1fC3XDrDeDafwDZMknUK6oKPuzbUXhFfMBZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Shannon Nelson <snelson@pensando.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/149] net: ionic: Fix error handling in ionic_init_module()
Date: Wed, 23 Nov 2022 09:50:55 +0100
Message-Id: <20221123084600.477661929@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

[ Upstream commit 280c0f7cd0aa4d190619b18243110e052a90775c ]

A problem about ionic create debugfs failed is triggered with the
following log given:

 [  415.799514] debugfs: Directory 'ionic' with parent '/' already present!

The reason is that ionic_init_module() returns ionic_bus_register_driver()
directly without checking its return value, if ionic_bus_register_driver()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of ionic can never be created later.

 ionic_init_module()
   ionic_debugfs_create() # create debugfs directory
   ionic_bus_register_driver()
     pci_register_driver()
       driver_register()
         bus_add_driver()
           priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when ionic_bus_register_driver() returns error.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/20221113092929.19161-1-yuancan@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index f60ffef33e0c..00b6985edea0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -569,8 +569,14 @@ int ionic_port_reset(struct ionic *ionic)
 
 static int __init ionic_init_module(void)
 {
+	int ret;
+
 	ionic_debugfs_create();
-	return ionic_bus_register_driver();
+	ret = ionic_bus_register_driver();
+	if (ret)
+		ionic_debugfs_destroy();
+
+	return ret;
 }
 
 static void __exit ionic_cleanup_module(void)
-- 
2.35.1



