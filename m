Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE4115CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82E5C433D6;
	Tue,  8 Nov 2022 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915563;
	bh=/K001D9QeV+ad9xjguYDAmDQXZEfv/wW9uMwdhMg2NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5KYhSZvU8v0uUdBm8txRSs4VHGlid9nh0c+qPD4cpriyeU0ii1oyUKfhCI8baTrD
	 diaoGVvqtBx5sdgPKm0HtIaCeBoq9ohAv16xtaue/Q+97QlWwq8n3Um+xZ0dPp/RHW
	 tXPOY+taExcLv+8nEBTCQGsHAzPT49Emet1Ekit8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/118] nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
Date: Tue,  8 Nov 2022 14:38:24 +0100
Message-Id: <20221108133341.795605593@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

[ Upstream commit 3a146b7e3099dc7cf3114f627d9b79291e2d2203 ]

s3fwrn5_nci_send() will call s3fwrn5_i2c_write() or s3fwrn82_uart_write(),
and free the skb if write() failed. However, even if the write() run
succeeds, the skb will not be freed in write(). As the result, the skb
will memleak. s3fwrn5_nci_send() should also free the skb when write()
succeeds.

Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index ba6c486d6465..9b43cd3a45af 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -97,11 +97,15 @@ static int s3fwrn5_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	}
 
 	ret = s3fwrn5_write(info, skb);
-	if (ret < 0)
+	if (ret < 0) {
 		kfree_skb(skb);
+		mutex_unlock(&info->mutex);
+		return ret;
+	}
 
+	consume_skb(skb);
 	mutex_unlock(&info->mutex);
-	return ret;
+	return 0;
 }
 
 static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
-- 
2.35.1



