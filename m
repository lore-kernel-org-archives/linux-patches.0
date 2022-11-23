Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A295E1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD17EC433D6;
	Wed, 23 Nov 2022 09:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197062;
	bh=0W3mu/HKMd5n1ShSbTV23pSlPq7KXXzwl5UrGTTVwNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyxjRvu2fuNlLSLfjPqW3OL3J8EAwuhwTPFJILW0pvsjToOy9xr3LnS2U/30CYW2d
	 nlkBbM49RdU3nE7rzBrfUyUgqM8Ro2rBvgjizBhlZozpDQTdNSMbBsCfek1BImM8b6
	 082XrGGQq6TqtXzfwlTY5AZ4Auy+whDEEuRzi8q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Shannon Nelson <snelson@pensando.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 170/314] net: ionic: Fix error handling in ionic_init_module()
Date: Wed, 23 Nov 2022 09:50:15 +0100
Message-Id: <20221123084633.267899318@linuxfoundation.org>
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
index 56f93b030551..5456c2b15d9b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -687,8 +687,14 @@ int ionic_port_reset(struct ionic *ionic)
 
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



