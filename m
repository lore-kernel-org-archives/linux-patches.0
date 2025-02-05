Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB490DF59;
	Wed,  5 Feb 2025 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768154; cv=none; b=kqqY3WkvBCqzieh9rP/tGN2yDYPtLD/xpGdMobNLpCpH6MGSo1D5bEne+tjvZcGLuwFrnAAwQpSTM6Oma8kWpjFQzEwEEdeW+Ox40+bEBsbfHj/qR2hxPoIrTxeg+Fgvn02MuOjt8Fk4xw3+H+EaWA5tN9LFAUNa1VjXG3Fz9J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768154; c=relaxed/simple;
	bh=MomvgFbme6QVw+JgjgHzINHHjrnavudIZegXF1Gs7WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWwrTpfmZMded6Ni47oFx4d1/bTPPggoXkFuK8x32jgRVCKkHU7JS7aP5COFnYkD42Ig9oOlOSY1KZn30remYtrduGERd3YvEikxgYT6pJywjIsB/4VoMCOgoMWhSRmB9QyhpRel+hseYFAd/qlofWeVNLQiPfWz77yissASYeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceoNiFD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceoNiFD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BB9C4CED1;
	Wed,  5 Feb 2025 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768154;
	bh=MomvgFbme6QVw+JgjgHzINHHjrnavudIZegXF1Gs7WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceoNiFD/xQ4B7zxToW/wiY6MEF6+5T/0vERx6K3mU/MWz3E/m3AIFQqhHBuH89syc
	 SoQR36+eh6yLyp4t41MZqchp1EDKYrQpMW/FaaghaNfbtvemD0pVtOdjqZqCPNX7Jf
	 qbZ6e7R1/0a7OzGdQGWrlW9CkHxpqTpcISwR1O68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 505/623] net: hns3: fix oops when unload drivers paralleling
Date: Wed,  5 Feb 2025 14:44:07 +0100
Message-ID: <20250205134515.539768275@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 12ba380eb7019..4e44f28288f90 100644
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
index a7e3b22f641c8..9ff797fb36c45 100644
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
index db78450092526..3f17b3073e50f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12919,9 +12919,11 @@ static int __init hclge_init(void)
 
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
index 163c6e59ea4c1..9ba767740a043 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3410,8 +3410,10 @@ static int __init hclgevf_init(void)
 
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



