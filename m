Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CF315CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FB0C433D6;
	Tue,  8 Nov 2022 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915993;
	bh=wcz8x0Fwl292mmc7QsYOKU3kIM185gGcXb52qFsXcLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcC5g1Bn+CbjFPw0QrnYuovJBirdeICNfE6OWo6VQyGiplzXnp/9ldGTusDmOlii3
	 1gZ0VRaDg4wb7mqIWqAiscjVGhZ/EIgBomLWgShiVY0YAcBe8BT4Qi8OFEdm3vjRW1
	 ToAIRIYFpQsh4qqmWpJVD67paKpXv2+BfBeCMqj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/144] nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
Date: Tue,  8 Nov 2022 14:38:28 +0100
Message-Id: <20221108133346.598808554@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 93d904a734a74c54d945a9884b4962977f1176cd ]

nfcmrvl_i2c_nci_send() will be called by nfcmrvl_nci_send(), and skb
should be freed in nfcmrvl_i2c_nci_send(). However, nfcmrvl_nci_send()
will only free skb when i2c_master_send() return >=0, which means skb
will memleak when i2c_master_send() failed. Free skb no matter whether
i2c_master_send() succeeds.

Fixes: b5b3e23e4cac ("NFC: nfcmrvl: add i2c driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcmrvl/i2c.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 01329b91d59d..a902720cd849 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -132,10 +132,15 @@ static int nfcmrvl_i2c_nci_send(struct nfcmrvl_private *priv,
 			ret = -EREMOTEIO;
 		} else
 			ret = 0;
+	}
+
+	if (ret) {
 		kfree_skb(skb);
+		return ret;
 	}
 
-	return ret;
+	consume_skb(skb);
+	return 0;
 }
 
 static void nfcmrvl_i2c_nci_update_config(struct nfcmrvl_private *priv,
-- 
2.35.1



