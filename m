Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9E622156D;
	Wed, 30 Jul 2025 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868448; cv=none; b=Knib0X79O4VCafb2I0+nX1FcNlnLefbpzny3Rb9LJm956zhrnRIGXwJskqTi+Vyufw6FNMoCxFsH69EZG+p85ijwboHAT+d/uIWj8PWloUuAKrRFDIj0geUc+evgzxdR6JWfyRSAmPIx/rmZTrpNuC9zNInI+02sNe3T6vzdpE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868448; c=relaxed/simple;
	bh=kS5o6LP4N4f+MD5wyO293jQ7DIfNkkt59rv9cH7Gid4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzzqHqVfFINZC34bctSLQFvkxMcdqCVOQcFeKuJ9X3DaT/ZVs6NGxMLfr5hPyu9Ptk8xyndx7gnNbyFgOzWdSQnEWCZgQGzRg3+HecCWb+UCURZhzDQeEKuRvwOE4yQupyqn4klZqTfsN9SEYXp68Le4SiDQd41g/WdRoYxiJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtrugPqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtrugPqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E29C4CEE7;
	Wed, 30 Jul 2025 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868448;
	bh=kS5o6LP4N4f+MD5wyO293jQ7DIfNkkt59rv9cH7Gid4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtrugPqEmUti1TVKpNmrt21isWdlqfYI+aOOcBJaWnow5im2Df1+UxXMUKgeJNbIm
	 3kSHCyGwa6HmYl6zz7NU8Pwx4Ha5/ogw0+TZoQpPL+fZATezV77lXpjOUmnGJvIqIC
	 IUY5Rx4RkHKsMbNbvcJYTH5s47+CHxEdp/u/Y0fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/76] net: hns3: fix concurrent setting vlan filter issue
Date: Wed, 30 Jul 2025 11:35:17 +0200
Message-ID: <20250730093227.781315030@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 4555f8f8b6aa46940f55feb6a07704c2935b6d6e ]

The vport->req_vlan_fltr_en may be changed concurrently by function
hclge_sync_vlan_fltr_state() called in periodic work task and
function hclge_enable_vport_vlan_filter() called by user configuration.
It may cause the user configuration inoperative. Fixes it by protect
the vport->req_vlan_fltr by vport_lock.

Fixes: 2ba306627f59 ("net: hns3: add support for modify VLAN filter state")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722125423.1270673-2-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 36 +++++++++++--------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4d318af748a0b..789f72d1067f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9493,33 +9493,36 @@ static bool hclge_need_enable_vport_vlan_filter(struct hclge_vport *vport)
 	return false;
 }
 
-int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en)
+static int __hclge_enable_vport_vlan_filter(struct hclge_vport *vport,
+					    bool request_en)
 {
-	struct hclge_dev *hdev = vport->back;
 	bool need_en;
 	int ret;
 
-	mutex_lock(&hdev->vport_lock);
-
-	vport->req_vlan_fltr_en = request_en;
-
 	need_en = hclge_need_enable_vport_vlan_filter(vport);
-	if (need_en == vport->cur_vlan_fltr_en) {
-		mutex_unlock(&hdev->vport_lock);
+	if (need_en == vport->cur_vlan_fltr_en)
 		return 0;
-	}
 
 	ret = hclge_set_vport_vlan_filter(vport, need_en);
-	if (ret) {
-		mutex_unlock(&hdev->vport_lock);
+	if (ret)
 		return ret;
-	}
 
 	vport->cur_vlan_fltr_en = need_en;
 
+	return 0;
+}
+
+int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en)
+{
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	mutex_lock(&hdev->vport_lock);
+	vport->req_vlan_fltr_en = request_en;
+	ret = __hclge_enable_vport_vlan_filter(vport, request_en);
 	mutex_unlock(&hdev->vport_lock);
 
-	return 0;
+	return ret;
 }
 
 static int hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
@@ -10540,16 +10543,19 @@ static void hclge_sync_vlan_fltr_state(struct hclge_dev *hdev)
 					&vport->state))
 			continue;
 
-		ret = hclge_enable_vport_vlan_filter(vport,
-						     vport->req_vlan_fltr_en);
+		mutex_lock(&hdev->vport_lock);
+		ret = __hclge_enable_vport_vlan_filter(vport,
+						       vport->req_vlan_fltr_en);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
 				"failed to sync vlan filter state for vport%u, ret = %d\n",
 				vport->vport_id, ret);
 			set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
 				&vport->state);
+			mutex_unlock(&hdev->vport_lock);
 			return;
 		}
+		mutex_unlock(&hdev->vport_lock);
 	}
 }
 
-- 
2.39.5



