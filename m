Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A156FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC51C433EF;
	Mon, 16 Jan 2023 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888218;
	bh=gH2bXmN+XPyY3R5S6T4DpnBQ2mQQAfX/0Px5tGg2Iag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2mif1qK6MeUMbXup9gL312u3P/LkNlgTxSTHLrTS/UTvk8qVuWu2c1JlYiAyIxzf
	 hQsENA4eDxGitedJysPp3bd792V33qaPgNAehpiJ1qLnns4682pVZBQmhE5Ti5fYu3
	 fQkjCFiGPYqBEmfPcdHWcWVHnJCE9MZSJyAg+xoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 445/521] nfc: Fix potential resource leaks
Date: Mon, 16 Jan 2023 16:51:47 +0100
Message-Id: <20230116154907.042774289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit df49908f3c52d211aea5e2a14a93bbe67a2cb3af ]

nfc_get_device() take reference for the device, add missing
nfc_put_device() to release it when not need anymore.
Also fix the style warnning by use error EOPNOTSUPP instead of
ENOTSUPP.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Fixes: 29e76924cf08 ("nfc: netlink: Add capability to reply to vendor_cmd with data")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/netlink.c | 52 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 39fb01ee9222..8953b03d5a52 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1515,6 +1515,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	u32 dev_idx, se_idx;
 	u8 *apdu;
 	size_t apdu_len;
+	int rc;
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
 	    !info->attrs[NFC_ATTR_SE_INDEX] ||
@@ -1528,25 +1529,37 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
-	if (!dev->ops || !dev->ops->se_io)
-		return -ENOTSUPP;
+	if (!dev->ops || !dev->ops->se_io) {
+		rc = -EOPNOTSUPP;
+		goto put_dev;
+	}
 
 	apdu_len = nla_len(info->attrs[NFC_ATTR_SE_APDU]);
-	if (apdu_len == 0)
-		return -EINVAL;
+	if (apdu_len == 0) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	apdu = nla_data(info->attrs[NFC_ATTR_SE_APDU]);
-	if (!apdu)
-		return -EINVAL;
+	if (!apdu) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto put_dev;
+	}
 
 	ctx->dev_idx = dev_idx;
 	ctx->se_idx = se_idx;
 
-	return nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+	rc = nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+
+put_dev:
+	nfc_put_device(dev);
+	return rc;
 }
 
 static int nfc_genl_vendor_cmd(struct sk_buff *skb,
@@ -1569,14 +1582,21 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 	subcmd = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_SUBCMD]);
 
 	dev = nfc_get_device(dev_idx);
-	if (!dev || !dev->vendor_cmds || !dev->n_vendor_cmds)
+	if (!dev)
 		return -ENODEV;
 
+	if (!dev->vendor_cmds || !dev->n_vendor_cmds) {
+		err = -ENODEV;
+		goto put_dev;
+	}
+
 	if (info->attrs[NFC_ATTR_VENDOR_DATA]) {
 		data = nla_data(info->attrs[NFC_ATTR_VENDOR_DATA]);
 		data_len = nla_len(info->attrs[NFC_ATTR_VENDOR_DATA]);
-		if (data_len == 0)
-			return -EINVAL;
+		if (data_len == 0) {
+			err = -EINVAL;
+			goto put_dev;
+		}
 	} else {
 		data = NULL;
 		data_len = 0;
@@ -1591,10 +1611,14 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 		dev->cur_cmd_info = info;
 		err = cmd->doit(dev, data, data_len);
 		dev->cur_cmd_info = NULL;
-		return err;
+		goto put_dev;
 	}
 
-	return -EOPNOTSUPP;
+	err = -EOPNOTSUPP;
+
+put_dev:
+	nfc_put_device(dev);
+	return err;
 }
 
 /* message building helper */
-- 
2.35.1



