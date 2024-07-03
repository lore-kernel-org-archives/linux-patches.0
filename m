Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7725117FAB8;
	Wed,  3 Jul 2024 11:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005490; cv=none; b=Wj+KlDRs+/CSnP5uFJS718k2Uh3DgO0r42RmjrV8jUHmTAiJSLlzcW+XaGTCTCpF7iPkOIL/aZauR8etaOMHmGLO9RvO3P9HMhlF62wc2RVB/hQ3ieiSgxXDvetpfWa2osoMwgTPZhefgmr2yT8tiAqFVuYFHAgujco/a+oRDtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005490; c=relaxed/simple;
	bh=ITxDh+r0KIvQDfPbfLRSX5sPjtxzXqkLIv1WF5s4Yfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EveuBgS+Leq+5OOpGRUHyEDYBMeHeLCAr3uFfGxpTTjd26R3Eie0QCjkdrvboVVUsXQ4xiqBRhMyegQjPKjA6iOyDuHWGgItcPOZl6A5c55Rl+3nLuW0lxU+nxQkViRXhczNhHBEWfMOD0SQ17ZvoN7zD08/r+dsAO/9/KLPmSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qliu2KSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qliu2KSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF3EC2BD10;
	Wed,  3 Jul 2024 11:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005490;
	bh=ITxDh+r0KIvQDfPbfLRSX5sPjtxzXqkLIv1WF5s4Yfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qliu2KSxdyWpass5JVDjSVPzrHhKF2Rmay9wiEIx/VuyBCMlfgxbknzV+UdDLidUc
	 IoDKybguVJ+sgDKlhM4RRtOgDgK/6uNQ0TXKBEB4XLozIyLEEkbsKW5dbimBJ+lTDo
	 +BAOucpzUgZw0Qpgodz/KL7N5/4e7dufz05MtNlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/356] net: hns3: fix kernel crash problem in concurrent scenario
Date: Wed,  3 Jul 2024 12:37:14 +0200
Message-ID: <20240703102916.811787440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 12cda920212a49fa22d9e8b9492ac4ea013310a4 ]

When link status change, the nic driver need to notify the roce
driver to handle this event, but at this time, the roce driver
may uninit, then cause kernel crash.

To fix the problem, when link status change, need to check
whether the roce registered, and when uninit, need to wait link
update finish.

Fixes: 45e92b7e4e27 ("net: hns3: add calling roce callback function when link status change")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d58048b056781..c3690e49c3d95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2948,9 +2948,7 @@ static void hclge_push_link_status(struct hclge_dev *hdev)
 
 static void hclge_update_link_status(struct hclge_dev *hdev)
 {
-	struct hnae3_handle *rhandle = &hdev->vport[0].roce;
 	struct hnae3_handle *handle = &hdev->vport[0].nic;
-	struct hnae3_client *rclient = hdev->roce_client;
 	struct hnae3_client *client = hdev->nic_client;
 	int state;
 	int ret;
@@ -2974,8 +2972,15 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 
 		client->ops->link_status_change(handle, state);
 		hclge_config_mac_tnl_int(hdev, state);
-		if (rclient && rclient->ops->link_status_change)
-			rclient->ops->link_status_change(rhandle, state);
+
+		if (test_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state)) {
+			struct hnae3_handle *rhandle = &hdev->vport[0].roce;
+			struct hnae3_client *rclient = hdev->roce_client;
+
+			if (rclient && rclient->ops->link_status_change)
+				rclient->ops->link_status_change(rhandle,
+								 state);
+		}
 
 		hclge_push_link_status(hdev);
 	}
@@ -11431,6 +11436,12 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 	return ret;
 }
 
+static bool hclge_uninit_need_wait(struct hclge_dev *hdev)
+{
+	return test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
+	       test_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state);
+}
+
 static void hclge_uninit_client_instance(struct hnae3_client *client,
 					 struct hnae3_ae_dev *ae_dev)
 {
@@ -11439,7 +11450,7 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 
 	if (hdev->roce_client) {
 		clear_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
-		while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		while (hclge_uninit_need_wait(hdev))
 			msleep(HCLGE_WAIT_RESET_DONE);
 
 		hdev->roce_client->ops->uninit_instance(&vport->roce, 0);
-- 
2.43.0



