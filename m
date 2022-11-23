Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2390E1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95825C433C1;
	Wed, 23 Nov 2022 09:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195964;
	bh=eNwbElfpjoYX+eKqbB93aiUjQFdjIuR6s5gPOYje37A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJ8bZdHVJdxiH3S9vABIO5OAP7FyKeIUtt3GiWtEOw9oa2RdhBfLAHYowj9Dl/73w
	 wVzTlEWfMzxW/hgKyXrzk5+Zn2blmll5ZQiFzqULiafsOU37RQxCfl1qiIoqKc8p31
	 E+Yv0N3f3GuMVVM2zxh/ZN7bHGpvsLWNq82w0IHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/181] net: hinic: Fix error handling in hinic_module_init()
Date: Wed, 23 Nov 2022 09:50:44 +0100
Message-Id: <20221123084605.835952588@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

[ Upstream commit 8eab9be56cc6b702a445d2b6d0256aa0992316b3 ]

A problem about hinic create debugfs failed is triggered with the
following log given:

 [  931.419023] debugfs: Directory 'hinic' with parent '/' already present!

The reason is that hinic_module_init() returns pci_register_driver()
directly without checking its return value, if pci_register_driver()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of hinic can never be created later.

 hinic_module_init()
   hinic_dbg_register_debugfs() # create debugfs directory
   pci_register_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when pci_register_driver() returns error.

Fixes: 253ac3a97921 ("hinic: add support to query sq info")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221110021642.80378-1-yuancan@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 8c6ec7c25809..92fba9a0c371 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1482,8 +1482,15 @@ static struct pci_driver hinic_driver = {
 
 static int __init hinic_module_init(void)
 {
+	int ret;
+
 	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
-	return pci_register_driver(&hinic_driver);
+
+	ret = pci_register_driver(&hinic_driver);
+	if (ret)
+		hinic_dbg_unregister_debugfs();
+
+	return ret;
 }
 
 static void __exit hinic_module_exit(void)
-- 
2.35.1



