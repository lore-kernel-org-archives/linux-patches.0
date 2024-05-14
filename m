Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8313E03C;
	Tue, 14 May 2024 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683525; cv=none; b=NNPMoLO9rWiYe9pLAVvzz8tNHaojVeuGJXMeS99cbcZuQqNYHyWf+schur5it72HbaPnE0zq2bHnvdWt8/3ovwOkq2TOHB97Lej8TODWJPP92XSGKdNtqyk/N65V0Uxa4IO0wrAFjE4JM/XC8wj3zZ5MM6OL/EJ9vqyekk4/hdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683525; c=relaxed/simple;
	bh=lPkiEy4bc+nEYWspckboWxfEAvEowAVe3mmAcd53Ss8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aac83gwEtk0W5mT56zbKUDsvzaDNuIGDTvyA5wRn0ZVoUmbFLrxBwpaMp9re2yLJZdhplHUlvn4dLP0asrQ4e6jeaBrM4L8MXXHBaE6U8vDXsCjQLBsVHsrCcG2sQvb4apnVTZm0BbLnEW2p2b44XKbH9D+h36hVlN9Qul2HDYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBNR3Lzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBNR3Lzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28252C2BD10;
	Tue, 14 May 2024 10:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683524;
	bh=lPkiEy4bc+nEYWspckboWxfEAvEowAVe3mmAcd53Ss8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBNR3LzsnhKwAaFMGZVpynbzhovMtqZ/YnpHgeS1R7dHiYaUJ/3ZhMGwVc8Z3qgZO
	 RwVX+tiNh6kcPn+Jnztx+9mQJI4dFz/RQIwsNJLlxX0lhgUYlF2RyetFA2lMd2ZT+f
	 BVEhGQ9gZrIY/DshkaNQ6GqaoqncaT24G9216euw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 231/336] net: hns3: fix port vlan filter not disabled issue
Date: Tue, 14 May 2024 12:17:15 +0200
Message-ID: <20240514101047.336671515@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit f5db7a3b65c84d723ca5e2bb6e83115180ab6336 ]

According to hardware limitation, for device support modify
VLAN filter state but not support bypass port VLAN filter,
it should always disable the port VLAN filter. but the driver
enables port VLAN filter when initializing, if there is no
VLAN(except VLAN 0) id added, the driver will disable it
in service task. In most time, it works fine. But there is
a time window before the service task shceduled and net device
being registered. So if user adds VLAN at this time, the driver
will not update the VLAN filter state,  and the port VLAN filter
remains enabled.

To fix the problem, if support modify VLAN filter state but not
support bypass port VLAN filter, set the port vlan filter to "off".

Fixes: 184cd221a863 ("net: hns3: disable port VLAN filter when support function level VLAN filter control")
Fixes: 2ba306627f59 ("net: hns3: add support for modify VLAN filter state")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a99e42005b9b8..012e281f65a56 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9897,6 +9897,7 @@ static int hclge_set_vlan_protocol_type(struct hclge_dev *hdev)
 static int hclge_init_vlan_filter(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport;
+	bool enable = true;
 	int ret;
 	int i;
 
@@ -9916,8 +9917,12 @@ static int hclge_init_vlan_filter(struct hclge_dev *hdev)
 		vport->cur_vlan_fltr_en = true;
 	}
 
+	if (test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, hdev->ae_dev->caps) &&
+	    !test_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B, hdev->ae_dev->caps))
+		enable = false;
+
 	return hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
-					  HCLGE_FILTER_FE_INGRESS, true, 0);
+					  HCLGE_FILTER_FE_INGRESS, enable, 0);
 }
 
 static int hclge_init_vlan_type(struct hclge_dev *hdev)
-- 
2.43.0



