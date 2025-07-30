Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3102167DB7;
	Wed, 30 Jul 2025 09:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868356; cv=none; b=XtUEShZ7o+K2RI/JQ0o2NpQsvz/Mvq5hbKPrkUf9JjxWaLXV8FJ659hRPwd3wxyXgoZ5DD9tXhZvz5I8HxTrK/T2Rp6YiMuIR0mXCa6n74dmqjYitWUfsJGUdoJMLeQKx94DBbsMfw2pvysDTrcgvQxwgYaV9AEZ4ZjONNmvhQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868356; c=relaxed/simple;
	bh=R8T4qOabeMjPZlI8Nai1EPHywXu9k7ddiLscHeJUCqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gcy5MEevOBsiD5R50fmki8b8Sl4E3N+D/c0BzensicFsQjPdxUgvVpAVhRa0EtlwSi/pNLrXij36U0BtFzyKMj01NknY3KdKHdCcrUnmEYR7NzUXoId+lyB/cKD5bDF4JgfS5putoKX6nmR7QMnFZERkGX62pxKsoE6ypNfa7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfcC7/2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfcC7/2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEF5C4CEF5;
	Wed, 30 Jul 2025 09:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868355;
	bh=R8T4qOabeMjPZlI8Nai1EPHywXu9k7ddiLscHeJUCqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfcC7/2o9H4+NWCqSi2ZPJ9Ek4sleNV9gCAUAn67ShaqO+lBKDfmrKn/wC55PF5jT
	 maPvfdV/i0fZOo4i8kA+rfO7HK9v4WCTdkyGfG5TlBRhtOLrFBGIfH+B/nnqdZ6Zkj
	 pVzZiB8mYEF79nKTQVQ3N9/PIJ0TFRdyXkjnfacw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/76] net: hns3: fixed vf get max channels bug
Date: Wed, 30 Jul 2025 11:35:19 +0200
Message-ID: <20250730093227.859098796@linuxfoundation.org>
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

[ Upstream commit b3e75c0bcc53f647311960bc1b0970b9b480ca5a ]

Currently, the queried maximum of vf channels is the maximum of channels
supported by each TC. However, the actual maximum of channels is
the maximum of channels supported by the device.

Fixes: 849e46077689 ("net: hns3: add ethtool_ops.get_channels support for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722125423.1270673-4-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1ba0b57c7a72d..68a9aeeed3da0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3029,11 +3029,7 @@ static void hclgevf_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 static u32 hclgevf_get_max_channels(struct hclgevf_dev *hdev)
 {
-	struct hnae3_handle *nic = &hdev->nic;
-	struct hnae3_knic_private_info *kinfo = &nic->kinfo;
-
-	return min_t(u32, hdev->rss_size_max,
-		     hdev->num_tqps / kinfo->tc_info.num_tc);
+	return min(hdev->rss_size_max, hdev->num_tqps);
 }
 
 /**
-- 
2.39.5



