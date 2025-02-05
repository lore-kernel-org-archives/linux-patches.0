Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C336170A13;
	Wed,  5 Feb 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767719; cv=none; b=uZ2vmhX0Dfl5pEfafUi89u8xEsYkcQsSSUb+iI8RFRFwpdf5UJpXr3jvPaxECim/YimS+Lc5j7n18GYRU++xptUIe25UfrE8KXcc0g76VLV/NomEw1cuTyQODvhugaT5A9gR4nP6GphChQfsc4AhjZD6KXxn8Aax7dui+6ddLMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767719; c=relaxed/simple;
	bh=nNm2Jdq9xuQbGV4NJPN4fy/03/1+WZUhu7QhjmmVwlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMPiyo+YXXZDtnpAQmh1gy5sG8Hrcci3g/JFQ5TZnoxZvrPKH44yN/n9uY9wK+hUmrNdfHN6ijnOelIajR4i9Sq9HXsk1ZOj54fAAeA6la2qmwmkpKT+2ypz0kwY4IIRUgbe3noIs07KKfLT+TkPM0578LwkwaISAL4JE9IwNL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L27g1PdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L27g1PdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DF1C4CED1;
	Wed,  5 Feb 2025 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767719;
	bh=nNm2Jdq9xuQbGV4NJPN4fy/03/1+WZUhu7QhjmmVwlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L27g1PdKv8HQF8/zryg33/vFKPm7diIsxusB/BXmtMVZ4MTPjniHxZrz/sm70CabX
	 MTKqa203bfNijDLZkttPnEpIjpXxYzEq2+5rbBaWLzj105cWWYjeQ7GiG//hY0W4X8
	 MEgjJIHYpWh6d8qr8HaRSQJ8RHf/7TkpwODxf3ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 474/590] net: hns3: fix oops when unload drivers paralleling
Date: Wed,  5 Feb 2025 14:43:49 +0100
Message-ID: <20250205134513.394179921@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 92e5995773774a3e70257e9c95ea03518268bea5 ]

When unload hclge driver, it tries to disable sriov first for each
ae_dev node from hnae3_ae_dev_list. If user unloads hns3 driver at
the time, because it removes all the ae_dev nodes, and it may cause
oops.

But we can't simply use hnae3_common_lock for this. Because in the
process flow of pci_disable_sriov(), it will trigger the remove flow
of VF, which will also take hnae3_common_lock.

To fixes it, introduce a new mutex to protect the unload process.

Fixes: 0dd8a25f355b ("net: hns3: disable sriov before unload hclge layer")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250118094741.3046663-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c       | 15 +++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h       |  2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |  2 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |  2 ++
 5 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 9a63fbc694083..b25fb400f4767 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -40,6 +40,21 @@ EXPORT_SYMBOL(hnae3_unregister_ae_algo_prepare);
  */
 static DEFINE_MUTEX(hnae3_common_lock);
 
+/* ensure the drivers being unloaded one by one */
+static DEFINE_MUTEX(hnae3_unload_lock);
+
+void hnae3_acquire_unload_lock(void)
+{
+	mutex_lock(&hnae3_unload_lock);
+}
+EXPORT_SYMBOL(hnae3_acquire_unload_lock);
+
+void hnae3_release_unload_lock(void)
+{
+	mutex_unlock(&hnae3_unload_lock);
+}
+EXPORT_SYMBOL(hnae3_release_unload_lock);
+
 static bool hnae3_client_match(enum hnae3_client_type client_type)
 {
 	if (client_type == HNAE3_CLIENT_KNIC ||
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d873523e84f27..388c70331a55b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -963,4 +963,6 @@ int hnae3_register_client(struct hnae3_client *client);
 void hnae3_set_client_init_flag(struct hnae3_client *client,
 				struct hnae3_ae_dev *ae_dev,
 				unsigned int inited);
+void hnae3_acquire_unload_lock(void);
+void hnae3_release_unload_lock(void);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 73825b6bd485d..dc60ac3bde7f2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -6002,9 +6002,11 @@ module_init(hns3_init_module);
  */
 static void __exit hns3_exit_module(void)
 {
+	hnae3_acquire_unload_lock();
 	pci_unregister_driver(&hns3_driver);
 	hnae3_unregister_client(&client);
 	hns3_dbg_unregister_debugfs();
+	hnae3_release_unload_lock();
 }
 module_exit(hns3_exit_module);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9a67fe0554a52..06eedf80cfac4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12929,9 +12929,11 @@ static int __init hclge_init(void)
 
 static void __exit hclge_exit(void)
 {
+	hnae3_acquire_unload_lock();
 	hnae3_unregister_ae_algo_prepare(&ae_algo);
 	hnae3_unregister_ae_algo(&ae_algo);
 	destroy_workqueue(hclge_wq);
+	hnae3_release_unload_lock();
 }
 module_init(hclge_init);
 module_exit(hclge_exit);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index d47bd8d6145f9..fd5992164846b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3412,8 +3412,10 @@ static int __init hclgevf_init(void)
 
 static void __exit hclgevf_exit(void)
 {
+	hnae3_acquire_unload_lock();
 	hnae3_unregister_ae_algo(&ae_algovf);
 	destroy_workqueue(hclgevf_wq);
+	hnae3_release_unload_lock();
 }
 module_init(hclgevf_init);
 module_exit(hclgevf_exit);
-- 
2.39.5



