Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D90512CD89;
	Tue, 14 May 2024 11:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685564; cv=none; b=ad2Cb+uWYmIWp/P8w5EteJr77ifVE1qOpP7cow5wUc+H6upmZNpoI6rGZT/RBNmbzJL+QMsicEjwQ5B0532xUmg3mqmdZgUUJXSWijiAd4156TpqAw7mqU28w8E0YZ5QEpwvev/ZK8YJMS0nN6H5Ixhrfv/yU1QiBcb+rUq0cYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685564; c=relaxed/simple;
	bh=DaFLVzgZD0u32201jXckyDxsYiKAgOl9HMHw05MkJJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na5mtL+ZHekkX4+sDF8HTDzRL40t7nxDiwhi+ZrfcSarrZ/26TrndyrMSQ8Pu6OIUIckqUGxfWfP1QGor20Zu6+XMOuKdzRjqQ4GnjXuwD/kNtkCI3AuCSkXkJE74Sos4OADE1cF4obQQEdj+m/o5G3uMTyJQX4Vel9gSqnQ0MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQegzwBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQegzwBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43C0C2BD10;
	Tue, 14 May 2024 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685564;
	bh=DaFLVzgZD0u32201jXckyDxsYiKAgOl9HMHw05MkJJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQegzwBP/pOjZNfcS4O/neO6hlDUXB9YlgxFkw9ZoHdQnG1C+m8FhZBo8MuWdy/OH
	 5BxEpfM077e/m0kM6W7Fj92uPsOfdNJmfYgao4J5fQpFkJVS8b37SHQIRpGIfkI19d
	 LayjhriGJTapDKriJU0LXeneeK+4vZiITwRte9qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/301] net: hns3: release PTP resources if pf initialization failed
Date: Tue, 14 May 2024 12:17:58 +0200
Message-ID: <20240514101040.075216621@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit 950aa42399893a170d9b57eda0e4a3ff91fd8b70 ]

During the PF initialization process, hclge_update_port_info may return an
error code for some reason. At this point,  the ptp initialization has been
completed. To void memory leaks, the resources that are applied by ptp
should be released. Therefore, when hclge_update_port_info returns an error
code, hclge_ptp_uninit is called to release the corresponding resources.

Fixes: eaf83ae59e18 ("net: hns3: add querying fec ability from firmware")
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b02b96bd93b7a..7f2bb0e708896 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11752,7 +11752,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	ret = hclge_update_port_info(hdev);
 	if (ret)
-		goto err_mdiobus_unreg;
+		goto err_ptp_uninit;
 
 	INIT_KFIFO(hdev->mac_tnl_log);
 
@@ -11803,6 +11803,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	devl_unlock(hdev->devlink);
 	return 0;
 
+err_ptp_uninit:
+	hclge_ptp_uninit(hdev);
 err_mdiobus_unreg:
 	if (hdev->hw.mac.phydev)
 		mdiobus_unregister(hdev->hw.mac.mdio_bus);
-- 
2.43.0



