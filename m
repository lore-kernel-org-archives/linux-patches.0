Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE751C4ED8;
	Tue, 27 Aug 2024 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769865; cv=none; b=eLY3UYw6+1tkWF2a0PvLWgGBUQZ9DS+Z7fZyZHPnYdNonNx6q6XDswyQEzfF7hiPuGmLkXe9vSAaMUzAite8oAu6aYgYG34/qFQm6qqlbR4fgixvp/zQpUwcYOZNrLdb5ePLdG788FpjGZsw9PJb3rJORUGNr7xx3CG/9DOUMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769865; c=relaxed/simple;
	bh=QwAngRO0u/LUFfQewJZQaUX1LEoQymrm8RjGD6fMZag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=av4cDgW8tZk0QLv1yrhosCn1SnxCwQRwatCvsgzZIZnPVO1avpRfuBCw+kGLv5s1slGfyLXPY7bYySgzOqdRiao/ynxt5e+HHDRoY5a9MyuU4/KskoCWCMqENmErK0hqZn938X2b00WcGMKjWoYotZFWzFPwSdJwmFciOoA7+cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vjbfu5TR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vjbfu5TR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E24AC61066;
	Tue, 27 Aug 2024 14:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769864;
	bh=QwAngRO0u/LUFfQewJZQaUX1LEoQymrm8RjGD6fMZag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vjbfu5TRgwhU+ttzSc66vefDhGvP/76mJR47zQq5LUz3+u4xZrQONWHaBW7ljEoCL
	 aKcXh0h2Zi53+aZWt2GYBwckEaGQfOWcLy42nAeyYeJDc0+fYbZo7CAMzJNvuKr/Qo
	 ffU9jzMr9kOlmWbMidnBE3p2WHutZ6OmPC4g46xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zhang <everything411@qq.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/341] net: ethernet: mtk_wed: fix use-after-free panic in mtk_wed_setup_tc_block_cb()
Date: Tue, 27 Aug 2024 16:34:50 +0200
Message-ID: <20240827143845.662302619@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Zheng Zhang <everything411@qq.com>

[ Upstream commit db1b4bedb9b97c6d34b03d03815147c04fffe8b4 ]

When there are multiple ap interfaces on one band and with WED on,
turning the interface down will cause a kernel panic on MT798X.

Previously, cb_priv was freed in mtk_wed_setup_tc_block() without
marking NULL,and mtk_wed_setup_tc_block_cb() didn't check the value, too.

Assign NULL after free cb_priv in mtk_wed_setup_tc_block() and check NULL
in mtk_wed_setup_tc_block_cb().

----------
Unable to handle kernel paging request at virtual address 0072460bca32b4f5
Call trace:
 mtk_wed_setup_tc_block_cb+0x4/0x38
 0xffffffc0794084bc
 tcf_block_playback_offloads+0x70/0x1e8
 tcf_block_unbind+0x6c/0xc8
...
---------

Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
Signed-off-by: Zheng Zhang <everything411@qq.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index c7196055c8c98..85a9ad2b86bff 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1762,14 +1762,15 @@ mtk_wed_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_pri
 {
 	struct mtk_wed_flow_block_priv *priv = cb_priv;
 	struct flow_cls_offload *cls = type_data;
-	struct mtk_wed_hw *hw = priv->hw;
+	struct mtk_wed_hw *hw = NULL;
 
-	if (!tc_can_offload(priv->dev))
+	if (!priv || !tc_can_offload(priv->dev))
 		return -EOPNOTSUPP;
 
 	if (type != TC_SETUP_CLSFLOWER)
 		return -EOPNOTSUPP;
 
+	hw = priv->hw;
 	return mtk_flow_offload_cmd(hw->eth, cls, hw->index);
 }
 
@@ -1825,6 +1826,7 @@ mtk_wed_setup_tc_block(struct mtk_wed_hw *hw, struct net_device *dev,
 			flow_block_cb_remove(block_cb, f);
 			list_del(&block_cb->driver_list);
 			kfree(block_cb->cb_priv);
+			block_cb->cb_priv = NULL;
 		}
 		return 0;
 	default:
-- 
2.43.0



